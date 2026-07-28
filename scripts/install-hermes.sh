#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

python_env="$HOME/.config/hermes-agent-termux/python.env"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer_url="https://hermes-agent.nousresearch.com/install.sh"
venv_home="${HERMES_VENV_HOME:-$HOME/.hermes-venv}"
venv_install_dir="${HERMES_VENV_INSTALL_DIR:-$venv_home/hermes-agent}"
installer_tmp=""
backup_dir=""
require_global="0"

cleanup() {
  [ -n "$installer_tmp" ] && rm -f "$installer_tmp"
  if [ -n "$backup_dir" ] && [ -d "$backup_dir" ]; then
    rm -rf "$backup_dir"
  fi
}
trap cleanup EXIT

log() { printf '\n=== %s ===\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

python_ok() {
  "$1" - <<'PY'
import sys
raise SystemExit(0 if (3, 11) <= sys.version_info[:2] < (3, 14) else 1)
PY
}

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ] || ! command -v pkg >/dev/null 2>&1; then
  fail "This script is intended for Termux on Android."
fi

if [ -f "$python_env" ]; then
  # shellcheck disable=SC1090
  . "$python_env"
  hash -r
fi

if [ -z "${UV_PYTHON:-}" ] || [ ! -x "${UV_PYTHON:-}" ] || ! python_ok "$UV_PYTHON"; then
  fail "UV_PYTHON is not set to a Hermes-compatible interpreter. Run: bash scripts/ensure-hermes-python.sh"
fi

if [ -z "${HERMES_PYTHON:-}" ] || [ ! -x "${HERMES_PYTHON:-}" ] || ! python_ok "$HERMES_PYTHON"; then
  export HERMES_PYTHON="$UV_PYTHON"
fi

export HERMES_PYTHON
export PYTHON="$HERMES_PYTHON"
export PYTHON_PATH="$HERMES_PYTHON"
export PYTHON_VERSION="$($HERMES_PYTHON - <<'PY'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
PY
)"
export UV_PYTHON="$HERMES_PYTHON"
export HERMES_HOME="$venv_home"
export HERMES_INSTALL_DIR="$venv_install_dir"
export ANDROID_API_LEVEL="${ANDROID_API_LEVEL:-$(getprop ro.build.version.sdk 2>/dev/null || echo 34)}"
export CARGO_BUILD_JOBS="${CARGO_BUILD_JOBS:-1}"
export CARGO_NET_RETRY="${CARGO_NET_RETRY:-5}"
export MAKEFLAGS="${MAKEFLAGS:--j1}"
export RUSTFLAGS="${RUSTFLAGS:--C codegen-units=1}"
export PIP_NO_INPUT="${PIP_NO_INPUT:-1}"
export PATH="$HOME/.local/share/hermes-agent-termux/python-bin:$PATH"
hash -r

log "Preparing Hermes Agent for Android Termux"
echo "Hermes home:       $HERMES_HOME"
echo "Hermes install:    $HERMES_INSTALL_DIR"
echo "Using Python:      $HERMES_PYTHON ($($HERMES_PYTHON --version 2>&1))"
echo "Forced PYTHON_PATH: $PYTHON_PATH"
echo "Forced PYTHON_VERSION: $PYTHON_VERSION"
mkdir -p "$HERMES_HOME"

tmp_base="${TMPDIR:-${PREFIX:?PREFIX is not set}/tmp}"
mkdir -p "$tmp_base"
backup_dir="$(mktemp -d "$tmp_base/hermes-entrypoints-XXXXXX")"
for name in hermes hermes-agent; do
  if [ -e "$PREFIX/bin/$name" ] || [ -L "$PREFIX/bin/$name" ]; then
    cp -a "$PREFIX/bin/$name" "$backup_dir/$name"
  fi
done

restore_previous_entrypoints() {
  for name in hermes hermes-agent; do
    if [ -e "$backup_dir/$name" ] || [ -L "$backup_dir/$name" ]; then
      cp -a "$backup_dir/$name" "$PREFIX/bin/$name"
      chmod +x "$PREFIX/bin/$name" 2>/dev/null || true
    else
      rm -f "$PREFIX/bin/$name" 2>/dev/null || true
    fi
  done
  hash -r
}

log "Downloading official Hermes installer"
installer_tmp="$(mktemp "$tmp_base/hermes-official-install-XXXXXX.sh")"
curl -fsSL "$installer_url" -o "$installer_tmp"

"$HERMES_PYTHON" - "$installer_tmp" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
needle = '''    if [ "$DISTRO" = "termux" ]; then
        log_info "Checking Termux Python..."
'''
patch = '''    if [ "$DISTRO" = "termux" ]; then
        log_info "Checking Termux Python (Hermes requires >=3.11,<3.14)..."
        for candidate in "${HERMES_PYTHON:-}" "${UV_PYTHON:-}" python3.13 python3.12 python3.11 python3 python; do
            [ -n "$candidate" ] || continue
            if command -v "$candidate" >/dev/null 2>&1; then
                candidate_path="$(command -v "$candidate")"
            elif [ -x "$candidate" ]; then
                candidate_path="$candidate"
            else
                continue
            fi
            if "$candidate_path" -c 'import sys; raise SystemExit(0 if (3, 11) <= sys.version_info[:2] < (3, 14) else 1)' 2>/dev/null; then
                PYTHON_PATH="$candidate_path"
                PYTHON_FOUND_VERSION="$("$PYTHON_PATH" --version 2>/dev/null)"
                PYTHON_VERSION="$("$PYTHON_PATH" - <<'PYVER'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
PYVER
)"
                export HERMES_PYTHON="$PYTHON_PATH"
                export PYTHON_PATH
                export PYTHON_VERSION
                export UV_PYTHON="$PYTHON_PATH"
                log_success "Python found: $PYTHON_FOUND_VERSION ($PYTHON_PATH; PYTHON_VERSION=$PYTHON_VERSION)"
                return 0
            fi
        done
        log_error "No Hermes-compatible Python found; need >=3.11,<3.14"
        log_info "Run: bash scripts/ensure-hermes-python.sh"
        exit 1
'''
if needle not in s:
    raise SystemExit('official installer shape changed: Termux check_python anchor not found')
p.write_text(s.replace(needle, patch, 1))
PY

patch_termux_fast_cli_project_root() {
  "$HERMES_INSTALL_DIR/venv/bin/python" - <<'PY'
from pathlib import Path
import os
path = Path(os.environ['HERMES_INSTALL_DIR']) / 'hermes_cli' / 'main.py'
if not path.exists():
    print(f'No Termux fast CLI PROJECT_ROOT patch target found: {path}')
    raise SystemExit(0)
text = path.read_text()
if 'print(f"Install directory: {PROJECT_ROOT}")' not in text:
    print('No Termux fast CLI PROJECT_ROOT patch needed')
    raise SystemExit(0)
first_use = text.find('print(f"Install directory: {PROJECT_ROOT}")')
first_def = text.find('PROJECT_ROOT = Path(__file__).parent.parent.resolve()')
if first_def != -1 and first_def < first_use:
    print('No Termux fast CLI PROJECT_ROOT patch needed')
    raise SystemExit(0)
marker = 'import sys\n'
insert = "import sys\n\n# Termux fast --version path uses PROJECT_ROOT before the later Path-based definition.\nPROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))\n"
if marker not in text:
    raise SystemExit(f'Cannot patch {path}: import sys marker not found')
path.write_text(text.replace(marker, insert, 1))
print(f'Patched Termux fast CLI PROJECT_ROOT bug: {path}')
PY
}

write_hermes_launcher_file() {
  local launcher="$1"
  local hermes_bin="$HERMES_INSTALL_DIR/venv/bin/hermes"
  [ -x "$hermes_bin" ] || fail "Hermes entrypoint missing: $hermes_bin"
  cat > "$launcher" <<EOF
#!/usr/bin/env bash
unset PYTHONPATH
unset PYTHONHOME
export HERMES_HOME="$HERMES_HOME"
export HERMES_INSTALL_DIR="$HERMES_INSTALL_DIR"
exec "$hermes_bin" "\$@"
EOF
  chmod +x "$launcher"
  echo "Installed Hermes launcher: $launcher -> $hermes_bin"
}

install_hermes_launcher() {
  # Public repo model: users only need the `hermes` command.
  write_hermes_launcher_file "$PREFIX/bin/hermes"
}

bash -n "$installer_tmp"
log "Verifying patched official installer uses pinned Hermes Python"
if ! grep -F 'PYTHON_VERSION="$(' "$installer_tmp" >/dev/null || ! grep -F 'Hermes requires >=3.11,<3.14' "$installer_tmp" >/dev/null; then
  fail "Patched official installer does not contain the strict Termux Python guard."
fi
log "Installing/repairing Hermes Agent via patched official installer"
if ! PYTHON_PATH="$HERMES_PYTHON" PYTHON_VERSION="$PYTHON_VERSION" UV_PYTHON="$HERMES_PYTHON" HERMES_PYTHON="$HERMES_PYTHON" bash "$installer_tmp" --skip-setup --dir "$HERMES_INSTALL_DIR" --hermes-home "$HERMES_HOME"; then
  restore_previous_entrypoints
  fail "Official Hermes install failed; restored previous hermes entrypoints."
fi

patch_termux_fast_cli_project_root
restore_previous_entrypoints
install_hermes_launcher
hash -r

log "Installing lightweight runtime helper"
"$HERMES_INSTALL_DIR/venv/bin/python" -m pip install --disable-pip-version-check 'duckduckgo_search==3.9.11'


log "Verifying Hermes command"
command -v hermes >/dev/null 2>&1 || fail "hermes command missing after install"
hermes --version | sed -n '1,8p'
case "$(hermes --version 2>&1)" in
  *"$HERMES_INSTALL_DIR"*) ;;
  *) fail "hermes --version did not report expected install dir" ;;
esac

echo "Hermes command ready."
echo "Command:      hermes"
echo "Hermes data:  $HERMES_HOME"
