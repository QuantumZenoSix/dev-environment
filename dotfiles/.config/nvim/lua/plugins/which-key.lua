-- which-key v3 picks up every keymap that has a `desc` (config/keymaps.lua, plugin `keys`, LSP/gitsigns
-- buffer-local maps), so keymaps don't need to be re-declared here - only the group names for prefixes.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    triggers = {}, -- Disable automatic popup; open it on demand with <leader>?
    spec = {
      { "<leader>", group = "Leader" },
      { "g", group = "Goto / LSP" },
      { "z", group = "Folds / View" },
      { "[", group = "Previous" },
      { "]", group = "Next" },
      { "<leader>a", group = "AI (Claude) / Append" },
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Change / Code action" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>D", group = "Debug (DAP)" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>F", group = "Files" },
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Git hunks" },
      { "<leader>i", group = "Indent guides" },
      { "<leader>l", group = "LSP / Lint / Line numbers" },
      { "<leader>r", group = "Rename / Remove" },
      { "<leader>t", group = "Trouble / Toggle" },
      { "<leader>w", group = "Workspace" },
      { "<leader><down>", group = "Scroll down" },
      { "<leader><up>", group = "Scroll up" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ keys = "<leader>" })
      end,
      desc = "Leader keymaps (which-key)",
    },
    {
      "<leader>/",
      function()
        require("which-key").show()
      end,
      desc = "All keymaps (which-key)",
    },
  },
}
