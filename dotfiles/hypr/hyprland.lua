-- ~/.config/hypr/hyprland.lua
-- Hyprland 0.56.2 (Lua Configuration)
-- Architettura modulare ottimizzata per ThinkPad X280 (Intel Kaby Lake HD Graphics 620)

-- ── Moduli di Configurazione ──────────────────────────────────────────────────
require("configs.monitors")    -- Risoluzioni, scaling e posizionamento display
require("configs.input")       -- Tastiera italiana, TrackPoint e Touchpad ThinkPad
require("configs.appearance")  -- Tema Nord, bordi aurora boreale, blur, ombre e animazioni
require("configs.rules")       -- Window rules, dialoghi modali e finestre fluttuanti
require("configs.binds")       -- Scorciatoie applicative, multimediali e workspace
require("configs.execs")       -- Variabili d'ambiente Wayland e demoni in autostart

-- ── Configurazione Globale del Compositor ─────────────────────────────────────
hl.config({
    ecosystem = {
        no_donation_nag = true,
        no_update_news  = true,
    },
    render = {
        -- direct_scanout = 0 previene lo sfarfallio (flicker/KMS plane switch) su Intel HD 620 durante il cambio workspace
        direct_scanout = 0,
    },
    dwindle = {
        preserve_split = true,
        force_split    = 2,
        smart_split    = false,
    },
    master = {
        new_status = "slave",
        mfact      = 0.55,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
