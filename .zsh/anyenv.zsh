if (( ! ${+commands[anyenv]} )); then
	return
fi

eval "$(anyenv init - zsh)"
