{
  programs.nixvim = {
    enable = true;
    imports = [ ./config.nix ];
    nixpkgs.useGlobalPackages = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git.settings.core.editor = "nvim";
}
