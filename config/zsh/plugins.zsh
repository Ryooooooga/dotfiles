### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zinit

### Aliases ###
case "$OSTYPE" in
    linux*)
        (( ${+commands[wslview]} )) && alias open='wslview'

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
        (( ${+commands[gfind]} )) && alias find='gfind'
        (( ${+commands[gdirname]} )) && alias dirname='gdirname'
        (( ${+commands[gxargs]} )) && alias xargs='gxargs'
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

mkcd() { mkdir -p -- "$@" && cd "$(realpath -- "${@[-1]}")"}
touch() { dirname -- "$@" | xargs -r -d"\n" mkdir -p -- && command touch -- "$@" }

### Tmux ###
source "${0:a:h}/tmux.zsh"
source "${0:a:h}/completions/tmux.completion.zsh"

alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
alias t='tmux-fzf'

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

### zsh-completions ###
zinit ice lucid wait"0"
zinit light 'zsh-users/zsh-completions'

### Fast-Syntax-Highlight ###
zinit ice lucid wait"0"
zinit light 'zdharma/fast-syntax-highlighting'

### Autopair ###
zinit ice lucid wait"0"
zinit light 'hlissner/zsh-autopair'

### FZF ###
export FZF_DEFAULT_OPTS="--reverse --border --ansi"
export FZF_DEFAULT_COMMAND='fd --color=always --hidden'

zinit ice lucid wait"0" as"program" from"gh-r"
zinit light 'junegunn/fzf'

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
        export MANPAGER=\"sh -c 'col -bx | bat --color=always --language=man --plain'\"
    "
zinit light 'sharkdp/bat'

### delta ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"delta*/delta"
zinit light 'dandavison/delta'

### GitHub CLI ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"**/gh" \
    atload'
        eval "$(gh completion -s zsh)"
        compdef _gh gh
    '
zinit light 'cli/cli'

### Lazygit ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    mv"lazygit* -> lazygit" \
    atload"alias lg='lazygit'"
zinit light 'jesseduffield/lazygit'

### GHQ ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"ghq*/ghq"
zinit light 'x-motemen/ghq'

### pmy ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"pmy*/pmy" \
    atload'
        export PMY_TRIGGER_KEY="^P"
        export PMY_CONFIG_HOME="$XDG_CONFIG_HOME/pmy"
        export PMY_RULE_PATH="$PMY_CONFIG_HOME/rules"
        export PMY_SNIPPET_PATH="$PMY_CONFIG_HOME/snippets"
        export PMY_LOG_PATH="$XDG_CACHE_HOME/pmy/log.txt"
        export PMY_SCRIPT_PATH="$PMY_CONFIG_HOME/scripts"
        export PMY_FUZZY_FINDER_DEFAULT_CMD="fzf --exit-0 --select-1 --tiebreak='begin,index' --height=40% --cycle --preview-window=right:50%"
        eval "$(pmy init)"
    '
zinit light 'relastle/pmy'

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

### mmv ###
zinit ice lucid wait"0" as"program" from"gh-r" \
    pick"mmv*/mmv"
zinit light 'itchyny/mmv'

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

### Docker ###
docker() {
    if [ "$#" -eq 0 ] || ! command -v "docker-$1" > /dev/null; then
        command docker "${@:1}"
    elif (( ${+aliases[docker-$1]} )); then
        eval "${aliases[docker-$1]} ${(q)@:2}"
    else
        "docker-$1" "${@:2}"
    fi
}

alias docker-ri='command docker run -it'
alias docker-rrm='command docker run --rm'
alias docker-rrmi='command docker run --rm -it'

docker-clean() {
    command docker ps -aqf status=exited | xargs -r docker rm --
}
docker-cleani() {
    command docker images -qf dangling=true | xargs -r docker rmi --
}
docker-rm() {
    if [ "$#" -eq 0 ]; then
        command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
    else
        command docker rm "$@"
    fi
}
docker-rmi() {
    if [ "$#" -eq 0 ]; then
        command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
    else
        command docker rmi "$@"
    fi
}

alias dok='docker'

### Vim ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --exclude='.git' --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file '{}'" --preview-window="right:60%")"
        [ -n "$selected" ] && "$EDITOR" -- ${(f)selected}
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
