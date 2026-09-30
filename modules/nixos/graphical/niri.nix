{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.swayosd ];
}
