#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

"$REPO_DIR"/link.bash

# zplugin
echo "Installing zinit..."
if [ -d "$XDG_DATA_HOME/zinit/bin" ]; then
    echo "zinit is already installed."
    git -C "$XDG_DATA_HOME/zinit/bin" pull
else
    git clone "https://github.com/zdharma/zinit" "$XDG_DATA_HOME/zinit/bin"
fi

# dein.vim
echo "Installing dein.vim..."
if [ -d "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" ]; then
    echo "dein.vim is already installed."
    git -C "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" pull
else
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s "$XDG_DATA_HOME/dein"
fi

# asdf-vm
echo "Installing asdf-vm..."
if [ -d "$XDG_DATA_HOME/asdf" ]; then
    echo "asdf-vm is already installed."
    git -C "$XDG_DATA_HOME/asdf" pull
else
    git clone "https://github.com/asdf-vm/asdf" "$XDG_DATA_HOME/asdf"
fi

# gdb-dashboard
echo "Installing gdb-dashboard..."
if [ -d "$XDG_DATA_HOME/gdb-dashboard" ]; then
    echo "gdb-dashboard is already installed."
    git -C "$XDG_DATA_HOME/gdb-dashboard" pull
else
    git clone "https://github.com/cyrus-and/gdb-dashboard" "$XDG_DATA_HOME/gdb-dashboard"
fi

# mac
if [ "$(uname)" = "Darwin" ]; then
    # Display hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles YES

    # Configure hammerspoon config location
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
fi
