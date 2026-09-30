{ pkgs, ... }:
{
  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
    userDirs = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      setSessionVariables = true;
      desktop = "$HOME/opt";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Documents/Music";
      pictures = "$HOME/Documents/Pictures";
      publicShare = "$HOME/opt";
      templates = "$HOME/opt";
      videos = "$HOME/opt";
    };
  };
}
