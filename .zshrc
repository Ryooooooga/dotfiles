source ~/.zplug/init.zsh

# pathes

# plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "mollifier/anyframe"
zplug "b4b4r07/enhancd", use:init.sh

# themes
zplug "agnoster/agnoster-zsh-theme", as:theme, use:agnoster.zsh-theme, from:github

# aliases
alias ..='cd ..'
alias make='make -j5'
alias rm='trash'
alias vi='vim'
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

# styles
zstyle ':completion:*:default' menu select=1 

zplug load
