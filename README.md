# My dot files :)

## Installation
First, we need to install the following:

JetBrains Nerd Font
```
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

Install tmux package manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
After syncing tmux.conf, source it with `tmux source-file ~/.tmux.conf`. Then press Leader + Shift + I to install all plugins in config.

After that, we symlink the files in this repo to the HOME directory. The commands assume the repo is in ~/code/dotfiles.
```
ln -s ~/code/dotfiles/zshrc.symlink ~/.zshrc
ln -s ~/code/dotfiles/zsh_plugins.txt.symlink ~/.zsh_plugins.txt

ln -s ~/code/dotfiles/config/nvim.symlink ~/.config/nvim
ln -s ~/code/dotfiles/config/tmux.symlink ~/.config/tmux
ln -s ~/code/dotfiles/config/alacritty.symlink ~/.config/alacritty
ln -s ~/code/dotfiles/config/fish.symlink ~/.config/fish
ln -s ~/code/dotfiles/hushlogin.symlink ~/.hushlogin
```

Inspiration from:
- https://github.com/holman/dotfiles
- https://github.com/nvim-lua/kickstart.nvim
- https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26710166#26710166

To find out what packages I installed in brew (not dependencies):
brew leaves

NVIM TODO
- file explorer
- tabs
- easy readme preview
- https://github.com/folke/which-key.nvim
- create a git submodule for nvim configuration
- see if there is a way to auto reload nvim after updating config?
    - Create session: https://vi.stackexchange.com/questions/22897/how-to-get-the-previous-session-every-time-i-start-vim
    - Run script after exiting nvim to restart nvim: https://stackoverflow.com/questions/20386219/automatically-run-script-when-exiting-vim

SHELL TODO
- install a zsh plugin manager
- bootstrap tpm and it's packages when running tmux for the first time

FAR FUTURE
- lazy loading
