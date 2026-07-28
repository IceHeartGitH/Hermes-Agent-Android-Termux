#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 /absolute/path/to/App-debug.apk [expected.package.name] [expected.versionCode] [expected.versionName]" >&2
  exit 2
fi

APK="$1"
EXPECTED_PACKAGE="${2:-}"
EXPECTED_VERSION_CODE="${3:-}"
EXPECTED_VERSION_NAME="${4:-}"

if [ ! -f "$APK" ]; then
  echo "APK not found: $APK" >&2
  exit 1
fi

TMPDIR="${TMPDIR:-${PREFIX:?PREFIX is not set}/tmp}"
SIGN_LOG="$TMPDIR/hermes-apk-sign-$$.log"
MANIFEST_LOG="$TMPDIR/hermes-apk-manifest-$$.log"
BADGING_LOG="$TMPDIR/hermes-apk-badging-$$.log"
ZIP_LOG="$TMPDIR/hermes-apk-zip-$$.log"
trap 'rm -f "$SIGN_LOG" "$MANIFEST_LOG" "$BADGING_LOG" "$ZIP_LOG"' EXIT

printf 'VERIFY 1/6: zipalign\n'
zipalign -c -p 4 "$APK"

printf 'VERIFY 2/6: APK signature\n'
apksigner verify --verbose "$APK" | tee "$SIGN_LOG"
grep -q 'Verified using v2 scheme (APK Signature Scheme v2): true' "$SIGN_LOG"

printf 'VERIFY 3/6: install/badging metadata\n'
aapt dump badging "$APK" | tee "$BADGING_LOG"
grep -q "sdkVersion:'" "$BADGING_LOG"
grep -q "targetSdkVersion:'" "$BADGING_LOG"
grep -q "launchable-activity:" "$BADGING_LOG"
if [ -n "$EXPECTED_PACKAGE" ]; then
  grep -q "package: name='$EXPECTED_PACKAGE'" "$BADGING_LOG"
fi
if [ -n "$EXPECTED_VERSION_CODE" ]; then
  grep -q "versionCode='$EXPECTED_VERSION_CODE'" "$BADGING_LOG"
fi
if [ -n "$EXPECTED_VERSION_NAME" ]; then
  grep -q "versionName='$EXPECTED_VERSION_NAME'" "$BADGING_LOG"
fi

printf 'VERIFY 4/6: manifest XML\n'
aapt dump xmltree "$APK" AndroidManifest.xml > "$MANIFEST_LOG"
grep -q 'android:versionCode' "$MANIFEST_LOG"
grep -q 'android:versionName' "$MANIFEST_LOG"
grep -q 'android:minSdkVersion' "$MANIFEST_LOG"
grep -q 'android:targetSdkVersion' "$MANIFEST_LOG"
grep -q 'android.intent.action.MAIN' "$MANIFEST_LOG"
grep -q 'android.intent.category.LAUNCHER' "$MANIFEST_LOG"
if [ -n "$EXPECTED_PACKAGE" ]; then
  grep -q "package=\"$EXPECTED_PACKAGE\"" "$MANIFEST_LOG"
fi

printf 'VERIFY 5/6: APK contents\n'
unzip -l "$APK" > "$ZIP_LOG"
grep -q 'classes.dex' "$ZIP_LOG"
grep -q 'AndroidManifest.xml' "$ZIP_LOG"

printf 'VERIFY 6/6: size sanity\n'
SIZE=$(stat -c%s "$APK")
printf 'APK_SIZE=%s bytes\n' "$SIZE"
test "$SIZE" -gt 5000

printf 'APK_VERIFY_OK %s\n' "$APK"
