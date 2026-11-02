
 -- ~/.config/nvim/lua/plugins/lsp.lua
 -- Configure Mason and Mason-LSPConfig for managing LSP servers

 -- Language servers to install (Mason) and enable (vim.lsp.enable)
 local servers = {
     "clangd",         -- C/C++
     "perlnavigator",  -- Perl
     "basedpyright",   -- Python (pyright fork that adds inlay hints)
     "gopls",          -- Go
     "sqls",           -- SQL
     "ts_ls",          -- JavaScript/TypeScript
     "rust_analyzer",  -- Rust
     "bashls",         -- Bash
     "lua_ls",         -- Lua
     "html",           -- HTML
     "cssls",          -- CSS
     "zls",            -- Zig
 }
 -- These need their runtime on PATH to install/run, so only add them when it's there
 if vim.fn.executable("ruby") == 1 then table.insert(servers, "ruby_lsp") end      -- Ruby
 if vim.fn.executable("pwsh") == 1 then table.insert(servers, "powershell_es") end -- PowerShell

 -- Linters to install (Mason package names) for nvim-lint (section E) - run with <leader>lc
 -- Not here because they don't come from Mason: perlcritic (Perl, Arch pkg perl-perl-critic in pkg_lists/arch_base.txt),
 --   clippy (Rust, via cargo), zsh -n (Zsh)
 -- PowerShell has no nvim-lint linter - powershell_es already runs PSScriptAnalyzer as LSP diagnostics
 local linters = {
     "ruff",           -- Python
     "pylint",         -- Python
     "eslint_d",       -- JavaScript/TypeScript (only reports in projects with an eslint config)
     "cpplint",        -- C/C++
     "shellcheck",     -- Bash/sh
     "selene",         -- Lua
     "golangci-lint",  -- Go
     "sqlfluff",       -- SQL
     "htmlhint",       -- HTML
     "biome",          -- CSS (works without a project config, unlike stylelint)
     "zlint",          -- Zig
     "statix",         -- Nix
 }
 if vim.fn.executable("ruby") == 1 then table.insert(linters, "rubocop") end       -- Ruby

 -- Debug adapters to install (Mason package names) for nvim-dap - configured in plugins/dap.lua
 local debuggers = {
     "debugpy",             -- Python
     "codelldb",            -- C/C++/Rust/Zig
     "perl-debug-adapter",  -- Perl (also needs the PadWalker module, Arch pkg perl-padwalker)
     "js-debug-adapter",    -- JavaScript/TypeScript
     "bash-debug-adapter",  -- Bash
 }
 if vim.fn.executable("go") == 1 then table.insert(debuggers, "delve") end          -- Go (Mason builds it with `go install`)
 if vim.fn.executable("ruby") == 1 then table.insert(debuggers, "rdbg") end         -- Ruby

 return {


     -- A. Mason for managing LSP servers and linters
   {
     'williamboman/mason.nvim',
     config = function()
         require('mason').setup()
     end,
   },

     -- A2. Install the linters and debug adapters (lists are at the top of this file) - LSPs are installed by section B
   {
     'WhoIsSethDaniel/mason-tool-installer.nvim',
     dependencies = { 'williamboman/mason.nvim' },
     config = function()
         require('mason-tool-installer').setup({
           ensure_installed = vim.list_extend(vim.list_extend({}, linters), debuggers),
           auto_update = true,
           run_on_start = true,
           -- Names above are already Mason package names, so skip the lspconfig-name lookup
           -- (it also crashes against current mason-lspconfig, which renamed its mapping table)
           integrations = { ['mason-lspconfig'] = false },
         })
     end,
   },


     -- B. Bridge between Mason and nvim-lspconfig
   {
     'mason-org/mason-lspconfig.nvim',
     dependencies = {
         'williamboman/mason.nvim',
         'neovim/nvim-lspconfig',                    -- Ensure nvim-lspconfig is a dependency
     },
     config = function()

       -- INSTALL LSPs (list is at the top of this file)
       require('mason-lspconfig').setup {
         ensure_installed = servers,
         automatic_enable = false, -- servers are enabled explicitly in section D
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
         -- Completion keymaps (insert + command line) live in config/keymaps.lua - added in `config` below

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
         -- Show function signature/params while typing inside a call (C-k toggles)
         signature = { enabled = true },

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
       opts_extend = { "sources.default" },
       config = function(_, opts)
         -- blink only reads its keymap during setup, so pull it from config/keymaps.lua here
         -- (this runs keymaps.lua a little earlier than init.lua would; init.lua's require then reuses it)
         local keymaps = require('config.keymaps')
         opts.keymap = keymaps.completion
         opts.cmdline = vim.tbl_deep_extend('force', opts.cmdline or {}, { keymap = keymaps.cmdline_completion })
         require('blink.cmp').setup(opts)
       end,
 },

 -- D. nvim-lspconfig for configuring LSP servers
 -- nvim-lspconfig for configuring LSP servers
   {
     'neovim/nvim-lspconfig',
     dependencies = { 
       'mason-org/mason-lspconfig.nvim',
       -- 'hrsh7th/cmp-nvim-lsp', -- Ensure cmp-nvim-lsp is available
       'saghen/blink.cmp'
     },
     config = function()
       -- vim.diagnostic.enable(false) -- Uncomment to disable diagnostics on startup

       -- Defaults for every server: blink-cmp completion capabilities
       -- (LSP keymaps live in config/keymaps.lua)
       vim.lsp.config("*", {
         capabilities = require('blink.cmp').get_lsp_capabilities(),
       })

       -- Lua LSP
       vim.lsp.config("lua_ls", {
         settings = {
           Lua = {
             diagnostics = {
               globals = { 'vim' }, -- Recognize 'vim' global
             },
             hint = { enable = true }, -- inlay hints
           },
         },
       })

       -- Python LSP (basedpyright) - inlay hints (variable/return types, argument names) are on by default
       vim.lsp.config("basedpyright", {
         settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard", -- same strictness as pyright (basedpyright defaults to the much noisier "recommended")
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                logLevel = "Warning",   -- reduce log spam / analysis chatter
              }
            }
          }
       })

       -- TypeScript/JavaScript LSP (ts_ls) - inlay hints are off unless requested here
       local ts_inlay_hints = {
         includeInlayParameterNameHints = "all",
         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
         includeInlayFunctionParameterTypeHints = true,
         includeInlayVariableTypeHints = true,
         includeInlayPropertyDeclarationTypeHints = true,
         includeInlayFunctionLikeReturnTypeHints = true,
         includeInlayEnumMemberValueHints = true,
       }
       vim.lsp.config("ts_ls", {
         settings = {
           typescript = { inlayHints = ts_inlay_hints },
           javascript = { inlayHints = ts_inlay_hints },
         },
       })

       -- Perl LSP (perlnavigator)
       vim.lsp.config("perlnavigator", {
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
                     -- NOTE: <project>/lib is added automatically. A *relative* `use lib "lib"` in your code
                     -- breaks go-to-definition into your own modules; use `use lib "$FindBin::Bin/lib"` instead
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

       -- Go LSP (gopls) - inlay hints are off unless requested here
       vim.lsp.config("gopls", {
         settings = {
           gopls = {
             hints = {
               assignVariableTypes = true,
               compositeLiteralFields = true,
               constantValues = true,
               functionTypeParameters = true,
               parameterNames = true,
               rangeVariableTypes = true,
             },
           },
         },
       })

       -- Ruby LSP (ruby_lsp) - turn on its inlay hints
       vim.lsp.config("ruby_lsp", {
         init_options = {
           featuresConfiguration = {
             inlayHint = { implicitHashValue = true, implicitRescue = true },
           },
         },
       })

       -- PowerShell LSP (powershell_es) - point it at Mason's install
       vim.lsp.config("powershell_es", {
         bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
       })

       -- clangd, rust_analyzer, zls: inlay hints on by default; bashls, html, cssls, sqls, perlnavigator: no inlay hint support

       -- Inlay hints: turn on for any server that supports them (toggle with <leader>lh)
       vim.api.nvim_create_autocmd("LspAttach", {
         group = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = true }),
         callback = function(args)
           local client = vim.lsp.get_client_by_id(args.data.client_id)
           if client and client:supports_method("textDocument/inlayHint") then
             vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
           end
         end,
       })

       -- Code lens: show actionable lenses above lines for every server that supports them (run with <leader>cl)
       -- (vim.lsp.codelens.enable is Nvim 0.12+; on 0.11 lenses must be refreshed manually per buffer)
       if vim.lsp.codelens.enable then
         vim.lsp.codelens.enable(true)
       else
         vim.api.nvim_create_autocmd("LspAttach", {
           group = vim.api.nvim_create_augroup("lsp_codelens", { clear = true }),
           callback = function(args)
             local client = vim.lsp.get_client_by_id(args.data.client_id)
             if not (client and client:supports_method("textDocument/codeLens")) then
               return
             end
             vim.lsp.codelens.refresh({ bufnr = args.buf })
             vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
               group = vim.api.nvim_create_augroup("lsp_codelens_" .. args.buf, { clear = true }),
               buffer = args.buf,
               callback = function() vim.lsp.codelens.refresh({ bufnr = args.buf }) end,
             })
           end,
         })
       end

       -- Now that LSPs have been configured, they need to be enabled
       vim.lsp.enable(servers)

     end,
   },



   -- E Linters
     {
         "mfussenegger/nvim-lint",
         event = { "BufReadPre", "BufNewFile" },
         config = function()
             local lint = require("lint")

             -- Configure linters by filetype
             -- (linters are installed by mason-tool-installer - list at the top of this file)
             lint.linters_by_ft = {
               python = { "pylint", "ruff" },
               javascript = { "eslint_d" },
               javascriptreact = { "eslint_d" },
               typescript = { "eslint_d" },
               typescriptreact = { "eslint_d" },
               -- markdown = { "vale" },
               c = { "cpplint" },
               cpp = { "cpplint" },
               perl = { "perlcritic" },
               sh = { "shellcheck" },
               bash = { "shellcheck" },
               zsh = { "zsh" },              -- shellcheck refuses zsh scripts, so just syntax-check with zsh -n
               lua = { "selene" },
               go = { "golangcilint" },
               sql = { "sqlfluff" },
               rust = { "clippy" },
               html = { "htmlhint" },
               css = { "biomejs" },
               zig = { "zlint" },
               ruby = { "rubocop" },
               nix = { "statix" },
             }

             -- sqlfluff refuses to run without a dialect - default to ansi (a project .sqlfluff can't override
             -- a CLI --dialect, so change it here if you mostly write mysql/postgres/sqlite/tsql/...)
             lint.linters.sqlfluff.args = { "lint", "--format=json", "--dialect=ansi", "-" }

             -- zsh: nvim-lint pipes the buffer to /dev/stdin, which zsh can't open from Neovim's pipe - check the file instead
             lint.linters.zsh.stdin = false
             lint.linters.zsh.args = { "--no-exec", "--no-rcs", "--no-globalrcs" }

             -- clippy: cargo exits 101 on deny-level lints/compile errors, which nvim-lint would report as a failure
             -- (it matches diagnostics by path relative to Neovim's cwd, so open Neovim from the crate root)
             lint.linters.clippy.ignore_exitcode = true

             -- biome: the stock parser only picks up errors ("×") and drops warnings - use its GitHub reporter instead
             lint.linters.biomejs.args = { "lint", "--reporter=github" }
             lint.linters.biomejs.parser = require("lint.parser").from_pattern(
               "^::(%w+) title=([^,]+),file=([^,]+),line=(%d+),endLine=(%d+),col=(%d+),endColumn=(%d+)::(.+)$",
               { "severity", "code", "file", "lnum", "end_lnum", "col", "end_col", "message" },
               { error = vim.diagnostic.severity.ERROR, warning = vim.diagnostic.severity.WARN, notice = vim.diagnostic.severity.INFO },
               { source = "biomejs" }
             )

             -- selene: without a config it flags `vim` as undefined - projects with a selene.toml use theirs, everything
             -- else runs from selene/ in this config (selene resolves its `std` file relative to the working dir)
             local selene = lint.linters.selene
             lint.linters.selene = function()
               local cwd = vim.fs.root(0, "selene.toml") or (vim.fn.stdpath("config") .. "/selene")
               return vim.tbl_extend("force", selene, { cwd = cwd })
             end

             -- perlcritic: use Arch's perl-perl-critic directly - on WSL a Windows perlcritic can come first on PATH and won't run
             if vim.fn.executable("/usr/bin/vendor_perl/perlcritic") == 1 then
               lint.linters.perlcritic.cmd = "/usr/bin/vendor_perl/perlcritic"
             end

             -- Autocommand group for linting
             -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
             -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
             --   group = lint_augroup,
             --   callback = function()
             --     lint.try_lint()
             --   end,
             -- })

             -- Manual lint keymap (<leader>lc) lives in config/keymaps.lua

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
     -- Add the server name to `servers` at the top of this file, plus a vim.lsp.config("SERVERNAME") entry if it needs settings
     -- SERVER NAME => :help lspconfig-all or https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

 -- 3: Run Lazy Sync or restart neovim



 -- Installing Linters
 -- Add the Mason package name to `linters` at the top of this file, and the nvim-lint linter name to
 -- linters_by_ft in section E (names can differ, e.g. Mason "golangci-lint" = nvim-lint "golangcilint")





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




