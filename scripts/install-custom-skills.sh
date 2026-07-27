#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SKILL_SRC="$ROOT/custom-skills"
LIB_SRC="$ROOT/custom-skills-library/awesome-design-md"
MANIFEST="$SKILL_SRC/manifest.json"
HERMES_HOME_DIR="${HERMES_HOME:-$HOME/.hermes-venv}"
SKILL_DST="$HERMES_HOME_DIR/skills"
LIB_DST="$HERMES_HOME_DIR/skill-libraries/awesome-design-md"
BACKUP_ROOT="$HERMES_HOME_DIR/backups/custom-skills-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
MODE=""
CATEGORY=""

usage() {
  cat <<'EOF'
Usage: bash scripts/install-custom-skills.sh [MODE] [--dry-run]

Modes:
  --all             Install all public-safe bundled custom skills and DESIGN.md library
  --marketing       Install marketing skills only
  --design          Install creative/design skills and DESIGN.md library
  --android         Install Android helper skills only
  --library         Install only the DESIGN.md reference library
  --category NAME   Install one category from custom-skills/ (e.g. research, productivity, omh)
  --list            List bundled categories and counts

Examples:
  bash scripts/install-custom-skills.sh --all
  bash scripts/install-custom-skills.sh --category omh
  bash scripts/install-custom-skills.sh --category productivity
  bash scripts/install-custom-skills.sh --design
  bash scripts/install-custom-skills.sh --all --dry-run
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all|--marketing|--design|--android|--library|--list) MODE="$1" ;;
    --category)
      MODE="--category"
      shift
      CATEGORY="${1:-}"
      [ -n "$CATEGORY" ] || { echo "Missing category name" >&2; exit 2; }
      ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

if [ -z "$MODE" ]; then
  echo "Missing install mode." >&2
  usage
  exit 2
fi

[ -d "$SKILL_SRC" ] || { echo "Missing custom skills folder: $SKILL_SRC" >&2; exit 1; }
[ -f "$MANIFEST" ] || { echo "Missing manifest: $MANIFEST" >&2; exit 1; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

list_categories() {
  python - "$MANIFEST" <<'PY'
from pathlib import Path
import json, sys
m=json.loads(Path(sys.argv[1]).read_text())
print('Bundled custom skills:')
for k,v in sorted(m.get('counts',{}).items()):
    if k.startswith('total_') or k == 'awesome_design_md_files':
        continue
    print(f'  {k}: {v}')
print(f"Total skills: {m['counts']['total_skills']}")
print(f"Total files:  {m['counts']['total_files']}")
print(f"DESIGN.md library entries: {m['counts']['awesome_design_md_files']}")
PY
}

copy_skill_dir() {
  local rel="$1"
  local src="$SKILL_SRC/$rel"
  local dst="$SKILL_DST/$rel"
  [ -f "$src/SKILL.md" ] || { echo "Missing SKILL.md: $src" >&2; exit 1; }
  if [ -e "$dst" ]; then
    run mkdir -p "$BACKUP_ROOT/$(dirname "$rel")"
    run rm -rf "$BACKUP_ROOT/$rel"
    run mv "$dst" "$BACKUP_ROOT/$rel"
  fi
  run mkdir -p "$(dirname "$dst")"
  run cp -a "$src" "$dst"
  echo "installed skill: $rel"
}

copy_category() {
  local cat="$1"
  [ -d "$SKILL_SRC/$cat" ] || { echo "Unknown or empty category: $cat" >&2; exit 1; }
  while IFS= read -r -d '' skill_md; do
    local rel
    rel="${skill_md#$SKILL_SRC/}"
    rel="${rel%/SKILL.md}"
    copy_skill_dir "$rel"
  done < <(find "$SKILL_SRC/$cat" -name SKILL.md -type f -print0 | sort -z)
}

install_all_categories() {
  while IFS= read -r -d '' catdir; do
    local cat
    cat="$(basename "$catdir")"
    [ "$cat" = "manifest.json" ] && continue
    copy_category "$cat"
  done < <(find "$SKILL_SRC" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
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
  --list)
    list_categories
    exit 0
    ;;
  --all)
    install_all_categories
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
  --category)
    copy_category "$CATEGORY"
    ;;
  --library)
    install_library
    ;;
esac

if [ "$DRY_RUN" -eq 0 ]; then
  echo
  echo "Verifying custom skills pack..."
  bash "$ROOT/scripts/verify-custom-skills.sh" || true
  echo
  echo "Done. Start a fresh Hermes session if a running session does not auto-load the new skills."
  if [ -d "$BACKUP_ROOT" ]; then
    echo "Backups, if any: $BACKUP_ROOT"
  fi
else
  echo "Dry run complete. No files changed."
fi
