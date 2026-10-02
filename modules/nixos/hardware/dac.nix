{ lib, pkgs, ... }:
let
  relay_control = pkgs.writeShellScript "relay_control" ''
    RELAY_ID="HW348_1"
    STATE_ON=1
    STATE_OFF=0

    case "$1" in
        on)
            ${lib.getExe' pkgs.usbrelay "usbrelay"} "$RELAY_ID=$STATE_ON"
            ;;
        off)
            ${lib.getExe' pkgs.usbrelay "usbrelay"} "$RELAY_ID=$STATE_OFF"
            ;;
        *)
            echo "Usage: $0 {on|off}"
            exit 1
            ;;
    esac

    exit 0
  '';
in

{
  services = {
    pipewire.wireplumber.extraConfig."50-nad-dac-priority"."monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.usb-NAD_Electronics_NAD_USB_Audio-.*"; } ];
        # Above built-in speakers (1000) and the USB default (1108), below the
        # jack headphones of the laptop.
        actions.update-props."priority.session" = 1500;
      }
    ];
    udev.extraRules = ''
      KERNEL=="hidraw*", ACTION=="add", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", TAG+="systemd", ENV{SYSTEMD_WANTS}+="dac_relay_attach.service"
    '';
  };

  systemd = {
    services = {
      dac_relay_attach = {
        description = "Power the DAC when its USB relay appears";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${relay_control} on";
        };
      };
      dac_trigger = {
        description = "DAC USB Relay Control Service";
        after = [ "multi-user.target" ];
        before = [ "sleep.target" ];
        unitConfig.StopWhenUnneeded = false;

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${relay_control} on";
          ExecStop = "${relay_control} off";
        };
        wantedBy = [ "multi-user.target" ];
      };
      dac_trigger_sleep = {
        description = "DAC USB Relay Sleep Control";
        before = [ "sleep.target" ];
        unitConfig.StopWhenUnneeded = true;

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${relay_control} off";
          ExecStop = "${relay_control} on";
        };
        wantedBy = [ "sleep.target" ];
      };
    };
  };
}
