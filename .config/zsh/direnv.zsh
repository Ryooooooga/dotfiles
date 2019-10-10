### direnv ###
if (( ! ${+commands[direnv]} )); then
	return
fi

eval "$(direnv hook zsh)"
