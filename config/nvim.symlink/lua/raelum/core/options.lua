local opt = vim.opt

-- Enable relative number for quick jumping between lines
opt.relativenumber = true
opt.number = true

-- Make tabs enter 4 spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Highlight all columns past max code length
codelength = 80
range = {}
for i=codelength, 999 do
    range[i-codelength] = i
end
opt.colorcolumn = table.concat(range, ',')

-- Turn off scrolling
opt.scrolloff = 9999

-- Don't wrap lines that go off screen
opt.wrap = false

-- Search case insentively unless explicitly typing a capital letter
opt.ignorecase = true
opt.smartcase = true

-- Turn off highlighting when searching
vim.o.hlsearch = false

-- Briefly highlight yanked text to provide visual feedback
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Display hidden characters
vim.opt.list = true
vim.opt.listchars:append "lead:⋅" -- leading spaces
vim.opt.listchars:append "trail:⋅" -- trailing spaces

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

-- Save backup copies (this also limits nvim to 1 write instead of 2 which is
-- useful when using entr to watch file changes and run command)
opt.backupcopy = 'yes'

-- Save undo history so it can persist across sessions
vim.o.undofile = true

-- Remove '~' sign after the end of buffer
opt.fillchars:append { eob = " " }
