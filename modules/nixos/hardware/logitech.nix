{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.logitech-udev-rules ];
}
