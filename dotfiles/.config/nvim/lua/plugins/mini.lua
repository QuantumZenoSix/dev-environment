return {
    { 'echasnovski/mini.diff', version = '*' },
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            -- Configure mini.move
            require("mini.move").setup({
                mappings = {
                    comment = "gc",
                    comment_line = "gcc",
                    textobject = "gc",
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = '<C-Left>',
                    right = '<C-Right>',
                    down = '<C-Down>',
                    up = '<C-Up>',

                    -- Move current line in Normal mode
                    line_left = '<C-Left>',
                    line_right = '<C-Right>',
                    line_down = '<C-Down>',
                    line_up = '<C-Up>',
                },
                  options = {
                    -- Automatically reindent selection during linewise vertical move
                    reindent_linewise = true,
              },
            })

            -- Configure mini.cursorword
            require("mini.cursorword").setup({
            })
        end,
    },
}
-- return { 'echasnovski/mini.move', version = '*' }

