{
  autoCmd = [
    {
      desc = "auto read when a file is changed from the outside";
      command = "checktime";
      event = [
        "BufEnter"
        "CursorHold"
        "FocusGained"
        "TermClose"
        "TermLeave"
        "VimResume"
      ];
    }
    {
      desc = "return to last edit position when opening files";
      event = [ "BufRead" ];
      callback.__raw =
        #lua
        ''
          function(opts)
            vim.api.nvim_create_autocmd('BufWinEnter', {
              once = true,
              buffer = opts.buf,
              callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                  not (ft:match('commit') and ft:match('rebase'))
                  and last_known_line > 1
                  and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                then
                  vim.api.nvim_feedkeys([[g`"]], 'nx', false)
                end
              end,
            })
          end
        '';
    }
    {
      desc = "highlight yanked text";
      event = [ "TextYankPost" ];
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];

  opts = {
    history = 500;
    autoread = true; # Auto read when a file is changed from the outside

    # UI
    mouse = "a"; # Enable mouse support
    showmode = false; # Don't show mode
    title = true;
    titlestring = "%f%( %M%)%(\\ %a%)";

    signcolumn = "yes"; # Always show the signcolumn
    number = true; # Show line numbers
    relativenumber = true; # Relative line numbers
    numberwidth = 3;
    statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s";

    cursorline = true; # Highlight the cursor's line
    scrolloff = 4; # Minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8;

    wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store";
    wildmode = "longest:full,full";

    whichwrap = "b,s,<,>,[,]";

    ignorecase = true; # Ignore case in general
    smartcase = true; # Become case-sensitive when uppercase is present
    showmatch = true; # Show matching brackets

    timeoutlen = 300; # Time in milliseconds to wait for a mapped sequence to complete

    winminwidth = 5; # Minimum window width

    splitbelow = true; # Put new windows below current
    splitright = true; # Put new windows right of current
    splitkeep = "screen"; # Keep the text on the same screen line when resizing splits

    termguicolors = true; # Enable true color support.
    fileformats = "unix,dos,mac"; # Always use UNIX-style newlines by default

    switchbuf = "useopen,usetab,newtab";
    showtabline = 2;
    cmdheight = 0;

    # Backup & undo
    updatetime = 200; # For CursorHold events

    undofile = true; # Enable persistent undo history
    undolevels = 10000;
    undodir.__raw = ''vim.fn.stdpath("data") .. "/undo"'';
    swapfile = false; # Disable creating swapfiles

    # Tabs & indentation
    listchars = {
      tab = "→ ";
      eol = "↲";
      nbsp = "␣";
      trail = "•";
      extends = "⟩";
      precedes = "⟨";
      space = "␣";
    };

    tabstop = 2; # number of visual spaces per TAB
    softtabstop = 2; # number of spaces in tab when editing
    shiftwidth = 2; # number of spaces to use for autoindent
    expandtab = true; # Use spaces instead of tabs

    smartindent = true; # Insert indents automatically

    linebreak = true; # Break line at predefined characters
    #showbreak = "↪ ";

    spelllang = "en_us"; # spellcheck against english
  };

  globals = {
    # Unused providers
    loaded_node_provider = 0;
    loaded_perl_provider = 0;
    loaded_ruby_provider = 0;
    mapleader = " "; # Custom mapping <leader> (see `:h mapleader` for more info)
    vimsyn_embed = "l"; # Enable highlighting for lua HERE doc inside vim script
    # Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
    loaded_matchit = 1;
    loaded_matchparen = 1;
    loaded_sql_completion = 1; # Disable sql omni completion, it is broken.
  };
}
