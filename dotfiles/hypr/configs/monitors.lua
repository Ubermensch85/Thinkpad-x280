-- ~/.config/hypr/configs/monitors.lua
-- Hyprland 0.56.2 - Gestione Monitor
-- Sintassi nativa: hl.monitor({ output = "...", mode = "...", position = "...", scale = N })

-- Pannello interno ThinkPad X280 (12.5" FHD IPS)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- Uscita HDMI (es. monitor esterno da scrivania o sala riunioni)
hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})

-- Uscita DisplayPort / USB-C Thunderbolt (es. monitor 4K ad alta densità)
hl.monitor({
    output   = "DP-2",
    mode     = "3840x2160@60",
    position = "1536x0",
    scale    = 2,
})

-- Regola di fallback universale per qualsiasi display non precedentemente specificato
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})
