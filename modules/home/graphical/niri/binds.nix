{ lib, pkgs, ... }:
let
  spawn = argv: { action.spawn = argv; };
  spawnLocked = argv: {
    action.spawn = argv;
    allow-when-locked = true;
  };
  osd = args: spawnLocked ([ "swayosd-client" ] ++ args);
  brightness = args: spawnLocked ([ (lib.getExe pkgs.osd-brightness) ] ++ args);

  workspaceBinds = lib.mergeAttrsList (
    map (n: {
      "Mod+${toString n}".action.focus-workspace = n;
      "Mod+Ctrl+${toString n}".action.move-column-to-workspace = n;
      "Mod+Ctrl+Shift+${toString n}".action.move-window-to-workspace = n;
    }) (lib.range 1 9)
  );
in
{
  programs.niri.settings.binds = workspaceBinds // {
    "Mod+Return" = spawn "alacritty" // {
      hotkey-overlay.title = "Open a Terminal: alacritty";
    };
    # TODO: try: spawn "systemd-run" "--user" "--scope" "-p" "MemoryMax=512M" "fuzzel"
    "Mod+Space" = spawn "fuzzel" // {
      hotkey-overlay.title = "Run an Application: fuzzel";
    };
    "Mod+Q" = spawn "swaylock" // {
      hotkey-overlay.title = "Lock the Screen: swaylock";
    };
    "Mod+P" = spawn [
      "nirius"
      "toggle-follow-mode"
    ];

    XF86AudioRaiseVolume = osd [
      "--output-volume"
      "raise"
    ];
    XF86AudioLowerVolume = osd [
      "--output-volume"
      "lower"
    ];
    XF86AudioMute = osd [
      "--output-volume"
      "mute-toggle"
    ];
    XF86AudioMicMute = osd [
      "--input-volume"
      "mute-toggle"
    ];
    XF86MonBrightnessUp = brightness [
      "raise"
      "all"
    ];
    XF86MonBrightnessDown = brightness [
      "lower"
      "all"
    ];

    "Mod+T" = {
      action.toggle-overview = [ ];
      repeat = false;
    };
    "Mod+Shift+Q" = {
      action.close-window = [ ];
      repeat = false;
    };

    "Mod+Left".action.focus-column-left = [ ];
    "Mod+Down".action.focus-window-down = [ ];
    "Mod+Up".action.focus-window-up = [ ];
    "Mod+Right".action.focus-column-right = [ ];
    "Mod+N".action.focus-column-left = [ ];
    "Mod+E".action.focus-window-down = [ ];
    "Mod+I".action.focus-window-up = [ ];
    "Mod+O".action.focus-column-right = [ ];

    "Mod+Ctrl+Left".action.move-column-left = [ ];
    "Mod+Ctrl+Right".action.move-column-right = [ ];
    "Mod+Ctrl+N".action.move-column-left = [ ];
    "Mod+Ctrl+O".action.move-column-right = [ ];

    "Mod+Home".action.focus-column-first = [ ];
    "Mod+End".action.focus-column-last = [ ];
    "Mod+Shift+Home".action.move-column-to-first = [ ];
    "Mod+Shift+End".action.move-column-to-last = [ ];

    "Mod+Page_Down".action.focus-workspace-down = [ ];
    "Mod+Page_Up".action.focus-workspace-up = [ ];
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
    "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
    "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

    "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
    "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
    "Mod+Shift+U".action.move-workspace-down = [ ];
    "Mod+Shift+I".action.move-workspace-up = [ ];

    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = [ ];
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = [ ];
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action.move-column-to-workspace-down = [ ];
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action.move-column-to-workspace-up = [ ];
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action.focus-column-right = [ ];
    "Mod+WheelScrollLeft".action.focus-column-left = [ ];
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

    "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
    "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
    "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
    "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

    "Mod+Shift+Left".action.consume-or-expel-window-left = [ ];
    "Mod+Shift+Right".action.consume-or-expel-window-right = [ ];
    "Mod+Shift+Down".action.move-window-down = [ ];
    "Mod+Shift+Up".action.move-window-up = [ ];

    "Mod+Comma".action.consume-window-into-column = [ ];
    "Mod+Period".action.expel-window-from-column = [ ];

    "Mod+R".action.switch-preset-column-width = [ ];
    "Mod+Shift+R".action.switch-preset-window-height = [ ];
    "Mod+Ctrl+R".action.reset-window-height = [ ];
    "Mod+F".action.maximize-column = [ ];
    "Mod+Shift+F".action.fullscreen-window = [ ];
    "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

    "Mod+C".action.center-column = [ ];
    "Mod+Ctrl+C".action.center-visible-columns = [ ];

    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";
    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    "Mod+Shift+D".action.toggle-window-floating = [ ];
    "Mod+D".action.switch-focus-between-floating-and-tiling = [ ];
    "Mod+W".action.toggle-column-tabbed-display = [ ];

    Print.action.screenshot = [ ];
    "Ctrl+Print".action.screenshot-screen = [ ];
    "Alt+Print".action.screenshot-window = [ ];

    "Mod+Escape" = {
      action.toggle-keyboard-shortcuts-inhibit = [ ];
      allow-inhibiting = false;
    };

    "Mod+Shift+E".action.quit = [ ];
    "Ctrl+Alt+Delete".action.quit = [ ];
    "Mod+Shift+P".action.power-off-monitors = [ ];
  };
}
