#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

if [ "${1:-}" != "--yes" ]; then
  cat <<'EOF'
This removes the Hermes Agent Android Termux install created by this repo:
- $PREFIX/bin/hermes launcher
- ~/.hermes-venv runtime/data directory
- helper Python env under ~/.config/hermes-agent-termux and ~/.local/share/hermes-agent-termux

Run with:
  bash scripts/uninstall-hermes-android-termux.sh --yes
EOF
  exit 1
fi

rm -f "$PREFIX/bin/hermes" 2>/dev/null || true
rm -rf "$HOME/.hermes-venv" 2>/dev/null || true
rm -rf "$HOME/.config/hermes-agent-termux" "$HOME/.local/share/hermes-agent-termux" 2>/dev/null || true
echo "Hermes Agent Android Termux uninstall complete."
