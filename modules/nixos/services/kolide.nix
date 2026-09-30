{ config, flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [ inputs.kolide-launcher.nixosModules.kolide-launcher ];

  age.secrets.work-kolide = {
    rekeyFile = self + "/secrets/work-kolide.age";
    path = "${config.services.kolide-launcher.enrollSecretDirectory}/secret";
  };

  environment.persistence."/nix/state".directories = [ "/var/kolide-k2" ];

  services.kolide-launcher = {
    enable = true;
    autoupdateInterval = "90000h";
    autoupdaterInitialDelay = "90000h";
  };
}
