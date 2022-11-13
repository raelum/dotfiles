# My dot files :)

## Installation
First, we need to install the following:

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
ln -s ~/code/dotfiles/p10k.zsh.symlink ~/.p10k.zsh
ln -s ~/code/dotfiles/tmux.conf.symlink ~/.tmux.conf
```

Inspiration from https://github.com/holman/dotfiles


To find out what packages I installed in brew (not dependencies):
brew leaves
