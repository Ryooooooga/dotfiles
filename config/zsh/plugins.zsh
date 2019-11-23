### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

### plugins ###
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-syntax-highlighting
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-history-substring-search
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-autosuggestions
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-completions

### locale ###
export LANG="en_US.UTF-8"

### chpwd-recent-dirs ###
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$ZSH_DATA_HOME/chpwd-recent-dirs"

### ls-colors ###
LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### less ###
export LESSHISTFILE=-

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
        (( ${+commands[gsed]} )) && alias sed='gsed'
    ;;
esac

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

(( ${+commands[trash]} )) && alias rm='trash'
(( ${+commands[colordiff]} )) && alias diff='colordiff'

### wget ###
export WGET_DATA_DIR="$XDG_DATA_HOME/wget"
alias wget='wget --hsts-file "$WGET_DATA_DIR/wget-hists"'

### Make ###
alias make='make -j5'

### CMake ###
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release'

### GDB ###
alias gdb='gdb -q'

### Tmux ###
alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

### ls/exa ###
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

### fzf ###
export FZF_DEFAULT_OPTS="--reverse --exit-0 --border --ansi"

### Docker ###
alias dock-clean='docker rm $(docker ps -aqf status=exited)'
alias dock-cleani='docker rmi $(docker images -qf dangling=true)'
alias dock-ri='docker run -it'
alias dock-rrm='docker run --rm'
alias dock-rrmi='docker run --rm -it'

dock-rm() {
    docker ps -a | fzf --multi --header-lines=1 | awk '{ print $1 }' | xargs docker rm
}

dock-rmi() {
    docker images -a | fzf --multi --header-lines=1 | awk '{ print $3 }' | xargs docker rmi
}

### functions ###
mkcd () {
    mkdir -p $1 && cd $1
}

### vim ###
export EDITOR="vi"
(( ${+commands[vim]} )) && export EDITOR="vim"
(( ${+commands[nvim]} )) && export EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

alias vi="vim"

vim() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --exclude='.git' --type=f  | fzf --multi --preview "fzf-preview-file '{}'" --preview-window=right:60%)"
        [ -n "$selected" ] && command "$EDITOR" ${(f)selected}
    else
        command "$EDITOR" $@
    fi
}

### key bindings ###
select_history() {
    local selected="$(history -nr 1 | awk '!a[$0]++' | fzf --query "$LBUFFER" | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}

select_cdr() {
    local selected="$(cdr -l | awk '{ $1=""; print }' | sed 's/^ //' | fzf --preview "fzf-preview-directory '{}'" --preview-window=right:50%)"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_ghq() {
    local selected="$(ghq list | fzf --preview "fzf-preview-git $(ghq root)/{}" --preview-window=right:60%)"
    if [ -n "$selected" ]; then
        BUFFER="cd \"$(ghq root)/$selected\""
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_dir() {
    local selected="$(fd --hidden --color=always --exclude='.git' --type=d | fzf --preview "fzf-preview-directory '{}'" --preview-window=right:50%)"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

zle -N select_history
zle -N select_cdr
zle -N select_ghq
zle -N select_dir

bindkey '^R' select_history # C-r
bindkey '^F' select_cdr # C-f
bindkey '^G' select_ghq # C-g
bindkey '^P' select_dir # C-p
bindkey '^[[3~' delete-char # DELETE

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

### direnv ###
if (( ${+commands[direnv]} )); then
    eval "$(direnv hook zsh)"
fi

### anyenv ###
export ANYENV_ROOT="$XDG_DATA_HOME/anyenv"

if [ -e "$ANYENV_ROOT" ]; then
    path=($ANYENV_ROOT/bin(N-/) $path[@])
    eval "$(anyenv init - zsh)"
fi

### asdf-vm ###
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"

if [ -e "$ASDF_DATA_DIR" ]; then
    source $ASDF_DATA_DIR/asdf.sh
    source $ASDF_DATA_DIR/completions/asdf.bash
fi

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### Rubygems ###
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

### pylint ###
export PYLINTHOME="$XDG_CACHE_HOME/pylint"

### youtube-dl ###
if (( ${+commands[youtube-dl]} )); then
    alias youtube-audio='youtube-dl -x --no-playlist'
fi

### custom functions ###
path=($XDG_CONFIG_HOME/bin(N-/) $path[@])

### local ###
if [ -f $ZDOTDIR/.zshrc.local ]; then
    source $ZDOTDIR/.zshrc.local
fi
