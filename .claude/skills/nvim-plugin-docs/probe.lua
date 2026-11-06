-- Headless snapshot of the live Neovim config, used to verify nvim_plugins.md against reality.
-- Run from the repo root (see SKILL.md for the exact command). Writes a plain-text report to $PROBE_OUT.
--
-- What it does: fires VeryLazy (headless Neovim has no UIEnter, so VeryLazy plugins otherwise never load),
-- opens a real file so buffer-local maps (LSP, gitsigns) attach, waits, then dumps:
--   plugins and whether lazy.nvim loaded them, mini.* modules that were set up, user commands,
--   every global + buffer-local keymap that has a desc, and a few state checks the doc relies on.

local out_path = vim.env.PROBE_OUT
if not out_path or out_path == "" then
  io.stderr:write("probe.lua: set PROBE_OUT to the report path\n")
  vim.cmd("cquit 1")
end

-- Default to the repo copy: it's inside a git work tree (so gitsigns attaches) and is a Lua file (so lua_ls attaches).
-- The deployed ~/.config/nvim copy is a Nix-store symlink outside any repo, so gitsigns would skip it.
local repo_keymaps = "dotfiles/.config/nvim/lua/config/keymaps.lua"
local target_file = vim.env.PROBE_FILE
  or (vim.fn.filereadable(repo_keymaps) == 1 and repo_keymaps)
  or (vim.fn.stdpath("config") .. "/lua/config/keymaps.lua")
local attach_wait_ms = tonumber(vim.env.PROBE_WAIT_MS) or 3000
local lines = {}

local function section(title)
  table.insert(lines, "")
  table.insert(lines, "## " .. title)
end

local function add(text)
  table.insert(lines, text)
end

local function dump_keymaps(maps, scope)
  table.sort(maps, function(a, b) return a.lhs < b.lhs end)
  for _, map in ipairs(maps) do
    -- which-key registers its own trigger maps (marks, registers, spelling) - not part of this config
    local is_which_key_trigger = map.desc and map.desc:match("^which%-key%-trigger")
    if map.desc and map.desc ~= "" and not is_which_key_trigger then
      local lhs = map.lhsraw and vim.fn.keytrans(map.lhsraw) or map.lhs
      add(string.format("%-6s %-4s %-22s %s", scope, map.mode, lhs, map.desc))
    end
  end
end

local function collect(modes, getter)
  local all = {}
  for _, mode in ipairs(modes) do
    for _, map in ipairs(getter(mode)) do
      map.mode = mode
      table.insert(all, map)
    end
  end
  return all
end

local function write_report()
  section("Plugins (lazy.nvim)")
  for _, plugin in ipairs(require("lazy").plugins()) do
    add(string.format("%-32s %s", plugin.name, plugin._.loaded and "loaded" or "not loaded"))
  end

  section("mini.* modules set up (global exists)")
  for _, name in ipairs({ "MiniAi", "MiniComment", "MiniDiff", "MiniMove", "MiniCursorword", "MiniPairs" }) do
    add(string.format("%-16s %s", name, _G[name] ~= nil and "yes" or "no"))
  end

  section("State checks")
  add("colorscheme           " .. tostring(vim.g.colors_name))
  add("statuscolumn          " .. vim.o.statuscolumn)
  local ok_ts, telescope = pcall(require, "telescope")
  add("telescope extensions  " .. (ok_ts and vim.inspect(vim.tbl_keys(telescope.extensions)) or "telescope missing"))
  add("GBrowse handlers      " .. tostring(#(vim.g.fugitive_browse_handlers or {})))
  local ok_gs, gs_config = pcall(require, "gitsigns.config")
  add("gitsigns max_file_len " .. (ok_gs and tostring(gs_config.config.max_file_length) or "n/a"))
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  add("LSP clients on probe  " .. vim.inspect(vim.tbl_map(function(c) return c.name end, clients)))

  section("User commands")
  local commands = vim.tbl_keys(vim.api.nvim_get_commands({}))
  table.sort(commands)
  add(table.concat(commands, " "))

  section("Global keymaps with desc")
  dump_keymaps(collect({ "n", "x", "o", "i", "c", "v" }, vim.api.nvim_get_keymap), "global")

  section("Buffer-local keymaps with desc (" .. vim.fn.expand("%:~:.") .. ")")
  dump_keymaps(collect({ "n", "x", "o", "i", "v" }, function(mode)
    return vim.api.nvim_buf_get_keymap(0, mode)
  end), "buffer")

  vim.fn.writefile(lines, out_path)
end

vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
vim.cmd.edit(vim.fn.fnameescape(target_file))
vim.defer_fn(function()
  local ok, err = pcall(write_report)
  if not ok then
    vim.fn.writefile({ "probe.lua failed: " .. tostring(err) }, out_path)
  end
  vim.cmd("qa!")
end, attach_wait_ms)
