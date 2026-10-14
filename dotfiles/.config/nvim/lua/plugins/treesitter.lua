-- nvim-treesitter `main` branch: it only installs parsers/queries.
-- Highlighting/indent are switched on per buffer via the FileType autocmd below.
-- Requires the `tree-sitter` CLI (0.26.1+) and a C compiler on PATH.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,                 -- main branch does not support lazy-loading
    -- Pinned: last commit supporting Nvim 0.11 (c82bf96f "drop support for Nvim 0.11" uses
    -- the 0.12-only vim.list.unique, which silently breaks install()). Unpin after upgrading to 0.12+.
    -- commit = "90cd6580e720caedacb91fdd587b747a6e77d61f",
    build = ":TSUpdate",
    config = function()
        -- Installs missing parsers in the background (no-op for ones already installed)
        require("nvim-treesitter").install({
            "c", "cpp", "perl", "python", "ruby", "go", "gomod", "gosum", "sql",
            "javascript", "typescript", "tsx", "jsdoc", "rust", "bash", "lua", "luadoc",
            "html", "css", "powershell", "zig",
            "json", "yaml", "toml", "markdown", "markdown_inline", "vim", "vimdoc", "query", "regex",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                -- Highlighting (provided by Neovim) - skip filetypes with no installed parser
                if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
                    return
                end
                -- Indentation (provided by nvim-treesitter) - only if the language has indent queries
                if vim.treesitter.query.get(lang, "indents") then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
  },
}
