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
    graphical-alacritty
    graphical-firefox
    graphical-fonts
    graphical-mako
    graphical-mime
    graphical-mpv
  ];

  # XXX: Should be pprograms.dconf.enable?
  dconf.enable = lib.mkForce true;

  home = {
    packages =
      with pkgs;
      lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
        baobab
        deluge
        eog
        font-manager
        gnome-epub-thumbnailer
        libnotify
        meld
        nautilus
        obsidian
        pavucontrol
        qalculate-gtk
        signal-desktop
        spawn
        spotify
        sublime-merge
        thunderbird
        xdg-utils
        zed-editor
      ];

    sessionVariables = {
      MOZ_DBUS_REMOTE = 1;
      MOZ_USE_XINPUT2 = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true";
    };

    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
    };
  };

  programs = {
    alacritty.enable = true;
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      installBatSyntax = true;
      settings = {
        clipboard-read = "ask";
        quit-after-last-window-closed = true;
      };
    };
  };

  systemd.user.services = {
    "git-maintenance@" = lib.mkIf config.programs.git.maintenance.enable {
      Unit.OnFailure = [ "notify-failure@%n.service" ];
    };
    "notify-failure@" = {
      Unit.Description = "Desktop notification for a failed unit";
      Service = {
        Type = "oneshot";
        ExecStart = ''${lib.getExe' pkgs.libnotify "notify-send"} --urgency=critical "%i failed" "journalctl --user -u %i"'';
      };
    };
    polkit-gnome = {
      Unit = {
        Description = "polkit-gnome";
        Documentation = [ "man:polkit(8)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
