### anyenv ###
export ANYENV_ROOT="$XDG_DATA_HOME/anyenv"
path=($ANYENV_ROOT/bin(N-/) $path)

if (( ! ${+commands[anyenv]} )); then
	return
fi

eval "$(anyenv init - zsh)"
