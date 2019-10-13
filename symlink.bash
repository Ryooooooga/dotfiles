#!/usr/bin/env bash
cd "$(dirname $0)"

mkdir -p ~/.config/
ln -sf $PWD/.gitconfig        ~/
ln -sf $PWD/.zshenv           ~/
ln -sf $PWD/.vimrc            ~/
ln -sf $PWD/.config/zsh       ~/.config/
ln -sf $PWD/.config/git       ~/.config/
ln -sf $PWD/.config/tmux      ~/.config/
ln -sf $PWD/.config/npm       ~/.config/
ln -sf $PWD/.config/alacritty ~/.config/

if [ "$(uname)" = "Darwin" ]; then
	touch ~/.hushlogin
	ln -sf $PWD/.config/hammerspoon ~/.config/
	ln -sf $PWD/.config/karabiner   ~/.config/
fi
