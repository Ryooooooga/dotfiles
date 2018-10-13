.PHONY: all install update help

DIR := $(realpath .)

all: help

install: update
	sh scripts/setup.sh

update: \
	~/.gitconfig \
	~/.gitignore_global \
	~/.zshrc \
	~/.zsh

~/.%: ${DIR}/.%
	ln -sf $< $@

help:
	@echo "Ryooooooga/dotfiles: make [target]"
	@echo "    install - install dotfiles."
	@echo "    update  - update dotfiles."
	@echo "    help    - display helps."

