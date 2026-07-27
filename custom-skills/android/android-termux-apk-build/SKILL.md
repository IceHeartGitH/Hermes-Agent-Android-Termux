---
name: android-termux-apk-build
description: Build and verify minimal native Android APKs entirely inside Android Termux, including aapt/javac/d8/apksigner workflows and Termux-specific pitfalls.
---

# Android Termux APK Build

Use this skill when the user wants to create, build, sign, verify, or troubleshoot an Android APK entirely on an Android phone in Termux, especially without Android Studio.

This skill is for lightweight native Android builds and bootstrapping proof-of-build APKs. For full production apps, Gradle/Android Gradle Plugin may still be preferred once a working SDK/Gradle setup is available.

## Core principles

- Treat the live Termux device as authoritative: verify installed commands and actual Android paths before assuming a desktop Android SDK layout.
- Be careful with package installs: use `pkg`/`apt` with retries for large packages and verify with real command output.
- Build the smallest installable APK first before adding app logic.
- Keep cleaning/security apps safety-first: dry-run scanning before deletion, no broad deletion promises, and no delete path until safety rules are tested.
- In paths under shared storage, quote every path; Android project folders often contain spaces.
- Prefer writing build intermediates under Termux home/cache, then copy final APK to shared storage. Some Android build tools behave poorly with paths containing spaces.

## Setup checklist

Check current tools:

```sh
for c in java javac aapt aapt2 adb apksigner d8 gradle kotlinc kotlin zip unzip git; do
  printf '%-10s ' "$c"
  command -v "$c" || true
done
```

Install core tools in safe chunks:

```sh
pkg install -y openjdk-21 zip aapt aapt2 android-tools apksigner d8
pkg install -y gradle kotlin
```

If the Termux repository is slow or unstable, retry with apt retry/timeouts:

```sh
apt -o Acquire::Retries=8 \
    -o Acquire::http::Timeout=30 \
    -o Acquire::https::Timeout=30 \
    --fix-missing install -y kotlin gradle
```

If an install is interrupted, recover cleanly before retrying:

```sh
dpkg --configure -a
ps -ef | grep -E 'apt|dpkg|pkg' | grep -v grep || true
```

## Android platform jars

Termux's `aapt` package may ship a small framework jar at:

```text
$PREFIX/share/aapt/android.jar
```

That jar may be insufficient for compiling normal app code. Download a real Android platform package from Google's repository and use its `android.jar` for `javac`/`d8`:

```sh
mkdir -p "$HOME/android-sdk/platforms" "$HOME/.cache/android-sdk"
cd "$HOME/.cache/android-sdk"
curl -L --retry 5 --connect-timeout 30 \
  -o platform-35_r02.zip \
  https://dl.google.com/android/repository/platform-35_r02.zip
unzip -q -o platform-35_r02.zip -d "$HOME/android-sdk/platforms"
test -f "$HOME/android-sdk/platforms/android-35/android.jar"
```

For manual `aapt2 link` on Termux, also keep a known-compatible older platform jar available when the latest SDK jar fails as an include path:

```sh
cd "$HOME/.cache/android-sdk"
curl -L -C - --retry 8 --connect-timeout 30 \
  -o platform-28_r06.zip \
  https://dl.google.com/android/repository/platform-28_r06.zip
unzip -q -o platform-28_r06.zip -d "$HOME/android-sdk/platforms"
test -f "$HOME/android-sdk/platforms/android-9/android.jar"
```

Use the latest working SDK jar for Java compile; use the older jar for resource linking only when needed.

## Minimal manual APK pipeline

For a proof-of-build APK without Gradle, use this pipeline:

1. `aapt2 compile` resources.
2. `aapt2 link` resources + manifest into a resource APK.
3. `javac` compile Java sources against SDK `android.jar`.
4. `d8` convert `.class` files to `classes.dex`.
5. Add `classes.dex` to the resource APK.
6. `zipalign` the unsigned APK.
7. Generate a debug keystore if absent.
8. Sign with `apksigner`.
9. Verify with `zipalign -c`, `apksigner verify`, `aapt dump badging`, and `aapt dump xmltree`.

Important Termux nuance:

- Use a real SDK `android.jar` for `javac` and `d8`.
- Prefer `aapt2` over Termux `aapt` for the installable APK manifest. A Termux `aapt package -I /system/framework/framework-res.apk` build may pass `apksigner` but still fail Android install with “problem parsing the package” because manifest Android attribute IDs are wrong.
- If current SDK `android.jar` cannot be loaded by Termux `aapt2` for resource linking, try an older platform resource jar from Google's repository. In the CleanIt session, `platform-28_r06.zip` extracted to `$HOME/android-sdk/platforms/android-9/android.jar` and produced correct `versionCode`, `versionName`, `minSdkVersion`, `targetSdkVersion`, and launcher attrs.
- Keep the newest platform jar for Java compile if needed, but link resources against the older jar that `aapt2` can load successfully.

## Path quoting and build directory

Avoid feeding unquoted `find` output to `javac` or `d8`; spaces in project paths will split arguments.

Good pattern:

```sh
mapfile -d '' JAVA_SOURCES < <(find "$ROOT/src" "$BUILD/obj" -name '*.java' -print0)
javac -encoding UTF-8 \
  -source 8 -target 8 \
  -bootclasspath "$ANDROID_JAR" \
  -d "$BUILD/classes" \
  "${JAVA_SOURCES[@]}"

mapfile -d '' CLASS_FILES < <(find "$BUILD/classes" -name '*.class' -print0)
d8 --min-api 23 \
  --lib "$ANDROID_JAR" \
  --output "$BUILD/dex" \
  "${CLASS_FILES[@]}"
```

Prefer intermediate output in Termux home/cache:

```sh
BUILD="$HOME/.cache/<app>-build"
DIST="$ROOT/build"
```

Then sign/copy final APK to `$DIST`.

## Java compatibility pitfalls

Termux's packaged `d8` may fail on some Java 8+ bytecode constructs from newer JDKs, including lambdas or anonymous listener patterns in some configurations.

For the first proof-of-build:

- Keep `MainActivity` simple.
- Compile with `-source 8 -target 8`.
- Avoid lambdas until the D8/toolchain path is proven.
- If D8 throws internal errors, reduce the Java source to a minimal Activity, then reintroduce UI behaviors gradually.

## Manifest/resource pitfalls

For very minimal manual builds, keep `AndroidManifest.xml` simple until the resource pipeline is confirmed. If resource linking cannot resolve attributes/styles:

- Temporarily remove theme/style indirection.
- Use simple `android:label` first.
- Avoid target SDK/resource attributes until the framework include is working.
- Prefer fixing the packaging tool/include path instead of accepting a manifest that merely dumps without errors.

Always verify both `badging` and `xmltree`; signing alone is not enough:

```sh
aapt dump badging build/<app>-debug.apk | grep -E "package:|sdkVersion|targetSdkVersion|launchable-activity"
aapt dump xmltree build/<app>-debug.apk AndroidManifest.xml | sed -n '1,120p'
```

A parse-error regression often shows up as missing/incorrect `versionCode`, `versionName`, `minSdkVersion`, `targetSdkVersion`, or launcher metadata in `aapt dump badging`. If the APK is signed but Android says “problem parsing the package,” rebuild with `aapt2 link` and a compatible platform jar, then re-check `badging`.

## Signing and verification

Generate debug keystore:

```sh
keytool -genkeypair \
  -keystore debug.keystore \
  -storepass android \
  -keypass android \
  -alias debug \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=Debug,O=Termux,C=US"
```

Sign and verify:

```sh
apksigner sign \
  --ks debug.keystore \
  --ks-pass pass:android \
  --key-pass pass:android \
  --ks-key-alias debug \
  --out build/App-debug.apk \
  build/App-unsigned.apk

apksigner verify --verbose build/App-debug.apk
```

Expected useful indicators:

```text
Verifies
Verified using v1 scheme (JAR signing): true
Verified using v2 scheme (APK Signature Scheme v2): true
Verified using v3 scheme (APK Signature Scheme v3): true
```

## Installing from Termux

`pm install` may fail when the APK is under shared storage (`/storage/emulated/0/...`) because Android `system_server` cannot read that FUSE file context.

If this happens, do not conclude the APK is invalid. First verify with `apksigner` and `aapt`. Then install manually from a file manager or set up a suitable ADB/local wireless-debugging install path.

## Git on shared storage

Git may report “dubious ownership” in shared-storage project folders. For a known user-owned project path, add it as safe:

```sh
git config --global --add safe.directory '/storage/emulated/0/.../Project Name'
```

## Safety-first cleaner app workflow

When building Android cleaner/optimizer apps, avoid making per-file manual selection the main workflow. A Clean Master-like app should feel automated in discovery but conservative in action:

1. Scan accessible shared storage or a user-selected SAF folder.
2. Detect low-risk candidates.
3. Group candidates by class, then show group count, total size, and reason.
4. Let the user choose groups first; per-file choice belongs in a secondary detail/advanced review screen.
5. Keep delete disabled or absent until a separate confirmation and audit flow exists.

Useful initial groups:

- APK installers: `.apk`, `.apks`, `.xapk`
- Temporary files: `.tmp`, `.temp`
- Log files: `.log`
- Backup/old files: `.bak`

For “scan whole device,” be precise: on modern Android this usually means “scan accessible storage,” not private app data or system partitions. Preserve protected directories such as Android, DCIM/Camera, Pictures, Movies, Music, Documents, WhatsApp, Telegram, and Signal.

Before claiming a cleaner APK is safe, verify there is no accidental delete engine yet by checking source for `delete()`, `DocumentsContract.deleteDocument`, and `ContentResolver.delete`, unless the task explicitly is to build the delete phase.

See `references/cleanit-safe-cleaner-group-scanner.md` for the CleanIt session's group-first scanner pattern and verification checklist.

## Verification checklist

Before reporting success:

```sh
bash build.sh
apksigner verify --verbose build/App-debug.apk
aapt dump xmltree build/App-debug.apk AndroidManifest.xml
unzip -l build/App-debug.apk | grep -E 'AndroidManifest.xml|classes.dex'
stat -c%s build/App-debug.apk
```

Report the exact APK path and real verification results.

## References

- `references/cleanit-termux-manual-apk.md` — condensed notes from the CleanIt session, including errors, fixes, and the verified proof-of-build result.
- `scripts/verify-minimal-apk.sh` — reusable verification script for signed APK, manifest, contents, and size sanity.
