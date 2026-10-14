{ lib, pkgs, ... }:
{
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-pipewire";
        extraEnv = {
          GBM_BACKENDS_PATH = "/run/opengl-driver/lib/gbm:/run/opengl-driver-32/lib/gbm";
          # Proton's xalia helper runs a Windows SDL3 that fails on the override
          # below with an error box, also during install-script runs that launch
          # options cannot wrap.
          PROTON_USE_XALIA = "0";
          SDL3_DYNAMIC_API = "${lib.getLib pkgs.sdl3-flydigi-rumble}/lib/libSDL3.so.0";
        };
      };
    };
  };

  home-manager.users.svoboda.home.packages = with pkgs; [
    cemu
    mangohud
    shadps4
  ];
}
