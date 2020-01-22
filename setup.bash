#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

clone() {
    local repo
    local dest
    repo="$1"
    dest="$2"

    if [ ! -e "$dest" ]; then
        git clone "$repo" "$dest"
    else
        echo "$dest is already exists..."
        git -C "$dest" pull
    fi
}

github() {
    clone "https://github.com/$1" "$2"
}

"$REPO_DIR"/link.bash

# zplugin
github zdharma/zinit "$XDG_DATA_HOME/zinit/bin"

# dein.vim
if [ ! -d "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" ]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s "$XDG_DATA_HOME/dein"
else
    echo "$XDG_DATA_HOME/dein is already exists..."
    git -C "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" pull
fi

# asdf-vm
github asdf-vm/asdf "$XDG_DATA_HOME/asdf"

# gdb-dashboard
github cyrus-and/gdb-dashboard "$XDG_DATA_HOME/gdb-dashboard"
mkdir -p "$XDG_CONFIG_HOME/gdb"
ln -sfv "$XDG_DATA_HOME/gdb-dashboard/.gdbinit" "$XDG_CONFIG_HOME/gdb/init"

# mac
if [ "$(uname)" = "Darwin" ]; then
    defaults write com.apple.finder AppleShowAllFiles YES
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
fi
