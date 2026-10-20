#!/bin/sh

MODE=$(tmux show-option -gv window-size 2>/dev/null)
CLIENT_W=$(tmux display-message -p '#{client_width}' 2>/dev/null || echo "100")
CLIENT_H=$(tmux display-message -p '#{client_height}' 2>/dev/null || echo "18")

if [ "$MODE" = "manual" ]; then
    # Restore auto-sizing and snap existing windows back to full client width
    tmux set-option -g window-size latest
    for win in $(tmux list-windows -a -F '#{session_name}:#{window_index}'); do
        tmux resize-window -t "$win" -A 2>/dev/null || true
    done
    tmux display-message "Screen padding: OFF (Full width)"
else
    # Calculate padded width for floating keyboard defaulting to full width if too narrow
    TARGET_W=$(( CLIENT_W - 31 ))
    [ "$TARGET_W" -lt 40 ] && TARGET_W="$CLIENT_W"

    # Enable manual sizing and constrain all windows to padded width
    tmux set-option -g window-size manual
    tmux set-option -g default-size "${TARGET_W}x${CLIENT_H}"
    for win in $(tmux list-windows -a -F '#{session_name}:#{window_index}'); do
        tmux resize-window -t "$win" -x "$TARGET_W" 2>/dev/null || true
    done
    tmux display-message "Screen padding: ON (${TARGET_W} cols, dots on right)"
fi
