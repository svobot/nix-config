{ config, ... }:
{
  environment.systemPackages = [ config.services.pipewire.package ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      # Prefer declared device priority over the remembered manual picks.
      # A manual pick still overrides for the running session.
      extraConfig."10-default-nodes-by-priority"."wireplumber.settings"."node.restore-default-targets" =
        false;
    };
  };
}
