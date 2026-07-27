# Shared storage project folders and SD-card access pattern

Session-derived notes for Android/Termux storage work.

## Phone storage root

For user requests like "главната директория на storage на телефона", use Termux shared storage:

- Termux path: `$HOME/storage/shared`
- Typical real path: `/storage/emulated/0`

Safe root listing pattern:

- list immediate children only;
- label each as `[папка]`, `[файл]`, or `[друго]`;
- sort folders before files;
- show total count;
- do not descend into sensitive folders unless explicitly asked.

## Creating project folders in shared storage

For project folders the user wants visible in the phone file manager, create under `$HOME/storage/shared`, not Termux `$HOME`:

```sh
mkdir -p "$HOME/storage/shared/Example Projects/Test Project"
[ -d "$HOME/storage/shared/Example Projects/Test Project" ]
readlink -f "$HOME/storage/shared/Example Projects/Test Project"
```

If the user first asked for a folder in Termux home and then asks to move it to phone storage root, verify source exists, verify destination parent is accessible, ensure destination does not already exist, then use `mv --` with quoted paths.

## Simple test HTML page

If asked to create a test page in such a project folder, a minimal `index.html` with a centered `Hello world` card is enough. Verify by reading back the file or checking it exists and reporting the real path.

## External SD / memory-card

When asked about "другата памет" or SD card, inspect `$HOME/storage` symlinks. Example observed shape:

- `$HOME/storage/external-1` -> `/storage/<CARD-ID>/Android/data/com.termux/files`
- `$HOME/storage/media-1` -> `/storage/<CARD-ID>/Android/media/com.termux`

These are Termux-scoped directories on the card. Read/list access there does not mean full root access to `/storage/<CARD-ID>`.
