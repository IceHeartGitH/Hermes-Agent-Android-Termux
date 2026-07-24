#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
PACK="$ROOT/custom-skills"
LIB="$ROOT/custom-skills-library/awesome-design-md"
INSTALLED=0
if [ "${1:-}" = "--installed" ]; then INSTALLED=1; fi
HERMES_HOME_DIR="${HERMES_HOME:-$HOME/.hermes-venv}"

count_pack_skills() {
  find "$PACK" -mindepth 3 -maxdepth 3 -name SKILL.md -type f 2>/dev/null | wc -l | tr -d ' '
}

count_pack_category() {
  local cat="$1"
  find "$PACK/$cat" -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | wc -l | tr -d ' '
}

count_design_md() {
  find "$LIB" -name DESIGN.md -type f 2>/dev/null | wc -l | tr -d ' '
}

validate_frontmatter() {
  python - "$PACK" <<'PY'
from pathlib import Path
import re, sys
root=Path(sys.argv[1])
errors=[]
for p in sorted(root.glob('*/*/SKILL.md')):
    t=p.read_text(encoding='utf-8')
    if not t.startswith('---'):
        errors.append(f'{p}: missing opening frontmatter')
        continue
    m=re.search(r'\n---\s*\n', t[3:])
    if not m:
        errors.append(f'{p}: missing closing frontmatter')
        continue
    fm=t[3:m.start()+3]
    if not re.search(r'^name:\s*\S+', fm, re.M): errors.append(f'{p}: missing name')
    desc=re.search(r'^description:\s*(.+)$', fm, re.M)
    if not desc: errors.append(f'{p}: missing description')
    elif len(desc.group(1))>1024: errors.append(f'{p}: description too long')
    if len(t)>100000: errors.append(f'{p}: file too large')
if errors:
    print('\n'.join(errors))
    sys.exit(1)
print('SKILL_FRONTMATTER_OK')
PY
}

secret_scan() {
  local hits
  hits=$(grep -RInE 'auth\.json|GITHUB_TOKEN=[^[:space:]]+|OPENROUTER_API_KEY=[^[:space:]]+|ANTHROPIC_API_KEY=[^[:space:]]+|OPENAI_API_KEY=[^[:space:]]+|(^|[^A-Za-z0-9_-])sk-[A-Za-z0-9_-]{32,}|ghp_[A-Za-z0-9_]{30,}' "$PACK" "$ROOT/custom-skills-library" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "SECRET_SCAN_FAILED"
    echo "$hits"
    return 1
  fi
  echo "SECRET_SCAN_OK"
}

path_scan() {
  local hits
  hits=$(grep -RInE '/storage/emulated/0/Obsidian[ ]Brain|/data/data/com\.termux/files/home/\.hermes-venv/auth|\.config/gh/hosts\.yml' "$PACK" "$ROOT/custom-skills-library" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "PRIVATE_PATH_SCAN_FAILED"
    echo "$hits"
    return 1
  fi
  echo "PRIVATE_PATH_SCAN_OK"
}

printf '=== Pack counts ===\n'
printf 'marketing=%s\n' "$(count_pack_category marketing)"
printf 'design=%s\n' "$(count_pack_category creative)"
printf 'android=%s\n' "$(count_pack_category android)"
printf 'total_skills=%s\n' "$(count_pack_skills)"
printf 'design_md=%s\n' "$(count_design_md)"

[ "$(count_pack_category marketing)" = "34" ]
[ "$(count_pack_category creative)" = "21" ]
[ "$(count_pack_category android)" = "1" ]
[ "$(count_pack_skills)" = "56" ]
[ "$(count_design_md)" = "74" ]

printf '\n=== Validation ===\n'
validate_frontmatter
secret_scan
path_scan

if [ "$INSTALLED" -eq 1 ]; then
  printf '\n=== Installed check ===\n'
  installed=0
  while IFS= read -r -d '' skill; do
    rel="${skill#$PACK/}"
    if [ -f "$HERMES_HOME_DIR/skills/$rel/SKILL.md" ]; then installed=$((installed+1)); fi
  done < <(find "$PACK" -mindepth 2 -maxdepth 2 -type d -print0)
  printf 'installed_custom_skills=%s\n' "$installed"
  if [ -d "$HERMES_HOME_DIR/skill-libraries/awesome-design-md" ]; then
    printf 'installed_library_design_md=%s\n' "$(find "$HERMES_HOME_DIR/skill-libraries/awesome-design-md" -name DESIGN.md -type f | wc -l | tr -d ' ')"
  else
    printf 'installed_library_design_md=0\n'
  fi
fi

echo
printf 'CUSTOM_SKILLS_VERIFY_OK\n'
