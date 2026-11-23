-- ~/.config/hypr/configs/appearance.lua
-- Hyprland 0.57.2 - Stile, Decorazioni, Curve ed Animazioni
-- Tema: Nord (nordtheme.com)
-- Palette:
--   nord0  #2e3440 — Polar Night (background)
--   nord3  #4c566a — Polar Night (bordo inattivo)
--   nord8  #88c0d0 — Frost (azzurro ghiaccio / accent primario)
--   nord9  #81a1c1 — Frost (blu artico / accent secondario)
--   nord10 #5e81ac — Frost (accent terziario)

hl.config({
    cursor = {
        -- Su Intel HD 620 (KMS/i915), no_hardware_cursors = false sfrutta l'accelerazione hardware
        -- del cursore senza occupare cicli CPU e preservando la batteria
        no_hardware_cursors  = false,
        sync_gsettings_theme = true,
    },
    general = {
        gaps_in                 = 4,
        gaps_out                = 6,
        border_size             = 1,
        col = {
            -- Gradiente blu elettrico / azzurro acceso
            active_border   = { colors = { "rgb(00bfff)", "rgb(0088ff)", "rgb(0055ff)", "rgb(0088ff)", "rgb(00bfff)" }, angle = 45 },
            inactive_border = "rgb(4c566a)",
        },
        extend_border_grab_area = 15,
        resize_on_border        = true,
        layout                  = "dwindle",
    },
    decoration = {
        rounding         = 10,
        rounding_power   = 2.0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled    = true,
            size       = 4,
            passes     = 2,
            vibrancy   = 0.2,   -- bassa: Nord è volutamente desaturato
            noise      = 0.02,
            brightness = 0.85,
        },
        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 2,
            color        = "rgba(10152066)",
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        enable_swallow           = true,
        swallow_regex            = "^(kitty)$",
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        vrr                      = 0,
    },
})

-- ── Curve Bezier & Spring (Hyprland 0.57.2) ─────────────────────────────────
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},   {0.32, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5},  {0.75, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},   {0.1, 1}  } })
hl.curve("linear",       { type = "bezier", points = { {0, 0},      {1, 1}    } })
hl.curve("easy",         { type = "spring", mass = 1, stiffness = 238.12, damping = 24.21 })

-- ── Animazioni ───────────────────────────────────────────────────────────────
hl.animation({ leaf = "global",           enabled = true, speed = 8,    bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true, speed = 4.8,  spring = "easy" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 1.8,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 4.5,  spring = "easy" })
hl.animation({ leaf = "border",           enabled = true, speed = 5.0,  bezier = "easeOutQuint" })
-- Rotazione gradiente disattivata per preservare la batteria ed evitare C-state wakeups continui su Intel HD 620
hl.animation({ leaf = "borderangle",      enabled = false })
hl.animation({ leaf = "fade",             enabled = true, speed = 3.0,  bezier = "quick" })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 1.8,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1.5,  bezier = "almostLinear" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3.8,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 4.0,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.6,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4.2,  bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.5,  spring = "easy",         style = "slidevert" })
