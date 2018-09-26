source ~/.zplug/init.zsh

# pathes

# history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_dups

# plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "mollifier/anyframe"
#zplug "b4b4r07/enhancd", use:init.sh
zplug "plugins/shrink-path", from:oh-my-zsh

# themes
zplug "Ryooooooga/agnoster-zsh-theme", as:theme, use:agnoster.zsh-theme, from:github

LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

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
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# styles
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zplug load
