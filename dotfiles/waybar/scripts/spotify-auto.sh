#!/bin/bash

# ~/.config/waybar/scripts/spotify-auto.sh
# Gestione automatica barra Spotify basata su eventi D-Bus MPRIS (zero polling)

CONFIG="$HOME/.config/waybar/config-spotify"
STYLE="$HOME/.config/waybar/style.css"

start_bar() {
    if ! pgrep -f "waybar -c $CONFIG" > /dev/null; then
        waybar -c "$CONFIG" -s "$STYLE" &
    fi
}

stop_bar() {
    if pgrep -f "waybar -c $CONFIG" > /dev/null; then
        pkill -f "waybar -c $CONFIG"
    fi
}

trap 'stop_bar; exit 0' SIGINT SIGTERM

while true; do
    # Ascolto eventi MPRIS nativo D-Bus (zero CPU wakeups)
    playerctl --player=brave -F metadata --format '{{status}}||{{xesam:album}}' 2>/dev/null | while IFS='||' read -r status album; do
        if [[ "$status" == "Playing" && -n "$album" ]]; then
            start_bar
        else
            stop_bar
        fi
    done

    # Se Brave si chiude, chiudi la barra e attendi la riapertura
    stop_bar
    sleep 3
done
