local keymap = vim.keymap

-- Set leader key to <space>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable default spacebar action
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlighting when pressing escape in normal mode
keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Write file shortcut (uses update so only writes when there are changes)
keymap.set('n', '<Leader>w', ':update<CR>')

-- Force write (maybe to trigger a file watching command)
keymap.set('n', '<Leader>W', ':write<CR>')

-- Save and quit shorcut (uses update like above)
keymap.set('n', '<Leader>q', ':update<CR>:q<CR>')

-- Force quit without saving
keymap.set('n', '<Leader>Q', ':q!<CR>')

-- Navigate to last buffer
keymap.set('n', '<Leader>l', '<C-^>')

-- Tab navigation
keymap.set('n', '<Leader>t', ':tabnext<CR>')
keymap.set('n', '<Leader>T', ':tabprevious<CR>')

-- Window splits (similar to tmux mappings)
keymap.set('n', '<Leader>\\', ':vsplit<CR>')
keymap.set('n', '<Leader>-', ':split<CR>')

-- Enable navigation shortcuts in normal, visual, and operation pending mode
-- Can press c then shift+L to change until the end of the line
local navigation_modes = {'n', 'v', 'o'}

-- Easier navigation to beginning and end of line
keymap.set(navigation_modes, 'gh', '^')
keymap.set(navigation_modes, 'gl', '$')

-- Easier navigation when scrolling up and down code
keymap.set(navigation_modes, '<S-j>', '10j')
keymap.set(navigation_modes, '<S-k>', '10k')

-- Better paste with auto-formatting
keymap.set('n', 'p', 'p`[v`]=')
keymap.set('n', 'P', 'P`[v`]=')

-- More natural redo command since most other commands capitalize to go in
-- opposite direction. Default 'U' command is useless anyways.
keymap.set('n', 'U', '<C-r>')
