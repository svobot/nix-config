{
  plugins = {
    #web-devicons.enable = true;
    telescope = {
      enable = true;
      extensions = {
        file-browser = {
          enable = true;
          settings.hijack_netrw = true;
        };
        frecency = {
          enable = true;
          settings = {
            db_safe_mode = false;
            matcher = "fuzzy";
          };
        };
        fzy-native.enable = true;
        ui-select.enable = true;
        undo.enable = true;
      };
      settings = {
        defaults = {
          prompt_prefix = "   ";
          selection_caret = "  ";
          sorting_strategy = "ascending";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
          path_display = [ "truncate" ];

          mappings = {
            i = {
              "<C-Down>" = "cycle_history_next";
              "<C-Up>" = "cycle_history_prev";
            };
          };
        };
        pickers.colorscheme.enable_preview = true;
      };
      keymaps = {
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Lists open buffers in current neovim instance";
        };
        "<leader>fc" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "Live fuzzy search inside of the currently open buffer";
        };
        "<leader>fr" = {
          action = "frecency";
          options.desc = "Search for files";
        };
        "<leader>fl" = {
          action = "live_grep";
          options.desc = "Search for a string and get results live as you type";
        };
        "<leader>ff" = {
          action = "git_files";
          options.desc = "Fuzzy search for files tracked by Git";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "List commits for current directory with diff preview";
        };
        "<leader>gb" = {
          action = "git_bcommits";
          options.desc = "List commits for current buffer with diff preview";
        };
        "<leader>gs" = {
          action = "git_status";
          options.desc = "List git status for current directory";
        };
        "<leader>u" = {
          action = "undo";
          options.desc = "List undo history";
        };
      };
    };
  };
  highlightOverride =
    let
      bg.__raw = ''vim.api.nvim_get_hl(0, { name = "BufferLineBuffer" }).bg'';
      fg.__raw = ''vim.api.nvim_get_hl(0, { name = "TelescopeNormal" }).fg'';
      bg_alt.__raw = ''vim.api.nvim_get_hl(0, { name = "Visual" }).bg'';
      green.__raw = ''vim.api.nvim_get_hl(0, { name = "String" }).fg'';
      red.__raw = ''vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg'';
    in
    {
      TelescopeBorder = {
        inherit bg;
        fg = bg_alt;
      };
      TelescopeNormal = {
        inherit bg;
      };
      TelescopePreviewBorder = {
        fg = bg;
        inherit bg;
      };
      TelescopePreviewNormal = {
        inherit bg;
      };
      TelescopePreviewTitle = {
        fg = bg;
        bg = green;
      };
      TelescopePromptBorder = {
        fg = bg_alt;
        bg = bg_alt;
      };
      TelescopePromptNormal = {
        inherit fg;
        bg = bg_alt;
      };
      TelescopePromptCounter = {
        inherit fg;
        bg = bg_alt;
      };
      TelescopePromptPrefix = {
        fg = red;
        bg = bg_alt;
      };
      TelescopePromptTitle = {
        fg = bg;
        bg = red;
      };
      TelescopeResultsBorder = {
        fg = bg;
        inherit bg;
      };
      TelescopeResultsNormal = {
        inherit bg;
      };
      TelescopeResultsTitle = {
        fg = bg;
        inherit bg;
      };
    };
}
