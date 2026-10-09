# Jellyfin requires dotnet
export DOTNET_ROOT="/data/data/com.termux/files/usr/lib/dotnet"

# Print url to local jellyfin server
jellyfin-url() {
    local ip
    ip=$(ifconfig 2>/dev/null | awk '/inet / && !/127\.0\.0\.1/ {print $2}' | head -n 1)
    echo "========================================="
    echo " Local:   http://localhost:8096"
    if [ -n "$ip" ]; then
        echo " Network: http://${ip}:8096"
    else
        echo " Network: Not connected to Wi-Fi"
    fi
    echo "========================================="
}

# Automatically acquire wake lock and attach to tmux on startup
if [ -z "$TMUX" ] && [[ $- == *i* ]]; then
    command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock
    tmux attach 2>/dev/null || tmux new-session
fi
