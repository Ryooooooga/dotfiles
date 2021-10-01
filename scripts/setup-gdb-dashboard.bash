#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if [ -d "$XDG_DATA_HOME/gdb-dashboard" ]; then
    echo "gdb-dashboard is already installed."
    git -C "$XDG_DATA_HOME/gdb-dashboard" pull
else
    echo "Installing gdb-dashboard..."
    git clone "https://github.com/cyrus-and/gdb-dashboard" "$XDG_DATA_HOME/gdb-dashboard"
fi
