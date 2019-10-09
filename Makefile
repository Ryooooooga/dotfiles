.PHONY: all install update help

DIR = $(realpath .)

all: help

install: update
	sh scripts/setup.sh

update:
	mkdir -p ~/.config
	ln -sf ${DIR}/.gitconfig        ~/
	ln -sf ${DIR}/.zshrc            ~/
	ln -sf ${DIR}/.zsh              ~/
	ln -sf ${DIR}/.vimrc            ~/
	ln -sf ${DIR}/.config/git       ~/.config/
	ln -sf ${DIR}/.config/tmux      ~/.config/
	ln -sf ${DIR}/.config/alacritty ~/.config/

	if [ "$$(uname)" = "Darwin" ]; then \
		ln -sf ${DIR}/mac/.hammerspoon ~/; \
		ln -sf ${DIR}/mac/.config/karabiner ~/.config/; \
	fi

help:
	@echo "Ryooooooga/dotfiles: make [target]"
	@echo "    install - install dotfiles."
	@echo "    update  - update dotfiles."
	@echo "    help    - display helps."

