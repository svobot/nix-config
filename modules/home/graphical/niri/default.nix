{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = with self.homeModules; [
    graphical-niri-niri
    graphical-niri-waybar
  ];

  programs.bash.profileExtra = ''
    [[ "$(tty)" == /dev/tty1 ]] && systemd-cat --identifier=niri niri-session -l
  '';

  # oomd kills whole leaf cgroups; a session-wide stall must not take the
  # compositor with it.
  xdg.configFile."systemd/user/niri.service.d/oomd.conf".text = ''
    [Service]
    ManagedOOMPreference=avoid
  '';

  home = {
    packages = with pkgs; [
      fuzzel
      wl-clipboard
      brillo # TODO: change to brightnessctl
      brightnessctl
      nirius
      xwayland-satellite
    ];
  };

  services = {
    cliphist.enable = true;
    swayidle =
      let
        lock = "${lib.getExe config.programs.swaylock.package} -f";
      in
      {
        enable = true;
        events = {
          before-sleep = lock;
          inherit lock;
        };
        timeouts = [
          {
            timeout = 600;
            command = lock;
          }
          {
            timeout = 630;
            command = "${lib.getExe config.programs.niri.package} msg action power-off-monitors";
          }
        ];
      };
    swayosd.enable = true;
    wl-clip-persist = {
      enable = true;
      # Password managers tag secret copies with the bare
      # x-kde-passwordManagerHint type, which is neither a real MIME type nor
      # a legacy X target, so requiring one of those shapes skips them.
      extraOptions = [
        "--all-mime-type-regex"
        "^(?:.+/.+|[A-Z0-9_]+)$"
      ];
    };
  };

  programs = {
    swaylock = {
      enable = true;
      settings = {
        indicator-caps-lock = true;
        scaling = "fill";
        show-failed-attempts = true;
        image = "${config.xdg.dataHome}/wall.jpg";
      };
    };
    wofi = {
      enable = true;
      settings = {
        allow_images = true;
        allow_markup = true;
      };
    };
  };

  systemd.user.services =
    let
      wlPaste = lib.getExe' pkgs.wl-clipboard "wl-paste";
      # cliphist has no filter of its own; check the offered types before storing.
      store = pkgs.writeShellApplication {
        name = "cliphist-store-unless-secret";
        runtimeInputs = [
          pkgs.wl-clipboard
          config.services.cliphist.package
        ];
        text = ''
          types=$(wl-paste --list-types 2>/dev/null || true)
          if grep -qx x-kde-passwordManagerHint <<<"$types"; then
            exit 0
          fi
          exec cliphist ${lib.escapeShellArgs config.services.cliphist.extraOptions} store
        '';
      };
    in
    {
      cliphist.Service.ExecStart = lib.mkForce "${wlPaste} --watch ${lib.getExe store}";
      cliphist-images.Service.ExecStart = lib.mkForce "${wlPaste} --type image --watch ${lib.getExe store}";
      swaybg = {
        Unit = {
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
          Requisite = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = ''${lib.getExe pkgs.swaybg} -i "%h/.local/share/wall.jpg" -m fill'';
          Restart = "on-failure";
        };

        Install.WantedBy = [ "niri.service" ];
      };
      niriusd = {
        Unit = {
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
          Requires = [ config.wayland.systemd.target ];
          ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
        };
        Service = {
          ExecStart = lib.getExe' pkgs.nirius "niriusd";
          Type = "simple";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };
      };
    };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.niri ];
  };
}
