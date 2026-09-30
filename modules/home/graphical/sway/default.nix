{
  flake,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = with self.homeModules; [
    graphical-sway-rofi
    graphical-sway-sway
    graphical-sway-waybar
  ];

  home = {
    packages = with pkgs; [
      grim
      slurp
      swaybg
      swayidle
      wl-clipboard
      xwayland
    ];
  };

  programs = {
    swaylock = {
      enable = true;
      settings = {
        indicator-caps-lock = true;
        scaling = "fill";
        show-failed-attempts = true;
        image = "${config.xdg.dataHome}/wall.jpg";
      };
    };
    wofi = {
      enable = true;
      settings = {
        allow_images = true;
        allow_markup = true;
      };
    };
  };
}
