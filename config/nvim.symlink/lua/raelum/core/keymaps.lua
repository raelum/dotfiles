local keymap = vim.keymap

vim.g.mapleader = ' '

-- Clear highlighting when pressing escape in normal mode
keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Write file shortcut (uses update so only writes when there are changes)
keymap.set('n', '<Leader>w', ':update<CR>')

-- Tab navigation
keymap.set('n', '<Leader>t', ':tabnext<CR>')
keymap.set('n', '<Leader>T', ':tabprevious<CR>')

-- Center view when searching
keymap.set('n', 'n', 'nzz')
keymap.set('n', 'N', 'Nzz')
keymap.set('n', '*', '*zz')
keymap.set('n', '#', '#zz')

-- Center view when scrolling through code
keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')

-- Better paste with auto-formatting
keymap.set('n', 'p', 'p`[v`]=')
keymap.set('n', 'P', 'P`[v`]=')

-- More natural redo command since most other commands capitalize to go in
-- opposite direction. Default 'U' command is useless anyways.
keymap.set('n', 'U', '<C-r>')
