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
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="16c0", ATTR{idProduct}=="05df", RUN+="${relay_control} on"
  '';

  systemd = {
    services = {
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
