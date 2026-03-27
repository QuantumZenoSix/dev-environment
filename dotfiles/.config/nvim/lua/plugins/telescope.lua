return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions') -- Import actions module
      local action_state = require('telescope.actions.state') -- Import action_state for focus_preview

      -- Custom action to focus the preview window
      local function focus_preview(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        if picker.preview_win then
          vim.api.nvim_set_current_win(picker.preview_win)
        end
      end

      telescope.setup {
        defaults = {
          -- Global settings for all pickers
          sorting_strategy = "ascending", -- This moves the selected match to the top
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.65 },
          },
          --mappings = {
            --i = { -- Insert mode mappings
              --["<C-p>"] = focus_preview, -- Focus preview window
              --["<C-e>"] = actions.preview_scrolling_down,
              --["<C-y>"] = actions.preview_scrolling_up,
              ---- Map mouse wheel up/down to preview scrolling
              --["<ScrollWheelUp>"] = actions.preview_scrolling_up,
              --["<ScrollWheelDown>"] = actions.preview_scrolling_down,
            --},
            --n = { -- Normal mode mappings
              --["<C-p>"] = focus_preview, -- Focus preview window
              --["<C-e>"] = actions.preview_scrolling_down,
              --["<C-y>"] = actions.preview_scrolling_up,
              --["<ScrollWheelUp>"] = actions.preview_scrolling_up,
              --["<ScrollWheelDown>"] = actions.preview_scrolling_down,
            --},
          --},
        },
        --pickers = {
          --live_grep = {
            --theme = 'cursor', -- Apply dropdown theme to live_grep
            --layout_config = {
              --height = 0.7, -- Adjust height for dropdown theme
            --},
          --},
        --},
      }

      local builtin = require('telescope.builtin')
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
}
