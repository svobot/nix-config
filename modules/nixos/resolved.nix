# systemd-resolved configuration - NixOS only
{
  networking = {
    firewall.allowedUDPPorts = [
      5353 # mDNS
    ];
    networkmanager.dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "1.1.1.1"
        "2606:4700:4700::1111"
        "8.8.8.8"
        "2001:4860:4860::8844"
      ];
      DNSSEC = false;
      Domains = [ "~." ];
      LLMNR = false;
      MulticastDNS = true;
    };
  };
}
