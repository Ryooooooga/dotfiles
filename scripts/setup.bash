#!/usr/bin/env bash

# zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

# NeoBundle
git clone https://github.com/Shougo/neobundle.vim "$HOME/.local/share/vim/bundle/neobundle.vim"
