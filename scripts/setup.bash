#!/usr/bin/env bash
XDG_DATA_HOME="$HOME/.local/share"

# zplugin
if [ ! -e "$XDG_DATA_HOME/zplugin/bin" ]; then
	git clone https://github.com/zdharma/zplugin.git "$XDG_DATA_HOME/zplugin/bin"
else
	echo "zplugin has been installed"
fi

# NeoBundle
if [ ! -e "$XDG_DATA_HOME/vim/bundle/neobundle.vim" ]; then
	git clone https://github.com/Shougo/neobundle.vim "$XDG_DATA_HOME/vim/bundle/neobundle.vim"
else
	echo "neobundle.vim has been installed"
fi
