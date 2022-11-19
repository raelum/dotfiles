local keymap = vim.keymap

vim.g.mapleader = ' '

-- Easier escape shortcuts
--keymap.set('i', 'jk', '<ESC>')
--keymap.set('i', 'kj', '<ESC>')

-- Don't copy to register when deleting a character
--keymap.set('n', 'x', '"_x')

-- Easier save (only writes when there are changes)
keymap.set('n', '<Leader>s', ':update<CR>')
