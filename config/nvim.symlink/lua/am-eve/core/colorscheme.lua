local status, tokyonight = pcall(require, "tokyonight")
if not status then
  return
end

tokyonight.setup({
  style = "night",
})
vim.cmd[[colorscheme tokyonight]]
