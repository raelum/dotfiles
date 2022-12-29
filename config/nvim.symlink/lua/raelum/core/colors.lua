--[[
Color adjustment for generic features that don't belong to any plugin.
Color adjustments for specific plugins will belong to that plugin's config file.

Pallete file:
https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox/palette.lua

Colors visualization:
https://github.com/gruvbox-community/gruvbox
--]]
local present, colors = pcall(require, 'gruvbox.palette')
if not present then
    return
end

-- Customize color of max code length highlight to differentiate it from
-- current line highlight and lua line color.
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.dark0 })
