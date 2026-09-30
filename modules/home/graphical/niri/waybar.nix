ctx@{ pkgs, ... }:
let
  colors = import ../colors.nix ctx;
in
{
  programs.waybar = {
    enable = true;
    settings = [
      {
        gtk-layer-shell = true;
        layer = "top";
        height = 25;
        modules-left = [
          "niri/workspaces"
          "custom/media"
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];
        "niri/workspaces" = {
          disable-scroll-wraparound = true;
        };
        "custom/media" = {
          icon-size = 25;
          format = "{icon} {text}";
          return-type = "json";
          max-length = 50;
          format-icons = {
            spotify = ''<span font-size="large" foreground="${colors.spotify}"></span> '';
            default = "􀫀";
          };
          escape = true;
          exec = "${pkgs.waybar-mediaplayer}/bin/waybar-mediaplayer.py --player spotify 2> /dev/null"; # Filter player based on name
          on-click = ''
            ${pkgs.niri}/bin/niri msg -j windows |\
            ${pkgs.jq}/bin/jq 'first(.[] | select(.app_id == "spotify")) | .id' |\
            ${pkgs.findutils}/bin/xargs ${pkgs.niri}/bin/niri msg action focus-window --id
          '';
          on-click-right = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
        };

        "niri/window" = {
          tooltip = false;
          on-click = "${pkgs.niri}/bin/niri msg action toggle-overview";
        };

        tray = {
          icon-size = 20;
          spacing = 5;
        };
        pulseaudio = {
          format = "{volume}% {icon}{format_source}";
          format-bluetooth = "{volume}%  {icon} {format_source}";
          format-bluetooth-muted = "􀊣  {icon} {format_source}";
          format-muted = "􀊣";
          format-source = "   {volume}%  􀊱";
          format-source-muted = "";
          format-icons = {
            headphone = "􀑈"; # 􀺭  􀺹  􀑈    􀸸   􀪷   􁄡   􀠦  􀲋􀲌
            hands-free = "􀑈";
            headset = "􀑈";
            default = [
              "􀊡"
              "􀊥"
              "􀊧"
              "􀊩"
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        network = {
          format-wifi = "􀙇";
          format-ethernet = "􀆪"; # 􀤆
          format-linked = "􀉣";
          format-disconnected = "􀇿";
          tooltip-format-wifi = "{essid}:\t{signalStrength}%\n{ifname}:\t{ipaddr}/{cidr}";
          tooltip-format-ethernet = "{ifname}:\t{ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
        };
        battery = {
          bat = "BAT0";
          states = {
            full = 100;
            good = 95;
            critical = 15;
          };
          format = "{capacity}%  {icon}";
          format-charging = ''{capacity}%  <span foreground="${colors.default.green}">􀢋</span>'';
          format-charging-full = "";
          format-full = "";
          format-alt = "{time}  {icon}";
          format-icons = [
            "􀛪"
            "􀛩"
            "􀺶"
            "􀺸"
            "􀛨"
          ];
        };
        clock = {
          format = "{:%A    %F    %T}";
          interval = 1;
          tooltip-format = ''<span font-family="SF Mono">{calendar}</span>'';
          calendar.format = {
            months = ''<span font-family="SF Pro Text"><big>{}</big></span>'';
            today = ''<span color="${colors.default.blue}">{}</span>'';
          };
          locale = "en_GB.UTF-8";
        };
      }
    ];
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: SF Pro Text, Font Awesome;
        font-size: 13px;
        font-weight: 600;
        min-height: 0;
      }

      #waybar {
        background-color: ${colors.grays.dark.gray6};
        color: ${colors.grays.light.gray6};
      }

      #workspaces button {
        padding: 0 5px;
        color: ${colors.default.gray};
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.focused {
        color: ${colors.grays.light.gray6};
      }

      #workspaces button.urgent {
        background-color: ${colors.default.red};
        color: ${colors.grays.light.gray6};
      }

      #clock,
      #battery,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode {
        color: ${colors.grays.light.gray6};
        padding: 0 10px;
        margin: 0 4px;
      }

      #battery.full {
        padding: 0;
        margin: 0;
      }

      @keyframes blink {
        to {
          background-color: ${colors.grays.light.gray6};
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        background-color: ${colors.default.red};
        animation-name: blink;
        animation-duration: 0.9s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      label:focus {
        background-color: #000000;
      }

      #network.internet.disconnected {
        color: ${colors.default.red};
      }

      #custom-media {
        color: ${colors.default.gray};
        min-width: 100px;
      }

      #tray {
      }
    '';

    systemd = {
      enable = true;
    };
  };
}
