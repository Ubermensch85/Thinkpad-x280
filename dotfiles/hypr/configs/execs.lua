-- ~/.config/hypr/configs/execs.lua
-- Hyprland 0.56.2 - Variabili d'ambiente e Script di Autostart

-- ── Variabili d'ambiente (Wayland / Toolkit) ──────────────────────────────────
hl.env("GDK_BACKEND",          "wayland,x11,*")
hl.env("QT_QPA_PLATFORM",      "wayland;xcb")
hl.env("SDL_VIDEODRIVER",      "wayland")
hl.env("CLUTTER_BACKEND",      "wayland")
hl.env("XDG_CURRENT_DESKTOP",  "Hyprland")
hl.env("XDG_SESSION_TYPE",     "wayland")
hl.env("XDG_SESSION_DESKTOP",  "Hyprland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_SIZE",         "24")
hl.env("HYPRCURSOR_SIZE",      "24")
hl.env("GH_NO_KEYRING",        "1")

-- ── Autostart Sessione ────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    -- Subsystem DBus e Systemd environment
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment")

    -- Autenticazione Polkit
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    -- Wallpaper e Notifiche
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("mako")

    -- Barra di stato Waybar e impostazioni interfaccia GNOME/GTK
    hl.exec_cmd("pkill waybar; waybar")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface text-scaling-factor 1.25")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

    -- OSD Overlay (Wob) per volume e luminosità
    hl.exec_cmd("rm -f $XDG_RUNTIME_DIR/wob.sock && mkfifo $XDG_RUNTIME_DIR/wob.sock && tail -f $XDG_RUNTIME_DIR/wob.sock | wob")

    -- Script utente di avvio
    hl.exec_cmd("/home/ubermensch/.local/bin/display-control init")
    hl.exec_cmd("/home/ubermensch/.config/waybar/scripts/spotify-auto.sh")
    hl.exec_cmd("checkupdates")
end)
