if (( ! ${+commands[direnv]} )); then
	return
fi

export EDITOR=vim

eval "$(direnv hook zsh)"
