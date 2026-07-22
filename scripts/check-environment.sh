#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "Termux prefix: ${PREFIX:-missing}"
if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ]; then
  echo 'ERROR: Not running inside Termux prefix.' >&2
  exit 1
fi

printf 'pkg: '; command -v pkg || true
printf 'repo dir: '; pwd

check_cmd() {
  local c="$1"
  if command -v "$c" >/dev/null 2>&1; then
    printf 'OK command %-22s %s
' "$c" "$(command -v "$c")"
  else
    printf 'MISS command %-20s
' "$c"
  fi
}

for c in curl git python python3.13 pip node npm npx clang make rustc cargo rg ssh jq fd wget unzip tar hermes termux-setup-storage; do
  check_cmd "$c"
done

echo
if command -v python >/dev/null 2>&1; then
  python - <<'PY'
import sys
v=sys.version_info
print(f'python version: {v.major}.{v.minor}.{v.micro}')
print('python hermes compatible:', (3,11) <= v[:2] < (3,14))
PY
fi

if command -v hermes >/dev/null 2>&1; then
  hermes --version || true
else
  echo 'Hermes command missing; installer will install/repair it.'
fi

for p in "$HOME/.hermes-venv" "$HOME/storage/shared" "/storage/emulated/0" "$HOME/storage/shared/Hermes Agent Projects"; do
  if [ -e "$p" ]; then
    echo "EXISTS $p"
  else
    echo "MISSING $p"
  fi
done
