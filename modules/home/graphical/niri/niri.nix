{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      input = {
        keyboard = {
          xkb.layout = "gb";
          numlock = true;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "50%";
        };
        workspace-auto-back-and-forth = true;
      };

      outputs = {
        "Dell Inc. DELL U3225QE 6BP3B34" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 120.0;
          };
          scale = 1.25;
        };
        "eDP-1".scale = 1;
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 0.5; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width.proportion = 1.0 / 3.0;
        focus-ring = {
          width = 4;
          active.color = "rgb(199, 199, 204)";
          inactive.color = "#505050";
        };
        border.enable = false;
        tab-indicator = {
          width = 8;
          gap = 8;
          length.total-proportion = 1.0;
          position = "top";
          place-within-column = true;
        };
        background-color = "transparent";
      };

      layer-rules = [
        {
          matches = [ { namespace = "^wallpaper$"; } ];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        # WezTerm misreports its size on the first configure unless the column
        # width is left to the client.
        {
          matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
          default-column-width = { };
        }
        {
          matches = [ { app-id = "firefox$"; } ];
          default-column-width.proportion = 1.0;
        }
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^Steam$";
            }
          ];
          default-column-width.proportion = 2.0 / 3.0;
        }
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^Steam Big Picture Mode$";
            }
          ];
          open-fullscreen = true;
        }
        {
          matches = [ { app-id = "^steam$"; } ];
          excludes = [
            { title = "^Steam$"; }
            { title = "^Steam Big Picture Mode$"; }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Library$";
            }
            { app-id = "pavucontrol"; }
          ];
          open-floating = true;
        }
      ];

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      environment = {
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
      };
      animations.window-resize.custom-shader = builtins.readFile ./window-resize.glsl;
      gestures.hot-corners.enable = false;
    };
  };
}
