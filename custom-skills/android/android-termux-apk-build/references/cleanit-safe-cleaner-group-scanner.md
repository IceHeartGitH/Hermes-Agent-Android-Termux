# CleanIt Safe Cleaner: group-first scanner lessons

Session-specific notes from building a Clean Master-style but safety-first Android cleaner entirely in Termux.

## Product/UX correction

The primary workflow should not be manual per-file selection. For this class of cleaner app, the main UX should be:

1. Scan accessible shared storage or a user-selected folder.
2. Detect low-risk cleanup candidates.
3. Sort candidates into understandable groups.
4. Show each group with count, total size, and a reason.
5. Let the user choose groups first.
6. Only later show per-file details as an optional/advanced review path.
7. Only after that, add a confirmation screen before any delete engine.

Per-file checkboxes are useful as a secondary detail screen, not as the center of the app.

## Android storage scope

On modern Android, “scan whole device” should be phrased and implemented as “scan accessible storage.” Without root or privileged permissions, the app cannot and should not scan private app data or system folders. A safe cleaner should prefer:

- public/shared storage scan where allowed;
- Android Storage Access Framework folder picker fallback;
- protected directory rules;
- dry-run reporting before delete.

## Safe candidate groups used

Initial safe-ish review groups:

- APK installers: `.apk`, `.apks`, `.xapk`
- Temporary files: `.tmp`, `.temp`
- Log files: `.log`
- Backup/old files: `.bak`

Protected folders retained:

- Android
- DCIM / Camera
- Pictures
- Movies
- Music
- Documents
- WhatsApp
- Telegram
- Signal

## Safety rules

- Nothing selected by default.
- Group selection is review-only until a confirmation flow exists.
- Do not add delete capability in the same step as scanner/grouping.
- Before claiming a cleaner build is safe, grep/check for accidental delete paths such as `delete()`, `DocumentsContract.deleteDocument`, or `ContentResolver.delete`.
- Keep “no delete yet” visible in the UI until the confirmation/audit flow exists.

## Verification pattern

For each APK iteration, run a focused ad-hoc verification script/check that covers:

- Java unit tests for scanner/group selection behavior.
- APK rebuild using the Termux aapt2 pipeline.
- `zipalign -c -p 4`.
- `apksigner verify --verbose`.
- `aapt dump badging` for package, version, SDK, permissions, launchable activity.
- `aapt dump xmltree` for manifest attributes.
- DEX string check for the newly added behavior.
- Source-level safety grep for absence of delete engine.
- Git workspace clean after committing.

## UX direction for next iterations

Clean Master-like, but safety-first:

- central scan button;
- dashboard/cards for groups;
- group-level selection;
- optional detail view per group;
- disabled/preview-only clean button until confirmation flow is implemented;
- explicit “nothing has been deleted” language.
