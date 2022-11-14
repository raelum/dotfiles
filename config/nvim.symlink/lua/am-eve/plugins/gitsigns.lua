local present, gitsigns = pcall(require, 'gitsigns')
if not present then
  return
end

gitsigns.setup({
  signcolumn = true,  -- Highlight changes in dedicated sign colums
  numhl      = false, -- Highlight numbers with git colors
})

local present, colors = pcall(require, 'gruvbox.palette')
if not present then
  return
end

-- Customize colors to remove distracting background highlighting
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.bright_green })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.bright_orange })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.bright_red })

-- Remove cursor line number color & sign column highliting to not conflict
-- visually with git signs
vim.api.nvim_set_hl(0, 'CursorLineNR', { fg = colors.dark4, bg = colors.dark1 })
vim.api.nvim_set_hl(0, 'SignColumn', {})
