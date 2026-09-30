ctx@{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = import ../colors.nix ctx;
in
{
  wayland.windowManager.sway = {
    enable = true;

    # https://github.com/nix-community/home-manager/issues/5311
    checkConfig = false;

    config = {
      bars = [ ];

      colors = {
        focused = {
          border = colors.default.blue;
          background = colors.default.blue;
          text = colors.grays.light.gray6;
          indicator = colors.default.blue;
          childBorder = colors.grays.light.gray;
        };
        focusedInactive = {
          border = colors.grays.dark.gray2;
          background = colors.grays.dark.gray2;
          text = colors.grays.light.gray6;
          indicator = colors.grays.light.gray4;
          childBorder = colors.grays.dark.gray4;
        };
        unfocused = {
          border = colors.grays.dark.gray4;
          background = colors.grays.dark.gray5;
          text = colors.grays.light.gray2;
          indicator = colors.grays.light.gray4;
          childBorder = colors.grays.dark.gray4;
        };
        urgent = {
          border = colors.default.red;
          background = colors.default.red;
          text = colors.grays.light.gray6;
          indicator = colors.grays.light.gray4;
          childBorder = colors.default.red;
        };
      };

      defaultWorkspace = "workspace 1";
      workspaceAutoBackAndForth = true;

      floating = {
        border = 0;
      };

      fonts = {
        names = [ "sans-serif" ];
        style = "medium";
        size = 9.5;
      };

      gaps = {
        inner = 8;
        #outer = 5;
        smartBorders = "no_gaps";
        smartGaps = true;
      };

      output = {
        "*" = {
          bg = "${config.xdg.dataHome}/wall.jpg fill";
        };
      };

      keybindings =
        let
          execSpawn = cmd: "exec ${pkgs.spawn}/bin/spawn ${cmd}";
          inherit (config.wayland.windowManager.sway.config) modifier terminal;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = execSpawn terminal;
          "${modifier}+space" = execSpawn "${lib.getExe pkgs.rofi} -show drun";
          "${modifier}+Shift+space" = execSpawn "${lib.getExe pkgs.rofi} -show run";
          "${modifier}+Alt+space" = execSpawn "${pkgs.sway-drunmenu}/bin/drunmenu";
          "${modifier}+q" = execSpawn "swaylock -f";
          "${modifier}+o" = execSpawn "${pkgs.screenocr}/bin/screenocr";
          "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
          "${modifier}+p" = execSpawn "${pkgs.screenshot}/bin/screenshot";

          "${modifier}+d" = "focus mode_toggle";
          "${modifier}+Shift+d" = "floating toggle";
          "${modifier}+r" = "mode 􀢿";

          "XF86AudioLowerVolume" = execSpawn "${lib.getExe pkgs.pamixer} -d 2";
          "XF86AudioMute" = execSpawn "${lib.getExe pkgs.pamixer} -t";
          "XF86AudioNext" = execSpawn "${lib.getExe pkgs.playerctl} -p spotify next";
          "XF86AudioPlay" = execSpawn "${lib.getExe pkgs.playerctl} -p spotify play-pause";
          "XF86AudioPrev" = execSpawn "${lib.getExe pkgs.playerctl} -p spotify previous";
          "XF86AudioRaiseVolume" = execSpawn "${lib.getExe pkgs.pamixer} -i 2";
          "XF86MonBrightnessDown" = execSpawn "${lib.getExe pkgs.brillo} -e -U 2";
          "XF86MonBrightnessUp" = execSpawn "${lib.getExe pkgs.brillo} -e -A 2";
        };

      modes = {
        "􀢿" = {
          Down = "resize grow height 10 px";
          Escape = "mode default";
          Left = "resize shrink width 10 px";
          Return = "mode default";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
        };
      };

      modifier = "Mod4";

      startup = [
        # FIX: Workaround for https://github.com/nix-community/home-manager/issues/3589
        {
          command = "swaymsg 'hide_edge_borders --i3' smart_no_gaps";
          always = true;
        }
      ];

      terminal = "${config.programs.alacritty.package}/bin/alacritty";

      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            command = "floating enable, sticky enable, resize set 688 387, exec ${pkgs.sway-move-to}/bin/sway-move-to bottom-right";
            criteria = {
              app_id = "firefox";
              title = "Picture-in-Picture";
            };
          }
          {
            command = "floating enable, sticky enable";
            criteria = {
              app_id = "firefox";
              title = ".*Sharing Indicator.*";
            };
          }
          {
            command = "floating enable";
            criteria = {
              app_id = "firefox";
              title = "Library";
            };
          }
          {
            command = "floating enable, resize set 950 1050, move position center";
            criteria = {
              app_id = "pavucontrol";
              title = "Volume Control";
            };
          }
          {
            command = "floating enable, border none";
            criteria = {
              app_id = "^$";
              title = "^[zZ]oom$";
            };
          }
          {
            command = "floating disable";
            criteria = {
              app_id = "^$";
              title = "^Zoom - Licensed Account$";
            };
          }
          {
            command = "floating enable, border pixel";
            criteria = {
              app_id = "^$";
              title = "^About$";
            };
          }
          {
            command = "floating enable, floating_minimum_size 960 x 700";
            criteria = {
              app_id = "^$";
              title = "Settings";
            };
          }
        ];
      };
    };

    extraConfig = ''
      titlebar_border_thickness 1
      titlebar_padding 12 3
      title_align center

      include /etc/sway/config.d/*
      exec ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd PATH
    '';

    extraSessionCommands = ''
      export LIBSEAT_BACKEND="logind"

      export MOZ_ENABLE_WAYLAND=1
      export NIXOS_OZONE_WL=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    systemd.enable = true;
    wrapperFeatures.gtk = true;
  };
}
