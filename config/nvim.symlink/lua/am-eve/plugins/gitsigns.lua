local present, gitsigns = pcall(require, 'gitsigns')
if not present then
  return
end

gitsigns.setup({
  signcolumn = false,  -- Dedicated column for git signs is bulky
  numhl      = true, -- Highlight numbers with git colors
})

local present, colors = pcall(require, 'gruvbox.palette')
if not present then
  print('Gruvbox palette not found.')
  return
end

-- Customize colors to remove distracting background highlighting
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.bright_green })
vim.api.nvim_set_hl(0, 'gitsignschange', { fg = colors.bright_orange })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.bright_red })

-- Remove cursor line number highlighting and color to not conflict
-- with git colored line numbers
vim.api.nvim_set_hl(0, 'CursorLineNR', { fg = colors.dark4 })
