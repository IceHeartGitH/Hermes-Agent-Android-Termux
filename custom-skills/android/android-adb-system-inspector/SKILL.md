---
name: android-adb-system-inspector
description: Use when the user wants non-root Android system inspection from Termux/Hermes: background apps, running processes, services, memory, battery, package/process visibility, Wireless debugging, adb pair/connect, or dumpsys access without root.
version: 0.1.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [android, termux, adb, wireless-debugging, system-inspection]
    related_skills: [android-termux-hermes-setup, termux-android-storage]
---

# Android ADB System Inspector

## Overview

This skill gives Hermes a non-root Android inspection workflow through Termux `adb` / Android Wireless debugging. Plain Termux cannot use privileged `dumpsys activity` because Android denies `android.permission.DUMP`; ADB shell can expose much more without root after the user enables Wireless debugging and pairs the phone.

Local helper script:

```text
~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py
```

## When to Use

Use when the user asks about:

- how many apps/processes are running in the background;
- Android running services, memory, battery, package/process state;
- giving Termux/Hermes more Android visibility without root;
- setting up or testing ADB Wireless debugging from the same phone;
- `dumpsys activity`, `ps -A`, `meminfo`, or similar Android system data.

## Setup Flow

1. Check ADB status:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py status
```

Completion: `adb version` prints and `adb devices` shows either no device or one `device` row.

2. Ask the user to enable Android Wireless debugging:

```text
Settings → Developer options → Wireless debugging → ON
```

Then open:

```text
Pair device with pairing code
```

The screen shows:

```text
IP address & port      = pairing target
Wi‑Fi pairing code     = pairing code
```

3. Pair from Termux. Prefer localhost first on the same phone:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py pair 127.0.0.1:<PAIR_PORT> <PAIR_CODE>
```

If localhost fails, use the IP/port exactly as Android displays:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py pair <PHONE_IP>:<PAIR_PORT> <PAIR_CODE>
```

Completion: output contains `Successfully paired`.

4. Connect to the Wireless debugging connection port. Go back one screen in Wireless debugging and read the main `IP address & Port` value, then run:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py connect 127.0.0.1:<DEBUG_PORT>
```

or:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py connect <PHONE_IP>:<DEBUG_PORT>
```

Completion: `adb devices -l` shows a `device` row.

## Inspection Commands

Background/app-like process count:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py apps
```

System summary:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py summary
```

Top processes:

```bash
python ~/.hermes-venv/skills/android/android-adb-system-inspector/scripts/adb_inspector.py top
```

Raw commands when needed:

```bash
adb shell ps -A
adb shell dumpsys activity processes
adb shell dumpsys meminfo
adb shell dumpsys battery
adb shell cmd package list packages
```

## Important Limits

- This is not root.
- Wireless debugging must be enabled by the user on the phone.
- Pairing code and ports are temporary; the user must read them from Android settings.
- After reboot or toggling Wireless debugging, reconnect/pair may be needed.
- Do not expose package/process lists as proof of app content or private data; they show process/system state, not app files.

## Common Pitfalls

1. Pairing port and connection port are different. Use the pairing dialog port for `pair`; use the main Wireless debugging port for `connect`.
2. `127.0.0.1` may not work on every device. Fall back to the phone IP shown by Android.
3. If `adb devices` says `unauthorized`, check the phone for an authorization prompt.
4. If no device appears, confirm Wireless debugging is still ON and the phone is on Wi‑Fi.

## Verification Checklist

- [ ] `adb version` works.
- [ ] `adb devices -l` shows a `device` row after connect.
- [ ] `adb shell ps -A` returns Android processes, not only Termux processes.
- [ ] `adb shell dumpsys battery` returns battery data.
- [ ] Helper `apps` or `summary` command runs successfully.
