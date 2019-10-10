### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

add-zsh-hook chpwd chpwd_recent_dirs

### editor ###
export EDITOR="vim"

### ls-colors ###
LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### GPG ###
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

### aliases ###
case $OSTYPE in
	linux*)
		alias pbcopy='xsel -bi'
		alias pbpaste='xsel -b'
	;;
	msys)
		alias cmake='command cmake -G"Unix Makefiles"'
		alias dock-ri='winpty docker run -it'
		alias dock-rrmi='winpty docker run --rm -it'
		alias pbcopy='cat > /dev/clipboard'
		alias pbpaste='cat /dev/clipboard'
	;;
	darwin*)
		(( ${+commands[gdate]} )) && alias date='gdate'
		(( ${+commands[gls]} )) && alias ls='gls'
		(( ${+commands[gcp]} )) && alias cp='gcp'
		(( ${+commands[gmv]} )) && alias mv='gmv'
		(( ${+commands[gdu]} )) && alias du='gdu'
		(( ${+commands[ghead]} )) && alias head='ghead'
		(( ${+commands[gtail]} )) && alias tail='gtail'
	;;
esac

alias ..='cd ..'
alias vi='vim'
(( ${+commands[trash]} )) && alias rm='trash'
(( ${+commands[colordiff]} )) && alias diff='colordiff'
#(( ${+commands[hub]} )) && alias git='hub'

alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release'
alias make='make -j5'
alias gdb='gdb -q'

alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

alias dock-clean='docker rm $(docker ps -aqf status=exited)'
alias dock-cleani='docker rmi $(docker images -qf dangling=true)'
alias dock-ri='docker run -it'
alias dock-rrm='docker run --rm'
alias dock-rrmi='docker run --rm -it'

if (( ${+commands[exa]} )) then
	alias ls='exa'
	alias ll='exa -l --git'
	alias la='exa -a'
	alias lla='exa -al --git'
	alias tree='exa -T'
else
	alias ls='ls --color=auto'
	alias ll='ls -l'
	alias la='ls -a'
	alias lla='ls -al'
fi

### functions ###
mkcd () {
	mkdir -p $1 && cd $_
}

### key bindings ###
if (( ${+commands[peco]} )); then
	fuzzy_finder=peco
elif (( ${+commands[fzy]} )); then
	fuzzy_finder=fzy
fi

select_history () {
	BUFFER="$(history -nr 1 | awk '!a[$0]++' | $fuzzy_finder --query "$LBUFFER" | sed 's/\\n/\n/')"
	CURSOR=$#BUFFER
	zle -R -c # refresh screen
}

select_cdr () {
	local selected_dir="$(cdr -l | awk '{print $2}' | $fuzzy_finder)"
	if [ -n "$selected_dir" ]; then
		BUFFER="cd $selected_dir"
		CURSOR=$#BUFFER
	fi
	zle -R -c # refresh screen
}

zle -N select_history
zle -N select_cdr

bindkey '^R' select_history # C-R
bindkey '^F' select_cdr # C-F
bindkey '^[[3~' delete-char # DELETE

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

path=($CARGO_HOME/bin(N-/) $path)

### direnv ###
if (( ! ${+commands[direnv]} )); then
	eval "$(direnv hook zsh)"
fi

### anyenv ###
export ANYENV_ROOT="$XDG_DATA_HOME/anyenv"

if [ -e "$ANYENV_ROOT" ]; then
	path=($ANYENV_ROOT/bin(N-/) $path)
	eval "$(anyenv init - zsh)"
fi

### asdf-vm ###
export ASDF_DIR="$XDG_DATA_HOME/asdf"

if [ -e "$ASDF_DIR" ]; then
	source $ASDF_DIR/asdf.sh
	source $ASDF_DIR/completions/asdf.bash
fi

### local ###
if [ -f $ZDOTDIR/.zshrc.local ]; then
	source $ZDOTDIR/.zshrc.local
fi
