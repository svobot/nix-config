ctx@{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mako = {
    enable = true;
    settings =
      let
        shareDirs = [
          "${config.home.profileDirectory}/share"
          "/run/current-system/sw/share"
          "/usr/share"
        ];

        colors = import ./colors.nix ctx;
      in
      {
        default-timeout = 5 * 1000; # millis
        font = "SF Pro Text 11";
        icon-path = lib.concatStringsSep ":" (
          map (dir: "${dir}/icons/hicolor") shareDirs ++ map (dir: "${dir}/pixmaps") shareDirs
        );
        icons = true;
        max-icon-size = 96;
        max-visible = 3;
        sort = "-time";
        text-color = colors.grays.light.gray5;
        background-color = colors.grays.dark.gray6;
        border-color = colors.default.blue;
        border-radius = 7;
        padding = "10";
        width = 400;
      };
  };

  systemd.user.services = {
    mako = {
      Unit = {
        Description = "mako";
        Documentation = [ "man:mako(1)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.mako}/bin/mako";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
