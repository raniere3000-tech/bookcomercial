#!/bin/bash
set -euo pipefail

# Só em sessões na nuvem
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Ferramentas de linha de comando usadas pelas skills do projeto
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
command -v apify >/dev/null 2>&1 || npm install -g apify-cli
command -v playwright-cli >/dev/null 2>&1 || npm install -g @playwright/cli
