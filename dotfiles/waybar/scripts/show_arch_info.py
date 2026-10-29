#!/usr/bin/env python3
import os, subprocess, sys, tty, termios, shutil, re

# ─── UTILITY ──────────────────────────────────────────────────────────────────

def getch():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)
    return ch

def cols():
    return shutil.get_terminal_size((80, 24)).columns

# Regex più robusta per ANSI escape codes
ANSI_ESCAPE = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
def vlen(s):
    return len(ANSI_ESCAPE.sub('', s))

# ─── SYSTEM INFO ──────────────────────────────────────────────────────────────

def get_sys_info():
    try:
        # Tenta di prendere l'IP da wlan0 o eth0
        ip = subprocess.check_output(
            "ip -4 a show wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1",
            shell=True).decode().strip()
        if not ip:
            ip = subprocess.check_output(
                "ip -4 a show eth0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1",
                shell=True).decode().strip()
    except:
        ip = "Offline"
    
    if not ip: ip = "Offline"

    try:
        boot = subprocess.check_output(
            "systemd-analyze 2>/dev/null | awk -F'=' '{print $2}' | awk '{print $1}'",
            shell=True).decode().strip()
    except:
        boot = "N/A"
    
    return f"\n\033[1;36m Boot:\033[0m {boot}s  |  \033[1;32m IP:\033[0m {ip}"

# ─── KEYBINDINGS ──────────────────────────────────────────────────────────────

BINDS = {
    "APP": [
        ("SUPER + RETURN",      "Kitty (terminale)"),
        ("SUPER + B",           "Firefox HW Accel"),
        ("SUPER + C",           "Librewolf HW Accel"),
        ("SUPER + D",           "Rofi Drun (launcher)"),
        ("SUPER + SHIFT + D",   "Rofi Run (comandi)"),
        ("SUPER + N",           "Nemo (file manager)"),
        ("SUPER + M",           "Nota (script Alacritty)"),
        ("SUPER + SHIFT + A",   "Ghostwriter (markdown)"),
        ("F9",                  "Edita Hyprland Config"),
    ],
    "SISTEMA": [
        ("SUPER + Q",           "Chiudi finestra attiva"),
        ("SUPER + E",           "Esci da Hyprland"),
        ("SUPER + ESC",         "Reboot"),
        ("SUPER + DELETE",      "Poweroff"),
        ("SUPER + R",           "Ricarica config Hyprland"),
        ("SUPER + I",           "Controlla batteria (root)"),
        ("SUPER + PRINT",       "Screenshot area (grimblast)"),
    ],
    "FINESTRE": [
        ("SUPER + F",           "Fullscreen"),
        ("SUPER + O",           "Toggle Float (centra/resize)"),
        ("SUPER + P",           "Pseudo Tiling"),
        ("SUPER + W",           "Toggle display"),
        ("SUPER + A",           "Toggle Waybar"),
        ("SUPER + S",           "Screensaver (hyprdvd)"),
        ("SUPER + SHIFT + S",   "Sposta → special:magic"),
        ("SUPER + `",           "Toggle special:magic"),
        ("SUPER + SHIFT + M",   "Toggle note (special)"),
    ],
    "SPOSTAMENTO": [
        ("SUPER + H/J/K/L",     "Sposta finestra (L/D/U/R)"),
        ("SUPER + LMB drag",    "Trascina finestra"),
        ("SUPER + RMB drag",    "Ridimensiona finestra"),
        ("SUPER + scroll",      "Workspace ±1"),
    ],
    "WORKSPACE": [
        ("SUPER + 1-9 / 0",     "Vai al workspace 1-10"),
        ("SUPER + SHIFT + 1-9", "Sposta finestra → WS N"),
    ],
    "AUDIO & LUCE": [
        ("F1 / XF86Mute",       "Mute audio"),
        ("F2 / XF86VolDown",    "Volume giù"),
        ("F3 / XF86VolUp",      "Volume su"),
        ("F4",                  "Toggle microfono"),
        ("F5 / XF86BrightDown", "Luminosità giù"),
        ("F6 / XF86BrightUp",   "Luminosità su"),
        ("F8",                  "Toggle WiFi"),
        ("SUPER + F10",         "Toggle Bluetooth"),
        ("SUPER + F11",         "DPMS off (1s delay)"),
        ("SUPER + F12",         "DPMS on"),
    ],
}

# ─── HELP VIEW ────────────────────────────────────────────────────────────────

def render_section(name, binds):
    lines = []
    lines.append(f"\033[1;4;37m{name}\033[0m")
    for key, desc in binds:
        # Padding fisso per la colonna dei tasti
        pad = max(1, 22 - len(key))
        lines.append(f"  \033[1;33m{key}\033[0m{' ' * pad}\033[36m{desc}\033[0m")
    lines.append("") # Riga vuota tra sezioni
    return lines

def show_help():
    os.system('clear')
    w = cols()
    
    title = " HYPRLAND KEYBINDINGS "
    print(f"\033[1;35m{'═' * w}\033[0m")
    print(f"\033[1;35m{title.center(w)}\033[0m")
    print(f"\033[1;35m{'═' * w}\033[0m")

    sections = list(BINDS.items())
    # Aumentiamo la soglia a 110 per sicurezza
    use_two_cols = w >= 110

    all_left_lines = []
    all_right_lines = []

    if use_two_cols:
        mid = (len(sections) + 1) // 2
        for name, binds in sections[:mid]:
            all_left_lines.extend(render_section(name, binds))
        for name, binds in sections[mid:]:
            all_right_lines.extend(render_section(name, binds))
        
        max_rows = max(len(all_left_lines), len(all_right_lines))
        all_left_lines += [""] * (max_rows - len(all_left_lines))
        all_right_lines += [""] * (max_rows - len(all_right_lines))
        
        col_w = (w // 2) - 2
        sep = "\033[90m│\033[0m"
        
        for l, r in zip(all_left_lines, all_right_lines):
            # Calcolo spazio per far stare la riga senza wrappare
            left_visible_len = vlen(l)
            padding = " " * max(0, col_w - left_visible_len)
            print(f" {l}{padding} {sep} {r}")
    else:
        for name, binds in sections:
            for line in render_section(name, binds):
                print(f" {line}")

    print(f"\033[1;35m{'═' * w}\033[0m")
    print("\033[90m  Premere un tasto per tornare...\033[0m")
    getch()

# ─── MAIN LOOP ────────────────────────────────────────────────────────────────

def main_loop():
    logo_path = os.path.expanduser("~/Immagini/Specchietto.png")
    while True:
        os.system('clear')
        w = cols()
        logo_w = max(25, min(45, w // 3))
        
        cmd = [
            "fastfetch",
            "--logo", logo_path,
            "--logo-type", "kitty",
            "--logo-width", str(logo_w),
            "--logo-height", "13",
            "--logo-preserve-aspect-ratio", "true"
        ]
        
        subprocess.run(cmd)
        print(get_sys_info())
        print(f"\n\033[1;33m[q]\033[0m Esci  |  \033[1;32m[h]\033[0m Keybindings")

        ch = getch().lower()
        if ch in ('q', '\x03'):
            os.system('clear')
            break
        elif ch == 'h':
            show_help()

if __name__ == "__main__":
    if os.environ.get("TERM") != "xterm-kitty":
        subprocess.run(['kitty', '--class', 'floating_term', '--title', 'Arch Info',
                        'python3', __file__])
    else:
        main_loop()
