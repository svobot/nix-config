{
  config,
  lib,
  pkgs,
  ...
}:
let
  icons = import ./util/icons.nix;
in
{
  extraPackages = with pkgs; [
    nixfmt
  ];

  diagnostic.settings = {
    update_in_insert = true;
    severity_sort = true;

    virtual_text = {
      severity.min = "warn";
      source = "if_many";
      prefix = "";
    };
    float.border = "none";
    jump = {
      severity.__raw = "vim.diagnostic.severity.WARN";
    };

    signs = {
      text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = icons.DiagnosticError;
        "__rawKey__vim.diagnostic.severity.WARN" = icons.DiagnosticWarn;
        "__rawKey__vim.diagnostic.severity.HINT" = icons.DiagnosticHint;
        "__rawKey__vim.diagnostic.severity.INFO" = icons.DiagnosticInfo;
      };
    };
  };

  lsp = {
    keymaps = lib.mkMerge [
      [
        {
          key = "[d";
          action.__raw = "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        }
        {
          key = "]d";
          action.__raw = "function() vim.diagnostic.jump({ count=1, float=true }) end";
        }
        {
          key = "<space>e";
          action.__raw = "function() vim.diagnostic.open_float() end";
        }
        {
          key = "ca";
          lspBufAction = "code_action";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
        }
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "gr";
          lspBufAction = "references";
        }
        {
          key = "<space>D";
          lspBufAction = "type_definition";
        }
        {
          key = "<space>rn";
          lspBufAction = "rename";
        }
        {
          key = "<leader>cd";
          mode = [ "n" ];
          action.__raw =
            #lua
            ''
              function()
                local conf = vim.diagnostic.config()
                if conf.virtual_lines then
                  conf.virtual_lines = false
                else
                  conf.virtual_lines = { current_line = true }
                end
                vim.diagnostic.config(conf)
              end
            '';
          options.desc = "Show diagnostics for current line";
        }
        {
          key = "<leader>cf";
          mode = [
            "n"
            "v"
          ];
          action.__raw =
            # lua
            "function() vim.lsp.buf.format({ async = true }) end";
          options.desc = "Format the current buffer";
        }
        {
          key = "<leader>uh";
          mode = [ "n" ];
          action.__raw =
            #lua
            "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
          options.desc = "Toggle inlay hints";
        }
        {
          key = "<leader>uf";
          mode = [ "n" ];
          action.__raw =
            #lua
            ''
              function()
                require("lsp-format").toggle({ args = "" })

                vim.notify(
                  (require("lsp-format").disabled and "Disabled " or "Enabled ") .. "formatting on save",
                  "info",
                  { title = "Formatter" }
                )
              end
            '';
          options.desc = "Toggle format on save";
        }
      ]
      (lib.mkIf config.plugins.telescope.enable [
        {
          key = "gd";
          mode = [
            "n"
            "v"
          ];
          action.__raw = ''require("telescope.builtin").lsp_definitions'';
          options.desc = "View LSP definitions in telescope";
        }
        {
          key = "gi";
          mode = [
            "n"
            "v"
          ];
          action.__raw = ''require("telescope.builtin").lsp_implementations'';
          options.desc = "View LSP implementations in telescope";
        }
        {
          key = "gr";
          mode = [
            "n"
            "v"
          ];
          action.__raw = ''require("telescope.builtin").lsp_references'';
          options.desc = "View LSP references in telescope";
        }
        {
          key = "<space>D";
          mode = [
            "n"
            "v"
          ];
          action.__raw = ''require("telescope.builtin").lsp_type_definitions'';
          options.desc = "View LSP type definitions in telescope";
        }
      ])
    ];
    servers = {
      basedpyright = {
        enable = true;
        package = null;
      };
      bashls.enable = true;
      elmls.enable = true;
      hls = {
        enable = true;
        package = null;
        packageFallback = true;
        config = {
          cmd = [
            "${pkgs.hls-scoped}/bin/hls-scoped"
            "--lsp"
          ];
          filetypes = [
            "haskell"
            "lhaskell"
            "cabal"
          ];
          settings.haskell = {
            cabalFormattingProvider = "cabal-fmt";
            formattingProvider = "fourmolu";
            plugin = {
              fourmolu.config.external = true;
              ghcide-completions.config.autoExtendOn = false;
            };
            # sessionLoading = "multipleComponents";
            sessionLoading = "singleComponent";
          };
        };
      };
      jsonls.enable = true;
      lua_ls = {
        enable = true;
        config = {
          diagnostics.globals = [ "vim" ];
          runtime.version = "LuaJIT";
          workspace.library = [ { __raw = ''vim.api.nvim_get_runtime_file("", true)''; } ];
        };
      };
      marksman.enable = true;
      nil_ls = {
        enable = true;
        config = {
          formatting.command = [ "nixfmt" ];
          nix = {
            maxMemoryMB = null;
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
            };
          };
        };
      };
      ruff.enable = true;
    };
  };
  plugins = {
    lspconfig.enable = true; # Necessary for https://github.com/nix-community/nixvim/pull/3289
    lsp-format.enable = true;
    lint = {
      enable = true;
      lintersByFt = {
        nix = [ "statix" ];
        lua = [ "selene" ];
      };
      linters = {
        statix.cmd = lib.getExe pkgs.statix;
      };
    };
  };
  autoCmd = [
    {
      event = [
        "BufEnter"
        "BufWritePost"
      ];
      callback.__raw = ''function() require("lint").try_lint() end'';
    }
  ];
}
