// ==============================================================================
// User.js - Firefox Developer Edition (Arch Linux + Hyprland / Wayland)
// Hardware: Intel Core i5-7200U (2C/4T) | Intel HD Graphics 620 (iHD VA-API) | 8GB RAM (No Swap)
// Kernel: XanMod Linux low-latency
// ==============================================================================

// === PERFORMANCE & RENDERING ===
user_pref("nglayout.initialpaint.delay", 0);
user_pref("browser.sessionstore.interval", 600000);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("image.mem.decode_bytes_at_a_time", 65536);

// === WEBRENDER & ACCELERAZIONE GRAFICA 2D/3D (Intel HD 620) ===
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.compositor", true);
user_pref("gfx.webrender.compositor.force-enabled", true);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.program-binary-disk", true);
// Accelerazione Hardware per HTML5 2D Canvas (sgrava la CPU nei giochi/grafici web)
user_pref("gfx.canvas.accelerated", true);
user_pref("gfx.canvas.accelerated.force-enabled", true);

// === WAYLAND / HYPRLAND NATIVO ===
user_pref("widget.wayland.fractional-scale.enabled", true);
user_pref("widget.wayland.fractional-scale", true);
user_pref("widget.wayland.vsync.enabled", true);
// Integrazione dialoghi file e mime con xdg-desktop-portal-hyprland
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
user_pref("widget.use-xdg-desktop-portal.settings", 1);

// === DECODIFICA VIDEO HARDWARE (VA-API Intel iHD Driver) ===
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
// Zero-copy DMA-BUF: esporta le texture video direttamente da VA-API a WebRender senza copie in RAM
user_pref("media.ffmpeg.vaapi.force-surface-zero-copy", true);
user_pref("media.rdd-ffmpeg.enabled", true);
// Accelerazione H.264 per chiamate WebRTC (Google Meet, Discord, Zoom)
user_pref("media.webrtc.hw.h264.enabled", true);
// CRUCIALE PER INTEL HD 620: Kaby Lake NON possiede decodifica hardware per AV1.
// Disabilitare AV1 costringe YouTube e i siti di streaming a fornire flussi VP9 o H.264,
// entrambi decodificati al 100% in hardware dalla GPU (0-5% CPU invece del 100% in software AV1).
user_pref("media.av1.enabled", false);

// === GESTIONE MEMORIA & PROTEZIONE ANTI-OOM (8GB RAM - ZERO SWAP) ===
// Su Linux è disattivato per default: attivandolo, Firefox scarica dalla RAM i tab inattivi
// prima che il kernel Linux o systemd-oomd uccidano i processi.
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("browser.tabs.unloadTabInContextMenu", true);
user_pref("browser.low_commit_space_threshold_mb", 512);
// Inattività minima prima di considerare lo scaricamento: 5 minuti (in millisecondi)
user_pref("browser.tabs.min_inactive_duration_before_unload", 300000);
// Limita i processi di contenuto a 4, saturando coerentemente i 4 thread logici dell'i5-7200U
// senza frammentare inutilmente la memoria tra decine di processi.
user_pref("dom.ipc.processCount", 4);
user_pref("dom.ipc.processCount.file", 4);

// === CACHE IN RAM (Zero usura SSD / Zero latenza I/O su disco) ===
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
// ~384 MB di cache RAM dinamica
user_pref("browser.cache.memory.capacity", 393216);
// 50 MB max per singola risorsa in cache
user_pref("browser.cache.memory.max_entry_size", 51200);

// === NETWORK & PROTOCOLLI MODERNI (Early Hints HTTP 103, HTTP/3 0-RTT, TLS Cache) ===
user_pref("network.early-hints.enabled", true);
user_pref("network.early-hints.preconnect.enabled", true);
user_pref("network.http.http3.enable", true);
user_pref("network.http.http3.enable_0rtt", true);
user_pref("network.ssl_tokens_cache_capacity", 32768);

// === DNS, ECH (ENCRYPTED CLIENT HELLO) & NATIVE RESOLVER (LAN DNSPROXY / PRODESK600) ===
// Mantiene il DNS sulla LAN verso il server ProDesk 600 (Pi-hole + dnsproxy DoQ/DoH3)
// Disattiva il DoH interno di Firefox per non bypassare la LAN
user_pref("network.trr.mode", 5);
// Interroga i record HTTPS (tipo 65 / SVCB) tramite il resolver di sistema
user_pref("network.dns.native_https_query", true);
// Abilita ECH (Encrypted Client Hello)
user_pref("network.dns.echconfig.enabled", true);
user_pref("network.dns.echconfig.fallback_to_origin_when_all_failed", true);
user_pref("network.dns.use_https_rr_as_altsvc", true);

// === PRIVACY & ENHANCED TRACKING PROTECTION ===
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
// Total Cookie Protection (d-FPI)
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("beacon.enabled", false);
user_pref("browser.send_pings", false);

// === TELEMETRIA & REPORTING (Disattivazione telemetria Dev Edition) ===
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");

// === ESPERIMENTI & SHIELD STUDIES ===
user_pref("experiments.supported", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// === CRASH REPORTS ===
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// === OTTIMIZZAZIONE AUDIO & ANTI-CLIPPING ===
// Ripristina il moltiplicatore audio a 1.0 per evitare il digital hard-clipping
user_pref("media.volume_scale", "1.0");
