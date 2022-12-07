local keymap = vim.keymap

vim.g.mapleader = ' '

-- Easier escape shortcuts
keymap.set('i', 'jk', '<ESC>')
keymap.set('i', 'kj', '<ESC>')

-- Don't copy to register when deleting a character
--keymap.set('n', 'x', '"_x')

-- Clear highlighting when pressing escape in normal mode
keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Easier save (only writes when there are changes)
keymap.set('n', '<Leader>s', ':update<CR>')
keymap.set('n', '<Leader>w', ':update<CR>')

keymap.set('n', '<Leader>t', ':tabnext<CR>')
keymap.set('n', '<Leader>T', ':tabprevious<CR>')
