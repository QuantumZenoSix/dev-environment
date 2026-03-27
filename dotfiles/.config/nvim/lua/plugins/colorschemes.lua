return {
    {'cesaralvarod/tokyogogh.nvim'},
    {'shrikecode/kyotonight.vim'},
    {'miikanissi/modus-themes.nvim'},
    {'lunacookies/vim-substrata'},
    {'diegoulloao/neofusion.nvim'},
    {'olivercederborg/poimandres.nvim'},
    {"ntk148v/komau.vim"},
    {'shaunsingh/nord.nvim'},
    {'thedenisnikulin/vim-cyberpunk'},
    {'nyoom-engineering/oxocarbon.nvim'},
    {'QuantumZenoSix/gothic-cyberpunk.vim'},
    {
        'maxmx03/fluoromachine.nvim',
        lazy = false,
        priority = 1000,
        config = function ()
         local fm = require 'fluoromachine'

         fm.setup {
            glow = true,
            brightness = 0.0275,
            theme = 'fluoromachine',
            -- theme = 'retrowave',
            transparent = false,
            overrides = {
                -- ['@type'] = { italic = true, bold = false },
                ['@function'] = { italic = true, bold = false },
                ['@comment'] = { italic = true },
                -- ['@keyword'] = { italic = false },
                -- ['@constant'] = { italic = false, bold = false },
                -- ['@variable'] = { italic = true },
                -- ['@field'] = { italic = true },
                -- ['@parameter'] = { italic = true },
            },
            colors = function(_, color)
                local darken = color.darken
                local lighten = color.lighten
                local blend = color.blend
                local shade = color.shade
                local tint = color.tint
                return {
                -- bg = '#200933', -- default
                bg = darken('#200933', 25),
                bgdark = darken('#200933', 35),
                -- cyan = '#49eaff',
                -- red = '#ff1e34',
                -- yellow = '#ffe756',
                -- orange = '#f38e21',
                -- pink = '#ffadff',
                -- purple = '#9544f7',
            }
            end,
         }

         -- vim.cmd.colorscheme 'fluoromachine'
        end
    }

    -- Configure LazyVim to use Zaibatsu
    -- {
    --     "LazyVim/LazyVim",
    --     opts = {
    --         colorscheme = "zaibatsu",
    --     },
    -- },



-- {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     opts = {
--     },
--     priority = 1000  -- Ensure it loads first
-- },
--    {
--      "LazyVim/LazyVim",
--      opts = {
--        colorscheme = "tokyonight-storm",
--      }
--    },
  --   {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --   end
  -- }
}



--    {
--      "LazyVim/LazyVim",
--      opts = {
--        colorscheme = "tokyonight-moon",
--      }
--    },
--    {
--      "LazyVim/LazyVim",
--      opts = {
--        colorscheme = "tokyonight-night",
--      }
--    },
-- CYBERDREAM


--  {
--    "scottmckendry/cyberdream.nvim",
--    lazy = false,
--    priority = 1000, -- Ensure it loads first
--    config = function()
--      require('cyberdream').setup({
--        -- Enable transparent background
--        transparent = true,
--
--        -- Enable italics comments
--        italic_comments = true,
--
--        -- Replace all fillchars with ' ' for the ultimate clean look
--        hide_fillchars = false,
--
--        -- Modern borderless telescope theme - also applies to fzf-lua
--        borderless_telescope = true,
--
--        -- Set terminal colors used in `:terminal`
--        terminal_colors = true,
--        theme = {
--          variant = "auto",
--          highlights = {
--            -- Highlight groups to override, adding new groups is also possible
--            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values
--
--            -- Example:
--            Comment = { fg = "#696969", bg = "NONE", italic = true },
--
--            -- Complete list can be found in `lua/cyberdream/theme.lua`
--          },
--        }
--      })
--      require('cyberdream').load()
--    end
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "cyberdream"
--    }
--  }


  -- onedark`` 
--  {
--    "navarasu/onedark.nvim",
--    priority = 1000, -- Ensure it loads first
--    config = function()
--      require('onedark').setup {
--        style = 'cool',
--          colors = {
--          bright_orange = "#ff8800",    -- define a new color
--          green = '#00ffaa',            -- redefine an existing color
--        },
--        highlights = {
--          ["@keyword"] = {fg = '$green'},
--          -- ["@string"] = {fg = '$bright_orange', bg = '#00ff00', fmt = 'bold'},
--          ["@function"] = {fg = '#0000ff', sp = '$cyan', fmt = 'underline,italic'},
--          ["@function.builtin"] = {fg = '#0059ff'}
--        },
--        -- Change code style ---
--        -- Options are italic, bold, underline, none
--        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
--        code_style = {
--            comments = 'italic',
--            keywords = 'italic,bold',
--            functions = 'underline',
--            strings = 'none',
--            variables = 'none'
--        },
--      }
--      require('onedark').load()
--    end
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      theme = "onedark"
--    }
--  }


-- Eldritch
--  {
--    "eldritch-theme/eldritch.nvim",
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "eldritch"
--    }
--  },
--
--  -- bluloco
--  {
--    "uloco/bluloco.nvim",
--    dependencies = { 'rktjmp/lush.nvim' },
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "bluloco-dark"
--    }
--  },
--
--  -- darkflat
--  {
--    "sekke276/dark_flat.nvim",
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "dark_flat"
--    }
--  },







-- Other Colorschemes I like
--return {

-- CYBERDREAM


--  {
--    "scottmckendry/cyberdream.nvim",
--    lazy = false,
--    priority = 1000, -- Ensure it loads first
--    config = function()
--      require('cyberdream').setup({
--        -- Enable transparent background
--        transparent = true,
--
--        -- Enable italics comments
--        italic_comments = true,
--
--        -- Replace all fillchars with ' ' for the ultimate clean look
--        hide_fillchars = false,
--
--        -- Modern borderless telescope theme - also applies to fzf-lua
--        borderless_telescope = true,
--
--        -- Set terminal colors used in `:terminal`
--        terminal_colors = true,
--        theme = {
--          variant = "auto",
--          highlights = {
--            -- Highlight groups to override, adding new groups is also possible
--            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values
--
--            -- Example:
--            Comment = { fg = "#696969", bg = "NONE", italic = true },
--
--            -- Complete list can be found in `lua/cyberdream/theme.lua`
--          },
--        }
--      })
--      require('cyberdream').load()
--    end
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "cyberdream"
--    }
--  }


  -- onedark`` 
--  {
--    "navarasu/onedark.nvim",
--    priority = 1000, -- Ensure it loads first
--    config = function()
--      require('onedark').setup {
--        style = 'cool',
--          colors = {
--          bright_orange = "#ff8800",    -- define a new color
--          green = '#00ffaa',            -- redefine an existing color
--        },
--        highlights = {
--          ["@keyword"] = {fg = '$green'},
--          -- ["@string"] = {fg = '$bright_orange', bg = '#00ff00', fmt = 'bold'},
--          ["@function"] = {fg = '#0000ff', sp = '$cyan', fmt = 'underline,italic'},
--          ["@function.builtin"] = {fg = '#0059ff'}
--        },
--        -- Change code style ---
--        -- Options are italic, bold, underline, none
--        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
--        code_style = {
--            comments = 'italic',
--            keywords = 'italic,bold',
--            functions = 'underline',
--            strings = 'none',
--            variables = 'none'
--        },
--      }
--      require('onedark').load()
--    end
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      theme = "onedark"
--    }
--  }


-- Eldritch
--  {
--    "eldritch-theme/eldritch.nvim",
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "eldritch"
--    }
--  },
--
--  -- bluloco
--  {
--    "uloco/bluloco.nvim",
--    dependencies = { 'rktjmp/lush.nvim' },
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "bluloco-dark"
--    }
--  },
--
--  -- darkflat
--  {
--    "sekke276/dark_flat.nvim",
--    priority = 1000, -- Ensure it loads first
--  },
--  {
--    "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "dark_flat"
--    }
--  },
--
--}
