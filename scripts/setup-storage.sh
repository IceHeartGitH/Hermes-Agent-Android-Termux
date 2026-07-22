#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

NON_INTERACTIVE="${HERMES_NON_INTERACTIVE:-0}"

storage_ready() {
  [ -d "$HOME/storage/shared" ] && [ -r "$HOME/storage/shared" ] && [ -x "$HOME/storage/shared" ]
}

if storage_ready; then
  echo "Android shared storage already available: $HOME/storage/shared"
elif [ "$NON_INTERACTIVE" = 1 ]; then
  echo 'WARN: shared storage not ready and non-interactive mode is enabled; run termux-setup-storage later.' >&2
else
  if command -v termux-setup-storage >/dev/null 2>&1; then
    echo "Running termux-setup-storage. Confirm the Android permission popup if shown."
    termux-setup-storage || true
    echo "Press Enter after confirming storage permission, or Ctrl+C to stop."
    read -r _ || true
  else
    echo 'WARN: termux-setup-storage command missing.' >&2
  fi
fi

if storage_ready; then
  mkdir -p "$HOME/storage/shared/Hermes Agent Projects"
  mkdir -p "$HOME/storage/shared/Hermes Agent Projects/Bootstrap Logs"
  mkdir -p "$HOME/storage/shared/Hermes Agent Projects/Templates"
else
  mkdir -p "$HOME/Hermes Agent Projects"
fi

for p in "$HOME/storage/shared" /storage/emulated/0 "$HOME/storage/downloads"; do
  [ -d "$p" ] && [ -r "$p" ] && [ -x "$p" ] && echo "OK storage: $p" || echo "WARN storage: $p"
done
