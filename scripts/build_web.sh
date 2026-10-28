#!/usr/bin/env bash
set -euo pipefail
sdk_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$sdk_root/web"
npm ci --no-audit --no-fund
npm run typecheck
npm run build
npm test
cd "$sdk_root"
python3 scripts/package_web.py
