# NixOS configuration for omphalos
{
  config,
  flake,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = [
    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-svoboda
    self.nixosModules.profiles-workstation
    self.nixosModules.profiles-work
    self.nixosModules.btrfs-root
    self.nixosModules.hardware-thinkpad-t14s-gen4
    self.nixosModules.hardware-efi
    self.nixosModules.hardware-secureboot
    self.nixosModules.hardware-tpm
    self.nixosModules.hardware-dac
    self.nixosModules.hardware-ddcci
    self.nixosModules.hardware-interception-tools
    self.nixosModules.hardware-voyager

    # Host-specific files
    ./graphical.nix
    ./state.nix
  ];

  # TODO: Check this is necessary:
  #   programs.ssh.startAgent = true;

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Host-specific configuration
  boot = {
    initrd.luks.devices.crypt.device = "/dev/disk/by-uuid/dad86045-c19f-4a16-bdfb-9de82fe26578";
    resumeDevice = "/dev/mapper/crypt";
    kernelParams = [
      "resume_offset=533760" # btrfs inspect-internal map-swapfile -r swapfile
    ];
  };

  fileSystems =
    let
      # btrfs applies compress/discard filesystem-wide from the first mount, so
      # every subvolume entry has to carry the same set.
      btrfsSubvolume = subvol: {
        device = "/dev/disk/by-uuid/745b73eb-5ccb-40e7-908f-ae7045ecd820";
        fsType = "btrfs";
        options = [
          "noatime"
          "compress=zstd"
          "discard=async"
          "subvol=${subvol}"
        ];
      };
    in
    {
      "/" = btrfsSubvolume "root";
      "/boot" = {
        device = "/dev/disk/by-uuid/765A-2EFF";
        fsType = "vfat";
        options = [
          "umask=0077"
          "discard"
        ];
      };
      "/home" = btrfsSubvolume "home";
      "/nix" = btrfsSubvolume "nix";
      "/nix/state" = btrfsSubvolume "persist" // {
        neededForBoot = true;
      };
      "/swap" = btrfsSubvolume "swap";
    };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQdwzOKq7bCBuVMdus9qkVdfYZDAQzXA4Bh+ABT31Ga";

  networking = {
    hostName = "omphalos";
    wireless.iwd = {
      enable = true;
      settings = {
        Rank = {
          BandModifier2_4GHz = 1.0;
          BandModifier5GHz = 2.0;
          BandModifier6GHz = 4.0;
        };
      };
    };
  };

  # NOTE: Workaround for: https://github.com/NixOS/nixpkgs/pull/548689
  # geoclue >= 2.8 has no built-in default for ip/method, and the nixpkgs module
  # generates a geoclue.conf without an [ip] section, so the GeoIP source gets
  # disabled. With iwd there is no wpa_supplicant for the WiFi source to scan
  # through either, which would leave geoclue without any usable source.
  environment.etc."geoclue/conf.d/10-ip-source.conf".text = ''
    [ip]
    enable=true
    method=ichnaea
  '';
  systemd.services.geoclue.restartTriggers = [
    config.environment.etc."geoclue/conf.d/10-ip-source.conf".source
  ];

  services = {
    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      submitData = false;
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
    };
    automatic-timezoned.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "lock";
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "reboot";
    };
    upower.criticalPowerAction = "Hibernate";
    udev.packages = with pkgs; [ logitech-udev-rules ];
  };

  systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      priority = 0;
    }
  ];
}
