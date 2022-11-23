local opt = vim.opt

-- Enable relative number for quick jumping between lines
opt.relativenumber = true
opt.number = true

-- Make tabs enter 2 spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Highlight all columns past max code length
codelength = 80
range = {}
for i=codelength, 999 do
  range[i-codelength] = i
end
opt.colorcolumn = table.concat(range, ',')

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

-- Make status line global when there are splits in nvim
vim.o.ls = 3

-- Allow backspacing more (auto-indents, line breaks)
opt.backspace='indent,eol,start'

-- Copy & paste things using system clipboard
opt.clipboard:append('unnamedplus')

-- Split windows similarly to tmux
opt.splitright = true
opt.splitbelow = true

-- Treat words with - in them as 1 word for vim motions
opt.iskeyword:append('-')
