#!/bin/bash

# ~/.config/waybar/scripts/battery_fixed.sh
# Lettura capacità, stato, consumo istantaneo e integrazione con stili Waybar

cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
ac=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)

# Determina l'icona e il consumo in base allo stato AC
if [ "$ac" -eq 1 ]; then
    icon=""
    # Calcolo RAPL per consumo CPU su alimentatore (AC)
    if [ -f /sys/class/powercap/intel-rapl:0/energy_uj ]; then
        old=$(sudo -n cat /sys/class/powercap/intel-rapl:0/energy_uj 2>/dev/null || echo 0)
        sleep 0.1
        new=$(sudo -n cat /sys/class/powercap/intel-rapl:0/energy_uj 2>/dev/null || echo 0)
        p_watt=$(awk -v n="$new" -v o="$old" 'BEGIN { if (n>o) printf "%.2f", (n-o)/100000; else printf "0.00" }')
        p_text="$p_watt W (CPU)"
    else
        p_text="AC"
    fi
else
    # Icone batteria in base alla capacità residua
    if [ "$cap" -le 10 ]; then icon="";
    elif [ "$cap" -le 30 ]; then icon="";
    elif [ "$cap" -le 60 ]; then icon="";
    elif [ "$cap" -le 90 ]; then icon="";
    else icon=""; fi

    # Lettura consumo standard su batteria
    if [ -f /sys/class/power_supply/BAT0/power_now ]; then
        p_now=$(cat /sys/class/power_supply/BAT0/power_now)
        p_watt=$(awk -v p="$p_now" 'BEGIN { printf "%.2f", p/1000000 }')
    elif [ -f /sys/class/power_supply/BAT0/voltage_now ] && [ -f /sys/class/power_supply/BAT0/current_now ]; then
        v_now=$(cat /sys/class/power_supply/BAT0/voltage_now)
        c_now=$(cat /sys/class/power_supply/BAT0/current_now)
        p_watt=$(awk -v v="$v_now" -v c="$c_now" 'BEGIN { printf "%.2f", (v*c)/1000000000000 }')
    else
        p_watt="0.00"
    fi
    p_text="$p_watt W"
fi

# Gestione classi CSS per lo styling
class=""
if [ "$status" = "Charging" ]; then
    class="charging"
elif [ "$cap" -le 5 ]; then
    class="critical"
elif [ "$cap" -le 18 ]; then
    class="warning"
fi

echo "{\"text\": \"$icon    $cap%\", \"tooltip\": \"Stato: $status | Consumo: $p_text\", \"class\": \"$class\"}"
