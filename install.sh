#!/bin/sh
INSTALL_DIR="${INSTALL_DIR:-$HOME/repos/github.com/Ryooooooga/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
  echo "Updating dotfiles..."
  git -C "$INSTALL_DIR" pull
else
  echo "Installing dotfiles..."
  git clone https://github.com/Ryooooooga/dotfiles "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
