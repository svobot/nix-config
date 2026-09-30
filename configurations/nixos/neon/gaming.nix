{ pkgs, ... }:
{
  programs = {
    gamemode.enable = true;
    steam.enable = true;
  };

  home-manager.users.svoboda.home.packages = with pkgs; [
    cemu
    mangohud
    shadps4
  ];
}
