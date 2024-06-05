#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[[ -n "$SKIP_GHRD" ]] && exit

export PATH="$DENO_INSTALL/bin:$PATH"

echo "Installing gh-rd..."
curl -fsSL https://deno.land/x/gh_rd/install.bash | /bin/bash

"$XDG_DATA_HOME/gh-rd/bin/gh-rd"
