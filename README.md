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

After that, we symlink the files in this repo to the HOME directory. The commands assume the repo is in ~/code/dotfiles.
```
ln -s ~/code/dotfiles/zshrc.symlink ~/.zshrc
ln -s ~/code/dotfiles/p10k.zsh.symlink ~/.p10k.zsh
```

Inspiration from https://github.com/holman/dotfiles
