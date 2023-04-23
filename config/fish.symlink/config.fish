# Load homebrew commands
fish_add_path /opt/homebrew/bin

# Set default editor.
# Use Alt+E to open current command in editor.
set -gx EDITOR nvim

# Setup tools
starship init fish | source
zoxide init fish | source

# Modern tooling aliases
alias cd z
alias ls lsd
alias cat bat
alias vim nvim

# Set up vim mode cursors
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
