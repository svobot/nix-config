{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-t14s-amd-gen4
      common-cpu-amd-pstate
    ])
    ++ (with self.nixosModules; [
      hardware-bluetooth
      hardware-sound
    ]);

  boot = {
    initrd.availableKernelModules = [ "thunderbolt" ];
    # Load in stage 1 so the wcn6855 firmware handshake and the default wlan0
    # netdev are done before iwd starts. ath11k registers the wiphy with
    # cfg80211 ~7ms before creating the netdev; iwd enumerates the wiphy in
    # that gap, logs "No default interface for wiphy 0" and never retries,
    # leaving no wifi device until the module is reloaded by hand.
    # qrtr provides the AF_QIPCRTR socket family qmi_handle_init() needs; without
    # it ath11k probing defers with -517 for the whole of stage 1 and only
    # completes just after switch-root, which is exactly when iwd starts.
    #
    # TODO: to check, run: journalctl -b 0 -o short-precise | grep -E 'failed to init core|chip_id|No default interface|Switching root'
    # chip_id/fw_version should appear before Switching root, and No default interface for wiphy 0 should not appear at all.
    initrd.kernelModules = [
      "qrtr"
      "qrtr_mhi"
      "ath11k_pci"
    ];
    blacklistedKernelModules = [ "sp5100_tco" ];
    kernelModules = [
      "kvm-amd"
      "thinkpad_acpi"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nowatchdog"
      "preempt=full"
    ];
  };

  console = {
    font = "ter-v24n";
    packages = with pkgs; [ terminus_font ];
  };

  environment = {
    persistence."/nix/state".directories = [
      "/var/lib/boltd"
      "/var/lib/fprint"
      "/var/lib/upower"
    ];
    systemPackages = with pkgs; [ iw ];
  };

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    graphics.enable = true;
  };

  networking.wireless.iwd.settings = lib.mkIf config.networking.wireless.iwd.enable {
    DriverQuirks.DefaultInterface = "ath11k_pci";
  };

  nix.settings.system-features = [ "gccarch-znver4" ];

  services = {
    fprintd.enable = true;
    hardware.bolt.enable = true;
    thinkfan = {
      enable = true;
      extraArgs = [
        "-b-5"
        "-s 1"
      ];
      levels = [
        [
          0
          0
          60
        ]
        [
          1
          55
          65
        ]
        [
          2
          60
          70
        ]
        [
          3
          65
          75
        ]
        [
          6
          70
          80
        ]
        [
          7
          80
          85
        ]
        [
          "level auto"
          85
          32767
        ]
      ];
    };
    tlp = {
      enable = true;
      settings = {
        # "powersave" on AC is deliberate, not a copy-paste slip. With
        # amd_pstate=active (scaling_driver = amd-pstate-epp) the firmware picks
        # the operating point; the two available governors are presets for how the
        # kernel configures it, not scheduling algorithms. The one measured
        # difference between them is EPP availability:
        #   performance -> energy_performance_available_preferences collapses to a
        #                  single entry, so CPU_ENERGY_PERF_POLICY_ON_AC below is
        #                  inert and no bias can be expressed at all
        #   powersave   -> full EPP list restored (default performance
        #                  balance_performance balance_power power custom)
        # Neither governor moves the frequency window: scaling_max_freq is 5134889
        # and scaling_min_freq is 1100334 (= lowest_nonlinear_freq) under both.
        # Idle power is governed by cpuidle C-states, not by that floor - cpu0
        # spends ~75% of idle time in C3, where the core is gated entirely.
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # EPP is a 0-255 hint to the SMU; balance_performance is 0x80, i.e. the
        # midpoint of the scale (verified via MSR_AMD_CPPC_REQ bits 31:24), not a
        # small step down from performance (0x00). Measured on this machine at
        # ~4-5% busy: identical work done (Busy% x Bzy_MHz within 1.4%) for
        # 8.62 W vs 10.18 W package power, with bursts still reaching ~4.5 GHz.
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = [ "bluetooth" ];
        DEVICES_TO_ENABLE_ON_AC = [ "bluetooth" ];

        DISK_IOSCHED = [ "none" ];

        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 85;
        RESTORE_THRESHOLDS_ON_BAT = 1;
      };
    };
    upower.enable = true;
  };

  systemd = {
    services.ath11k_hibernate = {
      description = "load/unload ath11k to prevent hibernation issues";
      before = [
        "hibernate.target"
        "suspend-then-hibernate.target"
        "hybrid-sleep.target"
      ];
      unitConfig.StopWhenUnneeded = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "-${pkgs.kmod}/bin/modprobe -a -r ath11k_pci ath11k";
        ExecStop = "-${pkgs.kmod}/bin/modprobe -a ath11k_pci ath11k";
      };
      wantedBy = [
        "hibernate.target"
        "suspend-then-hibernate.target"
        "hybrid-sleep.target"
      ];
    };
    sleep.settings.Sleep = {
      HibernateMode = "shutdown";
    };
  };
}
