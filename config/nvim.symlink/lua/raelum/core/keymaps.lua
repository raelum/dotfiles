local keymap = vim.keymap

vim.g.mapleader = ' '

-- Clear highlighting when pressing escape in normal mode
keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Write file shortcut (uses update so only writes when there are changes)
keymap.set('n', '<Leader>w', ':update<CR>')

keymap.set('n', '<Leader>t', ':tabnext<CR>')
keymap.set('n', '<Leader>T', ':tabprevious<CR>')
