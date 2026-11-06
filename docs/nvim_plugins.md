# Neovim Plugin Reference

What each plugin in this Neovim config does, how to call it, and which features run on their own without a keybind.

- **Source of truth:** `dotfiles/.config/nvim/` (`init.lua`, `lua/plugins/*.lua`, `lua/config/{keymaps,options,autocmds}.lua`)
- **Leader:** `<Space>`. `<leader>?` shows leader keymaps and `<leader>/` shows every keymap. which-key's automatic popup is turned off.
- **Mode letters:** `n` normal · `v` visual + select · `x` visual · `o` operator-pending (after `d`, `y`, `c`…) · `i` insert · `c` command line
- **Tags:** **custom** = mapped in this config · **default** = the plugin's own default key, still active
- **Keeping it current:** after adding, removing, or remapping plugins, ask Claude to "update the nvim plugin docs". This runs the project skill `.claude/skills/nvim-plugin-docs/`.
- **Last synced:** 2026-11-05 against Neovim v0.12.5

---

## Table of Contents

1. [Leader Key Map (which-key groups)](#1-leader-key-map-which-key-groups)
2. [Plugin Inventory](#2-plugin-inventory)
3. [Language Support Matrix](#3-language-support-matrix)
4. [Navigation & Search](#4-navigation--search)
   - [Telescope](#telescope) · [Harpoon](#harpoon) · [Flash](#flash) · [Neo-tree](#neo-tree)
5. [Editing](#5-editing)
   - [mini.move](#minimove) · [Commenting (built-in + ts-comments)](#commenting-built-in--ts-comments) · [Undotree](#undotree) · [Completion (blink.cmp)](#completion-blinkcmp)
6. [Code Intelligence](#6-code-intelligence)
   - [LSP](#lsp-nvim-lspconfig--mason) · [Diagnostics](#diagnostics) · [Linting (nvim-lint)](#linting-nvim-lint) · [Trouble](#trouble) · [Treesitter](#treesitter)
7. [Debugging (nvim-dap)](#7-debugging-nvim-dap)
8. [Git](#8-git)
   - [Gitsigns](#gitsigns) · [Fugitive](#fugitive) · [LazyGit](#lazygit)
9. [AI: Claude Code](#9-ai-claude-code)
10. [UI & Appearance](#10-ui--appearance)
11. [Plugin & Tool Management](#11-plugin--tool-management)
12. [Features Without Keybinds](#12-features-without-keybinds)
13. [Installed but Inactive / Disabled](#13-installed-but-inactive--disabled)
14. [Known Config Issues](#14-known-config-issues)

---

## 1. Leader Key Map (which-key groups)

| Prefix | Group | Lives in |
| --- | --- | --- |
| `<leader><leader>` | Toggle Neo-tree | Neo-tree |
| `<leader>0`–`9`, `<leader>h` `<leader>H` `<leader>n` `<leader>N` | Harpoon | Harpoon |
| `<leader>a` | AI (Claude) / Append | Claude Code, plus core find-and-append maps |
| `<leader>b` | Buffers | core (`:bn` / `:bp`) |
| `<leader>c` | Change / Code action | LSP, plus core change-word maps |
| `<leader>d` | Diagnostics | built-in diagnostics |
| `<leader>dt` | Trouble | Trouble |
| `<leader>D` | Debug (DAP) | nvim-dap |
| `<leader>f` | Find (Telescope) | Telescope, plus core quickfix search |
| `<leader>F` | Files | core recursive `:args` |
| `<leader>g` | Git | Fugitive, LazyGit, Gitsigns |
| `<leader>gh` | Git hunks | Gitsigns |
| `<leader>i` | Indent guides | Snacks indent, indent-blankline |
| `<leader>l` | LSP / Lint / Line numbers | LSP, nvim-lint, core |
| `<leader>r` | Rename / Remove | LSP rename, core remove marks |
| `<leader>t` | Trouble / Toggle | core transparent background (Trouble actually lives under `<leader>dt`) |
| `<leader>u` | Undotree | Undotree |
| `<leader>?` / `<leader>/` | which-key | which-key |

---

## 2. Plugin Inventory

Load trigger: **startup** = loaded at launch · **event** = on an autocmd · **keys/cmd** = on first key or command use · **lazy** = only when another plugin or keymap `require`s it.

| Category | Plugin | Spec file | Load trigger | Purpose |
| --- | --- | --- | --- | --- |
| Manager | `folke/lazy.nvim` | `init.lua` | startup | Plugin manager; versions pinned in `lazy-lock.json` |
| Navigation | `nvim-telescope/telescope.nvim` | `telescope.lua` | startup | Fuzzy finder (files, grep, buffers, LSP results) |
| Navigation | `ThePrimeagen/harpoon` (harpoon2) | `harpoon.lua` | startup | Pin a few files and jump between them |
| Navigation | `folke/flash.nvim` | `flash.lua` | event: VeryLazy | Label-based jump motions |
| Navigation | `nvim-neo-tree/neo-tree.nvim` (v3) | `neo-tree.lua` | startup | File explorer sidebar; replaces netrw |
| Editing | `echasnovski/mini.nvim` (move, cursorword) | `mini.lua` | startup | Move lines/selections; highlight the word under the cursor |
| Editing | `folke/ts-comments.nvim` | `ts-comments.lua` | event: VeryLazy | Language-aware comment strings for built-in `gc` |
| Editing | `mbbill/undotree` | `undotree.lua` | event: VeryLazy | Visual undo-history tree |
| Completion | `saghen/blink.cmp` + `rafamadriz/friendly-snippets` | `lsp.lua` | startup | Completion menu, snippets, signature help |
| LSP | `neovim/nvim-lspconfig` | `lsp.lua` | startup | Server configs, enabled via `vim.lsp.enable` |
| LSP | `williamboman/mason.nvim` | `lsp.lua` | startup | Installs language servers, linters, debug adapters |
| LSP | `mason-org/mason-lspconfig.nvim` | `lsp.lua` | startup | Ensures the servers in `lsp.lua` are installed |
| LSP | `WhoIsSethDaniel/mason-tool-installer.nvim` | `lsp.lua` | startup | Installs and updates linters and debug adapters on launch |
| Lint | `mfussenegger/nvim-lint` | `lsp.lua` | event: BufReadPre | Runs external linters on demand |
| Diagnostics | `folke/trouble.nvim` | `trouble.lua` | cmd: `:Trouble` | Panels for diagnostics, references, symbols, quickfix |
| Diagnostics | `folke/todo-comments.nvim` | `todo-comments.lua` | event: BufReadPost | Highlights and searches `TODO:`/`FIX:`/… comments |
| Syntax | `nvim-treesitter/nvim-treesitter` (main branch) | `treesitter.lua` | startup | Parsers for highlighting, indent, folds |
| Debug | `mfussenegger/nvim-dap` (+ dap-ui, nio, virtual-text, dap-python, dap-go, mason-nvim-dap) | `dap.lua` | lazy (first debug key) | Debugger client and UI |
| Git | `lewis6991/gitsigns.nvim` | `gitsigns.lua` | event: BufReadPost | Hunk signs, staging, blame |
| Git | `tpope/vim-fugitive` | `vim-fugitive.lua` | startup | `:Git` wrapper, status window, diffs, log |
| Git | `kdheepak/lazygit.nvim` | `lazygit.lua` | cmd: `:LazyGit*` | LazyGit TUI in a float |
| AI | `coder/claudecode.nvim` | `claudecode.lua` | keys/cmd | Claude Code terminal and IDE integration |
| UI | `folke/which-key.nvim` | `which-key.lua` | event: VeryLazy | Keymap browser (on demand) |
| UI | `goolord/alpha-nvim` | `alpha.lua` | startup | Start screen (startify theme) |
| UI | `vim-airline/vim-airline` + `vim-airline-themes` | `airline-themes.lua` | startup | Statusline (theme `lucius`) |
| UI | `folke/snacks.nvim` | `snacks.lua` | startup | Status column; indent guides (off by default); terminal for Claude Code |
| UI | `lukas-reineke/indent-blankline.nvim` + `TheGLander/indent-rainbowline.nvim` | `indent-rainbow.lua` | startup | Rainbow indent guides (disabled on file open) |
| UI | `sphamba/smear-cursor.nvim` | `smear.lua` | startup | Animated cursor trail |
| UI | 11 colorscheme plugins | `colorschemes.lua` | startup | Themes; active is `kyotonight` |
| Library | `nvim-lua/plenary.nvim`, `MunifTanjim/nui.nvim`, `nvim-tree/nvim-web-devicons`, `nvim-neotest/nvim-nio` | (dependencies) | as needed | Shared helpers, UI components, file icons, async |

---

## 3. Language Support Matrix

Language servers are listed in `servers`, linters in `linters`, and debug adapters in `debuggers`, all at the top of `lua/plugins/lsp.lua`. Treesitter parsers are listed in `lua/plugins/treesitter.lua`.

| Language | LSP server | Linter (`<leader>lc`) | Debugger | Treesitter parser(s) | Inlay hints |
| --- | --- | --- | --- | --- | --- |
| C | `clangd` | `cpplint` | `codelldb` (+ "Build & debug current file") | `c` | yes |
| C++ | `clangd` | `cpplint` | `codelldb` (+ "Build & debug current file") | `cpp` | yes |
| Rust | `rust_analyzer` | `clippy` (via cargo) | `codelldb` | `rust` | yes |
| Zig | `zls` | `zlint` | `codelldb` | `zig` | yes |
| Go | `gopls` | `golangcilint` | `delve` via nvim-dap-go (only if `go` is on PATH) | `go`, `gomod`, `gosum` | yes |
| Python | `basedpyright` | `pylint`, `ruff` | `debugpy` via nvim-dap-python | `python` | yes |
| JavaScript / TypeScript | `ts_ls` | `eslint_d` (only in projects with an eslint config) | `js-debug-adapter` (`pwa-node`, Node only) | `javascript`, `typescript`, `tsx`, `jsdoc` | yes |
| Perl | `perlnavigator` (with Perl::Critic) | `perlcritic` | `perl-debug-adapter` (needs `perl-padwalker`) | `perl` | no |
| Ruby | `ruby_lsp`, only if `ruby` is on PATH | `rubocop`, only if `ruby` is on PATH | `rdbg`, only if installed | `ruby` | yes |
| Bash / sh | `bashls` | `shellcheck` | `bash-debug-adapter` | `bash` | no |
| Zsh | — | `zsh -n` (syntax check) | — | — | — |
| Lua | `lua_ls` | `selene` (falls back to `nvim/selene/` config) | — | `lua`, `luadoc` | yes |
| SQL | `sqls` | `sqlfluff` (`--dialect=ansi`) | — | `sql` | no |
| HTML | `html` | `htmlhint` | — | `html` | no |
| CSS | `cssls` | `biomejs` | — | `css` | no |
| PowerShell | `powershell_es`, only if `pwsh` is on PATH (runs PSScriptAnalyzer) | — | — | `powershell` | — |
| Nix | — | `statix` | — | — | — |
| JSON / YAML / TOML / Markdown | — | — | — | `json`, `yaml`, `toml`, `markdown`, `markdown_inline` | — |
| Vim / help / misc | — | — | — | `vim`, `vimdoc`, `query`, `regex` | — |

---

## 4. Navigation & Search

### Telescope

> `nvim-telescope/telescope.nvim` · `lua/plugins/telescope.lua` · Fuzzy finder. Layout is horizontal with the prompt on top, results sorted ascending, and preview at 65% width.

**Keymaps**

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>ff` | n | Find files | custom |
| `<leader>fg` | n | Live grep (project-wide, uses ripgrep) | custom |
| `<leader>fb` | n | Open buffers | custom |
| `<leader>fh` | n | Help tags | custom |
| `<leader>fc` | n | Command history | custom |
| `<leader>fW` | n | Grep word under cursor | custom |
| `<leader>fs` | n | Grep `sub <word>` (find a Perl sub definition) | custom |
| `<leader>H` | n | Harpoon list in a Telescope picker | custom |

**Inside a picker (plugin defaults)**

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-n>` / `<C-p>`, `<Down>` / `<Up>` | i, n | Next / previous result |
| `j` / `k`, `gg` / `G`, `H` / `M` / `L` | n | Move in results (`<Esc>` from insert first) |
| `<CR>` | i, n | Open selection |
| `<C-x>` / `<C-v>` / `<C-t>` | i, n | Open in horizontal split / vertical split / new tab |
| `<C-u>` / `<C-d>` | i, n | Scroll preview up / down |
| `<Tab>` / `<S-Tab>` | i, n | Toggle multi-select and move |
| `<C-q>` | i, n | Send **all** results to quickfix and open it |
| `<M-q>` | i, n | Send **selected** results to quickfix and open it |
| `<C-r><C-w>` | i | Insert the word that was under the cursor |
| `<C-/>` (insert) / `?` (normal) | i, n | Show picker keymaps |
| `<C-c>` (insert) / `<Esc>` (normal) | i, n | Close |

**Useful commands without a keymap:** `:Telescope` (pick a picker) · `:Telescope oldfiles` · `:Telescope keymaps` · `:Telescope diagnostics` · `:Telescope colorscheme enable_preview=true` · `:Telescope resume` (reopen the last picker) · `:Telescope git_commits` · `:Telescope lsp_document_symbols`

---

### Harpoon

> `ThePrimeagen/harpoon` (branch `harpoon2`) · `lua/plugins/harpoon.lua`, keymaps in `keymaps.lua` · A short, ordered list of pinned files per project. Saves when the menu is toggled or closed.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>0` | n | Add current file to the list | custom |
| `<leader>h` | n | Toggle the quick menu | custom |
| `<leader>H` | n | Show the list in Telescope (with preview) | custom |
| `<leader>1` … `<leader>9` | n | Jump to file 1–9 | custom |
| `<leader>n` / `<leader>N` | n | Next / previous file in the list | custom |

**Inside the quick menu:** it's a normal buffer. Reorder lines to reorder files and use `dd` to remove one. `<CR>` opens the file under the cursor, and `q` or `<Esc>` closes and saves.

---

### Flash

> `folke/flash.nvim` · `lua/plugins/flash.lua` · Jump anywhere on screen by typing a few characters and then a label.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `s` | n, x, o | Flash jump: type chars, then the label | custom |
| `S` | n, x, o | Flash Treesitter: select a syntax node by label | custom |
| `r` | o | Remote flash: run an operator elsewhere without moving (e.g. `yr<label>iw`) | custom |
| `R` | o, x | Treesitter search: pick a node around a search match | custom |
| `<C-s>` | c | Toggle flash labels during a `/` or `?` search | custom |
| `f` `F` `t` `T` | n, x, o | Enhanced char motions: multi-line, with labels | default |
| `;` / `,` | n, x, o | Repeat last `f`/`t` forward / backward | default |

> `s` and `S` replace Vim's built-in substitute-char and substitute-line. Use `cl` / `cc` instead.

---

### Neo-tree

> `nvim-neo-tree/neo-tree.nvim` (v3.x) · `lua/plugins/neo-tree.lua` · File explorer on the left, 30 columns wide. Shows dotfiles but hides gitignored files, follows the current file, and replaces netrw (`nvim .` opens it).

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader><leader>` | n | Toggle Neo-tree | custom |

**Inside the tree**

| Keys | Action | Tag |
| --- | --- | --- |
| `<CR>` | Open file / expand dir | custom |
| `<Space>` | Toggle node open/closed | custom |
| `s` / `S` / `t` | Open in vsplit / split / new tab | custom |
| `C` / `z` | Close node / close all nodes | custom / default |
| `a` / `A` | Add file (end with `/` for a dir) / add directory | custom / default |
| `d` / `r` / `b` | Delete / rename / rename basename only | custom / custom / default |
| `y` / `x` / `p` | Copy / cut / paste via Neo-tree's clipboard | custom |
| `c` / `m` | Copy / move to a typed path | default |
| `R` | Refresh | custom |
| `H` | Toggle hidden files | default |
| `/` / `f` / `<C-x>` | Fuzzy find / filter / clear filter | default |
| `<BS>` / `.` | Go up a directory / set root to node | default |
| `[g` / `]g` | Previous / next git-modified file | default |
| `P` / `l` | Toggle floating preview / focus preview | default |
| `i` | File details | default |
| `o` + `c d g m n s t` | Order by created / diagnostics / git / modified / name / size / type | default |
| `<` / `>` | Switch source (filesystem ↔ buffers ↔ git status) | default |
| `?` | Show all mappings | default |
| `q` | Close window | custom |
| `<leader>as` | Add file under cursor to Claude Code context | custom (claudecode) |

**Commands:** `:Neotree toggle` · `:Neotree reveal` · `:Neotree buffers` · `:Neotree git_status` · `:Neotree float`

---

## 5. Editing

### mini.move

> `echasnovski/mini.nvim` → `require("mini.move")` · `lua/plugins/mini.lua` · Moves lines and selections, reindenting as they go.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<C-Up>` / `<C-Down>` | n | Move current line up / down | custom |
| `<C-Left>` / `<C-Right>` | n | Dedent / indent current line | custom |
| `<C-Up>` / `<C-Down>` | x | Move selection up / down (reindents) | custom |
| `<C-Left>` / `<C-Right>` | x | Move selection left / right | custom |

`mini.cursorword` is set up from the same file and has no keybinds. See [§12](#12-features-without-keybinds).

---

### Commenting (built-in + ts-comments)

> Commenting comes from **Neovim's built-in `gc`** (0.10+). `folke/ts-comments.nvim` (`ts-comments.lua`) sets the correct comment string for the Treesitter language **at the cursor**, for example JSX inside TSX or JS/CSS inside HTML. *(`mini.comment` is installed but never set up. See [§13](#13-installed-but-inactive--disabled).)*

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `gcc` | n | Toggle comment on current line | default (built-in) |
| `gc{motion}` | n | Toggle comment over a motion (e.g. `gcip`, `gc3j`) | default (built-in) |
| `gc` | x | Toggle comment on selection | default (built-in) |
| `gc` | o | Comment text object (e.g. `dgc` deletes a comment block) | default (built-in) |

---

### Undotree

> `mbbill/undotree` · `lua/plugins/undotree.lua` · Browse undo history as a branching tree. History only lasts until the buffer or session closes, because `undofile` is not enabled in `options.lua`.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>u` | n | Toggle Undotree panel | custom |

**Inside the panel (defaults):** `J` / `K` previous / next state · `<CR>` jump to state · `u` / `<C-r>` undo / redo · `<` / `>` previous / next *saved* state · `D` toggle diff panel · `T` toggle relative timestamps · `C` clear history · `<Tab>` back to editor · `?` help · `q` close

---

### Completion (blink.cmp)

> `saghen/blink.cmp` v1.\* + `friendly-snippets` · configured in `lua/plugins/lsp.lua`, keymaps in the `M.completion` / `M.cmdline_completion` tables at the bottom of `keymaps.lua` · Sources are `lsp`, `path`, `snippets`, `buffer`. The menu opens automatically as you type. Docs open only on request. Brackets are added after accepted functions, and signature help shows inside calls. The keymap preset is `none`, so **only** the keys below exist.

**Insert mode**

| Keys | Action |
| --- | --- |
| `<C-Space>` | Open menu, or toggle docs for the selected item |
| `<CR>` / `<C-y>` | Accept selected / accept (picks first if none selected) |
| `<C-e>` | Cancel menu and undo the preview |
| `<C-n>` / `<C-p>`, `<Down>` / `<Up>` | Next / previous item |
| `<C-f>` / `<C-b>` | Scroll docs down / up |
| `<Tab>` / `<S-Tab>` | Next / previous snippet placeholder |
| `<C-k>` | Toggle signature help |

**Command line (`:` `/` `?`)**

| Keys | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Open menu and insert first / last item, then cycle |
| `<C-n>` / `<C-p>`, `<Right>` / `<Left>` | Next / previous item |
| `<C-Space>` | Open menu |
| `<C-y>` | Accept |
| `<C-e>` | Cancel and undo preview |
| `<End>` | Hide menu, keep what you typed |

---

## 6. Code Intelligence

### LSP (nvim-lspconfig + Mason)

> `neovim/nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim` · `lua/plugins/lsp.lua` · Servers are installed by Mason and enabled with `vim.lsp.enable(servers)`. See the [matrix](#3-language-support-matrix). Inlay hints and code lens turn on automatically for every server that supports them.

**Buffer-local (set when a server attaches)**

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `gd` | n | Go to definition (Telescope if several) | custom |
| `gD` | n | Go to declaration | custom |
| `gr` | n | References (Telescope, excludes the declaration) | custom |
| `gi` | n | Go to implementation | custom |
| `gt` | n | Go to type definition (**shadows** built-in next-tab `gt`) | custom |
| `K` / `gh` | n | Hover docs | custom |
| `<C-k>` / `gs` | n | Signature help | custom |
| `<leader>rn` | n | Rename symbol | custom |
| `<leader>ca` | n, x | Code action | custom |
| `<leader>cl` | n | Run code lens on current line | custom |
| `<leader>cs` | n | Workspace symbols (Telescope, dynamic) | custom |

**Global**

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>lr` | n | Restart LSP (`:lsp restart` on 0.12+) | custom |
| `<leader>li` | n | LSP info (`:checkhealth vim.lsp`) | custom |
| `<leader>lf` | n | Format buffer | custom |
| `<leader>lh` | n | Toggle inlay hints (buffer) | custom |

**Built-in LSP keys still active:** `gO` document symbols · `<C-s>` (insert) signature help · `an` / `in` (x, o) expand / shrink selection by syntax node · `<C-]>` definition via tagfunc · `gq` format via formatexpr. The built-in `grn`/`gra`/`grr`/`gri`/`grt`/`grx` maps are **deleted** in `keymaps.lua` so `gr` doesn't lag.

**Adding a server:** append its name to `servers` at the top of `lsp.lua`. Add a `vim.lsp.config("<name>", {...})` block only if it needs settings.

---

### Diagnostics

> Built-in `vim.diagnostic`, keymaps in `keymaps.lua`.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `]d` / `[d` | n | Next / previous diagnostic, with float | custom |
| `<leader>dn` / `<leader>dp` | n | Next / previous diagnostic, with float | custom |
| `<leader>dl` | n | Show diagnostics for current line in a float | custom |
| `<leader>dq` | n | Diagnostics → **location** list | custom |
| `<leader>dd` / `<leader>de` | n | Disable / enable diagnostics for this buffer | custom |
| `]D` / `[D` | n | Last / first diagnostic in buffer | default (built-in) |
| `<C-w>d` | n | Diagnostic float under cursor | default (built-in) |

---

### Linting (nvim-lint)

> `mfussenegger/nvim-lint` · section E of `lua/plugins/lsp.lua` · **Manual only.** The lint-on-save autocmd is commented out. Linters are installed by mason-tool-installer, except `perlcritic` (Arch package), `clippy` (cargo), and `zsh`.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>lc` | n | Lint current file | custom |

**Adding a linter:** add the Mason package name to `linters` and the nvim-lint name to `linters_by_ft`. The two names can differ, e.g. `golangci-lint` vs `golangcilint`.

---

### Trouble

> `folke/trouble.nvim` · `lua/plugins/trouble.lua` · Panels for diagnostics, references, symbols, quickfix, and TODOs. The diagnostics panel auto-closes when it's empty and takes focus when opened. LSP references preview automatically.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>dte` | n | Toggle diagnostics (whole workspace) | custom |
| `<leader>dtt` | n | Toggle diagnostics (current buffer) | custom |
| `<leader>dtr` | n | Toggle LSP references | custom |
| `<leader>dtD` | n | Toggle LSP definitions | custom |
| `<leader>dts` | n | Toggle document symbols (no focus) | custom |
| `<leader>dtq` | n | Toggle quickfix list | custom |
| `<leader>dtn` / `<leader>dtp` | n | Next / previous Trouble item | custom |
| `<leader>dtd` | n | Close Trouble | custom |

**Inside a Trouble window (defaults):** `<CR>` jump · `o` jump and close · `<C-s>` / `<C-v>` jump in split / vsplit · `]]` / `[[` or `}` / `{` next / previous item · `p` preview · `P` toggle auto-preview · `gb` filter to current buffer · `s` cycle severity filter · `dd` delete item · `zo` / `zc` / `za` / `zR` / `zM` folds · `r` refresh · `i` inspect · `?` help · `q` close

**Commands:** `:Trouble <mode> [toggle] [filter.buf=0]`. Modes: `diagnostics`, `symbols`, `lsp`, `lsp_references`, `lsp_definitions`, `lsp_implementations`, `lsp_type_definitions`, `quickfix`, `loclist`, `todo`

---

### Treesitter

> `nvim-treesitter/nvim-treesitter` (**main** branch) · `lua/plugins/treesitter.lua` · Installs parsers in the background on startup. A `FileType` autocmd starts highlighting, and Treesitter indentation where the language has indent queries. Folding uses `vim.treesitter.foldexpr()`, with everything unfolded by default (`foldlevel=99`). Needs the `tree-sitter` CLI and a C compiler.

| Keys / Command | Action | Tag |
| --- | --- | --- |
| `za` (first press only) | Runs `zx` then `za` to refresh folds, then reverts to normal `za` (`autocmds.lua`) | custom |
| `za` `zo` `zc` `zR` `zM` | Toggle / open / close / open all / close all folds | default (built-in) |
| `an` / `in` | Expand / shrink selection by syntax node (x, o) | default (built-in) |
| `:TSInstall <lang>` / `:TSUninstall <lang>` | Add / remove a parser | command |
| `:TSUpdate` | Update all parsers (also runs on plugin build) | command |
| `:TSLog` | Show install log | command |
| `:InspectTree` / `:Inspect` | View the syntax tree / highlight groups under the cursor | command (built-in) |

---

## 7. Debugging (nvim-dap)

> `mfussenegger/nvim-dap` + `nvim-dap-ui`, `nvim-dap-virtual-text`, `nvim-dap-python`, `nvim-dap-go`, `mason-nvim-dap` · `lua/plugins/dap.lua`, keymaps in `keymaps.lua` · Loads on the first debug key. The debug UI opens when a session starts and closes when it ends. Variable values show at the end of each line while stopped. A `.vscode/launch.json` in the project root is read automatically. `dap.lua` has detailed usage notes per language at the bottom.

**Function keys** (`<F11>`/`<F12>` are taken by quickfix next/previous)

| Key | Action |
| --- | --- |
| `<F5>` | Toggle breakpoint |
| `<F6>` | Start / continue (shows config picker if several) |
| `<F7>` | Step over |
| `<F8>` | Step into |
| `<F9>` | Step out |
| `<F10>` | Clear all breakpoints |

**Leader keys**

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>Db` | n | Toggle breakpoint |
| `<leader>DB` | n | Conditional breakpoint (prompts) |
| `<leader>DL` | n | Log point (prompts; `{expr}` interpolates) |
| `<leader>Dx` | n | Clear all breakpoints |
| `<leader>Dc` | n | Start / continue |
| `<leader>Do` / `<leader>Di` / `<leader>DO` | n | Step over / into / out |
| `<leader>DC` | n | Run to cursor |
| `<leader>Dl` | n | Re-run last session (no picker) |
| `<leader>Dt` | n | Terminate session |
| `<leader>Du` | n | Toggle debug UI |
| `<leader>Dr` | n | Toggle REPL |
| `<leader>De` | n, v | Evaluate expression under cursor / selection |
| `<leader>Dm` / `<leader>DM` | n | **Python:** debug test method / class · **Go:** debug test under cursor / last test |

**Inside dap-ui panels (defaults):** `<CR>` expand · `o` open · `e` edit value · `d` remove · `r` send to REPL · `t` toggle · `w` watch

**Breakpoint signs:** `●` breakpoint · `◆` conditional · `◉` log point · `○` rejected · `→` current line (highlighted)

**Extra launch configs:** C/C++ "Build & debug current file" (compiles with `-g -O0 -Wall` into `~/.cache/nvim/dap-build/`) · Go "Attach remote (dlv on :38697)" · JS/TS "Launch current file (node)" and "Attach to process" · Perl and Ruby "current file"

---

## 8. Git

### Gitsigns

> `lewis6991/gitsigns.nvim` · `lua/plugins/gitsigns.lua` · Thin `▎` bars in the status column for added, changed, and deleted lines. Staged and unstaged hunks have separate signs.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `]h` / `[h` | n | Next / previous hunk (`]c`/`[c` in diff mode) | custom |
| `]H` / `[H` | n | Last / first hunk | custom |
| `<leader>ghs` | n, v | Stage hunk (or selected lines) | custom |
| `<leader>ghr` | n, v | Reset hunk (or selected lines) | custom |
| `<leader>ghu` | n | Undo last stage-hunk | custom |
| `<leader>ghp` | n | Preview hunk inline | custom |
| `<leader>ghS` / `<leader>ghR` | n | Stage / reset whole buffer | custom |
| `<leader>ghb` | n | Blame line (full commit message) | custom |
| `<leader>ghB` | n | Blame whole buffer | custom |
| `<leader>ghd` / `<leader>ghD` | n | Vimdiff against revision `~` / against the index | custom |
| `ih` | o, x | Hunk text object (e.g. `dih`, `vih`) | custom |
| `<leader>gt` | n | Toggle gitsigns signs | custom |

**Command:** `:Gitsigns <action>` (tab-completes every action, e.g. `:Gitsigns toggle_current_line_blame`, `:Gitsigns setqflist`)

---

### Fugitive

> `tpope/vim-fugitive` · `lua/plugins/vim-fugitive.lua`, keymaps in `keymaps.lua` · The `:Git` command, a status window, diffs, and log.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>gs` | n | Status window (`:Git`) | custom |
| `<leader>gc` | n | Commit (`:Git commit`) | custom |
| `<leader>gb` | n | Blame (`:Git blame`) | custom |
| `<leader>gd` | n | Diff current file vs index (`:Gdiffsplit`) | custom |
| `<leader>gl` | n | Commit log into quickfix (`:Gclog`) | custom |
| `<leader>go` | n | Open file on remote (`:GBrowse`). **Not working**, see [§14](#14-known-config-issues) | custom |

**Inside the `:Git` status window (defaults):** `s` stage · `u` unstage · `-` toggle stage · `U` unstage all · `X` discard change · `=` inline diff · `dv` vertical diff · `I` / `P` patch add/reset · `<CR>` open file · `o` / `gO` open in split / vsplit · `(` / `)` previous / next file or hunk · `cc` commit · `ca` amend · `ce` amend without editing · `cw` reword · `czz` / `czp` stash push / pop · `g?` help · `gq` close

**Commands:** `:Git <any git args>` · `:Gwrite` (stage file) · `:Gread` (checkout file) · `:GMove` / `:GRename` / `:GDelete` · `:Ggrep` · `:Gvdiffsplit`

---

### LazyGit

> `kdheepak/lazygit.nvim` · `lua/plugins/lazygit.lua` · Opens the `lazygit` TUI in a floating window (needs the `lazygit` binary).

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>gg` | n | LazyGit for the current file's repo | custom |

**Commands:** `:LazyGit` (cwd repo) · `:LazyGitCurrentFile` · `:LazyGitFilter` (commit browser) · `:LazyGitFilterCurrentFile` (this file's history) · `:LazyGitConfig`. Inside LazyGit, `?` lists its keys and `q` quits.

**Also under `<leader>g`:** `<leader>gu` (meant to undo the last commit) and `<leader>ga` (meant to stash). **Both are broken**, see [§14](#14-known-config-issues).

---

## 9. AI: Claude Code

> `coder/claudecode.nvim` (uses snacks.nvim for the terminal) · `lua/plugins/claudecode.lua` · Runs Claude Code in a split and connects it to Neovim as an IDE, so it sees the current selection and shows diffs.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>ac` | n | Toggle Claude terminal | custom |
| `<leader>af` | n | Focus Claude terminal | custom |
| `<leader>ar` | n | Resume a past conversation (`--resume`) | custom |
| `<leader>aC` | n | Continue last conversation (`--continue`) | custom |
| `<leader>am` | n | Select model | custom |
| `<leader>ab` | n | Add current buffer to context | custom |
| `<leader>as` | v | Send selection to Claude | custom |
| `<leader>as` | n (file explorers) | Add file under cursor (Neo-tree, oil, netrw, mini.files…) | custom |
| `<leader>aa` | n | Accept proposed diff | custom |
| `<leader>ad` | n | Deny proposed diff | custom |

**Commands:** `:ClaudeCode` · `:ClaudeCodeFocus` · `:ClaudeCodeAdd <path> [start] [end]` · `:ClaudeCodeSend` · `:ClaudeCodeTreeAdd` · `:ClaudeCodeSelectModel` · `:ClaudeCodeStatus` · `:ClaudeCodeStart` / `:ClaudeCodeStop` (integration server) · `:ClaudeCodeOpen` / `:ClaudeCodeClose` · `:ClaudeCodeDiffAccept` / `:ClaudeCodeDiffDeny` / `:ClaudeCodeCloseAllDiffs`

> `<leader>aw` and `<leader>ay` share this prefix. They are core find-and-append substitutions, not Claude.

---

## 10. UI & Appearance

### which-key

> `folke/which-key.nvim` · `lua/plugins/which-key.lua` · Lists any keymap that has a `desc`. **The automatic popup is off** (`triggers = {}`), so it only opens on demand.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>?` | n | Show leader keymaps | custom |
| `<leader>/` | n | Show all keymaps | custom |

### Indent guides (Snacks indent + indent-blankline rainbow)

> Two separate indent-guide systems, both off by default. Snacks indent is `enabled = false` in `snacks.lua`. indent-blankline is disabled by an autocmd on every `BufReadPost` (`autocmds.lua`). The rainbow colors come from `indent-rainbowline` at 17% opacity.

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>ie` / `<leader>id` | n | Enable / disable Snacks indent guides | custom |
| `<leader>iee` / `<leader>idd` | n | Enable / disable rainbow indent-blankline (`:IBLEnable` / `:IBLDisable`) | custom |

> `<leader>ie` and `<leader>id` pause for `timeoutlen` before firing, because `<leader>iee` and `<leader>idd` start with them.

### Colorschemes

> `lua/plugins/colorschemes.lua` installs the themes. The active one is set in `options.lua`: **`vim.cmd.colorscheme 'kyotonight'`**. Custom `Diff*` highlights are re-applied after every `:colorscheme`.

| Plugin | `:colorscheme` names |
| --- | --- |
| `shrikecode/kyotonight.vim` | `kyotonight` (**active**) |
| `maxmx03/fluoromachine.nvim` | `fluoromachine` (loaded eagerly with glow and custom purple bg) |
| `cesaralvarod/tokyogogh.nvim` | `tokyogogh`, `tokyogogh-night`, `tokyogogh-storm` |
| `miikanissi/modus-themes.nvim` | `modus`, `modus_operandi`, `modus_vivendi` |
| `lunacookies/vim-substrata` | `substrata` |
| `diegoulloao/neofusion.nvim` | `neofusion` |
| `olivercederborg/poimandres.nvim` | `poimandres` |
| `ntk148v/komau.vim` | `komau` |
| `shaunsingh/nord.nvim` | `nord` |
| `thedenisnikulin/vim-cyberpunk` | `cyberpunk`, `silverhand` |
| `dracula/vim` | `dracula`, `alucard` |
| local `nvim/colors/` | `cyberpunk`, `cyberspace`, `gothic-cyberpunk` |

| Keys / Command | Action | Tag |
| --- | --- | --- |
| `:Telescope colorscheme enable_preview=true` | Browse themes with live preview | command |
| `<leader>tb` | Make the background transparent (`Normal guibg=NONE`) | custom |

For the passive UI plugins (alpha, airline, Snacks status column, smear-cursor, mini.cursorword, devicons), see [§12](#12-features-without-keybinds).

---

## 11. Plugin & Tool Management

### lazy.nvim — `:Lazy`

| Key (in `:Lazy`) | Action |
| --- | --- |
| `S` | Sync: install + clean + update. Run this after editing plugin specs |
| `I` / `U` / `X` | Install missing / update / clean unused |
| `C` | Check for updates |
| `L` | Log of recent updates |
| `R` | Restore plugins to `lazy-lock.json` |
| `P` / `D` | Profile startup / debug view |
| `H` / `?` / `q` | Home / help / close |
| `i` `u` `x` `c` `r` `gb` `gl` | Same actions for the plugin under the cursor (`gb` build, `gl` log) |

Commit `lazy-lock.json` after updating so other machines get the same versions.

### Mason — `:Mason`

| Key (in `:Mason`) | Action |
| --- | --- |
| `i` / `u` / `X` | Install / update / uninstall package under cursor |
| `U` | Update all packages |
| `C` / `c` | Check outdated packages / check this package's version |
| `<CR>` | Expand package details or install log |
| `<C-f>` | Filter by language |
| `<C-c>` | Cancel installation |
| `g?` | Help |

**Commands:** `:MasonInstall <pkg>` · `:MasonUninstall <pkg>` · `:MasonUpdate` (refresh registry) · `:MasonLog` · `:MasonToolsInstall` / `:MasonToolsUpdate` / `:MasonToolsClean` (mason-tool-installer, which also installs and updates the `linters` + `debuggers` lists automatically on every launch)

---

## 12. Features Without Keybinds

These plugins run on their own or only through `:commands`. Nothing needs to be pressed.

| Plugin | What it does automatically | How to use it / commands |
| --- | --- | --- |
| **todo-comments.nvim** | Highlights comment keywords followed by a colon: **`TODO:`** · **`FIX:`** (also `FIXME` `BUG` `FIXIT` `ISSUE`) · **`HACK:`** · **`WARN:`** (also `WARNING` `XXX`) · **`PERF:`** (also `OPTIM` `PERFORMANCE` `OPTIMIZE`) · **`NOTE:`** (also `INFO`) · **`TEST:`** (also `TESTING` `PASSED` `FAILED`). Each gets an icon and a sign. | `:TodoTelescope` (fuzzy search the project) · `:TodoTrouble` or `:Trouble todo` · `:TodoQuickFix` · `:TodoLocList`. Filter with `keywords=TODO,FIX` and/or `cwd=path`, e.g. `:TodoTelescope keywords=FIX,BUG`. No jump keys are mapped. `require("todo-comments").jump_next()` / `jump_prev()` are available to bind. |
| **mini.cursorword** | Underlines every other occurrence of the word under the cursor after a short delay | Nothing to do |
| **smear-cursor.nvim** | Animated "smear" trail when the cursor jumps, including between windows and in insert mode. Disabled in the dap-ui console (it hangs debug sessions there) | `:SmearCursorToggle` |
| **ts-comments.nvim** | Swaps `commentstring` to match the Treesitter language at the cursor, so `gc` comments correctly in embedded code | Use `gc` / `gcc` |
| **nvim-treesitter** | Syntax highlighting, smart indent, and code folding for the parsers in [§3](#3-language-support-matrix). Missing parsers install in the background on launch | `:TSInstall`, `:TSUpdate`, `:InspectTree` |
| **alpha-nvim** | Start screen when Neovim opens with no file: ASCII "NEOVIM" header, then **MRU files in the current dir** (shortcuts `0`–`9`), then **recent files everywhere** (`10`+), `e` new file, `q` quit | Type the number or letter shown. `:Alpha` reopens it |
| **vim-airline** | Statusline with mode, branch, file, and position. Theme `lucius`, no powerline separators, single global statusline (`laststatus=3`) | `:AirlineTheme <name>` to switch for this session, `:AirlineToggle` |
| **snacks.nvim (statuscolumn)** | Custom left gutter: marks and signs on the left, folds and git signs on the right | Nothing to do |
| **gitsigns.nvim (signs)** | `▎` bars for added, changed, and deleted lines; staged hunks are shown separately | `<leader>gt` toggles them |
| **LSP inlay hints** | Inline type, parameter, and return hints for every server that supports them (see [§3](#3-language-support-matrix)) | `<leader>lh` toggles per buffer |
| **LSP code lens** | Actionable annotations above lines (e.g. "run test", "N references") | `<leader>cl` runs the lens on the line |
| **blink.cmp** | Menu pops up as you type (keywords and trigger chars like `.`). Auto-brackets after functions. Signature help inside calls | Keys in [§5](#completion-blinkcmp) |
| **nvim-dap-ui** | Opens scopes, stacks, watches, breakpoints, REPL, and console when a debug session starts, and closes them when it ends | `<leader>Du` to reopen |
| **nvim-dap-virtual-text** | Shows variable values at the end of each line while stopped (e.g. `x = 41`) | Nothing to do |
| **Neo-tree (filesystem)** | Follows the current file. Live file watching. Opens instead of netrw for `nvim <dir>`. Closes when it's the last window | `<leader><leader>` |
| **mason-tool-installer** | Installs missing linters and debug adapters, and updates existing ones, on every launch | `:MasonToolsUpdate` to force it |
| **fluoromachine** | Loaded at startup with glow, italic functions and comments, and a darkened purple background. Not the active theme | `:colorscheme fluoromachine` |
| **nvim-web-devicons** | File-type icons in Neo-tree, Telescope, Trouble, alpha (needs a Nerd Font) | Nothing to do |
| **plenary / nui / nvim-nio** | Libraries other plugins depend on | Nothing to do |

---

## 13. Installed but Inactive / Disabled

**Spec files that return `{}` (disabled on purpose, original config kept in comments):**

| File | Plugin | Notes |
| --- | --- | --- |
| `avante.lua` | `yetone/avante.nvim` | AI assistant, replaced by Claude Code |
| `blink-cmp.lua` | `saghen/blink.cmp` | Stub. The live blink config moved into `lsp.lua` |
| `gitgutter.lua` | `airblade/vim-gitgutter` | Fallback if gitsigns struggles on huge files |
| `markdown-preview.lua` | `iamcco/markdown-preview.nvim` | `:MarkdownPreview` does **not** exist while this is off |
| `mini-pairs.lua` | `echasnovski/mini.pairs` | Auto-pairs for brackets and quotes |
| `noice.lua` | `folke/noice.nvim` | Floating cmdline and messages UI |
| `lsp-old-unused.lua` | nvim-cmp based LSP setup | Superseded by `lsp.lua` + blink.cmp |

**Installed but never set up.** The spec has no `opts` or `config`, so lazy.nvim never calls `setup()` and the plugin does nothing (checked headless: `_G.MiniAi`, `MiniComment`, `MiniDiff` are all `nil`):

| File | Plugin | What you'd get if enabled (`opts = {}`) |
| --- | --- | --- |
| `mini-ai.lua` | `echasnovski/mini.ai` | Extra text objects: `a(`/`i(` brackets, `q` quotes, `f` function call, `a` argument, `t` tag, plus `an`/`il` next/last variants |
| `mini-comment.lua` | `echasnovski/mini.comment` | Redundant: built-in `gc` + ts-comments already cover it |
| `mini.lua` → `mini.diff` | `echasnovski/mini.diff` | Diff overlay. Overlaps with gitsigns |
| `telescope.lua` | `telescope-fzf-native.nvim` | Faster native sorter. Built, but `require('telescope').load_extension('fzf')` is never called |

---

## 14. Known Config Issues

Found while generating this doc. Nothing has been changed; each entry is listed so you can decide.

| # | Where | Problem | Suggested fix |
| --- | --- | --- | --- |
| 1 | `keymaps.lua` → `<leader>gu`, `<leader>ga` | `<cmd>git …<CR>` isn't a Neovim command, so pressing either gives **E492: Not an editor command** (verified). Also, `<leader>gu` uses `reset --hard`, which would *discard* the changes, while its comment says they should stay staged (`--soft`). | Use fugitive: `<cmd>Git reset --soft HEAD~1<CR>` and `<cmd>Git stash push<CR>` |
| 2 | `keymaps.lua` → `<leader>go` (`:GBrowse`) | Fugitive has no browse handler installed (`g:fugitive_browse_handlers` is empty), so `:GBrowse` errors | Add `tpope/vim-rhubarb` (GitHub) as a fugitive dependency, or drop the map |
| 3 | `gitsigns.lua` | `max_file_length`, `auto_attach`, `watch_gitdir`, `update_debounce` sit on the lazy spec, not inside `opts`, so gitsigns ignores them (live `max_file_length` is the default 40000) | Move them into `opts = { … }` |
| 4 | `mini.lua` → `mini.move` mappings | `comment`, `comment_line`, `textobject` aren't mini.move options and are ignored | Remove them |
| 5 | `mini-ai.lua`, `mini-comment.lua`, `mini.lua` (`mini.diff`), telescope fzf | Installed but inactive (see [§13](#13-installed-but-inactive--disabled)) | Add `opts = {}` / `load_extension('fzf')`, or remove |
| 6 | `which-key.lua` | Group `<leader>t` is labelled "Trouble / Toggle", but Trouble lives under `<leader>dt`, which has no group label | Add `{ "<leader>dt", group = "Trouble" }` |
| 7 | `keymaps.lua` → `<leader>dq` | Description says "quickfix list", but it calls `setloclist` (location list) | Fix the desc, or use `vim.diagnostic.setqflist` |
| 8 | `lua/plugins/.snacks.lua.swp` | Leftover Vim swap file that is **committed to git** | `git rm` it, and consider ignoring `*.swp` |
| 9 | `key_bindings.md` → Neovim section | Out of date: `<leader>h` is Harpoon (not clear-highlight), lint is `<leader>lc` (not `<leader>l`), `:LspInfo` is now `<leader>li` / `:checkhealth vim.lsp`, `:MarkdownPreview` is disabled, commenting is built-in `gc` (not vim-commentary) | Point that section at this file, or trim it |
