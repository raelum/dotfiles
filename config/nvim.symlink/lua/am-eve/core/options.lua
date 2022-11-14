local opt = vim.opt

-- Enable relative number for quick jumping between lines
opt.relativenumber = true
opt.number = true

-- Make tabs enter 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Don't wrap lines that go off screen
opt.wrap = false

-- Search case insentively unless explicitly typing
-- a capital letter
opt.ignorecase = true
opt.smartcase = true

-- Highlight line cursor is on
opt.cursorline = true
opt.signcolumn = 'yes'

-- Appearance settings
opt.termguicolors = true
opt.background = 'dark' -- make themes prefer dark mode

-- Allow backspacing more (auto-indents, line breaks)
opt.backspace='indent,eol,start'

-- Copy & paste things using system clipboard
opt.clipboard:append('unnamedplus')

-- Split windows similarly to tmux
opt.splitright = true
opt.splitbelow = true

-- Treat words with - in them as 1 word for vim motions
opt.iskeyword:append('-')
