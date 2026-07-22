#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_SETUP=false
NON_INTERACTIVE=false

log() { printf '\n=== %s ===\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

usage() {
  cat <<'EOF'
Hermes Agent Android Termux installer

Usage:
  bash install.sh [--force] [--skip-setup] [--non-interactive]

Installs Hermes Agent for Android Termux.
After install, use:
  hermes

Options:
  --force            Repair/reinstall over an existing local install
  --skip-setup       Do not run interactive `hermes setup` after install
  --non-interactive  Do not prompt for Android storage permission
  -h, --help         Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force) ;;
    --skip-setup) SKIP_SETUP=true ;;
    --non-interactive) NON_INTERACTIVE=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ] || ! command -v pkg >/dev/null 2>&1; then
  echo "ERROR: This installer is intended for Termux on Android." >&2
  exit 1
fi

log "Check Termux environment"
bash "$ROOT_DIR/scripts/check-environment.sh" || true

log "Install Termux packages"
bash "$ROOT_DIR/scripts/install-termux-packages.sh"

log "Ensure Hermes-compatible Python"
bash "$ROOT_DIR/scripts/ensure-hermes-python.sh"
if [ -f "$HOME/.config/hermes-agent-termux/python.env" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.config/hermes-agent-termux/python.env"
  hash -r
fi

log "Install/repair Hermes Agent"
HERMES_VENV_REQUIRE_GLOBAL=0 bash "$ROOT_DIR/scripts/install-hermes.sh"

log "Setup Android shared storage"
if [ "$NON_INTERACTIVE" = true ]; then
  HERMES_NON_INTERACTIVE=1 bash "$ROOT_DIR/scripts/setup-storage.sh" || warn "Storage setup incomplete; run termux-setup-storage later"
else
  bash "$ROOT_DIR/scripts/setup-storage.sh" || warn "Storage setup incomplete; run termux-setup-storage later"
fi

log "Hermes provider setup"
if [ "$SKIP_SETUP" = true ]; then
  warn "Skipping interactive setup. Run 'hermes setup' later."
elif command -v hermes >/dev/null 2>&1 && hermes --version >/dev/null 2>&1; then
  echo "About to run: hermes setup"
  echo "Complete provider/model login on this phone. Do not copy auth files from another phone."
  hermes setup || warn "hermes setup did not complete; rerun 'hermes setup' later"
else
  warn "hermes command not healthy; rerun: bash install.sh --force"
fi

log "Final verification"
bash "$ROOT_DIR/verify.sh" || warn "Verification found warnings/errors"

log "Done"
echo "Hermes Agent Android Termux install finished."
echo "Start Hermes with: hermes"
