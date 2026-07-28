# Android/Termux storage permission notes

This reference is intentionally generic. It describes typical Termux storage behavior without recording a specific user's device, home path, vault names, or directory listing.

## Useful checks

Initial environment checks:

```sh
pwd && whoami && uname -a && printf '
HOME=%s
' "$HOME"
```

Safe tree inspection should use directory-only traversal, a shallow max depth, and inline permission markers. Do not read file contents from user storage unless explicitly requested.

## termux-setup-storage behavior

Run:

```sh
termux-setup-storage
```

After Android permission is granted, Termux typically creates `$HOME/storage` symlinks such as:

```text
~/storage/shared
~/storage/downloads
~/storage/documents
~/storage/dcim
~/storage/pictures
~/storage/music
~/storage/movies
```

Some devices may also expose app-scoped storage links for external or media storage. Treat these as device-dependent and verify them on the target phone.

## Expected Android restrictions

Modern Android commonly restricts other apps' private data and OBB folders even after shared-storage permission is granted. Phrase this as an Android storage policy, not as a Hermes or Termux bug.

## Privacy note

Directory names in phone storage may reveal sensitive areas such as vaults, password-manager folders, backups, recordings, and photos. Report only what is necessary and avoid printing private filenames unless the user explicitly asks.
