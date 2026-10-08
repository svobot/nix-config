{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;
  };

  environment = {
    # sbctl otherwise looks under /var/lib/sbctl and refuses the legacy layout.
    etc."sbctl/sbctl.conf".source = (pkgs.formats.yaml { }).generate "sbctl.conf" {
      keydir = "${config.boot.lanzaboote.pkiBundle}/keys";
      guid = "${config.boot.lanzaboote.pkiBundle}/GUID";
    };
    persistence."/nix/state".directories = [ config.boot.lanzaboote.pkiBundle ];
    systemPackages = with pkgs; [ sbctl ];
  };
}
