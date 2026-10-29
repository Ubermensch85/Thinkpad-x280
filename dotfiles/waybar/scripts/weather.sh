#!/usr/bin/env python3
import datetime
import json
import locale
import sys
import urllib.error
import urllib.request

try:
    locale.setlocale(locale.LC_ALL, "")
except Exception:
    pass

URL = (
    "https://api.open-meteo.com/v1/forecast?latitude=43.11&longitude=12.39"
    "&current_weather=true&daily=temperature_2m_max,temperature_2m_min,"
    "precipitation_sum,weathercode,windspeed_10m_max"
    "&hourly=relativehumidity_2m,precipitation_probability"
    "&timezone=auto&forecast_days=3"
)

WEATHER_ICONS = {
    0: "󰖙",
    1: "󰖕", 2: "󰖕", 3: "󰖕",
    45: "󰖑", 48: "󰖑",
    51: "󰖗", 53: "󰖗", 55: "󰖗", 61: "󰖗", 63: "󰖗", 65: "󰖗",
    71: "󰼶", 73: "󰼶", 75: "󰼶", 77: "󰼶", 85: "󰼶", 86: "󰼶",
    95: "󰙪", 96: "󰙪", 99: "󰙪"
}

def get_icon(code):
    return WEATHER_ICONS.get(code, "󰖐")

data = None
for _ in range(3):
    try:
        req = urllib.request.Request(URL, headers={"User-Agent": "WaybarWeather/1.0"})
        with urllib.request.urlopen(req, timeout=5) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            if "current_weather" in data:
                break
    except Exception:
        pass

if not data or "current_weather" not in data:
    print(json.dumps({"text": "󰖐  N/A", "tooltip": "Dati non disponibili"}))
    sys.exit(0)

cw = data["current_weather"]
daily = data.get("daily", {})
hourly = data.get("hourly", {})

temp = cw.get("temperature", 0)
code = cw.get("weathercode", 0)
wind = cw.get("windspeed", 0)
icon = get_icon(code)

now = datetime.datetime.now()
current_hour = now.hour

rel_hum = hourly.get("relativehumidity_2m", [])
humidity = rel_hum[current_hour] if current_hour < len(rel_hum) else "N/D"

precip_prob = hourly.get("precipitation_probability", [])
rain_prob = precip_prob[current_hour] if current_hour < len(precip_prob) else "0"

max0 = daily.get("temperature_2m_max", [0])[0]
min0 = daily.get("temperature_2m_min", [0])[0]
rain0 = daily.get("precipitation_sum", [0])[0]
windmax0 = daily.get("windspeed_10m_max", [0])[0]

day1_name = (now + datetime.timedelta(days=1)).strftime("%A")
day2_name = (now + datetime.timedelta(days=2)).strftime("%A")

def get_day(idx, name):
    d_max = daily.get("temperature_2m_max", [0, 0, 0])[idx]
    d_min = daily.get("temperature_2m_min", [0, 0, 0])[idx]
    d_rain = daily.get("precipitation_sum", [0, 0, 0])[idx]
    d_code = daily.get("weathercode", [0, 0, 0])[idx]
    d_icon = get_icon(d_code)
    return f"{d_icon} {name}\n  {d_min}°C — {d_max}°C  |  {d_rain:.2f} mm"

part1 = f"󰖙 Oggi\n  Temp:     {temp}°C (min {min0}° | max {max0}°)\n  Umidità:  {humidity}%\n  Vento:    {wind} km/h (max {windmax0})\n  Pioggia:  {rain0:.2f} mm  ({rain_prob}% prob.)"
part2 = get_day(1, day1_name)
part3 = get_day(2, day2_name)

tooltip = f"{part1}\n\n{part2}\n\n{part3}\n"

output = {
    "text": f"{icon}  {temp}°C",
    "tooltip": tooltip
}
print(json.dumps(output, ensure_ascii=False))
