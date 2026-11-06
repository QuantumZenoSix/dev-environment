-- Code outline sidebar (symbols from treesitter or LSP)
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  -- Load on file open, not only on <leader>o, so on_attach sets the { / } jumps before the outline is first opened
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      -- Replaces the default paragraph motions in buffers aerial attaches to
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol (Aerial)" })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol (Aerial)" })
    end,
  },
  -- <leader>a is taken by the Claude Code prefix (claudecode.lua)
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle code outline (Aerial)" },
  },
}
