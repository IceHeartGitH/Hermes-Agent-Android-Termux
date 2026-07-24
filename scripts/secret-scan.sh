#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

TMP_DIR="${TMPDIR:-${PREFIX:-/data/data/com.termux/files/usr}/tmp}"
mkdir -p "$TMP_DIR"
hit_file="$(mktemp "$TMP_DIR/hermes-secret-hit-XXXXXX")"
trap 'rm -f "$hit_file"' EXIT

fail=0
while IFS= read -r -d '' f; do
  case "$f" in
    ./.git/*|./.gitignore|./scripts/secret-scan.sh|./scripts/verify-custom-skills.sh) continue ;;
  esac
  if grep -nE 'auth\.json|GITHUB_TOKEN=[^[:space:]]+|OPENROUTER_API_KEY=[^[:space:]]+|ANTHROPIC_API_KEY=[^[:space:]]+|OPENAI_API_KEY=[^[:space:]]+|(^|[^A-Za-z0-9_-])sk-[A-Za-z0-9_-]{32,}|ghp_[A-Za-z0-9_]{30,}' "$f" >"$hit_file" 2>/dev/null; then
    echo "POSSIBLE_SECRET $f"
    sed -n '1,20p' "$hit_file"
    fail=1
  fi
done < <(find . -type f -print0)
[ "$fail" = 0 ] || exit 1
echo "SECRET_SCAN_OK"
