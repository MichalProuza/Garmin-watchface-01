# CLAUDE.md

## Project Overview

Garmin Connect IQ watchface application ("Home Dashboard") written in Monkey C. Displays time, date (Czech locale), battery, steps, heart rate, and Bluetooth status. Optimized for AMOLED displays (Fenix 8 51mm primary target, 454×454).

## Tech Stack

- **Language:** Monkey C (Garmin Connect IQ)
- **SDK:** Garmin Connect IQ SDK 6.x+
- **Min API Level:** 3.1.0
- **Runtime:** Java JDK 8+
- **IDE:** VS Code with Monkey C extension

## Build

```bash
monkeyc -d fenix7 -f monkey.jungle -o bin/HomeDashboard.prg -y developer_key.der
```

No test framework is available for Connect IQ watchfaces. Verify changes by building successfully and reviewing rendering logic manually.

## Project Structure

```
source/
  HomeDashboardApp.mc    # App entry point (extends Application.AppBase)
  HomeDashboardView.mc   # All rendering logic (extends WatchUi.WatchFace)
resources/
  strings/strings.xml    # Czech (ces) + English (eng) strings
  drawables/             # Launcher icon and drawable declarations
  layouts/layout.xml     # Empty — all rendering is manual in onUpdate()
manifest.xml             # App manifest: ID, type, devices, languages
monkey.jungle            # Build config (points to manifest.xml)
```

## Architecture

- **HomeDashboardApp** — minimal entry point, returns `HomeDashboardView`
- **HomeDashboardView.onUpdate(dc)** — single rendering method draws everything using proportional coordinates (`width * N / 100`, `height * N / 100`) for multi-device scaling
- Layout is entirely code-driven (no XML layout), using `dc.drawText()` and `dc.fillRectangle()`/`dc.drawRectangle()` for all elements

## Key Patterns

- All positions use proportional math (percentages of screen width/height) — never hardcoded pixel values
- Czech localization is inline: `_dnyVTydnu` (day names) and `_mesice` (month names) arrays in HomeDashboardView
- Heart rate uses dual-source fallback: `Activity.getActivityInfo()` first, then `ActivityMonitor.getHeartRateHistory()`
- Battery color coding: green (>50%), yellow (>20%), red (≤20%)
- Black background for AMOLED battery efficiency

## Coding Conventions

- Comments and variable names in Czech
- Commit messages in Czech (e.g., `feat:`, `fix:` prefixes)
- Monkey C type annotations used (e.g., `as Dc`, `as Number?`, `as Array<String>`)
- Private methods prefixed with underscore for member variables (`_dnyVTydnu`, `_mesice`)
- Use `Lang.Dictionary` (not bare `Dictionary`) for compatibility across SDK versions

## Supported Devices (24 total)

Fenix 7/7S/7X, Fenix 8 43mm/47mm, Forerunner 255/255S/265/265S/955/965, Venu 2/2S/3/3S/Sq2/Sq2 Music, Epix 2/Epix Pro 42/47/51mm, Approach S70 42/47mm, D2 Air X10

## Common Pitfalls

- Always import `Toybox.Lang` explicitly when using `Lang.Dictionary` or `Lang.format()`
- Minimum size guards needed for drawn elements (e.g., `if (iconH < 6) { iconH = 6; }`) to avoid invisible UI on small screens
- `info.day_of_week` is 1-indexed (1=Sunday) — array access needs `dayIdx - 1`
