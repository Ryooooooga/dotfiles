#!/usr/bin/env bash
REPO_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

/bin/bash "$REPO_DIR/link.bash"

# macOS
if [ "$(uname)" = "Darwin" ]; then
    # Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowTabView -bool true
    defaults write com.apple.finder NewWindowTarget -string PfHm

    # Dock
    defaults write com.apple.dock orientation right
    defaults write com.apple.dock autohide -bool false
    defaults write com.apple.dock tilesize -int 50
    defaults write com.apple.dock magnification -bool false
    defaults write com.apple.dock show-recents -bool false

    # Menubar
    defaults write com.apple.menuextra.battery ShowPercent -bool true
    defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

    # Mission Control
    defaults write com.apple.dock wvous-br-corner -int 4 # Bottom right -> Desktop
    defaults write com.apple.dock mru-spaces -bool false # Don't automatically rearrange spaces

    # Disable .DS_Store on network disks
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Screen capture
    defaults write com.apple.screencapture disable-shadow -bool true

    killall Dock
    killall Finder
    killall SystemUIServer

    # Configure hammerspoon config location
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"

    # Homebrew
    if [ -z "$SKIP_HOMEBREW" ]; then
        echo "Installing Homebrew..."
        if type brew >/dev/null; then
            echo "Homebrew is already installed."
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi

        echo "Updating Homebrew..."
        brew update

        echo "Installing Homebrew apps..."
        brew bundle install --file "${REPO_DIR}/config/homebrew/Brewfile" --no-lock --verbose
    else
        echo "Skipping Homebrew"
    fi
fi

# deno
if [ -z "$SKIP_DENO" ]; then
    echo "Installing Deno..."
    DENO_INSTALL="$XDG_DATA_HOME/deno"
    curl -fsSL https://deno.land/x/install/install.sh | /bin/sh

    echo "Install completions"
    mkdir -p "$XDG_DATA_HOME/zsh/completions"
    "$DENO_INSTALL/bin/deno" completions zsh >"$XDG_DATA_HOME/zsh/completions/_deno"
else
    echo "Skipping Deno"
fi

# zinit
echo "Installing zinit..."
if [ -d "$XDG_DATA_HOME/zinit/bin" ]; then
    echo "zinit is already installed."
    git -C "$XDG_DATA_HOME/zinit/bin" pull
else
    git clone "https://github.com/zdharma/zinit" "$XDG_DATA_HOME/zinit/bin"
fi

# dein.vim
echo "Installing dein.vim..."
if [ -d "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" ]; then
    echo "dein.vim is already installed."
    git -C "$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim" pull

    echo "update dein.vim plugins..."
    nvim \
        -c ":call dein#update()" \
        -c ":call clap#installer#download_binary()" \
        -c ":TSUpdate" \
        -c ":q"
else
    curl "https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh" | sh -s "$XDG_DATA_HOME/dein"

    nvim \
        -c ":call clap#installer#download_binary()" \
        -c ":TSUpdate" \
        -c ":q"
fi

# asdf-vm
echo "Installing asdf-vm..."
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
if [ -d "$ASDF_DATA_DIR" ]; then
    echo "asdf-vm is already installed."

    # shellcheck source=/dev/null
    . "$ASDF_DATA_DIR/asdf.sh"
    asdf update
    asdf plugin update --all
else
    git clone "https://github.com/asdf-vm/asdf" "$ASDF_DATA_DIR"

    # shellcheck source=/dev/null
    . "$ASDF_DATA_DIR/asdf.sh"
    asdf plugin add neovim
    asdf install neovim nightly
    asdf global neovim nightly

    asdf plugin add nodejs
    /bin/bash "${ASDF_DATA_DIR}/plugins/nodejs/bin/import-release-team-keyring"
fi

# gdb-dashboard
echo "Installing gdb-dashboard..."
if [ -d "$XDG_DATA_HOME/gdb-dashboard" ]; then
    echo "gdb-dashboard is already installed."
    git -C "$XDG_DATA_HOME/gdb-dashboard" pull
else
    git clone "https://github.com/cyrus-and/gdb-dashboard" "$XDG_DATA_HOME/gdb-dashboard"
fi
