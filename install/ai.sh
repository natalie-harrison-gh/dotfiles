#!/usr/bin/env bash
# shellcheck source=script/platform.sh
. "$(dirname "$0")/../script/platform.sh" || exit 1

# Reinstall the AI CLIs via their self-updating standalone installers, then
# restore agent skills. Re-runnable: each installer updates in place. Not run by
# strap (interactive + needs logins) — invoke manually when reprovisioning.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> claude"
curl -fsSL https://claude.ai/install.sh | bash

echo "==> codex"
curl -fsSL https://chatgpt.com/codex/install.sh | sh

echo "==> skills"
"$DIR/skills.sh"

cat <<'EOF'

Done. Follow-ups:
  - Run `codex` once to sign in.
EOF
