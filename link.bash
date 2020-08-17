#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME/zsh"
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

ln -sfv "$REPO_DIR/config/alacritty"    "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/almel"        "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/apt"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/clang-format" "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/commitizen"   "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/dash"         "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/editorconfig" "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/fd"           "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/git"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/gnupg"        "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/hammerspoon"  "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/homebrew"     "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/karabiner"    "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/npm"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/nvim"         "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/python"       "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/scripts"      "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/sublime-text" "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/textlint"     "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/tmux"         "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/vim"          "$XDG_CONFIG_HOME"
ln -sfv "$REPO_DIR/config/zsh"          "$XDG_CONFIG_HOME"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv"  "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/vim/init.vim" "$HOME/.vimrc"
ln -sfv "$XDG_CONFIG_HOME/editorconfig/root.editorconfig" "$HOME/.editorconfig"
ln -sfv "$XDG_CONFIG_HOME/commitizen/root.czrc" "$HOME/.czrc"

if [ "$(uname)" = "Darwin" ]; then
    touch "$HOME/.hushlogin"

    # GPG
    ln -sfv "$REPO_DIR/config/gnupg/gpg-agent.conf.mac" "$HOME/.gnupg/gpg-agent.conf"

    # Dash
    DASH_LIBRARY="$HOME/Library/Application Support/Dash/library.dash"
    if [ ! -f "$DASH_LIBRARY" ]; then
        mkdir -p "$(dirname "$DASH_LIBRARY")"
        cp -v "$XDG_CONFIG_HOME/dash/library.dash" "$DASH_LIBRARY"
    fi

    # Sublime Text 3
    SUBL_DIR="$HOME/Library/Application Support/Sublime Text 3"
    mkdir -p "$SUBL_DIR/Packages/User"
    ln -sfv "$XDG_CONFIG_HOME/sublime-text/C++"                     "$SUBL_DIR/Packages"
    ln -sfv "$XDG_CONFIG_HOME/sublime-text/Go"                      "$SUBL_DIR/Packages"
    ln -sfv "$XDG_CONFIG_HOME/sublime-text/User/"*.sublime-settings "$SUBL_DIR/Packages/User"
    ln -sfv "$XDG_CONFIG_HOME/sublime-text/User/"*.sublime-keymap   "$SUBL_DIR/Packages/User"
fi
