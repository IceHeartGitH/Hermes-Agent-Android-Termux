#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

YES=0
PURGE_PACKAGES=0

usage() {
  cat <<'EOF'
Reset Hermes Agent Android Termux install.

Usage:
  bash scripts/reset-termux-clean.sh [--yes] [--purge-packages]

Options:
  --yes             Do not ask for confirmation
  --purge-packages  Also remove common Termux packages installed for Hermes
  -h, --help        Show this help

By default this removes the Hermes runtime and helper files, but keeps Termux
packages such as git, python, nodejs, rust, and build tools.

Use --purge-packages only when you want to return Termux close to a fresh app
state and you do not need those packages for other work.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --yes) YES=1 ;;
    --purge-packages) PURGE_PACKAGES=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ] || ! command -v pkg >/dev/null 2>&1; then
  echo "ERROR: This script is intended for Termux on Android." >&2
  exit 1
fi

if [ "$YES" != 1 ]; then
  echo "This will remove the Hermes Agent Android Termux installation."
  if [ "$PURGE_PACKAGES" = 1 ]; then
    echo "It will also remove common Termux packages installed for Hermes."
  fi
  printf 'Type RESET to continue: '
  read -r answer
  if [ "$answer" != RESET ]; then
    echo "Cancelled."
    exit 1
  fi
fi

REPO_DIR="$HOME/Hermes-Agent-Android-Termux"

rm -f "$PREFIX/bin/hermes" 2>/dev/null || true
rm -rf "$HOME/.hermes-venv" 2>/dev/null || true
rm -rf "$HOME/.config/hermes-agent-termux" "$HOME/.local/share/hermes-agent-termux" 2>/dev/null || true

if [ "$PURGE_PACKAGES" = 1 ]; then
  pkg uninstall -y \
    git curl wget jq fd ripgrep openssh \
    python python-pip python-cryptography python-psutil python-lxml \
    nodejs npm \
    clang make rust pkg-config libffi openssl ca-certificates \
    libxml2 libxslt \
    unzip tar \
    2>/dev/null || true
fi

pkg autoremove -y 2>/dev/null || true

if [ -d "$REPO_DIR" ]; then
  rm -rf "$REPO_DIR" 2>/dev/null || true
fi

echo "Hermes Agent Android Termux reset complete."
echo "Termux app remains installed."
