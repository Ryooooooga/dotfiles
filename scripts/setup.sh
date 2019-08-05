#!/bin/sh

# zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

# NeoBundle
curl "https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh" | sh
