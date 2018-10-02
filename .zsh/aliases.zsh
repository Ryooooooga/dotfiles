alias ..='cd ..'
alias vi='vim'
(( ${+commands[trash]} )) && alias rm='trash'

alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release'
alias make='make -j5'

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias dock-clean='docker rm $(docker ps -aqf status=exited)'
alias dock-cleani='docker rmi $(docker images -qf dangling=true)'
alias dock-ri='docker run -it'
alias dock-rrm='docker run --rm'
alias dock-rrmi='docker run --rm -it'

case $OSTYPE in
	linux*)
		alias pbcopy='xsel -bi'
		alias pbpaste='xsel -b'
	;;
	msys)
		alias cmake='command cmake -G"Unix Makefiles"'
		alias docker='winpty docker'
		alias pbcopy='cat > /dev/clipboard'
		alias pbpaste='cat /dev/clipboard'
	;;
esac
