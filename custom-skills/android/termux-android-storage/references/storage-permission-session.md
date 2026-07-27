# Android/Termux storage permission session notes

Context: Hermes Agent running inside Termux on Android 14, home at `/data/data/com.termux/files/home`.

## Useful observed checks

Initial environment checks:

```sh
pwd && whoami && uname -a && printf '\nHOME=%s\n' "$HOME"
```

Safe tree inspection should use directory-only traversal, a shallow max depth, and inline permission markers. In this session, `/sdcard`, `/storage/emulated/0`, and `/storage/self/primary` all resolved to the same shared storage root.

## termux-setup-storage behavior

Before setup, `$HOME/storage` was missing, while direct `/sdcard` access still worked. Running:

```sh
termux-setup-storage
```

created the Termux storage directory and symlinks. After the user granted permission, verified links included:

```text
~/storage/shared     -> /storage/emulated/0
~/storage/downloads  -> /storage/emulated/0/Download
~/storage/documents  -> /storage/emulated/0/Documents
~/storage/dcim       -> /storage/emulated/0/DCIM
~/storage/pictures   -> /storage/emulated/0/Pictures
~/storage/music      -> /storage/emulated/0/Music
~/storage/movies     -> /storage/emulated/0/Movies
```

Device-specific app storage links may also appear, e.g.:

```text
~/storage/external-0 -> /storage/emulated/0/Android/data/com.termux/files
~/storage/media-0    -> /storage/emulated/0/Android/media/com.termux
~/storage/external-1 -> /storage/<sdcard-id>/Android/data/com.termux/files
~/storage/media-1    -> /storage/<sdcard-id>/Android/media/com.termux
```

## Expected Android restrictions

Even after permission was granted, these remained blocked:

```text
/sdcard/Android/data
/sdcard/Android/obb
```

Phrase this as an Android restriction, not as a Hermes or Termux bug.

## Privacy note

When listing phone storage, directory names may reveal sensitive areas such as vaults, password-manager folders, backups, recordings, and photos. Do not read file contents from those areas unless the user explicitly asks.
