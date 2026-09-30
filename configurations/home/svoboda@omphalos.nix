{ flake, ... }:
let
  inherit (flake) self;
in
{
  imports = with self.homeModules; [
    default
    graphical
    graphical-niri
  ];

  home.username = "svoboda";
}
