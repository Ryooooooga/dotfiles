#!/usr/bin/env bash
cd "$(dirname "$0")" || return 1

mkdir -p ~/.config/
ln -sf "$PWD/gitconfig"        ~/.gitconfig
ln -sf "$PWD/zshenv"           ~/.zshenv
ln -sf "$PWD/vimrc"            ~/.vimrc
ln -sf "$PWD/.editorconfig"    ~/.editorconfig
ln -sf "$PWD/config/zsh"       ~/.config/
ln -sf "$PWD/config/nvim"      ~/.config/
ln -sf "$PWD/config/git"       ~/.config/
ln -sf "$PWD/config/tmux"      ~/.config/
ln -sf "$PWD/config/almel"     ~/.config/
ln -sf "$PWD/config/npm"       ~/.config/
ln -sf "$PWD/config/alacritty" ~/.config/

mkdir -p ~/.local/share/zsh

if [ "$(uname)" = "Darwin" ]; then
    touch ~/.hushlogin
    ln -sf "$PWD/config/hammerspoon" ~/.config/
    ln -sf "$PWD/config/karabiner"   ~/.config/
fi
