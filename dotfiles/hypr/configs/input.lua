-- ~/.config/hypr/configs/input.lua
-- Hyprland 0.56.2 - Configurazione Input
-- Ottimizzato per ThinkPad X280 (Tastiera italiana, Touchpad Synaptics TM3381, TrackPoint ELAN)

hl.config({
    input = {
        kb_layout       = "it",
        follow_mouse    = 1,
        sensitivity     = 0.4,
        accel_profile   = "flat",

        touchpad = {
            natural_scroll = false,
            tap_to_click   = true,
            scroll_factor  = 1.4,
        },
    },
})

-- Gesto nativo a 3 dita su touchpad per switch dei workspace (Hyprland 0.56+)
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Configurazione specifica per TrackPoint ThinkPad (tpps/2-elan-trackpoint)
hl.device({
    name        = "tpps/2-elan-trackpoint",
    sensitivity = 0.2,
})
