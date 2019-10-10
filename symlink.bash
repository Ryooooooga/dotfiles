#!/usr/bin/env bash
cd "$(dirname $0)"

mkdir -p ~/.config/
ln -sf $PWD/.gitconfig        ~/
ln -sf $PWD/.zshenv           ~/
ln -sf $PWD/.vimrc            ~/
ln -sf $PWD/.config/zsh       ~/.config/
ln -sf $PWD/.config/git       ~/.config/
ln -sf $PWD/.config/tmux      ~/.config/
ln -sf $PWD/.config/alacritty ~/.config/

if [ "$(uname)" = "Darwin" ]; then
	ln -sf $PWD/mac/.hammerspoon ~/
	ln -sf $PWD/mac/.config/karabiner ~/.config/
fi
