#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Dotfiles Installer for Termux
# Re-links configs and bootstraps TPM + persistence fixes
# ==============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "==> Setting up symlinks from $DOTFILES_DIR to $HOME..."

# 1. Tmux
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo "    Linked ~/.tmux.conf"

# 2. Neovim
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    # Back up if there are any non-symlink files, otherwise remove old directory
    non_symlinks=$(find "$HOME/.config/nvim" -maxdepth 1 -type f ! -type l 2>/dev/null || true)
    if [ -n "$non_symlinks" ]; then
        BACKUP="$HOME/.config/nvim.backup.$(date +%s)"
        mv "$HOME/.config/nvim" "$BACKUP"
        echo "    Backed up existing ~/.config/nvim to $BACKUP"
    else
        rm -rf "$HOME/.config/nvim"
    fi
fi
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
echo "    Linked ~/.config/nvim -> $DOTFILES_DIR/nvim"

# 3. Bashrc
if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%s)"
    echo "    Backed up existing ~/.bashrc"
fi
ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
echo "    Linked ~/.bashrc"

# 4. Termux Properties
if [ -f "$DOTFILES_DIR/termux/termux.properties" ]; then
    mkdir -p "$HOME/.termux"
    ln -sf "$DOTFILES_DIR/termux/termux.properties" "$HOME/.termux/termux.properties"
    echo "    Linked ~/.termux/termux.properties"
    command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true
fi

# 5. Antigravity Skills
if [ -d "$DOTFILES_DIR/antigravity/skills" ]; then
    mkdir -p "$HOME/.gemini/config"
    if [ -d "$HOME/.gemini/config/skills" ] && [ ! -L "$HOME/.gemini/config/skills" ]; then
        BACKUP="$HOME/.gemini/config/skills.backup.$(date +%s)"
        mv "$HOME/.gemini/config/skills" "$BACKUP"
        echo "    Backed up existing ~/.gemini/config/skills to $BACKUP"
    fi
    ln -sfn "$DOTFILES_DIR/antigravity/skills" "$HOME/.gemini/config/skills"
    echo "    Linked ~/.gemini/config/skills -> $DOTFILES_DIR/antigravity/skills"
fi

# 6. Antigravity CLI Configuration
if [ -f "$DOTFILES_DIR/antigravity/settings.json" ]; then
    mkdir -p "$HOME/.gemini/antigravity-cli"
    if [ -f "$HOME/.gemini/antigravity-cli/settings.json" ] && [ ! -L "$HOME/.gemini/antigravity-cli/settings.json" ]; then
        BACKUP="$HOME/.gemini/antigravity-cli/settings.json.backup.$(date +%s)"
        mv "$HOME/.gemini/antigravity-cli/settings.json" "$BACKUP"
        echo "    Backed up existing ~/.gemini/antigravity-cli/settings.json to $BACKUP"
    fi
    ln -sf "$DOTFILES_DIR/antigravity/settings.json" "$HOME/.gemini/antigravity-cli/settings.json"
    echo "    Linked ~/.gemini/antigravity-cli/settings.json -> $DOTFILES_DIR/antigravity/settings.json"
fi

# ==============================================================================
# Tmux Plugins
# ==============================================================================
echo "==> Checking Tmux Plugin Manager (TPM)..."
if [ ! -d "$TPM_DIR" ]; then
    echo "    Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

if command -v termux-fix-shebang >/dev/null 2>&1; then
    echo "==> Fixing TPM script shebangs for Termux..."
    termux-fix-shebang "$TPM_DIR/bin/"* "$TPM_DIR/scripts/"* "$TPM_DIR/tpm" 2>/dev/null || true
fi

# Plugins are listed in tmux.conf
echo "==> Installing Tmux plugins..."
"$TPM_DIR/bin/install_plugins"

echo "==> Applying Termux-specific fixes to Tmux plugins..."
if command -v termux-fix-shebang >/dev/null 2>&1; then
    find "$HOME/.tmux/plugins" -type f -exec termux-fix-shebang {} + 2>/dev/null || true
fi

# Fix /tmp permission bug in tmux-continuum
CONTINUUM_SAVE="$HOME/.tmux/plugins/tmux-continuum/scripts/continuum_save.sh"
if [ -f "$CONTINUUM_SAVE" ]; then
    sed -i 's|/tmp/tmux-continuum-|${TMPDIR:-/data/data/com.termux/files/usr/tmp}/tmux-continuum-|g' "$CONTINUUM_SAVE"
    echo "    Patched tmux-continuum lock directory path."
fi

# ==============================================================================
# Neovim Plugins
# ==============================================================================
echo "==> Syncing Neovim plugins via lazy.nvim..."
nvim --headless "+Lazy! sync" +qa

# ==============================================================================
# Agent Skills Dependencies
# ==============================================================================
if [ -f "$DOTFILES_DIR/antigravity/skills/requirements.txt" ] && command -v pip >/dev/null 2>&1; then
    echo "==> Installing Python dependencies for agent skills..."
    pip install -q -r "$DOTFILES_DIR/antigravity/skills/requirements.txt" || echo "    Warning: Some Python dependencies failed to install."
fi

echo "==> All dotfiles installed successfully!"
