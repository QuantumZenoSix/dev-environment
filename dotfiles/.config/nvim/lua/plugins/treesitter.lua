return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,               -- use :main / latest commits
    build = ":TSUpdate",
    config = function()
        -- Ensure nvim-treesitter install dir is in runtimepath (fixes parsers not loading)
        vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/site')
        require("nvim-treesitter.config").setup({
            -- Install parsers into the plugin dir (lazy.nvim adds this to runtimepath automatically)
            -- parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser",

            ensure_installed = { "lua", "python", "javascript", "c", "cpp", "java", "html", "css", "perl" },
            sync_install = false,
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
              },
            },
        })
    end,
  },
}
