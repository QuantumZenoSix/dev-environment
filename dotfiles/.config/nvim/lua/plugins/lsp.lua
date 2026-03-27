
 -- ~/.config/nvim/lua/plugins/lsp.lua
 -- Configure Mason and Mason-LSPConfig for managing LSP servers
 return {


     -- A. Mason for managing LSP servers
   {
     'williamboman/mason.nvim',
     -- dependencies = {
     --     "WhoIsSethDaniel/mason-tool-installer.nvim",
     --     "neovim/nvim-lspconfig", -- Add lspconfig to ensure compatibility
     --  },
     config = function()
         require('mason').setup()
     --     -- INSTALL LINTERs
     --     require("mason-tool-installer").setup({
     --       ensure_installed = {
     --         -- Linters for nvim-lint
     --         "pylint",        -- Python
     --         "ruff",          -- Python
     --         "eslint_d",      -- JavaScript/TypeScript
     --         "vale",          -- Markdown
     --         "cppcheck",      -- C
     --         "perlcritic",    -- Perl
     --         "shellcheck",    -- Bash/Zsh
     --         "luacheck",      -- Lua
     --       },
     --       auto_update = true,
     --       run_on_start = true,
     --     })
     --
     end,
   },


     -- B. Bridge between Mason and nvim-lspconfig
   {
     'mason-org/mason-lspconfig.nvim',
      version = "1.29.0", -- last version that supports Neovim 0.10
     dependencies = {
         'williamboman/mason.nvim',
         'neovim/nvim-lspconfig',                    -- Ensure nvim-lspconfig is a dependency
     },
     config = function()

       -- INSTALL LSPs
       require('mason-lspconfig').setup {
         ensure_installed = {
             "pyright",        -- Python
             "tsserver",       -- JavaScript/TypeScript
             "bashls",         -- Bash
             "clangd",         -- C/C++
             "perlnavigator",  -- Perl
             "lua_ls",         -- Lua
             "html",           -- HTML
             "cssls",          -- CSS
             "rust_analyzer",  -- Rust
             "zls"             -- Zig
         },
       }

     end,
   },

   -- C. nvim-cmp for autocompletion [USING BLINK NOW]
   -- {
   --   'hrsh7th/nvim-cmp',
   --   dependencies = {
   --     'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
   --     'hrsh7th/cmp-buffer',   -- Buffer completions
   --     'hrsh7th/cmp-path',     -- Path completions
   --     'L3MON4D3/LuaSnip',     -- Snippet engine
   --     'saadparwaiz1/cmp_luasnip', -- Snippet completions
   --   },
   --   config = function()
   --     local cmp = require('cmp')
   --     cmp.setup {
   --       snippet = {
   --         expand = function(args)
   --           require('luasnip').lsp_expand(args.body)
   --         end,
   --       },
   --       mapping = cmp.mapping.preset.insert {
   --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
   --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
   --         ['<C-Space>'] = cmp.mapping.complete(),
   --         ['<C-e>'] = cmp.mapping.abort(),
   --         ['<CR>'] = cmp.mapping.confirm { select = true }, -- Confirm selection
   --         ['<Tab>'] = cmp.mapping.select_next_item(),
   --         ['<S-Tab>'] = cmp.mapping.select_prev_item(),
   --       },
   --       sources = cmp.config.sources({
   --         { name = 'nvim_lsp' }, -- LSP completions
   --         { name = 'luasnip' },  -- Snippet completions
   --         { name = 'buffer' },   -- Buffer completions
   --         { name = 'path' },     -- Path completions
   --       }),
   --     }
   --   end,
   -- },
   --
   -- C. blink-cmp for autocompletion [USING BLINK NOW]
     {
       'saghen/blink.cmp',
       -- optional: provides snippets for the snippet source
       dependencies = { 'rafamadriz/friendly-snippets' },

       -- use a release tag to download pre-built binaries
       version = '1.*',
       -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
       -- build = 'cargo build --release',
       -- If you use nix, you can build from source using latest nightly rust with:
       -- build = 'nix run .#build-plugin',

       ---@module 'blink.cmp'
       ---@type blink.cmp.Config
       opts = {
         -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
         -- 'super-tab' for mappings similar to vscode (tab to accept)
         -- 'enter' for enter to accept
         -- 'none' for no mappings
         --
         -- All presets have the following mappings:
         -- C-space: Open menu or open docs if already open
         -- C-n/C-p or Up/Down: Select next/previous item
         -- C-e: Hide menu
         -- C-k: Toggle signature help (if signature.enabled = true)
         --
         -- See :h blink-cmp-config-keymap for defining your own keymap
         keymap = { 
                 preset = 'default', 
                 ['<CR>'] = { 'accept', 'fallback' },
                 ['<Tab>'] = { 'snippet_forward', 'fallback' },
                 ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
          },

         appearance = {
           -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
           -- Adjusts spacing to ensure icons are aligned
           nerd_font_variant = 'mono'
         },

         -- (Default) Only show the documentation popup when manually triggered
         completion = { 
                 documentation = { auto_show = false } ,
                -- Controls when the menu auto-shows
                trigger = {
                  -- Default: true → shows on trigger chars from LSP (like '.')
                  show_on_trigger_character = true,

                  -- Also show if you type keyword characters (letters, etc.)
                  show_on_keyword = true,

                  -- Optional: show even with 0 chars typed (very aggressive)
                  -- keyword_length = 0,  -- but usually keep at 1–3 to avoid noise
                },

                -- If completions feel delayed after dot (rare), try:
                -- keyword_length = 1,   -- start suggesting after 1 char total

                -- Ghost text (inline preview of selected item)
                accept = {
                  auto_brackets = { enabled = true },  -- nice for () after methods
                },
         },

         -- Default list of enabled providers defined so that you can extend it
         -- elsewhere in your config, without redefining it, due to `opts_extend`
         sources = {
           default = { 'lsp', 'path', 'snippets', 'buffer' },
         },

         -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
         -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
         -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
         --
         -- See the fuzzy documentation for more information
         fuzzy = { implementation = "prefer_rust_with_warning" },

       },
       opts_extend = { "sources.default" }
 },

 -- D. nvim-lspconfig for configuring LSP servers
 -- nvim-lspconfig for configuring LSP servers
   {
     'neovim/nvim-lspconfig',
     dependencies = { 
       'williamboman/mason-lspconfig.nvim',
       -- 'hrsh7th/cmp-nvim-lsp', -- Ensure cmp-nvim-lsp is available
       'saghen/blink.cmp'
     },
     config = function()
       -- Keep your original configuration
       -- vim.diagnostic.enable(false) -- Uncomment to disable diagnostics on startup

       -- Add nvim-cmp capabilities to LSP
       -- local capabilities = require('cmp_nvim_lsp').default_capabilities()

       -- Add blink-cmp capabilities to LSP
       local capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

       -- Define common keybindings for LSP
       local on_attach = function(client, bufnr)
         local bufopts = { noremap=true, silent=true, buffer=bufnr }
         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
         vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
         vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
         vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
       end

       -- Configure LSP servers
       -- local lspconfig = require('nvim-lspconfig')
       -- Module itself is actually called 'lspconfig' (see docs: https://github.com/neovim/nvim-lspconfig)
       local lspconfig = require('lspconfig')

       -- Lua LSP
       vim.lsp.config("lua_ls", {
       -- [DEPRECATED] lspconfig.lua_ls.setup {
         on_attach = on_attach,
         capabilities = capabilities,
         settings = {
           Lua = {
             diagnostics = {
               globals = { 'vim' }, -- Recognize 'vim' global
             },
           },
         },
       })

       -- Python LSP (pyright)
       vim.lsp.config("pyright", {
         on_attach = on_attach,
         capabilities = capabilities,
         settings = {
            python = {
              analysis = {
                -- already have these — good
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,

                -- Add these to reduce log spam / analysis chatter
                logLevel = "Warning",   -- or "Error"
              }
            }
          }
       })

       -- TypeScript LSP (ts_ls)
       vim.lsp.config("ts_ls", {
         on_attach = on_attach,
         capabilities = capabilities,
         settings = {
             perlnavigator = {
                 -- Path to your perl executable (usually auto-detected, but explicit helps)
                 perlPath = "perl",   -- or full path e.g. "/usr/bin/perl" or "/opt/homebrew/bin/perl"

                 -- Enable Perl::Critic integration (optional, but very useful for Perl code quality)
                 perlcriticEnabled = true,
                 perlcriticProfile = "",   -- "" = use default ~/.perlcriticrc or project .perlcriticrc
                 -- or set to full path e.g. "~/.perlcriticrc" or "perlcriticrc" (project-local)

                 -- Perl::Tidy for formatting (optional – :lua vim.lsp.buf.format() will use it)
                 perltidyProfile = "",     -- same as above: "" for default or project .perltidyrc

                 -- Warnings & linting
                 enableWarnings = true,

                 -- Very important for cross-file / external module navigation
                 -- Add any custom lib paths your project uses (e.g. local::lib, cpanm --local-lib, or project dirs)
                 -- These get added to @INC for the language server
                 includePaths = {
                     -- Examples – uncomment/add your own:
                     -- vim.fn.expand("~/.perl5/lib/perl5"),          -- if using local::lib
                     -- vim.fn.expand("./lib"),                       -- project-local lib/
                     -- "/path/to/shared/perl/modules",
                     "$workspaceFolder",          -- ← this adds the folder you opened Neovim in
                 },

                 -- Optional: disable if Perl::Critic is too noisy/slow on large codebases
                 -- perlcriticEnabled = false,

                 -- Optional: extra args passed to perl when indexing/analyzing
                 -- perlInc = { "-I/path/extra" },  -- rarely needed if includePaths works

                 -- Logging (set higher for debugging gd issues)
                 trace = {
                     server = "off",   -- "off" | "messages" | "verbose"
                 },
             },
         },
       })

       -- Bash LSP (blashls)
       vim.lsp.config("bashls", {
       -- lspconfig.bashls.setup {
         on_attach = on_attach,
         capabilities = capabilities,
       })

       -- C LSP (clangd)
       vim.lsp.config("clangd", {
         on_attach = on_attach,
         capabilities = capabilities,
       })

       -- Perl LSP (perlnavigator)
       vim.lsp.config("perlnavigator", {
         on_attach = on_attach,
         capabilities = capabilities,
       })
       vim.lsp.config("html", {
         on_attach = on_attach,
         capabilities = capabilities,
       })
       vim.lsp.config("cssls", {
         on_attach = on_attach,
         capabilities = capabilities,
       })
       -- Rust LSP (rust_analyzer)
       vim.lsp.config("rust_analyzer", {
         on_attach = on_attach,
         capabilities = capabilities,
       })

       -- Zig
       vim.lsp.config("zls", {
         on_attach = on_attach,
         capabilities = capabilities,
       })


     -- Now that LSPs have been configured, they need to be enabled 
     vim.lsp.enable({'lua_ls', 'pyright','ts_ls','bashls','clangd','perlnavigator','html','cssls','rust_analyzer','zls'})

     end,
   },



   -- E Linters
     {
         "mfussenegger/nvim-lint",
         event = { "BufReadPre", "BufNewFile" },
         config = function()
             local lint = require("lint")

             -- Configure linters by filetype
             lint.linters_by_ft = {
               python = { "pylint", "ruff" },
               javascript = { "eslint_d" },
               typescript = { "eslint_d" },
               -- markdown = { "vale" },
               c = { "cpplint" },
               perl = { "perlcritic" },
               sh = { "shellcheck" },
               zsh = { "shellcheck" },
               lua = { "luacheck" },
             }

             -- :MasonInstall pylint ruff eslint_d vale cpplint  shellcheck luacheck
             -- Autocommand group for linting
             -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
             -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
             --   group = lint_augroup,
             --   callback = function()
             --     lint.try_lint()
             --   end,
             -- })

             -- Keymap for manual linting
             vim.keymap.set("n", "<leader>l", function()
               lint.try_lint()
             end, { desc = "Trigger linting for current file" })

       end,
     }




 }




 -- To install a new LSP

 -- 1. [MASON] (Section B) Install a new language server 
 	-- a) via Mason manually :Mason
 	-- b) via this file => mason-lspconfig.nvim => "ensure_installed"
 	-- c) using npm
     -- SERVER NAME => :Mason or :lua print(vim.inspect(require('mason-lspconfig').get_available_servers()))

 -- 2: [LSPCONFIG] (Section D) Configure new language server
     -- In this file, add new setup entry to lspconfig.xxx - actually vim.lsp.config("SERVERNAME")
     -- SERVER NAME => :help lspconfig-all or https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

 -- 3: Run Lazy Sync or restart neovim



 -- Installing Linters
 -- Can be done through this config file, but tricky, easier just to run this
 -- :MasonInstall pylint ruff eslint_d vale cpplint  shellcheck luacheck





 -- Some Language Servers (manual install without mason)
 -- [PYTHON]
 -- npm install -g pyright
     -- pyright --version # verify
 -- 
 -- [PERL]
 -- npm install -g @perlnavigator/server
     -- perlnavigator --version # verify
 -- 
 -- [JAVASCRIPT/TYPESCRIPT]
 -- npm install -g typescript typescript-language-server
     -- tsserver --version # verify
 -- 
 -- [C]
 -- sudo apt install clangd 
     -- clangd --version # verify
 -- 
 -- [BASH]
 -- npm install -g bash-language-server
     -- bash-language-server --version # verify




