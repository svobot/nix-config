{ flake, ... }:
let
  inherit (flake) self;
in
{
  imports = with self.nixosModules; [
    graphical
    graphical-niri
    graphical-trusted
    pam-limits
  ];

  age.secrets.wallpaper = {
    rekeyFile = self + "/secrets/wallpaper.age";
    owner = "svoboda";
  };

  home-manager.users.svoboda.imports = with self.homeModules; [
    graphical
    graphical-niri
  ];

  systemd.oomd.enableSystemSlice = true;
}
