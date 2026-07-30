---
name: nanobot-weather
description: Use when getting current weather or forecasts without an API key using wttr.in or Open-Meteo from Termux/Linux.
version: 0.1.0
author: HKUDS/nanobot / adapted for Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [weather, no-api, curl, termux]
    related_skills: []
    source: https://github.com/HKUDS/nanobot/tree/main/nanobot/skills/weather
    upstream_commit: 6a1a45d07a6d
---

# Nanobot weather for Hermes Agent

Adapted from HKUDS/nanobot `weather` skill. Uses free services; no API key required.

## Quick current weather

```bash
curl -s 'wttr.in/Sofia?format=3'
```

Compact custom format:

```bash
curl -s 'wttr.in/Sofia?format=%l:+%c+%t+%h+%w'
```

Useful wttr.in flags:

```text
?0  current only
?1  today only
?m  metric units
?u  US units
?T  no terminal color/ANSI
```

Example full forecast:

```bash
curl -s 'wttr.in/Sofia?1T'
```

## Programmatic fallback: Open-Meteo

Use Open-Meteo when JSON is needed or wttr.in is unavailable. It requires coordinates but no key:

```bash
curl -s 'https://api.open-meteo.com/v1/forecast?latitude=42.70&longitude=23.32&current_weather=true'
```

## Reporting

Return concise weather in Bulgarian when the user writes in Bulgarian: location, condition, temperature, humidity/wind if available. Mention if the service did not resolve the requested location.

Original upstream is preserved in `references/original-SKILL.md`.
