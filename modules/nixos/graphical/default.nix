{
  # silent boot for plymouth
  boot = {
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
    plymouth.enable = true;
  };

  programs = {
    dconf.enable = true;
    evince.enable = true;
  };

  services = {
    gnome.at-spi2-core.enable = true;
    gvfs.enable = true;
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
