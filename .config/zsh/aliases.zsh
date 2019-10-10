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
