local present, builtin = pcall(require, 'telescope.builtin')
if not present then
  return
end

-- Search files
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>o', builtin.find_files, {})

-- Grep current file
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Search buffers
vim.keymap.set('n', '<leader><space>', builtin.buffers, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

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
