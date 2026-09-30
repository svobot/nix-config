{
  programs.seahorse.enable = true;

  security.pam.services = {
    login.enableGnomeKeyring = true;
    swaylock = { };
  };

  services.gnome.gnome-keyring.enable = true;
}
