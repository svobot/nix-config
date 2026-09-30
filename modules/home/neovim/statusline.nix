let
  icons = import ./util/icons.nix;
in
{
  plugins = {
    navic = {
      enable = true;
      settings = {
        lsp.auto_attach = true;
        separator = " ";
        highlight = true;
        depth_limit = 5;
        depth_limit_indicator = "${icons.Ellipsis}";
      };
    };
    lualine =
      let
        filetype = {
          __unkeyed-1 = "filetype";
          icon_only = true;
          padding = {
            left = 1;
            right = 0;
          };
          separator = "";
        };
        filename = {
          __unkeyed-1 = "filename";
          padding = {
            left = 0;
            right = 1;
          };
          symbols = {
            modified = icons.FileModified;
            readonly = icons.FileReadOnly;
            unnamed = "[No Name]";
            newfile = icons.FileNew;
          };
          separator = "";
        };
        diff = {
          __unkeyed-1 = "diff";
          symbols = {
            added = "${icons.GitAdd} ";
            modified = "${icons.GitChange} ";
            removed = "${icons.GitDelete} ";
          };
        };
        diagnostics = {
          __unkeyed-1 = "diagnostics";
          sources = [ "nvim_lsp" ];
          symbols = {
            error = "${icons.DiagnosticError} ";
            warn = "${icons.DiagnosticWarn} ";
            info = "${icons.DiagnosticInfo} ";
            hint = "${icons.DiagnosticHint} ";
          };
        };
        progress = {
          __unkeyed-1 = "progress";
          padding = {
            left = 1;
            right = 1;
          };
          separator = "";
        };
        location = {
          __unkeyed-1 = "location";
          padding = {
            left = 1;
            right = 0;
          };
        };
      in
      {
        enable = true;
        settings = {
          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [
              filetype
              filename
            ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" ];
            lualine_c = [
              filetype
              filename
              diagnostics
              "navic"
            ];
            lualine_x = [
              "searchcount"
              diff
            ];
            lualine_y = [
              progress
              location
            ];
            lualine_z.__empty = { };
          };
          options = {
            globalstatus = true;
            section_separators = "";
            component_separators = "";
            theme = "auto";
          };
        };
      };
  };
}
