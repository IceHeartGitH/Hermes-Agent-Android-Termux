#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

need_python="Python >=3.11,<3.14"
state_dir="$HOME/.config/hermes-agent-termux"
shim_dir="$HOME/.local/share/hermes-agent-termux/python-bin"
env_file="$state_dir/python.env"
termux_snapshot_base="https://termux.net/debs/stable"
pinned_python_version="3.13.13-1"
pinned_pip_version="26.1.2"

version_tuple() {
  "$1" - <<'PY'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")
PY
}

version_status() {
  if ! "$1" - <<'PY'
import sys
v = sys.version_info
if v < (3, 11):
    print('too_old')
elif v >= (3, 14):
    print('too_new')
else:
    print('ok')
PY
  then
    print_broken_python_message "$1" >&2
    echo 'broken'
  fi
}

android_sdk() {
  getprop ro.build.version.sdk 2>/dev/null || echo 0
}

print_broken_python_message() {
  local py="$1"
  echo "ERROR: Python executable is present but cannot run: $py"
  echo "Output: $($py --version 2>&1 || true)"
}

check_pinned_python_runtime_compatible() {
  local sdk
  sdk="$(android_sdk)"
  case "$sdk" in ''|*[!0-9]*) sdk=0 ;; esac
  if [ "$sdk" -lt 30 ]; then
    echo "ERROR: This Android build reports SDK $sdk. The pinned Termux Python $pinned_python_version package may require libc symbols such as memfd_create that are unavailable on older Android builds." >&2
    echo "Do not continue with this pinned package path on this device. Use a newer Android/Termux base or a device-specific Python strategy." >&2
    exit 1
  fi
}

show_python() {
  if command -v python >/dev/null 2>&1; then
    printf 'python=%s -> %s\n' "$(command -v python)" "$(python --version 2>&1)"
  else
    echo 'python=missing'
  fi
  if command -v python3 >/dev/null 2>&1; then
    printf 'python3=%s -> %s\n' "$(command -v python3)" "$(python3 --version 2>&1)"
  fi
  if command -v python3.13 >/dev/null 2>&1; then
    printf 'python3.13=%s -> %s\n' "$(command -v python3.13)" "$(python3.13 --version 2>&1)"
  fi
  dpkg-query -W -f='${Package} ${Version}\n' python python-ensurepip-wheels python-pip 2>/dev/null || true
}

sha256_check() {
  local expected="$1"
  local file="$2"
  local actual
  actual="$(sha256sum "$file" | awk '{print $1}')"
  if [ "$actual" != "$expected" ]; then
    echo "ERROR: SHA256 mismatch for $file" >&2
    echo "expected: $expected" >&2
    echo "actual:   $actual" >&2
    exit 1
  fi
}

hold_python_packages() {
  apt-mark hold python python-ensurepip-wheels python-pip >/dev/null 2>&1 || true
}

remove_conflicting_side_by_side_python313() {
  # Some failed/retried installs leave Termux's side-by-side `python3.13`
  # package installed. The main `python` 3.13.13 package and
  # `python-ensurepip-wheels` then conflict with files owned by `python3.13`,
  # e.g. ensurepip's bundled pip wheel. Remove the side-by-side package before
  # installing the pinned main Python set.
  if dpkg-query -W -f='${Status}' python3.13 2>/dev/null | grep -q 'install ok installed'; then
    echo "WARN: removing conflicting side-by-side Termux package python3.13 before installing pinned main python." >&2
    apt-mark unhold python3.13 >/dev/null 2>&1 || true
    apt remove -y python3.13 || dpkg --remove --force-depends python3.13
  fi
}

install_pinned_termux_python313() {
  local arch tmpdir python_deb wheels_deb pip_deb
  arch="$(dpkg --print-architecture)"
  case "$arch" in
    aarch64|arm|i686|x86_64) ;;
    *)
      echo "ERROR: unsupported Termux architecture for pinned Python: $arch" >&2
      exit 1
      ;;
  esac

  check_pinned_python_runtime_compatible
  echo "Installing pinned Termux Python $pinned_python_version from working snapshot ($arch)..."
  tmpdir="$(mktemp -d /data/data/com.termux/files/usr/tmp/hermes-python313-XXXXXX)"
  python_deb="$tmpdir/python_${pinned_python_version}_${arch}.deb"
  wheels_deb="$tmpdir/python-ensurepip-wheels_${pinned_python_version}_all.deb"
  pip_deb="$tmpdir/python-pip_${pinned_pip_version}_all.deb"

  curl -fL "$termux_snapshot_base/$arch/p/python/python_${pinned_python_version}_${arch}.deb" -o "$python_deb"
  curl -fL "$termux_snapshot_base/all/p/python-ensurepip-wheels/python-ensurepip-wheels_${pinned_python_version}_all.deb" -o "$wheels_deb"
  curl -fL "$termux_snapshot_base/all/p/python-pip/python-pip_${pinned_pip_version}_all.deb" -o "$pip_deb"

  case "$arch" in
    aarch64)
      sha256_check a0c616c13befdf48e2cfd9b201859d0cef6f43a8b68cc8622a7dae0836a6bc45 "$python_deb"
      ;;
    *)
      echo "WARN: no embedded SHA256 for python $arch; relying on HTTPS download." >&2
      ;;
  esac
  sha256_check 637be030e461ac4c3239b20ca926e5e46285fd2f88d8ccf61385bc29e8657194 "$wheels_deb"
  sha256_check 5f34382fa79a4e46585b3cdfbc6138439ca9298242eaca1025dd2ddaaa1083c8 "$pip_deb"

  remove_conflicting_side_by_side_python313
  apt-mark unhold python python-ensurepip-wheels python-pip >/dev/null 2>&1 || true

  if ! apt install -y --allow-downgrades "$python_deb" "$wheels_deb" "$pip_deb"; then
    echo "WARN: apt resolver could not install the pinned Python set directly; retrying with dpkg forced local downgrade." >&2
    echo "WARN: This handles fresh Termux states where apt tries to keep/select repo Python 3.14 while python-ensurepip-wheels requires 3.13.13-1." >&2
    dpkg -i --force-downgrade --force-overwrite "$python_deb" "$wheels_deb" "$pip_deb" || true
    apt-get -y -f install --allow-downgrades || true
    dpkg -i --force-downgrade --force-overwrite "$python_deb" "$wheels_deb" "$pip_deb"
  fi

  local installed_python installed_wheels installed_pip
  installed_python="$(dpkg-query -W -f='${Version}' python 2>/dev/null || true)"
  installed_wheels="$(dpkg-query -W -f='${Version}' python-ensurepip-wheels 2>/dev/null || true)"
  installed_pip="$(dpkg-query -W -f='${Version}' python-pip 2>/dev/null || true)"
  if [ "$installed_python" != "$pinned_python_version" ] || [ "$installed_wheels" != "$pinned_python_version" ] || [ "$installed_pip" != "$pinned_pip_version" ]; then
    echo "ERROR: pinned Python transaction did not end at the required versions." >&2
    echo "python=$installed_python expected=$pinned_python_version" >&2
    echo "python-ensurepip-wheels=$installed_wheels expected=$pinned_python_version" >&2
    echo "python-pip=$installed_pip expected=$pinned_pip_version" >&2
    echo "Try: apt-mark unhold python python-ensurepip-wheels python-pip && bash scripts/ensure-hermes-python.sh" >&2
    exit 1
  fi

  hold_python_packages
  rm -rf "$tmpdir"
  hash -r
}

configure_hermes_python_env() {
  local py="$1"
  local py_abs
  py_abs="$(command -v "$py")"

  if [ "$(version_status "$py_abs")" != ok ]; then
    echo "ERROR: selected Hermes Python is not compatible: $py_abs -> $($py_abs --version 2>&1)" >&2
    exit 1
  fi

  mkdir -p "$state_dir" "$shim_dir"
  ln -sfr "$py_abs" "$shim_dir/python"
  ln -sfr "$py_abs" "$shim_dir/python3"

  if ! "$py_abs" -m pip --version >/dev/null 2>&1; then
    "$py_abs" -m ensurepip --altinstall --upgrade || "$py_abs" -m ensurepip --upgrade || true
  fi

  local pip_bin=""
  local py_minor
  py_minor="$($py_abs - <<'PY'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
PY
)"
  if command -v "pip$py_minor" >/dev/null 2>&1; then
    pip_bin="$(command -v "pip$py_minor")"
    ln -sfr "$pip_bin" "$shim_dir/pip"
    ln -sfr "$pip_bin" "$shim_dir/pip3"
  else
    cat > "$shim_dir/pip" <<SH
#!/data/data/com.termux/files/usr/bin/sh
exec "$py_abs" -m pip "\$@"
SH
    cp "$shim_dir/pip" "$shim_dir/pip3"
    chmod 755 "$shim_dir/pip" "$shim_dir/pip3"
  fi

  cat > "$env_file" <<EOF
# Generated by Hermes-Agent-Android-Termux. Safe to source from shell scripts.
export HERMES_PYTHON="$py_abs"
export UV_PYTHON="$py_abs"
export PATH="$shim_dir:\$PATH"
EOF

  # Ensure python/python3 use the selected Hermes-compatible interpreter.
  ln -sfr "$py_abs" "$PREFIX/bin/python" || true
  ln -sfr "$py_abs" "$PREFIX/bin/python3" || true
  if [ -n "$pip_bin" ]; then
    ln -sfr "$pip_bin" "$PREFIX/bin/pip" || true
    ln -sfr "$pip_bin" "$PREFIX/bin/pip3" || true
  fi

  # shellcheck disable=SC1090
  . "$env_file"
  hash -r

  echo "Hermes Python env file: $env_file"
  echo "Hermes Python shim dir: $shim_dir"
  show_python

  if [ "$(version_status python)" != ok ]; then
    echo 'ERROR: default `python` is still not Hermes-compatible after Python pin/shim setup.' >&2
    exit 1
  fi
  if [ "$(version_status python3)" != ok ]; then
    echo 'ERROR: default `python3` is still not Hermes-compatible after Python pin/shim setup.' >&2
    exit 1
  fi
  hold_python_packages
  python -m pip --version || python -m ensurepip --upgrade
}

echo "Checking Hermes-compatible Python ($need_python)..."
show_python

if ! command -v python >/dev/null 2>&1; then
  echo 'Python missing; installing pinned Termux Python 3.13.13...'
  install_pinned_termux_python313
fi

status="$(version_status python)"
case "$status" in
  ok)
    configure_hermes_python_env python
    echo "OK: Termux python $(version_tuple python) is compatible with Hermes."
    exit 0
    ;;
  too_old)
    echo "ERROR: Python $(version_tuple python) is too old for Hermes; need $need_python." >&2
    exit 1
    ;;
  too_new)
    echo "WARN: Termux python $(version_tuple python) is too new for current Hermes; need $need_python."
    install_pinned_termux_python313
    ;;
  broken)
    echo "ERROR: Current python cannot execute. If the error mentions memfd_create, this device/Android build may not be compatible with the pinned Python package." >&2
    exit 1
    ;;
  *)
    echo "ERROR: Could not determine Python compatibility." >&2
    exit 1
    ;;
esac

post_pin_status="$(version_status python)"
if [ "$post_pin_status" != ok ]; then
  echo "ERROR: pinned Python install did not make default python compatible; status=$post_pin_status; output=$(python --version 2>&1 || true)" >&2
  echo "If the output mentions memfd_create, this Android build cannot run the pinned Python package." >&2
  exit 1
fi

configure_hermes_python_env python

echo "OK: Hermes-compatible Python ready: $(python --version 2>&1)"
