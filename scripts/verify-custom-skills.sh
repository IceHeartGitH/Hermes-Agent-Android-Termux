#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
PACK="$ROOT/custom-skills"
MANIFEST="$PACK/manifest.json"
LIB="$ROOT/custom-skills-library/awesome-design-md"
INSTALLED=0
if [ "${1:-}" = "--installed" ]; then INSTALLED=1; fi
HERMES_HOME_DIR="${HERMES_HOME:-$HOME/.hermes-venv}"

json_value() {
  python - "$MANIFEST" "$1" <<'PY'
from pathlib import Path
import json, sys
obj=json.loads(Path(sys.argv[1]).read_text())
cur=obj
for part in sys.argv[2].split('.'):
    cur=cur[part]
print(cur)
PY
}

count_pack_skills() {
  find "$PACK" -mindepth 2 -name SKILL.md -type f 2>/dev/null | wc -l | tr -d ' '
}

count_pack_category() {
  local cat="$1"
  find "$PACK/$cat" -mindepth 2 -name SKILL.md -type f 2>/dev/null | wc -l | tr -d ' '
}

count_pack_files() {
  find "$PACK" -type f 2>/dev/null | wc -l | tr -d ' '
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
for p in sorted(root.glob('**/SKILL.md')):
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
    if not re.search(r'^description:\s*', fm, re.M): errors.append(f'{p}: missing description')
    if len(t)>500000:
        errors.append(f'{p}: SKILL.md unexpectedly large')
if errors:
    print('\n'.join(errors))
    sys.exit(1)
print('SKILL_FRONTMATTER_OK')
PY
}

secret_scan() {
  local hits
  hits=$(grep -RInE 'auth\.json|GITHUB_TOKEN=[^[:space:]]+|OPENROUTER_API_KEY=[^[:space:]]+|ANTHROPIC_API_KEY=[^[:space:]]+|(^|[^A-Za-z0-9_-])sk-[A-Za-z0-9_-]{32,}|ghp_[A-Za-z0-9_]{30,}' "$PACK" "$ROOT/custom-skills-library" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "SECRET_SCAN_FAILED"
    echo "$hits"
    return 1
  fi
  echo "SECRET_SCAN_OK"
}

path_scan() {
  local hits
  hits=$(grep -RInE '/storage/emulated/0/(Obsidian Brain|Hermes Agent Projects)|/data/data/com\.termux/files/home/\.hermes-venv/(auth|state|sessions|memories)|\.config/gh/hosts\.yml|IceHeartGitH|S26 Ultra|Samsung S26|private repo|Obsidian Brain' "$PACK" "$ROOT/custom-skills-library" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "PRIVATE_PATH_SCAN_FAILED"
    echo "$hits"
    return 1
  fi
  echo "PRIVATE_PATH_SCAN_OK"
}

[ -f "$MANIFEST" ] || { echo "Missing manifest: $MANIFEST" >&2; exit 1; }
expected_total="$(json_value counts.total_skills)"
expected_files="$(json_value counts.total_files)"
expected_design="$(json_value counts.awesome_design_md_files)"

printf '=== Pack counts ===\n'
printf 'total_skills=%s\n' "$(count_pack_skills)"
printf 'total_files=%s\n' "$(count_pack_files)"
printf 'design_md=%s\n' "$(count_design_md)"

[ "$(count_pack_skills)" = "$expected_total" ]
[ "$(count_pack_files)" = "$expected_files" ]
[ "$(count_design_md)" = "$expected_design" ]

printf '\n=== Categories ===\n'
python - "$MANIFEST" "$PACK" <<'PY'
from pathlib import Path
import json, sys, subprocess
manifest=json.loads(Path(sys.argv[1]).read_text())
pack=Path(sys.argv[2])
counts=manifest.get('counts', {})
for cat, expected in sorted(counts.items()):
    if cat in {'total_skills','total_files','total_bytes','awesome_design_md_files'}:
        continue
    actual=sum(1 for _ in (pack/cat).glob('**/SKILL.md')) if (pack/cat).exists() else 0
    print(f'{cat}={actual}')
    if actual != expected:
        raise SystemExit(f'category count mismatch for {cat}: {actual} != {expected}')
PY

printf '\n=== Validation ===\n'
validate_frontmatter
secret_scan
path_scan

if [ "$INSTALLED" -eq 1 ]; then
  printf '\n=== Installed check ===\n'
  installed=0
  while IFS= read -r -d '' skill; do
    rel="${skill#$PACK/}"
    rel="${rel%/SKILL.md}"
    if [ -f "$HERMES_HOME_DIR/skills/$rel/SKILL.md" ]; then installed=$((installed+1)); fi
  done < <(find "$PACK" -name SKILL.md -type f -print0)
  printf 'installed_custom_skills=%s\n' "$installed"
  if [ -d "$HERMES_HOME_DIR/skill-libraries/awesome-design-md" ]; then
    printf 'installed_library_design_md=%s\n' "$(find "$HERMES_HOME_DIR/skill-libraries/awesome-design-md" -name DESIGN.md -type f | wc -l | tr -d ' ')"
  else
    printf 'installed_library_design_md=0\n'
  fi
fi

echo
printf 'CUSTOM_SKILLS_VERIFY_OK\n'
