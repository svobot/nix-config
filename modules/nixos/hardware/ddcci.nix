{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [
      "ddcci"
      "ddcci-backlight"
    ];
  };

  environment.systemPackages = [ pkgs.ddcutil ];

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", ACTION=="add", ATTR{name}=="AMDGPU DM*", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci-attach.service"
    SUBSYSTEM=="drm", ACTION=="change", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci-attach.service"
  '';

  # Kernels since 6.8 no longer let ddcci probe DDC buses on its own, so every
  # amdgpu i2c bus is checked with ddcutil and attached by hand.
  systemd.services.ddcci-attach = {
    description = "Attach ddcci to DDC/CI capable displays";
    startLimitIntervalSec = 0;
    serviceConfig.Type = "oneshot";
    script = ''
      buses() {
        for dev in /sys/class/i2c-dev/i2c-*; do
          case "$(cat "$dev/name")" in
            "AMDGPU DM"*) echo "''${dev##*/i2c-}" ;;
          esac
        done
      }

      externalConnected() {
        for status in /sys/class/drm/card*-*/status; do
          case "$status" in
            *eDP* | *Writeback*) continue ;;
          esac
          [ "$(cat "$status")" = connected ] && return 0
        done
        return 1
      }

      bound() {
        [ -e "/sys/bus/i2c/devices/$1-0037/driver" ]
      }

      detach() {
        if [ -e "/sys/bus/i2c/devices/$1-0037" ]; then
          echo 0x37 > "/sys/bus/i2c/devices/i2c-$1/delete_device"
        fi
      }

      attach() {
        detach "$1"
        echo ddcci 0x37 > "/sys/bus/i2c/devices/i2c-$1/new_device" || true
        bound "$1"
      }

      if ! externalConnected; then
        for bus in $(buses); do
          detach "$bus"
        done
        exit 0
      fi

      # The ddcci probe gets ENODEV while amdgpu is still committing a modeset,
      # and leaves the client unbound when it does, so keep retrying until the
      # link answers.
      for _ in 1 2 3 4 5 6 7 8; do
        attached=0
        pending=0
        for bus in $(buses); do
          if bound "$bus"; then
            attached=1
          elif ${lib.getExe pkgs.ddcutil} getvcp 10 --bus "$bus" >/dev/null 2>&1; then
            if attach "$bus"; then
              attached=1
            else
              pending=1
            fi
          else
            detach "$bus"
          fi
        done
        [ "$attached" = 1 ] && [ "$pending" = 0 ] && exit 0
        sleep 2
      done

      echo "no DDC/CI display attached"
    '';
  };
}
