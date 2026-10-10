{
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
    package = lib.mkIf (osConfig.hardware.amdgpu.initrd.enable or false) pkgs.btop-rocm;
    settings = {
      shown_boxes = "cpu mem net proc gpu0";
      swap_disk = false;
    };
  };
}
