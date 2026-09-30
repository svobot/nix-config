# Configuration wiring using nixos-unified helpers
# Uses mkLinuxSystem/mkHomeConfiguration for standardized setup
{ self, withSystem, ... }:
let
  inherit (self.nixos-unified.lib) mkLinuxSystem mkHomeConfiguration;

  # We use home-manager = false because we have our own customized home-manager setup
  # in modules/nixos/default.nix
  mkNixos = mkLinuxSystem { home-manager = false; };

  mkHome =
    system: name:
    withSystem system (
      { pkgs, ... }: mkHomeConfiguration pkgs (self + "/configurations/home/${name}.nix")
    );
in
{
  flake = {
    nixosConfigurations = {
      omphalos = mkNixos (self + "/configurations/nixos/omphalos");
    };

    homeConfigurations = {
      "svoboda@omphalos" = mkHome "x86_64-linux" "svoboda@omphalos";
    };
  };
}
