-- Ensure ~/.config/nvim-minimal/ is in runtimepath
vim.opt.runtimepath:prepend(vim.fn.stdpath('config'))

vim.g.mapleader = " "  -- Sets <Space> as the leader key

-- Load the lazy.nvim plugin manager (this will also load plugin configurations from plugins/)
-- require('config.lazy')
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin configurations from the plugins/ directory
require('lazy').setup('plugins')

-- Load your plugins

-- Now that lazy.lua is loaded and everything in plugins/ we need to load everything else in config/
-- Keymaps/options should usually be loaded after all plugins, so lets add these now
require('config.autocmds')      -- Load key mappings
require('config.keymaps')      -- Load key mappings
require('config.options')      -- Load Neovim options



