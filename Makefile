.PHONY: all install update help

DIR = $(realpath .)

all: help

install: update
	sh scripts/setup.sh

update:
	ln -sf ${DIR}/.gitconfig ~/.gitconfig
	ln -sf ${DIR}/.gitignore_global ~/.gitignore_global
	ln -sf ${DIR}/.zshrc ~/.zshrc
	ln -sf ${DIR}/.zsh ~/.zsh
	ln -sf ${DIR}/.vimrc ~/.vimrc

	if [ "$$(uname)" = "Darwin" ]; then \
		ln -sf ${DIR}/mac/.hammerspoon ~/.hammerspoon; \
		ln -sf ${DIR}/mac/.config/karabiner ~/.config/karabiner; \
	fi

help:
	@echo "Ryooooooga/dotfiles: make [target]"
	@echo "    install - install dotfiles."
	@echo "    update  - update dotfiles."
	@echo "    help    - display helps."

