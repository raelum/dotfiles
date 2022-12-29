local status, gruvbox = pcall(require, "gruvbox")
if not status then
    return
end

gruvbox.setup({
    contrast = "hard",
    bold = true
})
vim.cmd[[colorscheme gruvbox]]
