return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    modes = {
        diagnostics = {
          auto_open = false, -- Don't auto-open diagnostics
          auto_close = true, -- Auto-close when no diagnostics
          focus = true, -- Focus the window when opened
        },
        lsp_references = {
          auto_preview = true, -- Preview references in a floating window
        },
      },
      icons = {
        indent = {
          fold_open = "▼",
          fold_closed = "▶",
        },
      },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
}

