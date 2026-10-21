{
  config,
  lib,
  pkgs,
  ...
}:
let
  kernel = config.boot.kernelPackages.kernel;
  kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  # Upstream ddcci_remove never unregisters its devices, so once a monitor is
  # unplugged every later attach on that bus fails with EEXIST until the module
  # is reloaded. Fix pending upstream:
  # https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/merge_requests/19
  #
  # The probe reads 130 bytes per reply, far past the end of any DDC/CI frame,
  # and aborts on the first bad chunk of the capability string. The Dell
  # U3225QE serves stale buffer contents and defers the next request when
  # over-read, which on a native DisplayPort link (neon) shows up as AUX
  # timeouts on a quarter of the reads, so the probe never bound there and
  # answered maybe one probe in ten over USB4 (omphalos).
  #
  # Upstream's `install` target copies the .ko by hand, skipping Kbuild's
  # signing rule that emits the per-module `.ko.cer` nixpkgs' aggregateModules
  # now requires. Fix pending upstream:
  # https://github.com/NixOS/nixpkgs/pull/576387
  ddcci-driver = config.boot.kernelPackages.ddcci-driver.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./ddcci-fix-i2c-remove.patch
      ./ddcci-tolerate-flaky-ddc.patch
    ];
    installPhase = ''
      runHook preInstall

      for module in ddcci ddcci-backlight; do
        make -C "${kdir}" M="$PWD/$module" modules_install \
          INSTALL_MOD_PATH="$out" INSTALL_MOD_DIR=extra DEPMOD=true $makeFlags
      done

      install -Dm644 include/linux/ddcci.h -t "$out/include/linux"

      runHook postInstall
    '';
  });
in
{
  boot = {
    extraModulePackages = [ ddcci-driver ];
    kernelModules = [
      "ddcci"
      "ddcci-backlight"
    ];
  };

  environment.systemPackages = [ pkgs.ddcutil ];

  hardware.i2c.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", ACTION=="add", ATTR{name}=="AMDGPU DM*", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci-attach.service"
    SUBSYSTEM=="drm", ACTION=="change", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ddcci-attach.service"
  '';

  # Kernels since 6.8 no longer let ddcci probe DDC buses on its own, so the
  # DDC bus of every connected external connector is checked with ddcutil and
  # attached by hand.
  systemd.services.ddcci-attach = {
    description = "Attach ddcci to DDC/CI capable displays";
    startLimitIntervalSec = 0;
    serviceConfig = {
      Type = "oneshot";
      CacheDirectory = "ddcutil";
      Environment = "XDG_CACHE_HOME=/var/cache";
      # Lets a burst of hotplug events from one replug coalesce into one run.
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
    };
    script = ''
      # DisplayPort carries DDC/CI over AUX, exposed as the connector's child
      # i2c adapter; other connectors use the adapter behind the ddc link.
      buses() {
        for conn in /sys/class/drm/card*-*; do
          case "$conn" in
            *eDP* | *Writeback*) continue ;;
          esac
          [ "$(cat "$conn/status" 2>/dev/null)" = connected ] || continue
          set -- "$conn"/i2c-*
          bus=$1
          [ -e "$bus" ] || bus=$(readlink "$conn/ddc" 2>/dev/null)
          [ -n "$bus" ] && echo "''${bus##*/i2c-}"
        done
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

      active=" $(buses | tr '\n' ' ')"

      for client in /sys/bus/i2c/devices/*-0037; do
        [ -e "$client" ] || continue
        [ "$(cat "$client/name" 2>/dev/null)" = ddcci ] || continue
        bus=''${client##*/}
        bus=''${bus%-0037}
        case "$active" in
          *" $bus "*) ;;
          *) detach "$bus" ;;
        esac
      done

      [ -n "$(buses)" ] || exit 0

      # The ddcci probe gets ENODEV while amdgpu is still committing a modeset,
      # and leaves the client unbound when it does, so keep retrying until the
      # link answers.
      for _ in 1 2 3 4; do
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
