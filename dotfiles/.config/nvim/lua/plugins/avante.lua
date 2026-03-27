return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",
    -- for example
    -- provider = "ollama",
    -- provider = "openai",
    provider = "grok",
    behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = false, -- don't auto-apply code changes; review first (safer)
        auto_approve_tool_permissions = true,
        auto_set_group_name = true,               -- group suggestions by file/context
        -- support_paste_from_clipboard = true,      -- enable pasting images/code into chat
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        -- confirmation_ui_style = "popup",
        minimize_diff = false,
        enable_fastapply = false,  -- ← key one; prevents skipping preview

    },   
    providers = {
            grok = {
                __inherited_from = "openai",
                endpoint = "https://api.x.ai/v1",          -- xAI's base URL
                api_key_name = "XAI_API_KEY",              -- env var name you'll set
                model = "grok-code-fast-1",                       -- or "grok-2", check current models at https://docs.x.ai
                -- model = "grok-beta",                       -- or "grok-2", check current models at https://docs.x.ai
                -- Optional: temperature, max_tokens, etc.
                max_tokens = 8192,
                extra_request_body = {
                    temperature = 0.3,
                }
            },
            openai = {
                endpoint = "https://api.openai.com/v1",
                model = "gpt-4.1-mini",            -- or "gpt-4o-mini", "o1-mini", "o1-preview", etc.
                timeout = 30000,             -- 30 seconds
                max_tokens = 4096,
                ["local"] = false,
                extra_request_body = {
                    temperature = 0.3,
                }
            },      
            claude = {
                endpoint = "https://api.anthropic.com",
                -- model = "claude-sonnet-4-20250514",
                model = "claude-haiku-4-5-20251001",  -- or "claude-haiku-4-5"
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.2,
                    max_tokens = 4096,
                },
                -- disable_tools = { "write_to_file", "edit_file", "replace_in_file" },

            },
            ollama = {
                model = "deepseek-coder-v2:16b",
                endpoint = "http://127.0.0.1:11434",
                -- Critical fix: defer the require
                is_env_set = function()
                    return require("avante.providers.ollama").check_endpoint_alive()
                end,
                -- is_env_set = require("avante.providers.ollama").check_endpoint_alive
                extra_request_body = {
                    temperature = 0.8,
                }
                -- model = "llama3.1:8b",
                -- endpoint = "http://127.0.0.1:11434",
                -- -- Critical fix: defer the require
                -- is_env_set = function()
                --   return require("avante.providers.ollama").check_endpoint_alive()
                -- end,
                -- -- is_env_set = require("avante.providers.ollama").check_endpoint_alive
            },
    },
    web_search_engine = {
      provider = "brave", -- tavily, serpapi, google, kagi, brave, or searxng
      proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    }

  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
