local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Automatically load plugins when updating this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost install.lua source <afile> | PackerSync
  augroup end
]])

-- Import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

-- List of plugins to install
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Color theme
  use 'ellisonleao/gruvbox.nvim'

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Show git diff markers
  use 'lewis6991/gitsigns.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Better 'jk' escape without blocking on 'j'
  use 'max397574/better-escape.nvim'

  -- Easier commenting
  use 'numToStr/Comment.nvim'

  -- Autocomplete braces pair
  use 'windwp/nvim-autopairs'

  -- Add indentation guidelines
  use 'lukas-reineke/indent-blankline.nvim'

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
