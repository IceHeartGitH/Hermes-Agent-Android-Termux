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
  echo "OK storage: $HOME/storage/shared"
else
  echo "WARN storage: $HOME/storage/shared"
fi
