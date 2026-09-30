# NixOS system user configuration for svoboda
{
  config,
  flake,
  lib,
  ...
}:
let
  inherit (flake) self;
in
{
  # Link home-manager user to NixOS user
  home-manager.users.svoboda.home = {
    username = config.users.users.svoboda.name;
    inherit (config.users.users.svoboda) uid;
  };

  age.secrets.svoboda-password.rekeyFile = self + "/secrets/svoboda-password.age";

  users.groups.svoboda.gid = config.users.users.svoboda.uid;

  users.users.svoboda = {
    createHome = true;
    description = "Tomáš Svoboda";
    group = "svoboda";
    extraGroups = [
      "wheel"
      "audio"
    ]
    ++ lib.optionals config.hardware.i2c.enable [ "i2c" ]
    ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
    ++
      lib.optionals
        (config.home-manager.users.svoboda.programs.niri.enable || config.programs.sway.enable)
        [
          "input"
          "video"
        ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
    ++ lib.optionals config.virtualisation.podman.enable [ "podman" ]
    ++ lib.optionals (config.services.netbird.clients ? work) [
      config.services.netbird.clients.work.user.group
    ];
    isNormalUser = true;
    uid = 1000;

    hashedPasswordFile = config.age.secrets.svoboda-password.path;
  };

  services.getty = {
    autologinUser = config.users.users.svoboda.name;
    autologinOnce = true;
  };
}
