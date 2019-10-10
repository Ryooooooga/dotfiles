### anyenv ###
export ANYENV_ROOT="$XDG_DATA_HOME/anyenv"

if [ ! -e "$ANYENV_ROOT" ]; then
	return
fi

path=($ANYENV_ROOT/bin(N-/) $path)
eval "$(anyenv init - zsh)"
