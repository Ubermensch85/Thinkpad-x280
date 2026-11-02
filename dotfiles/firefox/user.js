// User.js - Firefox Developer Edition - Arch + Hyprland (Intel HD 620)
// ==============================================================================

// === PERFORMANCE & RENDERING ===
user_pref("nglayout.initialpaint.delay", 0);
user_pref("browser.sessionstore.interval", 600000);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("gfx.webrender.all", true);

// === WAYLAND / HYPRLAND & HARDWARE ACCELERATION (VA-API Intel iHD) ===
user_pref("widget.wayland.fractional-scale", true);
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);

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

// === DNS, ECH (ENCRYPTED CLIENT HELLO) & NATIVE RESOLVER (LAN DNSPROXY / PRODESK600) ===
// Mantiene il DNS sulla LAN verso il server ProDesk 600 (Pi-hole + dnsproxy DoQ/DoH3)
// Disattiva il DoH interno di Firefox per non bypassare la LAN
user_pref("network.trr.mode", 5);
// Interroga i record HTTPS (tipo 65 / SVCB) tramite il resolver di sistema
user_pref("network.dns.native_https_query", true);
// Abilita ECH (Encrypted Client Hello)
user_pref("network.dns.echconfig.enabled", true);
user_pref("network.dns.echconfig.fallback_to_origin_when_all_failed", true);
// ECH su connessioni HTTP/3
user_pref("network.dns.http3_echconfig.enabled", true);
user_pref("network.dns.use_https_rr_as_altsvc", true);

// === OTTIMIZZAZIONE AUDIO & ANTI-CLIPPING ===
// Ripristina il moltiplicatore audio a 1.0 per evitare il digital hard-clipping
user_pref("media.volume_scale", "1.0");


