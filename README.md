# Lenovo ThinkPad X280 — Arch Linux & Hyprland Setup

Repository di backup, configurazione e documentazione tecnica per **Lenovo ThinkPad X280 (Type 20KE)** con **Arch Linux**, kernel **XanMod**, e ambiente desktop Wayland basato su **Hyprland** e **Waybar**.

---

## 💻 Specifiche Hardware di Riferimento

| Componente | Specifiche / Note |
|---|---|
| **Dispositivo** | Lenovo ThinkPad X280 (`20KES9WF00`) |
| **Processore** | Intel Core 8th Gen (Kaby Lake-R, es. i5-8250U / i7-8550U) |
| **Scheda Grafica** | Intel UHD Graphics 620 (`i915`) |
| **Display** | 12.5" IPS Full HD (1920x1080) — Calibrato con profilo ICC dedicato |
| **Audio** | Realtek ALC257 (`snd-hda-intel` ottimizzato con codec Lenovo) |
| **Rete / Wi-Fi** | Intel Dual Band Wireless-AC 8265 (`iwlwifi` / `iwlmvm`) |
| **Input** | Tastiera ThinkPad retroilluminata, TrackPoint, ClickPad multitouch |
| **Kernel** | `linux-xanmod-edge` / Linux standard con bootloader `systemd-boot` |

---

## 🗂️ Struttura del Repository

```text
Thinkpad-x280/
├── README.md                           # Questa documentazione
├── etc/
│   ├── modprobe.d/                     # Moduli kernel, parametri driver e blacklist
│   ├── udev/rules.d/                   # Regole udev (lid switch, webcam, autosuspend USB)
│   ├── tlp.d/                          # Gestione energetica TLP e soglie batteria
│   └── system/                         # Configurazioni di sistema e boot
│       ├── boot/                       # systemd-boot (loader.conf, voci arch / xanmod)
│       ├── mkinitcpio.conf             # Initramfs ottimizzato (lz4, moduli i915 nvme)
│       ├── pacman.conf                 # Configurazione repository e opzioni pacman
│       ├── sudoers                     # Regole privilegi
│       └── kernel_x280.config          # Configurazione kernel personalizzato per X280
├── dotfiles/
│   ├── hypr/                           # Hyprland compositor (Lua config, binds, shader)
│   ├── waybar/                         # Waybar status bar (config, stili, script)
│   ├── zsh/                            # Shell ZSH (.zshrc, alias, prompt)
│   └── config/                         # Configurazioni app utente (kitty, mpv)
├── scripts/
│   ├── battery/                        # Script monitoraggio e alert stato batteria
│   ├── system/                         # Script manutenzione (update.sh, fix vari)
│   └── wayland/                        # Overlay wob (volume, luminosità) e display control
├── packages/                           # Liste pacchetti ufficiali e AUR installati
└── assets/
    ├── icc/                            # Profilo colore ICC calibrato per display X280
    └── wallpapers/                     # Sfondi desktop
```

---

## ⚙️ Dettagli delle Ottimizzazioni

### 1. Risparmio Energetico e Batteria (`etc/tlp.d/`)
I ThinkPad dispongono di controller di carica avanzati supportati dal kernel. Le soglie impostate preservano le celle al litio dall'usura prematura:
- **`00-thresholds.conf`**: Imposta soglia di avvio ricarica a **75%** e arresto a **80%** (`START_CHARGE_THRESH_BAT0=75`, `STOP_CHARGE_THRESH_BAT0=80`). Se collegato alla corrente, il portatile alimenta il sistema senza mantenere la batteria al 100%.
- **`10-battery.conf`**: Quando scollegato dalla rete, imposta il governor della CPU su `powersave`, `balance_power`, disabilita il boost termico (`CPU_BOOST=0`) e abilita `PCIE_ASPM` e runtime power management.
- **`20-ac.conf`**: Sotto alimentazione AC, il sistema passa al profilo prestazioni massime (`balance_performance`, CPU boost attivo, risparmio energetico bus disattivato per latenza minima).

### 2. Scheda Video e Display (`etc/modprobe.d/i915.conf` e Kernel Boot)
- **`enable_fbc=1`**: Attiva il *Framebuffer Compression* per ridurre i consumi energetici dello schermo.
- **`enable_psr=0`**: Disattiva il *Panel Self Refresh*, evitando il noto freeze/sfarfallio del display che affligge le GPU integrate Intel di 8ª generazione su Wayland.
- **`enable_dpcd_backlight=3`**: Abilita il controllo della luminosità nativo via DPCD.
- **Profilo ICC (`assets/icc/x280-lcd.icc`)**: Profilo colore calibrato per il pannello IPS dell'X280 per correggere gamma e resa cromatica.

### 3. Audio ThinkPad ALC257 (`etc/modprobe.d/thinkpad-audio-unified.conf`)
I portatili ThinkPad con codec Realtek ALC257 soffrono spesso di problemi con la presa combo jack (cuffie/microfono) o click/pop audio dovuti al risparmio energetico aggressivo del chipset:
- Forza `model=alc257-lenovo` sul driver `snd-hda-intel`.
- Disabilita il power-save intermittente (`power_save=0`) che causava ritardi e rumori all'attivazione del flusso audio.
- Corregge l'allineamento buffer (`position_fix=1`) per prevenire xrun/desync audio.

### 4. Regole Udev (`etc/udev/rules.d/`)
- **`99-hyprland-lid-dpms.rules`**: Spegne o riaccende automaticamente lo schermo tramite `hyprctl dispatch dpms off/on` quando il coperchio del ThinkPad viene chiuso o riaperto.
- **`99-webcam.rules`**: Imposta automaticamente frequenza anti-sfarfallio a 50Hz (`power_line_frequency=1`) e nitidezza della webcam interna Chicony.
- **`50-usb-powersave.rules`**: Gestisce il risparmio energetico del lettore schede Realtek USB integrato.

### 5. Bootloader Systemd-Boot (`etc/system/boot/`)
Configurazione a caricamento istantaneo con parametri kernel studiati per la massima reattività:
- Parametri: `quiet loglevel=3 i915.enable_psr=0 i915.enable_dpcd_backlight=3 i915.enable_fbc=1 8250.nr_uarts=0 tpm_tis.force=0 rootflags=noatime,commit=30 audit=0 nowatchdog`
- Riduce scritture su NVMe (`noatime,commit=30`), elimina porte seriali legacy non presenti (`8250.nr_uarts=0`), disattiva il watchdog kernel per risparmiare cicli CPU e batteria.

---

## 🚀 Guida al Ripristino / Installazione

### A. Mappa di Copia dei File di Sistema (Richiede `sudo`)

| File nel Repository | Percorso di Destinazione nel Sistema |
|---|---|
| `etc/modprobe.d/*.conf` | `/etc/modprobe.d/` |
| `etc/udev/rules.d/*.rules` | `/etc/udev/rules.d/` |
| `etc/tlp.d/*.conf` | `/etc/tlp.d/` |
| `etc/system/mkinitcpio.conf` | `/etc/mkinitcpio.conf` |
| `etc/system/pacman.conf` | `/etc/pacman.conf` |
| `etc/system/boot/loader.conf` | `/boot/loader/loader.conf` |
| `etc/system/boot/*.conf` | `/boot/loader/entries/` |

> [!IMPORTANT]
> Dopo aver aggiornato i file in `/etc/modprobe.d/` e `/etc/mkinitcpio.conf`, rigenerare l'immagine initramfs con:
> ```bash
> sudo mkinitcpio -P
> sudo udevadm control --reload-rules && sudo udevadm trigger
> ```

### B. Mappa di Copia dei Dotfiles Utente

| File nel Repository | Percorso Utente (`$HOME`) |
|---|---|
| `dotfiles/hypr/` | `~/.config/hypr/` |
| `dotfiles/waybar/` | `~/.config/waybar/` |
| `dotfiles/zsh/.zshrc` | `~/.zshrc` |
| `dotfiles/config/kitty/` | `~/.config/kitty/` |
| `dotfiles/config/mpv/` | `~/.config/mpv/` |
| `scripts/battery/`, `system/`, `wayland/` | `~/.local/bin/` |

### C. Reinstallazione Pacchetti
Per ripristinare esattamente i pacchetti presenti su questo sistema:
```bash
# 1. Pacchetti ufficiali Arch Linux
sudo pacman -S --needed - < packages/pacman-explicit.txt

# 2. Pacchetti AUR (tramite yay)
yay -S --needed - < packages/aur-explicit.txt
```

### D. Manutenzione del Sistema (`scripts/system/update.sh`)
Lo script `update.sh` incluso nel repository automatizza la manutenzione completa:
1. Riordina e ottimizza i mirror con `rate-mirrors` (protocollo HTTPS).
2. Aggiorna il sistema e i pacchetti AUR con `yay -Syyu --devel`.
3. Controlla e aggiorna il firmware UEFI del ThinkPad con `fwupdmgr`.
4. Esegue la pulizia delle cache mantenendo le ultime 2 versioni di sicurezza (`paccache -r -k 2`).
5. Aggiorna `systemd-boot` e invia un segnale realtime a Waybar per azzerare il contatore degli aggiornamenti.

---

## 📝 Licenza e Note
Configurazione creata e mantenuta da **Ubermensch85** per uso personale e come modello di riferimento per configurazioni Arch Linux su Lenovo ThinkPad X280.
