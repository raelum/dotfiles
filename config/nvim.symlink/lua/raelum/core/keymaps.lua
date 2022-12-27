local keymap = vim.keymap

vim.g.mapleader = ' '

-- Clear highlighting when pressing escape in normal mode
keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Write file shortcut (uses update so only writes when there are changes)
keymap.set('n', '<Leader>w', ':update<CR>')

-- Save and quit shorcut (uses update like above)
keymap.set('n', '<Leader>q', ':update<CR>:q<CR>')

-- Force quit without saving
keymap.set('n', '<Leader>Q', ':q!<CR>')

-- Tab navigation
keymap.set('n', '<Leader>t', ':tabnext<CR>')
keymap.set('n', '<Leader>T', ':tabprevious<CR>')

-- Window splits (similar to tmux mappings)
keymap.set('n', '<Leader>\\', ':vsplit<CR>')
keymap.set('n', '<Leader>-', ':split<CR>')

-- Easier navigation to beginning and end of line
keymap.set('n', '<S-h>', '^')
keymap.set('n', '<S-l>', '$')

-- Easier navigation when scrolling up and down code
keymap.set('n', '<S-j>', '10j')
keymap.set('n', '<S-k>', '10k')

-- Center view when searching
keymap.set('n', 'n', 'nzz')
keymap.set('n', 'N', 'Nzz')
keymap.set('n', '*', '*zz')
keymap.set('n', '#', '#zz')

-- Better paste with auto-formatting
keymap.set('n', 'p', 'p`[v`]=')
keymap.set('n', 'P', 'P`[v`]=')

-- More natural redo command since most other commands capitalize to go in
-- opposite direction. Default 'U' command is useless anyways.
keymap.set('n', 'U', '<C-r>')
