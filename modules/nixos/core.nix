{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = with self.nixosModules; [
    nix
    nixpkgs
    registry
    resolved
    zram
  ];

  documentation = {
    dev.enable = true;
    man.cache.enable = true;
  };

  environment = {
    persistence."/nix/state".directories = [ "/var/lib/fwupd" ];
    systemPackages = with pkgs; [
      ghostty.terminfo
      man-pages
      neovim
      nfs-utils
    ];
  };

  programs = {
    fish.enable = true;
    nix-index.enable = true;
    command-not-found.enable = false;
    mosh.enable = true;
  };

  boot = {
    initrd.systemd.enable = true;
    kernelParams = [ "log_buf_len=10M" ];
  };

  console.keyMap = "uk";

  i18n.defaultLocale = "en_GB.UTF-8";

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useNetworkd = true;
    wireguard.enable = true;
  };

  security = {
    polkit.enable = true;
    sudo-rs.enable = true;
  };

  services = {
    dbus.implementation = "broker";
    # TODO: config tailscale
    fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };
    openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  system.stateVersion = lib.mkDefault "25.11";

  systemd = {
    coredump.settings.Coredump.MaxUse = "2G";
    network = {
      enable = true;
      networks = {
        "60-ethernet" = {
          # Type = "ether" also matches Docker's veth pairs, and networkd would take
          # them over and run DHCP on them, hence Kind = "!*": physical NICs have
          # an empty netlink info_kind while veth/bridge/wireguard devices do not.
          matchConfig = {
            Type = "ether";
            Kind = "!*";
          };
          DHCP = "yes";
          networkConfig.MulticastDNS = "resolve";
          dhcpV4Config.RouteMetric = 20;
          ipv6AcceptRAConfig.RouteMetric = 20;
        };
        "70-wifi" = {
          matchConfig.WLANInterfaceType = "station";
          DHCP = "yes";
          networkConfig.MulticastDNS = "resolve";
          dhcpV4Config.RouteMetric = 40;
          ipv6AcceptRAConfig.RouteMetric = 40;
        };
      };
      wait-online = {
        anyInterface = true;
        timeout = 30;
      };
    };
    oomd = {
      enableUserSlices = true;
      settings.OOM.DefaultMemoryPressureDurationSec = "60s";
    };
    services.tailscaled = {
      after = [
        "network-online.target"
        "systemd-resolved.service"
      ];
      wants = [
        "network-online.target"
        "systemd-resolved.service"
      ];
    };
  };

  age.secrets.root-password.rekeyFile = lib.mkDefault (
    self + "/secrets/${config.networking.hostName}-root-password.age"
  );

  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = config.age.secrets.root-password.path;
  };
}
