# NixOS configuration for neon
{ flake, ... }:
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
    self.nixosModules.hardware-efi
    self.nixosModules.hardware-secureboot
    self.nixosModules.hardware-tpm
    self.nixosModules.hardware-dac
    self.nixosModules.hardware-ddcci
    self.nixosModules.hardware-logitech
    self.nixosModules.hardware-voyager

    # Host-specific files
    ./disko.nix
    ./gaming.nix
    ./graphical.nix
    ./hardware.nix
  ];

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvXsKc3p4/9iiZKybq2z+R2nMERWq3SpSJoTapHgYaQ";

  networking.hostName = "neon";

  system.stateVersion = "26.11";

  time.timeZone = "Europe/Prague";
}
