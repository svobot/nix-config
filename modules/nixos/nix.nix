{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      accept-flake-config = true;
      allowed-users = [ "@wheel" ];
      build-users-group = "nixbld";
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      cores = 0;
      max-jobs = "auto";
      experimental-features = [
        "auto-allocate-uids"
        "configurable-impure-env"
        "flakes"
        "nix-command"
      ];
      connect-timeout = 5;
      http-connections = 0;
      max-substitution-jobs = 32;
      flake-registry = "/etc/nix/registry.json";
      always-allow-substitutes = true;
      impure-env = [ "NIXPKGS_ALLOW_UNFREE" ];
      auto-optimise-store = true;
      sandbox = true;
    };

    distributedBuilds = true;

    channel.enable = false;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d --keep-one";
    };
  };
}
