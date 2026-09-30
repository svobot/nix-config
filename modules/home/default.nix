# Shared home-manager configuration for all platforms
{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
  ]
  ++ (with self.homeModules; [
    bash
    btop
    dev
    fish
    git
    neovim
    starship
    xdg
  ]);

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    stateVersion = lib.mkDefault "25.11";
    sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
    packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
      with pkgs;
      [
        mosh
        nix-closure-size
        nix-output-monitor
      ]
    );
    shellAliases = {
      cat = "bat";
      cls = "clear";
      l = "ls";
      la = "ls --all";
      ls = "eza --binary --header --long --classify";
      lst = "eza --binary --header --long --classify -T";
      man = "batman";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = [ "--disable-up-arrow" ];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf = {
      enable = true;
      historyWidget.command = "";
    };
    gpg.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
