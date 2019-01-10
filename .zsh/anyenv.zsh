if (( ! ${+commands[anyenv]} )); then
	return
fi

path=(
	~/.anyenv/bin(N-/)
	$path
)

eval "$(anyenv init - zsh)"
