.PHONY: all install update help

DIR := $(realpath .)

all: help

install: update

update: \
	~/.gitconfig \
	~/.zshrc

~/.%: ${DIR}/.%
	ln -sf $< $@

help:
	@echo "Ryooooooga/dotfiles: make [target]"
	@echo "    install - install dotfiles."
	@echo "    update  - update dotfiles."
	@echo "    help    - display helps."

