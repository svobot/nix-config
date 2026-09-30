{
  description = "svobot's configuration";

  inputs = {
    # Core infrastructure
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # CI workflow generation
    actions-nix = {
      url = "github:nialov/actions.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
    };

    # nixos-unified for unified configuration management
    nixos-unified.url = "github:srid/nixos-unified";

    # System modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Security and secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    # Persistence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    # Secure boot
    # rust-overlay is a direct input only so lanzaboote's v1.1.0-pinned copy can
    # follow it; that pin is old enough to trip nixpkgs' stdenv.is* deprecation.
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "git-hooks";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Build tools
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    # Package index
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Editor configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        #nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Development tools
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utility inputs
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    systems.url = "github:nix-systems/default";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
      systems = [
        "x86_64-linux"
      ];
    };
}
