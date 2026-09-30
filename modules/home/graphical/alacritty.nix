{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      #env.TERM = "xterm-256color";
      font = {
        normal = {
          family = "monospace";
          style = "Regular";
        };
        bold = {
          family = "monospace";
          style = "Bold";
        };
        italic = {
          family = "monospace";
          style = "Italic";
        };
        size = 11;
      };
      terminal.shell.program = "${pkgs.fish}/bin/fish";
    };
  };
}
