# A client connecting to the idle host would otherwise get the 4K desktop
# squeezed into a handheld-sized stream; Big Picture goes fullscreen via the
# niri rule and streams through Steam's own GL path.
# The "Starting/Stopped desktop stream" lines flap whenever the overlay
# toggles mid-game, so only the once-per-session markers are used.
{ config, pkgs, ... }:
{
  home-manager.users.svoboda.systemd.user.services.steam-remoteplay-bigpicture = {
    Unit.Description = "Enter Big Picture when a Remote Play client connects";
    Service = {
      ExecStart = pkgs.writeShellScript "steam-remoteplay-bigpicture" ''
        ${pkgs.coreutils}/bin/tail -n0 -F "$HOME/.steam/steam/logs/streaming_log.txt" \
          | while IFS= read -r line; do
            case $line in
              *"Switching video stream from NONE to Desktop_MovieStream"*)
                ${config.programs.steam.package}/bin/steam steam://open/bigpicture
                ;;
              *"PipeWire: Deinitializing streaming"*)
                ${config.programs.steam.package}/bin/steam steam://close/bigpicture
                ;;
            esac
          done
      '';
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
