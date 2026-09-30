{ config, ... }:
{
  environment.systemPackages = [ config.services.pipewire.package ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
