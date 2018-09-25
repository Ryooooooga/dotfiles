source ~/.zplug/init.zsh

# pathes

# plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "mollifier/anyframe"
#zplug "b4b4r07/enhancd", use:init.sh

# themes
zplug "agnoster/agnoster-zsh-theme", as:theme, use:agnoster.zsh-theme, from:github

# aliases
alias ..='cd ..'
alias make='make -j5'
alias rm='trash'
alias vi='vim'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

case $OSTYPE in
	linux*)
		alias pbcopy='xsel -bi'
		alias pbpaste='xsel -b'
	;;
	msys)
		alias pbcopy='cat > /dev/clipboard'
		alias pbpaste='cat /dev/clipboard'
	;;
esac

# functions
mkcd () { mkdir -p $1 && cd $_ }

select_history () {
	local filter
	
	if (( ${+commands[peco]} )); then
		filter=peco
	elif (( ${+commands[fzy]} )); then
		filter=fzy
	else
		echo 'no filter commands peco/fzy'
		exit 1
	fi
	BUFFER="$(history -nr 1 | awk '!a[$0]++' | $filter --query "$LBUFFER" | sed 's/\\n/\n/')"
	CURSOR=$#BUFFER # move cursor to eol
	zle -R -c # refresh screen	
}

# key bindings
zle -N select_history
bindkey '^R' select_history

# styles
zstyle ':completion:*:default' menu select=1 

zplug load
