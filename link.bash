#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME/vim"
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

ln -sfv "$REPO_DIR/config/"* "$XDG_CONFIG_HOME"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/vim/init.vim" "$HOME/.vimrc"
ln -sfv "$XDG_CONFIG_HOME/editorconfig/.editorconfig" "$HOME/.editorconfig"
ln -sfv "$XDG_CONFIG_HOME/commitizen/.czrc" "$HOME/.czrc"

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
    mkdir -p "$SUBL_DIR"
    ln -sfv "$XDG_CONFIG_HOME/sublime-text-3/Packages" "$SUBL_DIR"
fi
