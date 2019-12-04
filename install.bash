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
        git -C "$dest" pull
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

# fzf
clone https://github.com/junegunn/fzf "$XDG_DATA_HOME/fzf" && (command -v go > /dev/null) && make -C "$XDG_DATA_HOME/fzf"

# emojify
mkdir -p "$XDG_DATA_HOME/emojify/bin"
curl 'https://raw.githubusercontent.com/mrowa44/emojify/master/emojify' > "$XDG_DATA_HOME/emojify/bin/emojify"
chmod +x "$XDG_DATA_HOME/emojify/bin/emojify"

# forgit
mkdir -p "$XDG_DATA_HOME/forgit"
curl 'https://raw.githubusercontent.com/wfxr/forgit/master/forgit.plugin.zsh' > "$XDG_DATA_HOME/forgit/forgit.plugin.zsh"

# mac
if [ "$(uname)" = "Darwin" ]; then
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
fi
