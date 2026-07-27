---
name: termux-android-storage
description: Inspecting and enabling Android shared-storage access from Hermes/Termux, including termux-setup-storage verification and safe directory tree reporting.
---

# Termux Android Storage

Use this skill when the user asks what phone folders Hermes can access, wants an `ls`/tree of Android storage, asks about `termux-setup-storage`, or needs help verifying Termux storage permissions on Android.

## Core principles

- Treat the live device as authoritative: verify paths and permissions with tools instead of relying on generic Android knowledge.
- Prefer directory-only inspection unless the user explicitly asks to read files, especially around sensitive folders such as Vault, KeePass, backups, call recordings, DCIM, and app media.
- Be explicit about what is accessible vs. merely present.
- Explain Android storage limits plainly: shared storage may be accessible, but `/sdcard/Android/data` and `/sdcard/Android/obb` are commonly blocked on modern Android even after storage permission is granted.
- In CLI/Termux sessions, return plain text paths, not attachment markers.

## Workflow

1. Identify the current Termux environment:
   - `pwd`
   - `whoami`
   - `uname -a`
   - `printf 'HOME=%s\n' "$HOME"`

2. Check common shared-storage paths:
   - `$HOME/storage`
   - `$HOME/storage/shared`
   - `/sdcard`
   - `/storage/emulated/0`
   - `/storage/self/primary`

3. For a safe folder structure report:
   - List directories only.
   - Avoid showing regular files by default.
   - Limit depth, usually 2–3 levels.
   - Mark permission failures inline, e.g. `НЯМА ДОСТЪП` or `[permission denied]`.
   - Collapse duplicate realpaths so `/sdcard`, `/storage/emulated/0`, and `/storage/self/primary` are not repeated as separate trees.

4. If `~/storage` is missing or incomplete, explain `termux-setup-storage`:
   - It prompts Android for storage permission.
   - It creates symlinks under `~/storage` such as `shared`, `downloads`, `documents`, `dcim`, `pictures`, `music`, and `movies`.
   - It does not grant root.
   - It does not generally unlock other apps' private data or restricted `/Android/data` and `/Android/obb` paths.

5. If the user asks to run it, execute:
   - `termux-setup-storage`
   The user may need to confirm an Android permission prompt on the device.

6. Verify after setup:
   - Print each symlink and its resolved target with `readlink -f`.
   - Check read/list access for `~/storage/shared`, `downloads`, `dcim`, `pictures`, `/sdcard`, `/sdcard/Android/data`, and `/sdcard/Android/obb`.
   - Mention any external storage links such as `external-0`, `external-1`, `media-0`, or `media-1`.

## Good verification command

```sh
printf 'Storage symlinks:\n'
for p in "$HOME/storage"/*; do
  [ -e "$p" ] || continue
  printf '%s -> ' "$p"
  readlink -f "$p"
done

printf '\nAccess checks:\n'
for p in \
  "$HOME/storage/shared" \
  "$HOME/storage/downloads" \
  "$HOME/storage/dcim" \
  "$HOME/storage/pictures" \
  "/sdcard" \
  "/sdcard/Android/data" \
  "/sdcard/Android/obb"; do
  if [ -e "$p" ]; then
    if [ -r "$p" ] && [ -x "$p" ]; then
      echo "OK read/list: $p"
    else
      echo "NO read/list: $p"
    fi
  else
    echo "MISSING: $p"
  fi
done
```

## Shared-storage folder creation, moving, and listing

When the user asks for a folder in the phone storage root, treat the target as `$HOME/storage/shared` (real path usually `/storage/emulated/0`). For "главната директория" without "storage", use Termux home `$HOME` unless the user explicitly says phone storage.

- Create folders with `mkdir -p "$HOME/storage/shared/<name>"` or create in `$HOME` first if that is what was requested; always verify with `[ -d ... ]` and report both the Termux path and real `/storage/emulated/0/...` path when relevant.
- If moving from Termux home to phone storage root, use `mv -- "$HOME/<name>" "$HOME/storage/shared/<name>"`; before moving, verify source exists, shared-storage root is readable/listable, and destination does not already exist to avoid accidental merge/overwrite.
- For root listings of phone storage, list only immediate children of `$HOME/storage/shared`; label each item as `[папка]`, `[файл]`, or `[друго]`, sort folders before files, and show the total count. Do not descend into sensitive folders unless explicitly asked.
- In Bulgarian, concise phrasing is preferred: `Готово`, exact path(s), and `Проверих`.

## File deletion by numbered listing

When the user asks to delete files by numbers from a previously shown folder list:

1. Map the requested numbers back to the exact filenames from the last listing in the conversation; do not re-number a fresh listing unless the user asks for a new list.
2. If the request is syntactically incomplete or ambiguous (e.g. `изтрий 5, 6 и`), ask a short clarification with likely choices such as `Само 5 и 6`, `5, 6 и 7`, or `друг файл`.
3. Before deleting, verify each exact path exists under the intended directory.
4. Use `rm -- 'exact filename'` with proper quoting; Android Download filenames often contain spaces, Bulgarian text, punctuation, and parentheses.
5. Verify each target no longer exists after deletion and report only the deleted filenames plus the remaining count if useful.
6. Do not open/read file contents while doing cleanup unless explicitly requested.

## External SD / memory-card access checks

When the user asks about "другата памет", "втора памет", "memory card", or SD-card access from Termux:

1. Inspect Termux-created storage symlinks first; do not assume full-card access:

```sh
for p in "$HOME/storage"/*; do
  [ -e "$p" ] || continue
  printf '%s -> ' "$p"
  readlink -f "$p" 2>/dev/null || printf 'unresolved\n'
done
```

2. Treat paths like `$HOME/storage/external-1` and `$HOME/storage/media-1` as likely SD-card scoped app directories. Common real paths observed on Android are:
   - `/storage/<CARD-ID>/Android/data/com.termux/files`
   - `/storage/<CARD-ID>/Android/media/com.termux`
3. Verify read/list access with `[ -d "$p" ] && [ -r "$p" ] && [ -x "$p" ]`; if helpful, count immediate items with Python `os.listdir` rather than using a broad recursive listing.
4. Report clearly that access to these Termux-specific SD-card directories does not prove full access to the SD-card root. On modern Android, full SD-card root access may be restricted even after `termux-setup-storage`.
5. Use cautious Bulgarian phrasing: `виждам втора памет / SD карта`, `имам достъп до Termux папките върху нея`, and `нямам потвърден пълен достъп до главната директория на SD картата`.

## Reporting style

For Bulgarian-speaking users, concise Bulgarian output works well:

- `Имам достъп до:` for accessible roots.
- `Нямам достъп до:` for blocked paths.
- `Това е нормално ограничение на Android` for expected `/Android/data` and `/Android/obb` restrictions.
- Warn before inspecting sensitive content; do not open private-looking folders without explicit request.
- For cleanup actions, be brief: say `Готово`, list exact deleted names, and mention verification.

## Related skills

- `android-termux-hermes-setup` — broader Android/Termux setup, Termux source/update checks, and Hermes installation before storage configuration.

## References

- `references/storage-permission-session.md` — observed Android/Termux storage setup and verification pattern from a Hermes CLI session.
- `references/shared-storage-project-folders-and-sd-card.md` — session notes for creating project folders/pages in phone storage and distinguishing SD-card Termux-scoped access from full card-root access.
