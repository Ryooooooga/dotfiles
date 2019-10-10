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

cd "$(dirname $0)"
XDG_DATA_HOME="$HOME/.local/share"

# symlink
./symlink.bash

# zplugin
clone https://github.com/zdharma/zplugin "$XDG_DATA_HOME/zplugin/bin"

# NeoBundle
clone https://github.com/Shougo/neobundle.vim "$XDG_DATA_HOME/vim/bundle/neobundle.vim"

# asdf-vm
clone https://github.com/asdf-vm/asdf "$XDG_DATA_HOME/asdf"
