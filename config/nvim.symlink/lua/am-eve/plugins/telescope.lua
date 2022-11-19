local present, builtin = pcall(require, 'telescope.builtin')
if not present then
  return
end

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local present, telescope = pcall(require, 'telescope')
if not present then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        -- Similar to tmux mappings
        ['<C-_>'] = 'select_horizontal',
        ["<C-Bslash>"] = 'select_vertical',
      },
      n = {
        -- Similar to tmux mappings
        ['<C-_>'] = 'select_horizontal',
        ["<C-Bslash>"] = 'select_vertical',
      }
    }
  }
})
