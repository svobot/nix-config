# NixOS modules aggregator
# This is the main entry point for NixOS configurations
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules (shared across all NixOS hosts)
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.kolide-launcher.nixosModules.kolide-launcher
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index
  ]
  ++ (with self.nixosModules; [
    agenix-rekey
    core
    impermanence
  ]);

  # Home-manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flake; };
    sharedModules = [ self.homeModules.default ];
  };
}
