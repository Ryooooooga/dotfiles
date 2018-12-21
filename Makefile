.PHONY: all install update help

DIR = $(realpath .)

all: help

install: update
	sh scripts/setup.sh

update:
	ln -sf \
		${DIR}/.gitconfig \
		${DIR}/.gitignore_global \
		${DIR}/.zshrc \
		${DIR}/.zsh \
		${DIR}/.vimrc \
		~/

	if [ "$$(uname)" = "Darwin" ]; then \
		ln -sf ${DIR}/mac/.hammerspoon ~/; \
		ln -sf ${DIR}/mac/.config/karabiner ~/.config/; \
	fi

help:
	@echo "Ryooooooga/dotfiles: make [target]"
	@echo "    install - install dotfiles."
	@echo "    update  - update dotfiles."
	@echo "    help    - display helps."

