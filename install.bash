#!/usr/bin/env bash
function clone() {
	local repo
	local dest
	repo=$1
	dest=$2

	if [ ! -e "$dest" ]; then
		git clone "$repo" "$dest"
	else
		echo "$dest is already exists..."
	fi
}

cd "$(dirname "$0")" || return 1
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"

# symlink
./symlink.bash

# zplugin
clone https://github.com/zdharma/zplugin "$XDG_DATA_HOME/zplugin/bin"

# dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s "$XDG_DATA_HOME/dein"

# asdf-vm
clone https://github.com/asdf-vm/asdf "$XDG_DATA_HOME/asdf"

# mac
if [ "$(uname)" = "Darwin" ]; then
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
fi
