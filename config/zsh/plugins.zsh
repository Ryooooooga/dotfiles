### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zinit

### Aliases ###
case $OSTYPE in
    linux*)
        if (( ${+commands[win32yank.exe]} )); then
            alias pp='win32yank.exe -i'
            alias p='win32yank.exe -o'
        elif (( ${+commands[xsel]} )); then
            alias pp='xsel -bi'
            alias p='xsel -b'
        fi
    ;;
    msys)
        alias cmake='command cmake -G"Unix Makefiles"'
        alias pp='cat > /dev/clipboard'
        alias p='cat /dev/clipboard'
    ;;
    darwin*)
        alias pp='pbcopy'
        alias p='pbpaste'
        (( ${+commands[gdate]} )) && alias date='gdate'
        (( ${+commands[gls]} )) && alias ls='gls --color=auto'
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

alias la='ls -a'
alias ll='ls -al'

alias tailf='tail -f'
alias view='"$EDITOR" -R'

(( ${+commands[trash]} )) && alias rm='trash'
(( ${+commands[colordiff]} )) && alias diff='colordiff'

### zsh-history-substring-search ###
zinit ice lucid wait"0" \
    atload'
        bindkey "${terminfo[kcuu1]}" history-substring-search-up   # arrow-up
        bindkey "${terminfo[kcud1]}" history-substring-search-down # arrow-down
        bindkey "^[[A" history-substring-search-up   # arrow-up
        bindkey "^[[B" history-substring-search-down # arrow-down
    '
zinit light 'zsh-users/zsh-history-substring-search'

### AutoSuggestions ###
zinit ice lucid wait"0"
zinit light 'zsh-users/zsh-autosuggestions'

### Completions ###
zinit ice lucid wait"0"
zinit light 'zsh-users/zsh-completions'

### Fast-Syntax-Highlight ###
zinit ice lucid wait"0"
zinit light 'zdharma/fast-syntax-highlighting'

### Autopair ###
zinit ice lucid wait"0"
zinit light 'hlissner/zsh-autopair'

### FZF ###
export FZF_DEFAULT_OPTS="--reverse --exit-0 --border --ansi"
export FZF_DEFAULT_COMMAND='fd --color=always --hidden'

zinit ice lucid wait"0" as"program" from"gh-r"
zinit light 'junegunn/fzf-bin'

### direnv ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    mv"direnv* -> direnv" \
    atload'eval "$(direnv hook zsh)"'
zinit light 'direnv/direnv'

### exa ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    mv"exa* -> exa" \
    atload"
        alias ls='exa --group-directories-first'
        alias la='exa --group-directories-first -a'
        alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
        alias tree='exa --group-directories-first -T --icons'
    "
zinit light 'ogham/exa'

### bat ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"bat*/bat" \
    atload"
        alias cat='bat --paging=never'
        export MANPAGER=\"sh -c 'col -bx | bat --language=man --plain'\"
    "
zinit light 'sharkdp/bat'

### delta ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"delta*/delta"
zinit light 'dandavison/delta'

### Lazygit ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    mv"lazygit* -> lazygit" \
    atload"alias lg='lazygit'"
zinit light 'jesseduffield/lazygit'

### GHQ ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"ghq*/ghq"
zinit light 'x-motemen/ghq'

### Emojify ###
zinit ice lucid wait"0" as"program" \
    atclone'rm *.{py,bats}' atpull'%atclone'
zinit light 'mrowa44/emojify'

### Forgit ###
zinit ice lucid wait"1" \
    atinit'export FORGIT_NO_ALIASES=1' \
    atload'
        export FORGIT_PLUGIN_ZSH="${ZINIT[PLUGINS_DIR]}/wfxr---forgit/forgit.plugin.zsh"
        export FORGIT_GI_REPO_LOCAL="$XDG_DATA_HOME/gitignore"
        export FORGIT_GI_TEMPLATES="$FORGIT_GI_REPO_LOCAL/templates"
    '
zinit light 'wfxr/forgit'

### locale ###
export LANG="en_US.UTF-8"

### chpwd-recent-dirs ###
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$XDG_CACHE_HOME/chpwd-recent-dirs"

### ls-colors ###
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### less ###
export LESSHISTFILE='-'

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### Git ###
alias g='git'

### GPG ###
export GPG_TTY="$(tty)"

### wget ###
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

### Make ###
alias make='make -j$(($(nproc)+1))'

### CMake ###
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release'
alias cmakeb='cmake --build'

### GDB ###
alias gdb='gdb -q -nh -x "$XDG_DATA_HOME/gdb-dashboard/.gdbinit"'

### Tmux ###
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
alias t='tmux has-session && tmux attach || tmux new-session'

### Docker ###
docker() {
    if [ "$#" -ne 0 ] && command -v "docker-$1" > /dev/null; then
        "docker-$1" "${@:2}"
    else
        command docker "${@:1}"
    fi
}

docker-clean() {
    command docker ps -aqf status=exited | xargs docker rm
}
docker-cleani() {
    command docker images -qf dangling=true | xargs docker rmi
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
        command docker ps -a | fzf --multi --header-lines=1 | awk '{ print $1 }' | xargs docker rm
    else
        command docker rm "$@"
    fi
}
docker-rmi() {
    if [ "$#" -eq 0 ]; then
        command docker images -a | fzf --multi --header-lines=1 | awk '{ print $3 }' | xargs docker rmi
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
        [ -n "$selected" ] && "$EDITOR" ${(f)selected}
    else
        command "$EDITOR" "$@"
    fi
}

### asdf-vm ###
if [ -e "$ASDF_DATA_DIR" ]; then
    source "$ASDF_DATA_DIR/asdf.sh"
fi

### Node.js ###
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_history"

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### Rubygems ###
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

### irb ###
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

### Python ###
alias python="python3"
alias pip="pip3"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

### pylint ###
export PYLINTHOME="$XDG_CACHE_HOME/pylint"

### SQLite3 ###
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"

### MySQL ###
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql_history"

### PostgreSQL ###
export PSQL_HISTORY="$XDG_CACHE_HOME/psql_history"

### fd ###
alias fd='"${commands[fdfind]:-fd}" --ignore-file="$XDG_CONFIG_HOME/fd/ignore"'

### youtube-dl ###
if (( ${+commands[youtube-dl]} )); then
    alias youtube-audio='youtube-dl -x --no-playlist'
fi

### local ###
if [ -f "$ZDOTDIR/.zshrc.local" ]; then
    source "$ZDOTDIR/.zshrc.local"
fi
