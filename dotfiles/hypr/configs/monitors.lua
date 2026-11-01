-- ~/.config/hypr/configs/monitors.lua
-- Hyprland - Gestione Monitor
-- Sintassi nativa: hl.monitor({ output = "...", mode = "...", position = "...", scale = N, icc = "..." })

-- Pannello interno ThinkPad X280 (12.5" FHD IPS AUO B125HAN02.2)
-- Calibrato con profilo ICC dedicato e Black Point Compensation (BPC)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
    icc      = "/home/ubermensch/.local/share/icc/x280-lcd.icc",
})

-- Uscita HDMI (Televisori 4K 43"-50", risoluzione nativa con scala 2 per massima leggibilità)
hl.monitor({
    output   = "HDMI-A-2",
    mode     = "preferred",
    position = "auto",
    scale    = 2,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "auto",
    scale    = 2,
})

-- Uscita DisplayPort / USB-C Thunderbolt (Monitor o TV 4K)
hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "auto",
    scale    = 2,
})

-- Regola di fallback universale per qualsiasi display non precedentemente specificato
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})
