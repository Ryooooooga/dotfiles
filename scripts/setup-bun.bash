#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[[ -n "$SKIP_BUN" ]] && exit


if [[ -x "$BUN_INSTALL/bin/bun" ]]; then
    echo "Bun is already installed."
    "$BUN_INSTALL/bin/bun" upgrade
else
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | /bin/bash
fi
