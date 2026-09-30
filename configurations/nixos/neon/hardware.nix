{ flake, pkgs, ... }:
let
  inherit (flake) inputs self;
in
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
    ])
    ++ (with self.nixosModules; [
      hardware-bluetooth
      hardware-sound
    ]);

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  console = {
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
  };

  hardware.enableRedistributableFirmware = true;

  # Don't connect using the monitor's ethernet port.
  systemd.network.networks."50-monitor-ethernet" = {
    matchConfig.MACAddress = "b4:e9:b8:67:c0:56";
    linkConfig.ActivationPolicy = "always-down";
  };

  nix.settings.system-features = [
    "benchmark"
    "big-parallel"
    "gccarch-znver5"
    "kvm"
    "nixos-test"
  ];
}
