# My dot files :)

## Installation
First, we need to install the following:

JetBrains Nerd Font
```
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

Oh My Zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

PowerLevel10k
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Install tmux package manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
After syncing tmux.conf, source it with `tmux source-file ~/.tmux.conf`. Then press shift + I to install all plugins in config.

After that, we symlink the files in this repo to the HOME directory. The commands assume the repo is in ~/code/dotfiles.
```
ln -s ~/code/dotfiles/zshrc.symlink ~/.zshrc
ln -s ~/code/dotfiles/zsh_plugins.txt.symlink ~/.zsh_plugins.txt
ln -s ~/code/dotfiles/p10k.zsh.symlink ~/.p10k.zsh
ln -s ~/code/dotfiles/tmux.conf.symlink ~/.tmux.conf
ln -s ~/code/dotfiles/config/nvim.symlink ~/.config/nvim
```

Inspiration from:
- https://github.com/holman/dotfiles
- https://github.com/nvim-lua/kickstart.nvim

To find out what packages I installed in brew (not dependencies):
brew leaves

NVIM TODO
- file explorer
- tabs
- easy readme preview
- https://github.com/folke/which-key.nvim
- create a git submodule for nvim configuration
- see if there is a way to auto reload nvim after updating config?

SHELL TODO
- install a zsh plugin manager
- bootstrap tpm and it's packages when running tmux for the first time

FAR FUTURE
- lazy loading
