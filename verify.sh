#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

section() { printf '
=== %s ===
' "$*"; }

section "Termux"
printf 'PREFIX=%s
' "${PREFIX:-missing}"
command -v pkg >/dev/null 2>&1 && echo "OK pkg" || echo "WARN pkg missing"

section "Python"
if command -v python >/dev/null 2>&1; then
  python --version
  python - <<'PY'
import sys
ok=(3,11) <= sys.version_info[:2] < (3,14)
print('Hermes-compatible Python:', ok)
raise SystemExit(0 if ok else 1)
PY
else
  echo "ERROR: python missing" >&2
  exit 1
fi

section "Hermes"
command -v hermes >/dev/null 2>&1 || { echo "ERROR: hermes command missing" >&2; exit 1; }
hermes --version | sed -n '1,12p'
case "$(hermes --version 2>&1)" in
  *"$HOME/.hermes-venv/hermes-agent"*) echo "OK hermes uses Android Termux install path" ;;
  *) echo "WARN: hermes did not report expected install path $HOME/.hermes-venv/hermes-agent" >&2 ;;
esac

section "Storage"
[ -d "$HOME/storage/shared" ] && echo "OK shared storage" || echo "WARN shared storage missing; run termux-setup-storage"

echo

echo "VERIFY_DONE"
