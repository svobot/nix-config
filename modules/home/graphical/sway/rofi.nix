{ config, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${config.programs.alacritty.package}/bin/alacritty";
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background-color = mkLiteral "#282C33";
          border-color = mkLiteral "#2e343f";
          text-color = mkLiteral "#8ca0aa";
          spacing = mkLiteral "0";
          width = mkLiteral "512px";
          font = mkLiteral "SF Pro Display 12.5";
          highlight = mkLiteral "underline #bbccd5";
        };

        "inputbar" = {
          border = mkLiteral "0 0 1px 0";
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
        };

        "prompt" = {
          padding = mkLiteral "16px";
          border = mkLiteral "0 1px 0 0";
        };

        "textbox" = {
          background-color = mkLiteral "#2e343f";
          border = mkLiteral "0 0 1px 0";
          border-color = mkLiteral "#282C33";
          padding = mkLiteral "8px 16px";
        };

        "entry" = {
          padding = mkLiteral "16px";
        };

        "listview" = {
          cycle = mkLiteral "false";
          margin = mkLiteral "0 0 -1px 0";
          scrollbar = mkLiteral "false";
        };

        "element" = {
          border = mkLiteral "0 0 1px 0";
          padding = mkLiteral "16px";
        };

        "element selected" = {
          background-color = mkLiteral "#2e343f";
        };

        "element-icon" = {
          size = mkLiteral "1.65ch";
        };

        "element-text" = {
          padding = mkLiteral "0 0 0 16px";
        };

        "element-text, element-icon" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
      };
    extraConfig = {
      modes = "drun,run,ssh";
      show-icons = true;
      drun-match-fields = "name,generic,exec";
      #icon-theme = "Arc";
      #case-sensitive = false;
    };
  };
}
