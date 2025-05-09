#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[[ -n "$SKIP_DENO" ]] && exit

if [[ -x "$DENO_INSTALL/bin/deno" ]]; then
  echo "Deno is already installed."
  "$DENO_INSTALL/bin/deno" upgrade
else
  echo "Installing Deno..."
  curl -fsSL https://deno.land/x/install/install.sh | CI=1 /bin/sh
fi

echo "Install Deno completions..."
mkdir -p "$XDG_DATA_HOME/zsh/completions"
"$DENO_INSTALL/bin/deno" completions zsh >"$XDG_DATA_HOME/zsh/completions/_deno"
