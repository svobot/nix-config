# Hosts set boot.initrd.luks.devices.crypt.device and their subvolume mounts.
{
  boot = {
    initrd = {
      luks.devices.crypt = {
        allowDiscards = true;
        bypassWorkqueues = true;
      };
      systemd.services.rollback = {
        description = "Wipe btrfs root subvolume";
        wantedBy = [ "initrd.target" ];
        after = [
          "systemd-cryptsetup@crypt.service"
          "systemd-hibernate-resume.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs_tmp
          mount -o subvol=/ /dev/mapper/crypt /btrfs_tmp
          mkdir -p /btrfs_tmp/old_roots

          if [[ -e /btrfs_tmp/root ]]; then
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H-%M-%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              touch "/btrfs_tmp/old_roots/$timestamp"
          fi

          for i in $(find /btrfs_tmp/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
              btrfs subvolume delete --recursive "$i" || echo "warning: could not prune $i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };
    supportedFilesystems = [ "btrfs" ];
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    fstrim.enable = false;
  };
}
