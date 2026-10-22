-- ~/.config/hypr/configs/rules.lua
-- Hyprland 0.56.2 - Regole Finestre (Window Rules)
--
-- Effetti statici (valutati all'apertura della finestra):
--   float, tile, fullscreen, maximize, move, size, center, pseudo,
--   monitor, workspace, pin, no_initial_focus, suppress_event
-- Effetti dinamici (rivalutati al cambio di stato/proprietà):
--   opacity, border_color, border_size, rounding, no_blur, no_focus, ...

-- ════════════════════════════════════════════════════════════════════════════
-- REGOLE GLOBALI DI COMPORTAMENTO
-- ════════════════════════════════════════════════════════════════════════════

-- Ignora richieste arbitrarie di massimizzazione (es. app Electron, browser, Steam)
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ════════════════════════════════════════════════════════════════════════════
-- DIALOG E FINESTRE MODALI
-- ════════════════════════════════════════════════════════════════════════════

-- Regola globale: qualsiasi finestra riconosciuta nativamente come modale (Wayland)
hl.window_rule({
    match  = { modal = true },
    float  = true,
    center = true,
})

-- Fallback per dialog e finestre di dialogo che non dichiarano modal (XWayland e app legacy)
hl.window_rule({
    match  = { title = "^(Open File|Open Folder|Save As|Save File|Salva come|Apri|Preferences|Settings|Impostazioni|Print|Stampa|Alert|Confirm|Error|Warning|About|Find|Search).*$" },
    float  = true,
    center = true,
})

-- ── Firefox Developer Edition — dialog interni ───────────────────────────────
hl.window_rule({
    match  = { class = "^firefox-developer-edition$", modal = true },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = {
        class = "^firefox-developer-edition$",
        title = "^(Opening|Save|Salva|Enter name|Alert|Confirm|Print|About Mozilla).*$",
    },
    float  = true,
    center = true,
})

-- ── AnyDesk — finestre secondarie / sessioni ──────────────────────────────────
hl.window_rule({
    match  = { class = "^(Anydesk)$", modal = true },
    float  = true,
    center = true,
})
hl.window_rule({
    match  = { class = "^(Anydesk)$", title = "negative:^(AnyDesk)$" },
    float  = true,
    center = true,
})

-- ════════════════════════════════════════════════════════════════════════════
-- SISTEMA E UTILITY
-- ════════════════════════════════════════════════════════════════════════════

-- ── Polkit Authentication Agent ──────────────────────────────────────────────
hl.window_rule({
    match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    float = true,
})

-- ── Floating Terminal generico ───────────────────────────────────────────────
hl.window_rule({
    match  = { class = "^(floating_term)$" },
    float  = true,
    size   = { 860, 600 },
    center = true,
    pin    = true,
})

-- Caso speciale: Arch Info sovrascrive le dimensioni
hl.window_rule({
    match  = { class = "^(floating_term)$", title = "^(Arch Info)$" },
    size   = { 1020, 680 },
    center = true,
})

-- ── kitty-update (Pacman update helper) ──────────────────────────────────────
hl.window_rule({
    match  = { class = "^(kitty-update)$" },
    float  = true,
    size   = { 1050, 680 },
    center = true,
})

-- ── kitty-config (Editor configurazione Hyprland con F9) ─────────────────────
hl.window_rule({
    match  = { class = "^(kitty-config)$" },
    float  = true,
    size   = { 1050, 700 },
    center = true,
})

-- ── kitty-nmtui (Network Manager TUI da Waybar) ──────────────────────────────
hl.window_rule({
    match  = { class = "^(kitty-nmtui)$" },
    float  = true,
    size   = { 800, 560 },
    center = true,
})

-- ── Pavucontrol (Mixer audio PulseAudio/PipeWire) ────────────────────────────
hl.window_rule({
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
    float  = true,
    size   = { 820, 560 },
    center = true,
})

-- ── Nota (Scratchpad veloce Alacritty) ────────────────────────────────────────
hl.window_rule({
    match     = { class = "^(Nota)$" },
    float     = true,
    size      = { 900, 600 },
    center    = true,
    workspace = "special:notes",
})

-- ── Kitty su workspace 2 ─────────────────────────────────────────────────────
hl.window_rule({
    match = { class = "^(kitty)$", workspace = "2" },
    float = true,
    size  = { 820, 560 },
    move  = { 980, 150 },
})

-- ── fly-foot-write ───────────────────────────────────────────────────────────
hl.window_rule({
    match        = { title = "^(fly-foot-write)$" },
    float        = true,
    border_color = { colors = { "rgb(FFFFFF)", "rgb(000000)" }, angle = 0 },
})

-- ════════════════════════════════════════════════════════════════════════════
-- BROWSER WEB
-- ════════════════════════════════════════════════════════════════════════════

-- ── Librewolf ────────────────────────────────────────────────────────────────
hl.window_rule({
    match   = { class = "^(librewolf)$" },
    opacity = "1.0 override 1.0 override",
})

-- ── Firefox Developer Edition ────────────────────────────────────────────────
hl.window_rule({
    match   = { class = "^firefox-developer-edition$" },
    opacity = "1.0 override 1.0 override",
})

-- ════════════════════════════════════════════════════════════════════════════
-- APPLICAZIONI SPECIFICHE
-- ════════════════════════════════════════════════════════════════════════════

-- ── Atril (Visualizzatore documenti) ──────────────────────────────────────────
hl.window_rule({
    match   = { class = "^([Aa]tril)$" },
    opacity = "1.0 override 1.0 override",
})

-- ── AnyDesk (Finestra principale) ────────────────────────────────────────────
hl.window_rule({
    match       = { class = "^(Anydesk)$", title = "^(AnyDesk)$" },
    float       = true,
    center      = true,
    size        = { 1680, 920 },
    opacity     = "1.0 override 1.0 override",
    border_size = 0,
})

-- ── Sky TG24 (MPV floating PIP) ──────────────────────────────────────────────
hl.window_rule({
    match = { title = "^(Sky TG24 — Diretta)$" },
    float = true,
    size  = { 560, 315 },
    move  = { 1330, 48 },
})

-- ── GeForce NOW ──────────────────────────────────────────────────────────────
-- Regola generale: 100% opaco (nessuna trasparenza), no blur, no ombre, idle inibito, render in background
hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$" },
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "focus",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

-- Finestra Launcher (titolo "GeForce NOW"): floating 1440x900 centrata
hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$", title = "^([Gg]e[Ff]orce [Nn][Oo][Ww])$" },
    fullscreen           = false,
    float                = true,
    size                 = { 1440, 900 },
    center               = true,
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "focus",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

-- Sessione Streaming di Gioco (es. "Call of Duty® su GeForce NOW" o in inglese "on GeForce NOW"):
-- Fullscreen automatico, zero sfarfallio tra workspace, standby inibito, rendering continuo
hl.window_rule({
    match                = { class = "^([Gg]e[Ff]orce.*|geforcenow-electron)$", title = ".*(su|on) GeForce NOW.*" },
    fullscreen           = true,
    opacity              = "1.0 override 1.0 override",
    no_blur              = true,
    no_shadow            = true,
    idle_inhibit         = "always",
    render_unfocused     = true,
    no_shortcuts_inhibit = true,
})

-- ════════════════════════════════════════════════════════════════════════════
-- FIX XWAYLAND DRAG & DROP
-- ════════════════════════════════════════════════════════════════════════════

hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
