#!/usr/bin/env bash
# Thinkpad-x280 — Script di sincronizzazione / installazione dotfiles
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Thinkpad-x280 Setup Script ==="
echo "Directory repository: $REPO_DIR"

install_user_dotfiles() {
    echo "[*] Installazione dotfiles utente in $HOME..."
    mkdir -p "$HOME/.config" "$HOME/.local/bin"

    # Hyprland
    if [ -d "$REPO_DIR/dotfiles/hypr" ]; then
        mkdir -p "$HOME/.config/hypr"
        cp -rn "$REPO_DIR/dotfiles/hypr/"* "$HOME/.config/hypr/"
        echo "  [+] Hyprland configurato in ~/.config/hypr"
    fi

    # Waybar
    if [ -d "$REPO_DIR/dotfiles/waybar" ]; then
        mkdir -p "$HOME/.config/waybar"
        cp -rn "$REPO_DIR/dotfiles/waybar/"* "$HOME/.config/waybar/"
        echo "  [+] Waybar configurato in ~/.config/waybar"
    fi

    # Kitty & MPV
    if [ -d "$REPO_DIR/dotfiles/config/kitty" ]; then
        mkdir -p "$HOME/.config/kitty"
        cp -rn "$REPO_DIR/dotfiles/config/kitty/"* "$HOME/.config/kitty/"
        echo "  [+] Kitty configurato in ~/.config/kitty"
    fi

    if [ -d "$REPO_DIR/dotfiles/config/mpv" ]; then
        mkdir -p "$HOME/.config/mpv"
        cp -rn "$REPO_DIR/dotfiles/config/mpv/"* "$HOME/.config/mpv/"
        echo "  [+] MPV configurato in ~/.config/mpv"
    fi

    # EasyEffects (DSP Audio per altoparlanti ThinkPad X280)
    if [ -d "$REPO_DIR/dotfiles/easyeffects" ]; then
        mkdir -p "$HOME/.local/share/easyeffects/output" "$HOME/.local/share/easyeffects/autoload/output"
        cp -u "$REPO_DIR/dotfiles/easyeffects/output/"* "$HOME/.local/share/easyeffects/output/" 2>/dev/null || true
        cp -u "$REPO_DIR/dotfiles/easyeffects/autoload/"* "$HOME/.local/share/easyeffects/autoload/output/" 2>/dev/null || true
        echo "  [+] Preset EasyEffects installati in ~/.local/share/easyeffects"
    fi

    # Firefox Developer Edition (user.js anti-clipping & hwaccel)
    if [ -f "$REPO_DIR/dotfiles/firefox/user.js" ]; then
        for profile in "$HOME/.mozilla/firefox/"*.dev-edition-default; do
            if [ -d "$profile" ]; then
                cp -u "$REPO_DIR/dotfiles/firefox/user.js" "$profile/user.js"
                echo "  [+] user.js aggiornato nel profilo Firefox: $(basename "$profile")"
            fi
        done
    fi

    # Zshrc
    if [ -f "$REPO_DIR/dotfiles/zsh/.zshrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        cp "$REPO_DIR/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
        echo "  [+] .zshrc installato in ~/"
    fi

    # Profili colore ICC
    if [ -d "$REPO_DIR/assets/icc" ]; then
        mkdir -p "$HOME/.local/share/icc"
        cp -u "$REPO_DIR/assets/icc/"* "$HOME/.local/share/icc/" 2>/dev/null || true
        echo "  [+] Profili colore ICC installati in ~/.local/share/icc"
    fi

    # Scripts
    echo "[*] Copia script in ~/.local/bin/..."
    find "$REPO_DIR/scripts" -type f \( -name "*.sh" -o -name "*.py" -o ! -name "*.*" \) -exec cp -u {} "$HOME/.local/bin/" \;
    chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
    echo "  [+] Script utente aggiornati e resi eseguibili."
}

echo "Scegli un'opzione:"
echo "1) Installa solo dotfiles e script utente (~/.config, ~/.local/bin)"
echo "2) Mostra istruzioni per i file di sistema (root /etc)"
echo "3) Esci"
read -rp "Selezione [1-3]: " choice

case "$choice" in
    1)
        install_user_dotfiles
        echo "[+] Completato con successo!"
        ;;
    2)
        echo ""
        echo "Per installare i file di sistema, eseguire manualmente:"
        echo "  sudo cp -r $REPO_DIR/etc/modprobe.d/* /etc/modprobe.d/"
        echo "  sudo cp -r $REPO_DIR/etc/udev/rules.d/* /etc/udev/rules.d/"
        echo "  sudo cp -r $REPO_DIR/etc/tlp.d/* /etc/tlp.d/"
        echo "  sudo mkinitcpio -P"
        echo "  sudo udevadm control --reload-rules && sudo udevadm trigger"
        ;;
    *)
        echo "Operazione annullata."
        exit 0
        ;;
esac
