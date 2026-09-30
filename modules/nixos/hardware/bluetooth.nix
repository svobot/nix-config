{
  environment.persistence."/nix/state".directories = [ "/var/lib/bluetooth" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    disabledPlugins = [ "sap" ];
    settings = {
      General = {
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
}
