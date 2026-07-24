# Termux ADB Wireless System Inspection Notes

Session learning for phone-only non-root Android inspection from Hermes/Termux.

## Verified behavior

- Termux `android-tools` can provide `adb` and start an ADB server.
- Plain Termux cannot dump ActivityManager: `dumpsys activity processes` can fail with `Permission Denial` for missing `android.permission.DUMP`.
- Trying to toggle Wireless debugging through `settings put global adb_wifi_enabled 1` or similar can fail with Android permission errors such as missing `INTERACT_ACROSS_USERS` / secure settings privileges.
- Some ROMs do not resolve `android.settings.WIRELESS_DEBUGGING_SETTINGS`; opening `android.settings.APPLICATION_DEVELOPMENT_SETTINGS` may still work and bring Developer options to the front.
- `adb devices` starts the ADB server as a side effect. If the user abandons setup and wants to save battery, run `adb kill-server` and verify with `ps`, but do not run another `adb devices` afterward because it restarts the server.

## Practical flow

1. Check whether `adb` exists and whether an ADB server/device is already active.
2. If no device is connected, explain that Android requires the user to enable Wireless debugging and read temporary pairing code/ports from Settings.
3. Try opening Developer options for the user, but do not promise that Hermes can enable Wireless debugging itself.
4. Pair/connect only after the user provides the port/code.
5. If setup is paused, stop ADB server to avoid idle battery/process use.

## Cleanup command

```sh
adb kill-server
ps -u "$(id -u)" -o pid,ppid,stat,comm,args 2>/dev/null | grep -E 'adb|adb_inspector|shizuku|rish' | grep -v grep || true
```

Do not follow this with `adb devices` unless you intentionally want to restart the server.
