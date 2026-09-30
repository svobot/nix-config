{
  config,
  lib,
  ...
}:
{
  keymaps = lib.mkMerge [
    [
      {
        key = "<space>w";
        action = ":Trim<cr>";
        mode = [ "n" ];
        options.desc = "Trim leading/trailing whitespace";
      }
      {
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        mode = [
          "n"
          "i"
        ];
        options.desc = "Escape and clear hlsearch";
      }
      {
        action = ":cd %:p:h<cr>:pwd<cr>";
        key = "<leader>cd";
        options.desc = "Set CWD to the directory of the current buffer";
      }
      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      {
        action = "'Nn'[v:searchforward]";
        key = "n";
        mode = [
          "n"
          "x"
          "o"
        ];
        options = {
          desc = "Next search result";
          expr = true;
        };
      }
      {
        action = "'nN'[v:searchforward]";
        key = "N";
        mode = [
          "n"
          "x"
          "o"
        ];
        options = {
          desc = "Prev search result";
          expr = true;
        };
      }
    ]
    # buffers
    [
      {
        action = "<cmd>enew<cr>";
        key = "<leader>bn";
        options.desc = "New file";
      }
      {
        action = "<cmd>bdelete<cr>";
        key = "<leader>bd";
        options.desc = "Close the current buffer";
      }
      {
        action = "<cmd>bufdo bd<cr>";
        key = "<leader>ba";
        options.desc = "Close all buffers";
      }
      {
        action = "<cmd>bnext<cr>";
        key = "<leader>l";
        options.desc = "Go to next buffer";
      }
      {
        action = "<cmd>bprevious<cr>";
        key = "<leader>h";
        options.desc = "Go to previous buffer";
      }
      {
        action = "<cmd>e #<cr>";
        key = "<leader>bb";
        mode = [ "n" ];
        options.desc = "Switch to other buffer";
      }
    ]
    #tabs
    [
      {
        action = ":tabnew<cr>";
        key = "<leader>tn";
        options.desc = "Create a new tab";
      }
      {
        action = ":tabonly<cr>";
        key = "<leader>to";
        options.desc = "Close all other tabs";
      }
      {
        action = ":tabclose<cr>";
        key = "<leader>to";
        options.desc = "Close the current tab";
      }
      {
        action = ":tabmove";
        key = "<leader>tm";
        options.desc = "Move the current tab";
      }
    ]
    # windows
    [
      {
        action = "<C-w>h";
        key = "<A-left>";
        mode = "n";
        options = {
          desc = "Go to left window";
          remap = true;
        };
      }
      {
        action = "<C-w>j";
        key = "<A-down>";
        mode = "n";
        options = {
          desc = "Go to lower window";
          remap = true;
        };
      }
      {
        action = "<C-w>k";
        key = "<A-up>";
        mode = "n";
        options = {
          desc = "Go to upper window";
          remap = true;
        };
      }
      {
        action = "<C-w>l";
        key = "<A-right>";
        mode = "n";
        options = {
          desc = "Go to right window";
          remap = true;
        };
      }
    ]
    (lib.mkIf config.plugins.gitsigns.enable [
      {
        key = "]h";
        action = "<cmd>Gitsigns next_hunk<cr>";
        mode = [ "n" ];
        options.desc = "Next Hunk";
      }
      {
        key = "[h";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        mode = [ "n" ];
        options.desc = "Previous Hunk";
      }
      {
        key = "<leader>ghs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Stage Hunk";
      }
      {
        key = "<leader>ghr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Reset Hunk";
      }
      {
        key = "<leader>ghS";
        action = "<cmd>Gitsigns stage_buffer<cr>";
        mode = [ "n" ];
        options.desc = "Stage Buffer";
      }
      {
        key = "<leader>ghu";
        action = "<cmd>Gitsigns undo_stage_hunk<cr>";
        mode = [ "n" ];
        options.desc = "Undo Stage Hunk";
      }
      {
        key = "<leader>ghR";
        action = "<cmd>Gitsigns reset_buffer<cr>";
        mode = [ "n" ];
        options.desc = "Reset Buffer";
      }
      {
        key = "<leader>ghp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        mode = [ "n" ];
        options.desc = "Preview Hunk";
      }
      {
        key = "<leader>ghb";
        action.__raw =
          #lua
          ''function() require("gitsigns").blame_line{full=true} end'';
        mode = [ "n" ];
        options.desc = "Blame Line";
      }
    ])
    (lib.mkIf config.plugins.multicursors.enable [
      {
        key = "ms";
        action = ":MCstart<cr>";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Select the word under the cursor and start listening for the actions";
      }
      {
        key = "mp";
        action = ":MCvisualPattern<cr>";
        mode = [ "v" ];
        options.desc = "Prompts for a pattern and selects every match in the visual selection";
      }
      {
        key = "mp";
        action = ":MCpattern<cr>";
        mode = [ "n" ];
        options.desc = "Prompts for a pattern and selects every match in the buffer";
      }
      {
        key = "mc";
        action = ":MCclear<cr>";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Clears all multicursor selections";
      }
    ])
  ];
}
