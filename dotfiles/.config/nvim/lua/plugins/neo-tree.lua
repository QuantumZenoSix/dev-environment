return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here

        close_if_last_window = true,         -- Close Neo-tree if it's the last window
        enable_git_status = true,           -- Show git status (requires Git)
        -- enable_diagnostics = true,          -- Show diagnostics from LSP
        popup_border_style = "rounded",     -- "double", "none", "rounded", "shadow", "single", or "solid"
        default_component_configs = {
            indent = {
            with_markers = true,
            indent_size = 2,
            padding = 1,
            },
            git_status = {
            symbols = {
                added = "✚",
                modified = "",
                deleted = "✖",
                renamed = "",
                untracked = "",
                ignored = "",
                unstaged = "",
                staged = "",
                conflict = "",
            },
            },
        },

        filesystem = {
            follow_current_file = { enabled = true }, -- Sync with the file you're editing
            hijack_netrw_behavior = "open_default",   -- Replace netrw
            use_libuv_file_watcher = true,            -- Fast file system watching
            filtered_items = {
            visible = true,        -- Set to true to show hidden files by default
            hide_dotfiles = false,
            hide_gitignored = true,
            },
        },

        buffers = {
            follow_current_file = { enabled = true },
            show_unloaded = true,
        },

        window = {
            position = "left",       -- "left", "right", "top", "bottom"
            width = 30,
            mappings = {
            ["<space>"] = "toggle_node",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["C"] = "close_node",
            ["R"] = "refresh",
            ["a"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["q"] = "close_window",
            },
        },

  },
}
