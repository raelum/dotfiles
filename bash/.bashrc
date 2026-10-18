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

# Update max phantom processes via rish and attach to tmux on startup
if [[ -z $TMUX && $- == *i* ]]; then
    if ! rish -c 'device_config put activity_manager max_phantom_processes 2147483647' >/dev/null 2>&1; then
        echo -e "\033[1;31m[!] Shizuku is not running; aborting tmux to protect background processes.\033[0m"
        echo -e "\033[0;33m    Start Shizuku, then run 'exec bash' to retry.\033[0m"
        return 1 2>/dev/null || true
    fi
    tmux new-session -A
fi
