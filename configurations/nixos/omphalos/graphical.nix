{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.svoboda = {
    # VCP 60 (Input Source) values of the U3225QE: 0x19 Thunderbolt, 0x0f
    # DisplayPort, 0x11 HDMI.
    programs.niri.settings.binds."Mod+Shift+S" = {
      action.spawn = [
        (lib.getExe pkgs.ddcutil)
        "--model"
        "DELL U3225QE"
        "setvcp"
        "60"
        "0x0f"
      ];
      hotkey-overlay.title = "Hand the monitor over to neon";
    };
  }
  // lib.optionalAttrs config.programs.sway.enable {
    wayland.windowManager.sway = {
      config = {
        input = {
          "type:touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
          };

          "type:keyboard" = {
            xkb_layout = "gb,cz";
            xkb_variant = ",qwerty";
          };
        };
        output = {
          "Dell Inc. DELL U3225QE 6BP3B34" = {
            mode = "3840x2160@120Hz";
            scale = "1.25";
          };
        };
      };

      extraConfig = ''
        bindswitch --locked --reload lid:on output eDP-1 disable
        bindswitch --locked --reload lid:off output eDP-1 enable
      '';

      # TODO: Maybe try out
      #extraSessionCommands = ''
      #  export GDK_DPI_SCALE="1.3"
      #  export ELM_SCALE="1.3"
      #'';
    };
  };
}
