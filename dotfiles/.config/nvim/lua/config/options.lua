vim.opt.autoindent     = true                                  -- Maintain indent of current line
vim.opt.backup         = false                                 -- Creates a backup file
vim.opt.clipboard      = "unnamedplus"                         -- Allows Neovim to access the system clipboard
vim.opt.compatible     = false                                 -- Set compatibility to Vim-Only (not vi)
vim.opt.encoding       = 'utf-8'                               -- Set default encoding
vim.opt.expandtab      = true                                  -- Use spaces instead of tabs
vim.opt.foldlevel      = 99                                    -- Everything unfolded by default
vim.opt.foldmethod     = "expr"
vim.opt.foldexpr       = "nvim_treesitter#foldexpr()"          -- Use Treesitter-based folding
vim.opt.history        = 1000                                  -- Increase command history size
vim.opt.hlsearch       = true                                  -- Highlight search matches
vim.opt.ignorecase     = true                                  -- Ignore case in search patterns
vim.opt.laststatus     = 3                                   -- Always show statusline
vim.opt.linebreak      = true                                  -- Companion to wrap, don't split words
vim.opt.mouse          = 'a'                                   -- Enable mouse support
vim.opt.number         = true                                  -- Show absolute line numbers
vim.opt.pumheight      = 10                                    -- Pop up menu height
vim.opt.relativenumber = true                                  -- Show relative line numbers
vim.opt.scrolloff      = 8                                     -- Minimal number of screen lines to keep above and below the cursor
vim.opt.shiftwidth     = 4                                     -- Number of spaces inserted for each indentation
vim.opt.showmatch      = true                                  -- Show matching brackets
vim.opt.showmode       = true                                  -- Show current mode
vim.opt.sidescrolloff  = 8                                     -- Minimal number of screen columns either side of cursor if wrap is false
-- vim.opt.softtabstop = ...                                   -- Optional: Uncomment and set if needed
vim.opt.smartcase      = true                                  -- Enable smart case search
vim.opt.smartindent    = true                                  -- Make indenting smarter again
vim.opt.smarttab       = true                                  -- Insert tabs on the start of a line according to shiftwidth
vim.opt.signcolumn     = "yes"                                 -- Always show the sign column to prevent text shifting
vim.opt.splitbelow     = true                                  -- Horizontal splits open below
vim.opt.splitright     = true                                  -- Vertical splits open to the right
vim.opt.termguicolors = true
vim.opt.tabstop        = 4                                     -- Number of spaces per tab
vim.opt.wrap           = true                                  -- Wrap long lines
-- Case
vim.opt.wildignorecase = true                                   -- Ignore case when globbing in files/cmdline

-- vim.opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
-- vim.opt.completeopt = { "menuone" "noselect" }  -- mostly just for cmp
-- vim.opt.conceallevel = 0                        -- so that `` is visible in markdown file
-- vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
-- vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
-- vim.opt.showtabline = 2                         -- always show tabs
vim.opt.showtabline = 0                         -- always hide tabs
-- vim.opt.swapfile = false                        -- creates a swapfile
-- vim.opt.timeoutlen = 300                        -- time to wait for a mapped sequence to complete (in milliseconds)
-- vim.opt.undofile = true                         -- enable persistent undo
-- vim.opt.updatetime = 300                        -- faster completion (4000ms default)
-- vim.opt.whichwrap = "bs<>[]hl"                  -- which "horizontal" keys are allowed to travel to prev/next line
-- vim.opt.writebackup = false                     -- disallow editing if file is being used elsewhere



-- True color support
vim.opt.termguicolors = true
vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])

-- Grep program setup (for vim - neovim uses ripgrep => rg --vimgrep -uu )
-- [GREP] vim.opt.grepprg = "grep -nH -r -i --include='*.pl' --include='*.pm' --include='*.py' --include='*.js' --include='*.c' --include='*.cpp' --include='*.sh' --include='*.ps1' --include='*.css' --include='*.lua'"
-- [RIPGREP] vim.opt.grepprg rg --vimgrep -uu
vim.opt.grepprg = "rg --vimgrep -uu -i --glob '!*.min.js'"

-- Include/exclude file types 
-- [RIPGREP]  -g '{*.pl,*.pm}'
-- [GREP] *.pl or --include='*.pl' or --exclude='*.js'

-- Optional: Custom command (can go in a Lua command block or separate `commands.lua` file)
vim.api.nvim_create_user_command('Diff', "w !git diff --no-index % -", {})







-- THEME
-- Set colorscheme with
-- vim.cmd.colorscheme 'fluoromachine'
-- vim.cmd('colorscheme fluoromachine')

-- Set colorscheme to cyberspace (purple/neon-green)
--vim.cmd.colorscheme 'cyberspace'
--vim.g.airline_theme = 'zenburn'

-- Set global variable for cyberpunk cursorline color
-- vim.g.cyberpunk_cursorline = 'red'
-- vim.cmd.colorscheme 'cyberpunk'


-- Filetype and Syntax Setup
vim.opt.filetype = "on"                                        -- Enable filetype detection
vim.cmd("filetype plugin on")                                  -- Load filetype-specific plugins
vim.cmd("filetype indent on")                                  -- Load filetype-specific indentation
vim.cmd("syntax enable")                                       -- Enable syntax highlighting

-- THEME
vim.opt.background = 'dark'                                    -- Set background to dark
vim.opt.cursorline = true                                      -- Enable cursorline highlighting
vim.opt.showmode = false                                       -- Hide mode since airline shows it

-- Set airline theme colorscheme
vim.g.airline_theme = 'lucius'
vim.g.airline_powerline_fonts = 1

vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
-- vim.g.airline_symbols = {
--     branch = '',
--     readonly = '',
--     linenr = '☰',
--     maxlinenr = '',
--     dirty = '⚡'
-- }

-- vim.cmd('syntax on')
-- vim.opt.syntax = "on"

-- Colorscheme (load after syntax and filetype)
vim.cmd.colorscheme 'gothic-cyberpunk'
-- vim.cmd.colorscheme 'kyotonight'
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {
    "*.pl", "*.pm",        -- Perl files
    "*.py",                -- Python
    "*.lua",               -- Lua
    "*.c", "*.h",          -- C
    "*.cpp", "*.hpp",      -- C++
    "*.java",              -- Java
    "*.js", "*.ts",        -- JavaScript, TypeScript
    "*.html", "*.htm",     -- HTML
    "*.css",               -- CSS
    "*.sh",                -- Shell scripts
    "*.rb",                -- Ruby
    "*.go",                -- Go
    "*.php",               -- PHP
    "*.rs",                -- Rust
    "*.vim",               -- Vimscript
  },
  callback = function()
    vim.cmd("syntax sync fromstart")
    -- Set syntax based on filetype
    local ft = vim.opt.filetype:get()
    vim.opt.syntax = ft
  end,
})


-- Override colors for Diffs
vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#004d00", fg = "#d7ffaf" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4d3d00" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4d0000", fg = "#ff5f5f", bold = true })
vim.api.nvim_set_hl(0, "DiffText",   { bg = "#870000", fg = "#ffffff", bold = true })
