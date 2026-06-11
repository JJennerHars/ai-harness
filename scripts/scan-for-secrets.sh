#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$repo_root"

fail=0

printf 'Scanning %s for likely secrets/private data...\n' "$repo_root"

# File names that should never be committed.
blocked_paths='(^|/)(\.env(\..*)?|auth\.json|state\.db|sessions/|logs/|request_dumps/|audio_cache/|id_rsa|id_ed25519|.*\.(pem|p12|pfx|key))$'
if git ls-files --cached --others --exclude-standard | grep -Ei "$blocked_paths"; then
  printf '\nERROR: blocked private/secret-looking file path found.\n' >&2
  fail=1
fi

# Content patterns. These are intentionally broad; inspect false positives carefully.
patterns=(
  'AKIA[0-9A-Z]{16}'
  'gh[pousr]_[A-Za-z0-9_]{30,}'
  'github_pat_[A-Za-z0-9_]{30,}'
  'sk-[A-Za-z0-9]{20,}'
  'xox[baprs]-[A-Za-z0-9-]{20,}'
  '-----BEGIN (RSA |OPENSSH |EC |DSA |PRIVATE )?PRIVATE KEY-----'
  'Authorization:[[:space:]]*Bearer[[:space:]]+[A-Za-z0-9._~+/-]+=*'
  '(api[_-]?key|secret|password|token|refresh[_-]?token)[[:space:]]*[:=][[:space:]]*['"'"']?[^'"'"'[:space:]]{12,}'
  '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
)

for pattern in "${patterns[@]}"; do
  if git grep -InE "$pattern" -- . ':!scripts/scan-for-secrets.sh' ':!SECURITY.md' ':!README.md' 2>/dev/null; then
    printf '\nERROR: possible secret or direct personal information matched pattern: %s\n' "$pattern" >&2
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  printf 'No blocked paths or high-signal secret patterns found. Still manually review git diff before publishing.\n'
fi

exit "$fail"
