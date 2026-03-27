
-- NON-LEADER CUSTOM MOTIONS

-- Smaller movements up/down buffer
vim.keymap.set('n', '<C-d>', '22<C-e>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '22<C-y>', { noremap = true, silent = true })

-- Larher movements up/down buffer with Ctrl e/y
vim.keymap.set('n', '<C-e>', '4<C-e>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-y>', '4<C-y>', { noremap = true, silent = true })

-- Clear all buffers' unsaved changes
vim.keymap.set('n', 'E!', ':bufdo e!<CR>', { noremap = true, silent = true })

-- vim :bn / :bp -> <leader>bn / <leader>bp
vim.keymap.set('n', '<leader>bn', ':bn<CR>')
vim.keymap.set('n', '<leader>bp', ':bp<CR>')

-- Integrated Terminal
vim.keymap.set('n', '<C-_>', ':split | resize 15 | set nonumber norelativenumber | terminal<CR> | i', { noremap = true, silent = true })

-- Escape key impled :nohl 
vim.keymap.set('n', '<esc>', ':nohlsearch<CR><esc>', { noremap = true, silent = true })

-- Map Ctrl+b to enter visual-block mode
vim.keymap.set('n', '<C-b>', '<C-v>', { noremap = true, silent = true })

-- Quickfix nav shortcuts
vim.keymap.set('n', '<F12>', ':cn<CR>', { desc = 'Next item in quickfix list', noremap = true, silent = true })
vim.keymap.set('n', '<F11>', ':cp<CR>', { desc = 'Previous item in quickfix list', noremap = true, silent = true })

-- Remap > to indent and keep visual selection
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Remap < to unindent and keep visual selection
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })

-- :args - but assumes recursive
vim.keymap.set('n', '<leader>FF', function()
    -- Prompt for a file pattern
    local pattern = vim.fn.input('rargs: ')
    if pattern ~= '' then
        -- Prepend **/ and execute :args
        vim.cmd('args **/' .. vim.fn.escape(pattern, ' '))
        vim.fn.setqflist({}, 'r')  -- Clear quickfix list
        local args = vim.fn.argv() -- Get argument list
        local qflist = {}
        for _, file in ipairs(args) do
            if not file:match('%.swp$') then -- Skip .swp files
                table.insert(qflist, { filename = vim.fn.expand(file, ':p'), lnum = 1, col = 1 })
            end
        end
        vim.fn.setqflist(qflist, 'a') -- Add entries to quickfix list
        vim.cmd('copen')              -- Open quickfix window
    end
end, { noremap = true, silent = true })


-- LEADER CUSTOM MOTIONS

-- Toggle line numbering
vim.keymap.set('n', '<Leader>ld', ':set nonumber norelativenumber<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>le', ':set number relativenumber<CR>', { noremap = true, silent = true })

-- Toggle line numbering and relative numbering with a single keybinding
vim.keymap.set('n', '<Leader>ll', function()
  if vim.opt.number:get() or vim.opt.relativenumber:get() then
    vim.opt.number = false
    vim.opt.relativenumber = false
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
  end
end, { noremap = true, silent = true, desc = "Toggle line numbering" })

-- leader+h to unhighlight) - already added to the Esc key
-- vim.keymap.set('n', '<leader>h', ':nohlsearch<CR><esc>', { noremap = true, silent = true })

-- 'Remove Markers' | Remove all markers
vim.keymap.set('n', '<leader>rm', ':delm a-zA-Z0-9<CR>', { desc = 'Remove All Markers', noremap = true, silent = true })

-- Set Transparent background
vim.keymap.set('n', '<leader>tb', ':highlight Normal guibg=NONE ctermbg=NONE<CR>', { desc = 'Set Transparent bg', noremap = true, silent = true })

-- move up/down in 20-step jumps
vim.keymap.set('n', '<leader><down><down>', '20<C-e>', { desc = 'Move down 20 steps', noremap = true, silent = true })
vim.keymap.set('n', '<leader><up><up>', '20<C-y>', { desc = 'Move down 20 steps', noremap = true, silent = true })

-- Neotree
vim.keymap.set('n', '<leader><leader>', ':Neotree toggle<CR>',
    { desc = 'Toggle Neo-tree file explorer', noremap = true, silent = true })

-- Find and [c]hange [w]ord under cursor - <Esc> to apply and . to repeat
vim.keymap.set('n', '<leader>cw', '*Ncgn', { noremap = true, silent = true })

-- Find and [c]hange [W]ord under cursor - replace all in doc
vim.keymap.set('n', '<leader>cW', '* | :%s::', { noremap = true, silent = true })

-- Find and [a]ppend [w] word under cursor - replace all in the doc
vim.keymap.set('n', '<leader>aw', 'yiw | :%s:\\V<C-r>":<C-r>"', { noremap = true, silent = true })

-- Find and [c]hange [Y]anked text - replace all in doc
vim.keymap.set('n', '<leader>cy', ':%s:\\V<C-r>":', { noremap = true, silent = true })

-- Find and [a]ppend [y]anked text- replace all in doc
vim.keymap.set('n', '<leader>ay', ':%s:\\V<C-r>":<C-r>"', { noremap = true, silent = true })

-- Find all occurrences of word under cursor in current buffer and add to quickfix list
vim.keymap.set('n', "<leader>fw", "yiw | :vim '<C-r>\"' % <C-r> | :cope <CR>", { noremap = true, silent = true })
-- vim.keymap.set('n', "<leader>fW", "yiw | <leader>fg | :vim '<C-r>\"' % <C-r> <CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fW', function()
  require('telescope.builtin').grep_string({
    search =  vim.fn.expand("<cword>"),   -- word under cursor
    -- Alternative: just the word: search = vim.fn.expand("<cword>")
  })
end, { desc = "Search for word" })


-- _______________________ Telescope __________________________
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Fuzzy File search - Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Fuzzy grep - Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Fuzzy buffer search - Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Fuzzy tags - Telescope help tags' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').command_history, { desc = 'Fuzzy command find - Search command history' })
-- vim.keymap.set('n', '<leader>fs', ':Telescope grep_string<CR>', { desc = "Search for sub def" })
vim.keymap.set('n', '<leader>fs', function()
  require('telescope.builtin').grep_string({
    search = "sub " .. vim.fn.expand("<cword>"),   -- "sub " + word under cursor
    -- Alternative: just the word: search = vim.fn.expand("<cword>")
  })
end, { desc = "Search for 'sub <word>' or sub definition" })
-- _______________________ Harpoon __________________________
local harpoon = require("harpoon")

-- ==> (optional) basic telescope UI configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end
-- ==> end optional telescope menu

vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle quick menu" })
vim.keymap.set("n", "<leader>H", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
vim.keymap.set("n", "<leader>0", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>N", function() harpoon:list():prev() end, { desc = "Harpoon: Previous file" })
vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end, { desc = "Harpoon: Next file" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Go to file 4" })
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon: Go to file 5" })
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Harpoon: Go to file 6" })
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "Harpoon: Go to file 7" })
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "Harpoon: Go to file 8" })
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "Harpoon: Go to file 9" })


-- _______________________ Git (General) __________________________
-- 'Git Undo' | Undo last commit and set changes as staged and unsaved
vim.keymap.set('n', '<leader>gu', '<cmd>git reset --hard HEAD~1<CR>',
    { desc = 'Undo last commit', noremap = true, silent = true })

-- 'Git stash' | Stash current changes using no custom stash name
vim.keymap.set('n', '<leader>ga', '<cmd>git stash save<CR>', { desc = 'Git stash (Add)', noremap = true, silent = true })


-- Open lazyGit on the repo of the current buffer
vim.keymap.set('n', '<leader>gg', ':LazyGitCurrentFile<CR>', { desc = 'Open LazyGit', noremap = true, silent = true })



-- _______________________ Git-Signs __________________________
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_signs<CR>", { desc = "Toggle gitsigns" })

-- These below are located in plugins/gitsigns.lua - they are there so they are buffer-local (loaded on buffer-attach)

        -- -- Next Hunk
        -- vim.keymap.set('n', ']h', function()
        --   if vim.wo.diff then
        --     vim.cmd.normal({ ']c', bang = true })
        --   else
        --     gs.nav_hunk('next')
        --   end
        -- end, { buffer = buffer, desc = 'Next Hunk' })
        --
        -- -- Prev Hunk
        -- vim.keymap.set('n', '[h', function()
        --   if vim.wo.diff then
        --     vim.cmd.normal({ '[c', bang = true })
        --   else
        --     gs.nav_hunk('prev')
        --   end
        -- end, { buffer = buffer, desc = 'Prev Hunk' })
        --
        -- -- Last Hunk
        -- vim.keymap.set('n', ']H', function() gs.nav_hunk('last') end, { buffer = buffer, desc = 'Last Hunk' })
        --
        -- -- First Hunk
        -- vim.keymap.set('n', '[H', function() gs.nav_hunk('first') end, { buffer = buffer, desc = 'First Hunk' })
        --
        -- -- Stage Hunk
        -- vim.keymap.set({'n', 'v'}, '<leader>ghs', ':Gitsigns stage_hunk<CR>', { buffer = buffer, desc = 'Stage Hunk' })
        --
        -- -- Reset Hunk
        -- vim.keymap.set({'n', 'v'}, '<leader>ghr', ':Gitsigns reset_hunk<CR>', { buffer = buffer, desc = 'Reset Hunk' })
        --
        -- -- Undo Stage Hunk
        -- vim.keymap.set('n', '<leader>ghu', gs.undo_stage_hunk, { buffer = buffer, desc = 'Undo Stage Hunk' })
        --
        -- -- GitSigns Select Hunk
        -- vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = buffer, desc = 'GitSigns Select Hunk' })
        --
        -- -- Preview Hunk Inline
        -- vim.keymap.set('n', '<leader>ghp', gs.preview_hunk_inline, { buffer = buffer, desc = 'Preview Hunk Inline' })



        -- __________ -- BUFFER ACTIONS AND MORE ___________

        -- Stage Buffer
        -- vim.keymap.set('n', '<leader>ghS', gs.stage_buffer, { buffer = buffer, desc = 'Stage Buffer' })
        --
        -- -- Reset Buffer
        -- vim.keymap.set('n', '<leader>ghR', gs.reset_buffer, { buffer = buffer, desc = 'Reset Buffer' })
        --
        -- -- Blame Line
        -- vim.keymap.set('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, { buffer = buffer, desc = 'Blame Line' })
        --
        -- -- Blame Buffer
        -- vim.keymap.set('n', '<leader>ghB', function() gs.blame() end, { buffer = buffer, desc = 'Blame Buffer' })
        --
        -- -- Diff This
        -- vim.keymap.set('n', '<leader>ghd', gs.diffthis, { buffer = buffer, desc = 'Diff This' })
        --
        -- -- Diff This ~
        -- vim.keymap.set('n', '<leader>ghD', function() gs.diffthis('~') end, { buffer = buffer, desc = 'Diff This ~' })




-- _______________________ Vim-fugitive __________________________
-- Open Git status
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Open Git status" })

-- Commit changes
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })

-- Open Git blame
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

-- Diff current file
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff" })

-- Browse current file on remote (e.g., GitHub)
vim.keymap.set("n", "<leader>go", ":GBrowse<CR>", { desc = "Open file in remote" })

-- Log current file history
vim.keymap.set("n", "<leader>gl", ":Gclog<CR>", { desc = "Git commit log" })

-- Push to remote
--vim.keymap.set("n", "<leader>gP", ":Git push<CR>", { desc = "Git push" })

-- Pull from remote
--vim.keymap.set("n", "<leader>gp", ":Git pull<CR>", { desc = "Git pull" })


-- _______________________ Indent __________________________
--
-- local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ie', ':lua Snacks.indent.enable()<CR>', { desc = 'Enable Snacks indent' })
vim.keymap.set('n', '<leader>id', ':lua Snacks.indent.disable()<CR>', { desc = 'Disable Snacks indent' })
vim.keymap.set('n', '<leader>iee', ':IBLEnable<CR>', { desc = 'Enable Rainbow indent' })
vim.keymap.set('n', '<leader>idd', ':IBLDisable<CR>', { desc = 'Enable Rainbow indent' })


-- _______________________ LSP __________________________
-- Set up keybindings for LSP functionality in Neovim
-- These mappings use <leader> (default: '\') and other keys for quick access
local opts = { noremap = true, silent = true }


-- ===> LSP ACTIONS

-- Restart LSP: Restart the language server for the current buffer (useful for troubleshooting)
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', opts)

-- Show LSP info: Display details about active language servers for the current buffer
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', opts)

-- Format code: Auto-format the current buffer per language server rules
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)


-- ===> GO N' SHOW

-- [⚡] Go to definition: Jump to where a symbol (function, variable, etc.) is defined
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

-- [⚡] Go to declaration: Navigate to the declaration of a symbol (useful in C/C++ or similar)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

-- [⚡] Find references: List all places a symbol is used in the project
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

-- Implementation: Go to the implementation of a symbol (e.g., for interfaces or abstract methods)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

-- [⚡] Hover documentation: Show docs or type info for the symbol under the cursor
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)


-- ===> DIAGNOSTICS

-- [Touble-Superceded] List diagnostics: Show all diagnostics for the project in the quickfix list 
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, opts)

-- Disable diagnostics for current buffer: Turn off LSP diagnostics for the current file
vim.keymap.set('n', '<leader>dd', function() vim.diagnostic.disable(0) end, opts)

-- Enable diagnostics for current buffer: Re-enable LSP diagnostics for the current file
vim.keymap.set('n', '<leader>de', function() vim.diagnostic.enable(0) end, opts)

-- Disable diagnostics for current line: Suppress diagnostics for the line under the cursor
vim.keymap.set('n', '<leader>dld', function() vim.diagnostic.disable(0, vim.api.nvim_win_get_cursor(0)[1] - 1) end, opts)

-- Enable diagnostics for current line: Re-enable diagnostics for the line under the cursor
vim.keymap.set('n', '<leader>dle', function() vim.diagnostic.enable(0, vim.api.nvim_win_get_cursor(0)[1] - 1) end, opts)

-- [⚡] Open diagnostic float: Show detailed diagnostics for the current line
vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)

-- [⚡] Next diagnostic: Jump to the next error, warning, or hint in the file
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- [⚡] Previous diagnostic: Jump to the previous error, warning, or hint in the file
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)


-- ===> OTHER

-- Signature help: Display function signature and parameters while typing
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

-- Rename symbol: Refactor a symbol's name across the project
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

-- Code actions: Apply fixes or refactorings (e.g., fix imports, extract code)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

-- Workspace symbols: Search for symbols (functions, classes, etc.) across the project
vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

-- Type definition: Jump to the type definition of a symbol (e.g., class or type alias)
-- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)




vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })


-- _______________________ Trouble __________________________
vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble diagnostics" })
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Toggle Trouble diagnostics (current buffer)" })
vim.keymap.set("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<CR>", { desc = "Toggle Trouble LSP references" })
vim.keymap.set("n", "<leader>td", "<cmd>Trouble lsp_definitions toggle<CR>", { desc = "Toggle Trouble LSP definitions" })
vim.keymap.set("n", "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Toggle Trouble quickfix" })
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Toggle Trouble symbols" })
vim.keymap.set("n", "<leader>tc", "<cmd>Trouble close<CR>", { desc = "Close Trouble" })
vim.keymap.set("n", "<leader>tn", ":Trouble diagnostics next<CR>", { desc = "Next Trouble item" })
vim.keymap.set("n", "<leader>tp", ":Trouble diagnostics prev<CR>", { desc = "Prevous Trouble item" })

-- _______________________ Undotree __________________________
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
