#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SKILL_SRC="$ROOT/custom-skills"
DESIGN_LIB_SRC="$ROOT/custom-skills-library/awesome-design-md"
CRITERIA_LIB_SRC="$ROOT/custom-skills-library/google-seo-geo-criteria-bank"
MANIFEST="$SKILL_SRC/manifest.json"
HERMES_HOME_DIR="${HERMES_HOME:-$HOME/.hermes-venv}"
SKILL_DST="$HERMES_HOME_DIR/skills"
LIB_ROOT_DST="$HERMES_HOME_DIR/skill-libraries"
DESIGN_LIB_DST="$LIB_ROOT_DST/awesome-design-md"
CRITERIA_LIB_DST="$LIB_ROOT_DST/google-seo-geo-criteria-bank"
BACKUP_ROOT="$HERMES_HOME_DIR/backups/custom-skills-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
MODE=""
CATEGORY=""

usage() {
  cat <<'EOF'
Usage: bash scripts/install-custom-skills.sh [MODE] [--dry-run]

Modes:
  --all             Install all public-safe bundled custom skills and bundled libraries
  --marketing       Install marketing skills only
  --seo-geo         Install Google SEO/GEO inspection skills and criteria bank library
  --design          Install creative/design skills and DESIGN.md library
  --android         Install Android helper skills only
  --library         Install all bundled reference libraries
  --design-library  Install only the DESIGN.md reference library
  --criteria-library Install only the Google SEO/GEO criteria bank library
  --category NAME   Install one category from custom-skills/ (e.g. research, productivity, omh)
  --list            List bundled categories and counts

Examples:
  bash scripts/install-custom-skills.sh --all
  bash scripts/install-custom-skills.sh --seo-geo
  bash scripts/install-custom-skills.sh --category omh
  bash scripts/install-custom-skills.sh --category productivity
  bash scripts/install-custom-skills.sh --design
  bash scripts/install-custom-skills.sh --all --dry-run
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all|--marketing|--seo-geo|--design|--android|--library|--design-library|--criteria-library|--list) MODE="$1" ;;
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
print(f"Google SEO/GEO criteria files: {m['counts'].get('google_seo_geo_criteria_files', 0)}")
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

copy_library_dir() {
  local src="$1"
  local dst="$2"
  local name="$3"
  [ -d "$src" ] || { echo "Missing library folder: $src" >&2; exit 1; }
  if [ -e "$dst" ]; then
    run mkdir -p "$BACKUP_ROOT/skill-libraries"
    run rm -rf "$BACKUP_ROOT/skill-libraries/$name"
    run mv "$dst" "$BACKUP_ROOT/skill-libraries/$name"
  fi
  run mkdir -p "$(dirname "$dst")"
  run cp -a "$src" "$dst"
  echo "installed library: $dst"
}

install_design_library() {
  copy_library_dir "$DESIGN_LIB_SRC" "$DESIGN_LIB_DST" "awesome-design-md"
}

install_criteria_library() {
  copy_library_dir "$CRITERIA_LIB_SRC" "$CRITERIA_LIB_DST" "google-seo-geo-criteria-bank"
}

install_all_libraries() {
  install_design_library
  install_criteria_library
}

install_seo_geo_pack() {
  copy_skill_dir "marketing/google-seo-site-inspector"
  copy_skill_dir "marketing/google-geo-site-inspector"
  copy_skill_dir "marketing/google-seo-geo-site-inspector"
  install_criteria_library
}

case "$MODE" in
  --list)
    list_categories
    exit 0
    ;;
  --all)
    install_all_categories
    install_all_libraries
    ;;
  --marketing)
    copy_category marketing
    ;;
  --seo-geo)
    install_seo_geo_pack
    ;;
  --design)
    copy_category creative
    install_design_library
    ;;
  --android)
    copy_category android
    ;;
  --category)
    copy_category "$CATEGORY"
    ;;
  --library)
    install_all_libraries
    ;;
  --design-library)
    install_design_library
    ;;
  --criteria-library)
    install_criteria_library
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
