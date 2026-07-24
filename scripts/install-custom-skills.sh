#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SKILL_SRC="$ROOT/custom-skills"
LIB_SRC="$ROOT/custom-skills-library/awesome-design-md"
HERMES_HOME_DIR="${HERMES_HOME:-$HOME/.hermes-venv}"
SKILL_DST="$HERMES_HOME_DIR/skills"
LIB_DST="$HERMES_HOME_DIR/skill-libraries/awesome-design-md"
BACKUP_ROOT="$HERMES_HOME_DIR/backups/custom-skills-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
MODE=""

usage() {
  cat <<'EOF'
Usage: bash scripts/install-custom-skills.sh [MODE] [--dry-run]

Modes:
  --all        Install all custom skills and the DESIGN.md library
  --marketing  Install marketing/SEO custom skills only
  --design     Install design/UI/UX custom skills and the DESIGN.md library
  --android    Install Android helper custom skills only
  --library    Install only the custom skills reference library

Examples:
  bash scripts/install-custom-skills.sh --all
  bash scripts/install-custom-skills.sh --design
  bash scripts/install-custom-skills.sh --marketing
  bash scripts/install-custom-skills.sh --library
  bash scripts/install-custom-skills.sh --all --dry-run
EOF
}

for arg in "$@"; do
  case "$arg" in
    --all|--marketing|--design|--android|--library) MODE="$arg" ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; usage; exit 2 ;;
  esac
done

if [ -z "$MODE" ]; then
  echo "Missing install mode." >&2
  usage
  exit 2
fi

if [ ! -d "$SKILL_SRC" ]; then
  echo "Missing custom skills folder: $SKILL_SRC" >&2
  exit 1
fi

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

copy_skill_dir() {
  local cat="$1"
  local name="$2"
  local src="$SKILL_SRC/$cat/$name"
  local dst="$SKILL_DST/$cat/$name"
  [ -f "$src/SKILL.md" ] || { echo "Missing SKILL.md: $src" >&2; exit 1; }
  if [ -e "$dst" ]; then
    run mkdir -p "$BACKUP_ROOT/$cat"
    run rm -rf "$BACKUP_ROOT/$cat/$name"
    run mv "$dst" "$BACKUP_ROOT/$cat/$name"
  fi
  run mkdir -p "$SKILL_DST/$cat"
  run cp -a "$src" "$dst"
  echo "installed skill: $cat/$name"
}

copy_category() {
  local cat="$1"
  [ -d "$SKILL_SRC/$cat" ] || return 0
  while IFS= read -r -d '' skill_dir; do
    copy_skill_dir "$cat" "$(basename "$skill_dir")"
  done < <(find "$SKILL_SRC/$cat" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

install_library() {
  [ -d "$LIB_SRC" ] || { echo "Missing library folder: $LIB_SRC" >&2; exit 1; }
  if [ -e "$LIB_DST" ]; then
    run mkdir -p "$BACKUP_ROOT/skill-libraries"
    run rm -rf "$BACKUP_ROOT/skill-libraries/awesome-design-md"
    run mv "$LIB_DST" "$BACKUP_ROOT/skill-libraries/awesome-design-md"
  fi
  run mkdir -p "$(dirname "$LIB_DST")"
  run cp -a "$LIB_SRC" "$LIB_DST"
  echo "installed library: $LIB_DST"
}

case "$MODE" in
  --all)
    copy_category marketing
    copy_category creative
    copy_category android
    install_library
    ;;
  --marketing)
    copy_category marketing
    ;;
  --design)
    copy_category creative
    install_library
    ;;
  --android)
    copy_category android
    ;;
  --library)
    install_library
    ;;
esac

if [ "$DRY_RUN" -eq 0 ]; then
  echo
  echo "Verifying custom skills..."
  bash "$ROOT/scripts/verify-custom-skills.sh" --installed || true
  echo
  echo "Done. Start a fresh Hermes session if a running session does not auto-load the new skills."
  if [ -d "$BACKUP_ROOT" ]; then
    echo "Backups, if any: $BACKUP_ROOT"
  fi
else
  echo "Dry run complete. No files changed."
fi
