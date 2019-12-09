### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

### History-substring-search ###
zplugin ice silent wait"0"
zplugin light 'zsh-users/zsh-history-substring-search'

### AutoSuggestions ###
zplugin ice silent wait"0"
zplugin light 'zsh-users/zsh-autosuggestions'

### Completions ###
zplugin ice silent wait"0"
zplugin light 'zsh-users/zsh-completions'

### Fast-Syntax-Highlight ###
zplugin ice silent wait"0"
zplugin light 'zdharma/fast-syntax-highlighting'

### Autopair ###
zplugin ice silent wait"0"
zplugin light 'hlissner/zsh-autopair'

### FZF ###
zplugin ice silent wait"0" as"program" from"gh-r"
zplugin light 'junegunn/fzf-bin'

### FZF ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"direnv* -> direnv" \
    atload'eval "$(direnv hook zsh)"'
zplugin light 'direnv/direnv'

### exa ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"exa* -> exa" \
    atload"
        alias ls='exa'
        alias la='exa -a'
        alias ll='exa -al --git --icons'
        alias tree='exa -T --icons'
    "
zplugin light 'ogham/exa'

### bat ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"bat*/bat -> bat"
zplugin light 'sharkdp/bat'

### fd ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"fd*/fd -> fd"
zplugin light 'sharkdp/fd'

### Lazygit ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"lazygit* -> lazygit" \
    atload"alias lg='lazygit'"
zplugin light 'jesseduffield/lazygit'

### GHQ ###
zplugin ice silent wait"0" as"program" from"gh-r" \
    mv"ghq*/ghq -> ghq"
zplugin light 'motemen/ghq'

### Emojify ###
zplugin ice silent wait"0" as"program" \
    atclone'rm *.{py,bats}' atpull'%atclone'
zplugin light 'mrowa44/emojify'

### Forgit ###
zplugin ice silent wait"1"
zplugin light 'wfxr/forgit'

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
        if (( ${+commands[win32yank.exe]} )); then
            alias pbcopy='win32yank.exe -i'
            alias pbpaste='win32yank.exe -o'
        elif (( ${+commands[xsel]} )); then
            alias pbcopy='xsel -bi'
            alias pbpaste='xsel -b'
        fi
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
        (( ${+commands[ggrep]} )) && alias grep='ggrep'
    ;;
esac

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

(( ${+commands[trash]} )) && alias rm='trash'
(( ${+commands[colordiff]} )) && alias diff='colordiff'

### Git ###
alias g='git'

### fzf ###
export FZF_DEFAULT_OPTS="--reverse --exit-0 --border --ansi"

### forgit ###
export FORGIT_PLUGIN_ZSH="${ZPLGM[PLUGINS_DIR]}/wfxr---forgit/forgit.plugin.zsh"
export FORGIT_GI_REPO_LOCAL="$XDG_DATA_HOME/gitignore"
export FORGIT_NO_ALIASES=1

### wget ###
export WGET_DATA_DIR="$XDG_DATA_HOME/wget"
alias wget='wget --hsts-file "$WGET_DATA_DIR/wget-hists"'

### Make ###
alias make='make -j5'

### CMake ###
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release'

### GDB ###
alias gdb='gdb -q -nh -x "$XDG_CONFIG_HOME/gdb/init"'

### Tmux ###
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'

### Docker ###
docker() {
    if [ "$#" -ne 0 ] && command -v "docker-$1" > /dev/null; then
        "docker-$1" "${@:2}"
    else
        command docker "${@:1}"
    fi
}

docker-clean() {
    command docker rm "$(command docker ps -aqf status=exited)" "$@"
}
docker-cleani() {
    command docker rmi "$(command docker images -qf dangling=true)" "$@"
}
docker-ri() {
    command docker run -it "$@"
}
docker-rrm() {
    command docker run --rm "$@"
}
docker-rrmi() {
    command docker run --rm -it "$@"
}
docker-rm() {
    if [ "$#" -eq 0 ]; then
        command docker ps -a | fzf --multi --header-lines=1 | awk '{ print $1 }' | xargs command docker rm
    else
        command docker rm "$@"
    fi
}
docker-rmi() {
    if [ "$#" -eq 0 ]; then
        command docker images -a | fzf --multi --header-lines=1 | awk '{ print $3 }' | xargs command docker rmi
    else
        command docker rmi "$@"
    fi
}

### functions ###
mkcd () { mkdir -p $1 && cd $1 }

### Vim ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --exclude='.git' --type=f  | fzf --multi --preview "fzf-preview-file '{}'" --preview-window=right:60%)"
        [ -n "$selected" ] && command "$EDITOR" ${(f)selected}
    else
        command "$EDITOR" "$@"
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

bindkey -r '^[' # disable vi-cmd-mode
bindkey '^R'    select_history      # C-r
bindkey '^F'    select_cdr          # C-f
bindkey '^G'    select_ghq          # C-g
bindkey '^O'    select_dir          # C-o
bindkey '^A'    beginning-of-line   # C-a
bindkey '^E'    end-of-line         # C-e
bindkey '^[[3~' delete-char         # DELETE
bindkey "${terminfo[kcuu1]}" history-substring-search-up   # arrow-up
bindkey "${terminfo[kcud1]}" history-substring-search-down # arrow-down
bindkey "^[[A" history-substring-search-up   # arrow-up
bindkey "^[[B" history-substring-search-down # arrow-down

### Go ###
export GOPATH="$XDG_DATA_HOME/go"
path=($GOPATH/bin(N-/) $path[@])

### asdf-vm ###
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"

if [ -e "$ASDF_DATA_DIR" ]; then
    source $ASDF_DATA_DIR/asdf.sh
    source $ASDF_DATA_DIR/completions/asdf.bash
fi

### Node.js ###
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

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
if [ -f $ZDOTDIR/zshrc.local ]; then
    source $ZDOTDIR/zshrc.local
fi
