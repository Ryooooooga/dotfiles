#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[[ -n "$SKIP_BUN" ]] && exit

echo "Installing Bun..."
curl -fsSL https://bun.com/install | SHELL=fuck BUN_INSTALL="$XDG_DATA_HOME/bun" bash
