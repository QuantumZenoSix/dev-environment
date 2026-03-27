return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    -- Increase max file length to handle larger files
    max_file_length = 100000, -- Default is 40000; adjust as needed (e.g., 100,000 lines)
    auto_attach = true,
    -- Optimize background loading and updates
    watch_gitdir = {
      follow_files = true, -- Follow file renames/moves
    },
  update_debounce = 800, -- Delay in ms for async updates; tweak for performance (e.g., 200 for slower systems)
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

        -- __________ HUNK ACTIONS ____________

        -- Next Hunk
        vim.keymap.set('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next')
          end
        end, { buffer = buffer, desc = 'Next Hunk' })

        -- Prev Hunk
        vim.keymap.set('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev')
          end
        end, { buffer = buffer, desc = 'Prev Hunk' })

        -- Last Hunk
        vim.keymap.set('n', ']H', function() gs.nav_hunk('last') end, { buffer = buffer, desc = 'Last Hunk' })

        -- First Hunk
        vim.keymap.set('n', '[H', function() gs.nav_hunk('first') end, { buffer = buffer, desc = 'First Hunk' })

        -- Stage Hunk
        vim.keymap.set({'n', 'v'}, '<leader>ghs', ':Gitsigns stage_hunk<CR>', { buffer = buffer, desc = 'Stage Hunk' })

        -- Reset Hunk
        vim.keymap.set({'n', 'v'}, '<leader>ghr', ':Gitsigns reset_hunk<CR>', { buffer = buffer, desc = 'Reset Hunk' })

        -- Undo Stage Hunk
        vim.keymap.set('n', '<leader>ghu', gs.undo_stage_hunk, { buffer = buffer, desc = 'Undo Stage Hunk' })

        -- GitSigns Select Hunk
        vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = buffer, desc = 'GitSigns Select Hunk' })

        -- Preview Hunk Inline
        vim.keymap.set('n', '<leader>ghp', gs.preview_hunk_inline, { buffer = buffer, desc = 'Preview Hunk Inline' })



        -- __________ -- BUFFER ACTIONS AND MORE ___________

        -- Stage Buffer
        vim.keymap.set('n', '<leader>ghS', gs.stage_buffer, { buffer = buffer, desc = 'Stage Buffer' })

        -- Reset Buffer
        vim.keymap.set('n', '<leader>ghR', gs.reset_buffer, { buffer = buffer, desc = 'Reset Buffer' })

        -- Blame Line
        vim.keymap.set('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, { buffer = buffer, desc = 'Blame Line' })

        -- Blame Buffer
        vim.keymap.set('n', '<leader>ghB', function() gs.blame() end, { buffer = buffer, desc = 'Blame Buffer' })

        -- Diff This
        vim.keymap.set('n', '<leader>ghD', gs.diffthis, { buffer = buffer, desc = 'Diff This' })

        -- Diff This hunk
        vim.keymap.set('n', '<leader>ghd', function() gs.diffthis('~') end, { buffer = buffer, desc = 'Diff This ~' })
    end,
  },
}


