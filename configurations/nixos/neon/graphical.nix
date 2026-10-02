{ lib, pkgs, ... }:
{
  # VCP 60 (Input Source) values of the U3225QE: 0x19 Thunderbolt, 0x0f
  # DisplayPort, 0x11 HDMI.
  home-manager.users.svoboda.programs.niri.settings.binds."Mod+Shift+S" = {
    action.spawn = [
      (lib.getExe pkgs.ddcutil)
      "--model"
      "DELL U3225QE"
      "setvcp"
      "60"
      "0x19"
    ];
    hotkey-overlay.title = "Hand the monitor over to omphalos";
  };
}
