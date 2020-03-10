#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME/zsh"

ln -sfv "$REPO_DIR/config/zsh"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/nvim"         "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/git"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/gnupg"        "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/tmux"         "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/vim"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/editorconfig" "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/almel"        "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/npm"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/alacritty"    "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/bin"          "$XDG_CONFIG_HOME"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv"  "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/vim/init.vim" "$HOME/.vimrc"
ln -sfv "$XDG_CONFIG_HOME/editorconfig/root.editorconfig" "$HOME/.editorconfig"

if [ "$(uname)" = "Darwin" ]; then
    touch "$HOME/.hushlogin"
    mkdir -p "$HOME/.gnupg"
    ln -sfv "$REPO_DIR/config/gnupg/gpg-agent.conf.mac" "$HOME/.gnupg/gpg-agent.conf"
    ln -sfv "$REPO_DIR/config/dash"              "$XDG_CONFIG_HOME"
    ln -sfv "$REPO_DIR/config/hammerspoon"       "$XDG_CONFIG_HOME"
    ln -sfv "$REPO_DIR/config/karabiner"         "$XDG_CONFIG_HOME"
fi
