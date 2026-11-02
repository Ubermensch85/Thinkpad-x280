#!/usr/bin/env python3
import datetime
import json
import locale
import os
import sys
import time
import urllib.error
import urllib.request

try:
    locale.setlocale(locale.LC_ALL, "")
except Exception:
    pass

# Coordinate: Via dello Zucchero 14, 06132 Perugia (Santa Sabina)
LAT = 43.0752
LON = 12.3218
CACHE_FILE = os.path.expanduser("~/.cache/waybar-weather.json")

URL = (
    f"https://api.open-meteo.com/v1/forecast?latitude={LAT}&longitude={LON}"
    "&current_weather=true&daily=temperature_2m_max,temperature_2m_min,"
    "precipitation_sum,weathercode,windspeed_10m_max"
    "&hourly=relativehumidity_2m,precipitation_probability"
    "&timezone=auto&forecast_days=3"
)

# WMO Weather Codes -> (Descrizione italiana, (Icona giorno, Icona notte))
WEATHER_INFO = {
    0: ("Sereno", ("󰖙", "󰖔")),
    1: ("Prevalentemente sereno", ("󰖕", "󰼱")),
    2: ("Parzialmente nuvoloso", ("󰖕", "󰼱")),
    3: ("Coperto", ("󰖐", "󰖐")),
    45: ("Nebbia", ("󰖑", "󰖑")),
    48: ("Nebbia con brina", ("󰖑", "󰖑")),
    51: ("Pioggerella leggera", ("󰖗", "󰖗")),
    53: ("Pioggerella moderata", ("󰖗", "󰖗")),
    55: ("Pioggerella fitta", ("󰖗", "󰖗")),
    56: ("Pioviggine gelata", ("󰼶", "󰼶")),
    57: ("Pioviggine gelata densa", ("󰼶", "󰼶")),
    61: ("Pioggia debole", ("󰖖", "󰖖")),
    63: ("Pioggia moderata", ("󰖖", "󰖖")),
    65: ("Pioggia forte", ("󰖖", "󰖖")),
    66: ("Pioggia gelata leggera", ("󰼶", "󰼶")),
    67: ("Pioggia gelata forte", ("󰼶", "󰼶")),
    71: ("Neve debole", ("󰼶", "󰼶")),
    73: ("Neve moderata", ("󰼶", "󰼶")),
    75: ("Neve forte", ("󰼶", "󰼶")),
    77: ("Granelli di neve", ("󰼶", "󰼶")),
    80: ("Rovesci leggeri", ("󰖖", "󰖖")),
    81: ("Rovesci moderati", ("󰖖", "󰖖")),
    82: ("Rovesci violenti", ("󰖖", "󰖖")),
    85: ("Rovesci di neve leggeri", ("󰼶", "󰼶")),
    86: ("Rovesci di neve forti", ("󰼶", "󰼶")),
    95: ("Temporale", ("󰙪", "󰙪")),
    96: ("Temporale con grandine", ("󰙪", "󰙪")),
    99: ("Temporale violento", ("󰙪", "󰙪")),
}

def get_weather_meta(code, is_day=1):
    desc, icons = WEATHER_INFO.get(code, ("Variabile", ("󰖐", "󰖐")))
    icon = icons[0] if is_day else icons[1]
    return desc, icon

data = None
is_cached = False
fetch_time = None

# Tentativi con backoff per gestire avvio del sistema / Wi-Fi lento
for attempt in range(4):
    try:
        req = urllib.request.Request(URL, headers={"User-Agent": "WaybarWeather/1.0"})
        with urllib.request.urlopen(req, timeout=4) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            if "current_weather" in data:
                fetch_time = time.time()
                try:
                    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
                    with open(CACHE_FILE, "w", encoding="utf-8") as f:
                        json.dump({"timestamp": fetch_time, "data": data}, f)
                except Exception:
                    pass
                break
    except Exception:
        if attempt < 3:
            time.sleep(2)

# Se fallisce la rete, ripiega sulla cache locale se disponibile
if not data or "current_weather" not in data:
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r", encoding="utf-8") as f:
                cache_obj = json.load(f)
                data = cache_obj.get("data")
                fetch_time = cache_obj.get("timestamp")
                is_cached = True
        except Exception:
            data = None

if not data or "current_weather" not in data:
    print(json.dumps({
        "text": "󰖐  N/A",
        "tooltip": "Meteo non disponibile (offline)\nClicca per riprovare"
    }, ensure_ascii=False))
    sys.exit(0)

cw = data["current_weather"]
daily = data.get("daily", {})
hourly = data.get("hourly", {})

temp = round(cw.get("temperature", 0), 1)
code = cw.get("weathercode", 0)
wind = round(cw.get("windspeed", 0), 1)
is_day = cw.get("is_day", 1)
desc, icon = get_weather_meta(code, is_day)

now = datetime.datetime.now()
now_hour_str = now.strftime("%Y-%m-%dT%H:00")

# Ricerca umidità e probabilità pioggia per l'ora corrente
hourly_times = hourly.get("time", [])
hour_idx = -1
if now_hour_str in hourly_times:
    hour_idx = hourly_times.index(now_hour_str)
elif len(hourly_times) > now.hour:
    hour_idx = now.hour

rel_hum = hourly.get("relativehumidity_2m", [])
humidity = rel_hum[hour_idx] if 0 <= hour_idx < len(rel_hum) else "N/D"

precip_prob = hourly.get("precipitation_probability", [])
rain_prob = precip_prob[hour_idx] if 0 <= hour_idx < len(precip_prob) else "0"

max0 = daily.get("temperature_2m_max", [0])[0]
min0 = daily.get("temperature_2m_min", [0])[0]
rain0 = daily.get("precipitation_sum", [0.0])[0]
windmax0 = daily.get("windspeed_10m_max", [0.0])[0]

day1_name = "Domani (" + (now + datetime.timedelta(days=1)).strftime("%A").capitalize() + ")"
day2_name = (now + datetime.timedelta(days=2)).strftime("%A").capitalize()

def format_forecast_day(idx, name):
    d_max = daily.get("temperature_2m_max", [0, 0, 0])[idx]
    d_min = daily.get("temperature_2m_min", [0, 0, 0])[idx]
    d_rain = daily.get("precipitation_sum", [0, 0, 0])[idx]
    d_code = daily.get("weathercode", [0, 0, 0])[idx]
    d_desc, d_icon = get_weather_meta(d_code, is_day=1)
    return f"{d_icon} {name} — {d_desc}\n  Min: {d_min:.1f}°C  |  Max: {d_max:.1f}°C  |  Pioggia: {d_rain:.1f} mm"

part1 = (
    f" Perugia (Santa Sabina / Via dello Zucchero)\n"
    f"{icon} Oggi: {desc}\n"
    f"  Temperatura: {temp}°C (min {min0:.1f}°C | max {max0:.1f}°C)\n"
    f"  Umidità:     {humidity}%\n"
    f"  Vento:       {wind} km/h (raffiche fino a {windmax0:.1f} km/h)\n"
    f"  Pioggia:     {rain0:.1f} mm ({rain_prob}% probabilità)"
)
part2 = format_forecast_day(1, day1_name)
part3 = format_forecast_day(2, day2_name)

status_note = ""
if is_cached and fetch_time:
    time_str = datetime.datetime.fromtimestamp(fetch_time).strftime("%H:%M")
    status_note = f"󰋼 Dati offline (aggiornati alle {time_str})\n\n"

tooltip = f"{status_note}{part1}\n\n{part2}\n\n{part3}\n\n󰍉 Clicca per aggiornare"

output = {
    "text": f"{icon}  {temp}°C",
    "tooltip": tooltip.strip()
}
print(json.dumps(output, ensure_ascii=False))
