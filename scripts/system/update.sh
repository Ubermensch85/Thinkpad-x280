#!/usr/bin/env zsh
set -euo pipefail

echo "[*] Aggiornamento mirrorlist con rate-mirrors..."

# Genera una mirrorlist ottimizzata (https solo, max 2 ore di ritardo)
# Eseguiamo rate-mirrors come utente normale anche se lo script è root
if [[ $EUID -eq 0 ]]; then
    sudo -u ubermensch -H rate-mirrors \
        --disable-comments-in-file \
        --protocol=https \
        arch \
        --max-delay 7200 \
        | sudo tee /etc/pacman.d/mirrorlist > /dev/null
else
    rate-mirrors \
        --disable-comments-in-file \
        --protocol=https \
        arch \
        --max-delay 7200 \
        | sudo tee /etc/pacman.d/mirrorlist > /dev/null
fi
echo "[+] Mirrorlist aggiornata con successo."

echo "[*] Aggiornamento sistema con yay..."
if [[ $EUID -eq 0 ]]; then
    sudo -u ubermensch -H yay -Syyu --devel --noconfirm
else
    yay -Syyu --devel --noconfirm
fi

echo "[*] Aggiornamento firmware..."
# fwupdmgr restituisce codice 2 se i metadati sono già aggiornati; sopprimiamo il warning sulle capsule UEFI non supportate
(fwupdmgr refresh 2>/dev/null || true) && (fwupdmgr update -y 2>/dev/null || echo "[-] Nessun aggiornamento firmware o fwupd non configurato.")

echo "[*] Pulizia cache pacman e yay..."
# Rimuove le directory temporanee lasciate dai download paralleli di pacman (evita l'errore 'Error reading fd 8')
rm -rf /var/cache/pacman/pkg/download-* 2>/dev/null || true

if [[ $EUID -eq 0 ]]; then
    sudo -u ubermensch -H yay -Sc --noconfirm
    sudo -u ubermensch -H yay -Yc --noconfirm
else
    yay -Sc --noconfirm
    yay -Yc --noconfirm
fi
paccache -r -k 2

echo "[*] Rigenerazione systemd-boot..."
bootctl update 2>/dev/null || true

# Aggiorna immediatamente il modulo degli aggiornamenti su Waybar (signal 8)
pkill -RTMIN+8 waybar 2>/dev/null || true

echo "[*] Aggiornamento completato!"
