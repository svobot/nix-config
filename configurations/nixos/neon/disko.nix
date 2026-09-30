{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_9100_PRO_2TB_S7YFNJ0L328118A";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        crypt = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypt";
            passwordFile = "/tmp/disk.key";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes =
                let
                  # btrfs applies compress/discard filesystem-wide from the first
                  # mount, so every subvolume entry has to carry the same set.
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                    "discard=async"
                  ];
                in
                {
                  "/root" = {
                    mountpoint = "/";
                    inherit mountOptions;
                  };
                  "/home" = {
                    mountpoint = "/home";
                    inherit mountOptions;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    inherit mountOptions;
                  };
                  "/state" = {
                    mountpoint = "/nix/state";
                    inherit mountOptions;
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    inherit mountOptions;
                    swap.swapfile = {
                      size = "32G";
                      priority = 0;
                    };
                  };
                };
            };
          };
        };
      };
    };
  };

  fileSystems."/nix/state".neededForBoot = true;
}
