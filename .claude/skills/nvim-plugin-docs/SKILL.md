---
name: nvim-plugin-docs
description: Regenerates or updates nvim_plugins.md (repo root), the organized reference of every Neovim plugin in dotfiles/.config/nvim, covering keymaps, commands, no-keybind/passive features, the language support matrix, inactive plugins, and config issues. Use when the user adds, removes, updates, or remaps Neovim plugins or keymaps, edits files under dotfiles/.config/nvim/, changes LSP servers/linters/debuggers/treesitter parsers, or asks to update, refresh, sync, or audit the nvim plugin docs or plugin reference.
argument-hint: "[plugin name or 'full' resync]"
---

# Neovim Plugin Docs

Keep `nvim_plugins.md` (repo root) **true to the config in `dotfiles/.config/nvim/`**. The config is the source of truth. Never document a key, command, or feature you haven't seen in the config, in the installed plugin source, or in the probe report.

## Sources to read

| What | Where |
| --- | --- |
| Plugin specs | `dotfiles/.config/nvim/lua/plugins/*.lua` (one file per plugin or group) |
| Keymaps (most of them) | `dotfiles/.config/nvim/lua/config/keymaps.lua`, including `LspAttach` / `FileType` autocmds and the blink tables `M.completion` / `M.cmdline_completion` at the bottom |
| Keymaps inside specs | `keys = {…}` in specs, and `on_attach` in `gitsigns.lua` |
| Options / autocmds | `lua/config/options.lua` (active colorscheme, airline, folds), `lua/config/autocmds.lua` |
| LSP / lint / debug lists | `servers`, `linters`, `debuggers` at the top of `lua/plugins/lsp.lua`; `linters_by_ft` in the same file; adapters and configs in `lua/plugins/dap.lua` |
| Treesitter parsers | `install({...})` list in `lua/plugins/treesitter.lua` |
| Pinned plugin set | `dotfiles/.config/nvim/lazy-lock.json` |
| Plugin defaults (pinned versions) | `~/.local/share/nvim/lazy/<plugin>/`: grep its `config.lua` / `defaults.lua` / `doc/*.txt` for default keys and commands |

If the plugin isn't installed locally, use Context7 (`resolve-library-id` → `query-docs`) for its defaults. If neither source confirms a default, leave it out.

## Classify every spec file

1. **Disabled stub:** the file starts with `return {}` (original config kept in comments). Goes in §13 "Spec files that return `{}`".
2. **Installed but never set up:** the spec has no `opts`, no `config`, and no `config = true`, and the plugin needs `setup()` (all `mini.*` modules, for example). lazy.nvim won't call `setup()`, so it's inert. Goes in §13 "Installed but never set up". The same applies to Telescope extensions that are built but never loaded with `load_extension`.
3. **Active:** document it in the right section (§4–§11). If it has passive behavior, also add a row to **§12 Features Without Keybinds**. Plugins with *no* keymaps (todo-comments, smear-cursor, mini.cursorword, alpha, airline, ts-comments…) must appear in §12.

Record the load trigger for the §2 inventory: `lazy = false` or no trigger means startup; `event` means event; `keys` / `cmd` means keys/cmd; `lazy = true` means lazy.

## Verify against the live config (headless probe)

Run from the repo root. The `--cmd` stub stops mason-tool-installer from installing or updating packages during the probe:

```bash
PROBE_OUT=<scratchpad>/nvim_probe.txt timeout 90 nvim --headless \
  --cmd "lua package.preload['mason-tool-installer'] = function() local noop = function() end; return { setup = noop, run_on_start = noop, check_install = noop, clean = noop } end" \
  -c "luafile .claude/skills/nvim-plugin-docs/probe.lua"
```

`probe.lua` fires VeryLazy, opens `dotfiles/.config/nvim/lua/config/keymaps.lua` so LSP and gitsigns maps attach, then writes:
- each plugin and whether it loaded
- which `mini.*` modules were set up
- active colorscheme, statuscolumn, loaded Telescope extensions, GBrowse handlers, gitsigns `max_file_length`, attached LSP clients
- all user commands
- every global and buffer-local keymap that has a `desc`

Optional env vars: `PROBE_FILE` (another file to open), `PROBE_WAIT_MS` (attach wait, default 3000).

Cross-check every keymap row in the doc against the report. A key in the report but missing from the doc means the doc needs a row. A key in the doc but not in the report means it was removed, or it's a plugin default with no `desc`; check the plugin source to tell which. If Neovim isn't installed, skip the probe and say so in the report.

## Doc structure (keep this order and these anchors)

The header block lists source, leader, mode letters, tags, how to update, and a **Last synced** line (today's date + `nvim --version` first line). Below it, the Table of Contents, then:

1. **Leader Key Map:** which-key groups (from `which-key.lua` `spec`) plus where each prefix's maps come from
2. **Plugin Inventory:** Category · Plugin · Spec file · Load trigger · Purpose
3. **Language Support Matrix:** Language · LSP · Linter · Debugger · Treesitter parsers · Inlay hints. Note conditional entries ("only if `ruby` on PATH")
4. **Navigation & Search:** Telescope, Harpoon, Flash, Neo-tree
5. **Editing:** mini.move, commenting, Undotree, blink.cmp
6. **Code Intelligence:** LSP, Diagnostics, nvim-lint, Trouble, Treesitter
7. **Debugging (nvim-dap)**
8. **Git:** Gitsigns, Fugitive, LazyGit
9. **AI: Claude Code**
10. **UI & Appearance:** which-key, indent guides, colorschemes
11. **Plugin & Tool Management:** `:Lazy`, `:Mason`
12. **Features Without Keybinds:** Plugin · What it does automatically · How to use / commands
13. **Installed but Inactive / Disabled**
14. **Known Config Issues:** # · Where · Problem · Suggested fix

Put a new plugin in the section matching its category. If none fits, add a section before §12 and update the ToC.

Per-plugin block format:

```markdown
### <Name>

> `<owner/repo>` · `lua/plugins/<file>.lua` · <one-line purpose + notable config>

| Keys | Mode | Action | Tag |
| --- | --- | --- | --- |
| `<leader>xx` | n | What it does | custom |

**Inside the <window/picker> (defaults):** `k` action · `k` action · …

**Commands:** `:Cmd` · `:Cmd arg`
```

Table conventions:
- Write `<leader>`, not `<Space>`.
- Tag is `custom` (mapped in this config) or `default` (the plugin's or Neovim's built-in key, still active).
- Escape `|` inside table cells as `\|`.
- Mark shadowed built-ins (e.g. LSP `gt` hides next-tab).

## Known config issues (§14)

Check for these while reading. Each one has caused a real problem before:
- Lazy spec fields that belong inside `opts` (e.g. gitsigns `max_file_length` at the spec level is ignored).
- Keymaps whose RHS isn't a valid command (e.g. `<cmd>git …` causes E492). Verify with `nvim --headless --clean -c 'lua print(pcall(vim.cmd, "<cmd text>"))' -c 'qa!'`.
- Commands that need a missing companion plugin (e.g. `:GBrowse` needs vim-rhubarb).
- `desc` text that contradicts what the mapping does.
- which-key groups that don't match where the maps actually live.
- Prefix overlaps that cause `timeoutlen` delays (e.g. `<leader>ie` vs `<leader>iee`).

Drop issues that have been fixed. Never change the config to fix an issue unless the user asks; this skill only documents.

## Finish

1. Update the **Last synced** line.
2. Re-check that every ToC anchor still matches its heading.
3. Report what changed in the doc: plugins added or removed, keys changed, new or resolved issues. Say whether the probe ran.
4. If the Neovim section of `key_bindings.md` contradicts the config, mention it (it's listed in §14), but don't edit it unless asked.
