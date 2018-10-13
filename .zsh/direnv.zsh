if (( ! ${+commands[direnv]} )); then
	exit
fi

export EDITOR=vim

eval "$(direnv hook zsh)"
