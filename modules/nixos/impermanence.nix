{
  environment.persistence."/nix/state" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [ "/etc/machine-id" ];
  };

  # Read in place rather than bind-mounted into /etc: agenix derives its
  # identityPaths from this and decrypts during activation.
  services.openssh.hostKeys = [
    {
      path = "/nix/state/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
}
