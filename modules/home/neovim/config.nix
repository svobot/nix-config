{
  config,
  lib,
  ...
}:
let
  icons = import ./util/icons.nix;
in
{
  imports = [
    ./completion.nix
    ./core.nix
    ./keymap.nix
    ./lsp.nix
    ./statusline.nix
    ./telescope.nix
  ];

  viAlias = true;
  vimAlias = true;
  withRuby = false;

  luaLoader.enable = true;

  clipboard = {
    register = "unnamedplus";
    providers = {
      wl-copy.enable = true;
    };
  };

  colorscheme = "onedark";

  colorschemes = {
    onedark = {
      enable = true;
      settings = {
        code_style = {
          keywords = "bold,italic";
        };
        diagnostics = {
          undercurl = true;
        };
        highlights = {
          "@nospell" = {
            fg = "none";
          };
          "@spell" = {
            fg = "none";
          };
        };
      };
    };
    catppuccin.enable = true;
    kanagawa.enable = true;
    tokyonight.enable = true;
  };

  plugins = {
    bufferline = {
      enable = true;
      settings.options = lib.mkMerge [
        {
          always_show_bufferline = false;
          buffer_close_icon = icons.BufferClose;
        }
        (lib.mkIf config.plugins.lsp.enable {
          diagnostics = "nvim_lsp";
          diagnostics_indicator.__raw = ''
            function(_, _, diag)
              local error = diag.error and "${icons.DiagnosticError} " .. diag.error .. " " or ""
              local warning = diag.warning and "${icons.DiagnosticWarn} " .. diag.warning .. " " or ""
              return vim.trim(error .. warning)
            end
          '';
        })
        (lib.mkIf config.plugins.snacks.enable {
          close_command.__raw = "function(n) Snacks.bufdelete.delete(n) end";
          right_mouse_command.__raw = "function(n) Snacks.bufdelete.delete(n) end";
        })
      ];
    };
    fidget = {
      enable = false;
      settings = {
        notification = {
          override_vim_notify = true;
        };
      };
    };
    gitsigns = {
      enable = true;
      settings =
        let
          signs = {
            add.text = icons.GitSignChanged;
            change.text = icons.GitSignChanged;
            delete.text = icons.GitSignDeleted;
            topdelete.text = icons.GitSignTopDeleted;
            changedelete.text = icons.GitSignChanged;
            untracked.text = icons.GitSignChanged;
          };
        in
        {
          inherit signs;
          signs_staged = signs;
        };
    };
    guess-indent.enable = true;
    indent-blankline = {
      enable = true;
      settings.indent.char = icons.IndentationRuler;
    };
    multicursors.enable = true;
    nix-develop.enable = true;
    noice = {
      enable = true;
      settings = {
        messages.enabled = false;
        lsp = {
          progress.enabled = true;
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
        };
        presets = {
          bottom_search = true; # use a classic bottom cmdline for search
          command_palette = true; # position the cmdline and popupmenu together
          long_message_to_split = true; # long messages will be sent to a split
          inc_rename = false; # enables an input dialog for inc-rename.nvim
          lsp_doc_border = true; # add a border to hover docs and signature help
        };
        views.mini.win_options.winblend = 0; # make notifications background opaque
      };
    };
    nvim-autopairs.enable = true;
    sleuth.enable = true;
    snacks = {
      enable = true;
      settings = {
        bufdelete.enabled = true;
        words = {
          enabled = true;
        };
      };
    };
    todo-comments = {
      enable = true;
      settings = {
        keywords = {
          FIX.icon = icons.TodoFix;
          TODO.icon = icons.TodoTodo;
          HACK.icon = icons.TodoHack;
          WARN.icon = icons.TodoWarn;
          PERF.icon = icons.TodoPerf;
          NOTE.icon = icons.TodoNote;
          TEST.icon = icons.TodoTest;
        };
        highlight = {
          keyword = "bg";
          after = "";
        };
      };
      #keymaps.todoTelescope.key = "<leader>tc";
    };
    treesitter = {
      enable = true;
      settings = {
        auto_install = false;
        highlight.enable = true;
        indent.enable = true;
        incremental_selection.enable = true;
      };
    };
    trim = {
      enable = true;
      settings = rec {
        ft_blocklist = [
          "TelescopePrompt"
          "Trouble"
          "dashboard"
          "help"
        ];
        highlight = true;
        highlight_bg.__raw = ''vim.api.nvim_get_hl(0, {name= "DiffDelete"}).bg'';
        highlight_ctermbg = highlight_bg;
        trim_first_line = false;
        trim_last_line = false;
        trim_on_write = false;
      };
    };
    vim-matchup = {
      enable = true;
      settings.surround_enabled = 1;
    };
    vim-suda.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
  };

  highlightOverride = {
    NoiceFormatProgressDone = {
      link = "NonText";
    };
    NoiceFormatProgressTodo = {
      link = "NonText";
    };
  };

  globals = {
    matchup_treesitter_enabled = false;
  };
}
