### ls-colors ###
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### Aliases ###
alias la='ls -a'
alias ll='ls -al'
alias gdb='gdb -q -nh'
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'

case "$OSTYPE" in
    linux*)
        if (( ${+commands[win32yank.exe]} )); then
            alias pp='win32yank.exe -i'
            alias p='win32yank.exe -o'
        elif (( ${+commands[xsel]} )); then
            alias pp='xsel -bi'
            alias p='xsel -b'
        fi
    ;;
    darwin*)
        path=(
            /usr/local/opt/coreutils/libexec/gnubin(N-/)
            /usr/local/opt/findutils/libexec/gnubin(N-/)
            /usr/local/opt/gnu-sed/libexec/gnubin(N-/)
            /usr/local/opt/grep/libexec/gnubin(N-/)
            /usr/local/opt/make/libexec/gnubin(N-/)
            "$path[@]"
        )
        alias pp='pbcopy'
        alias p='pbpaste'
    ;;
esac

j() {
    local root dir
    root="${$(git rev-parse --show-cdup 2>/dev/null):-.}"
    dir="$(fd --color=always --hidden --type=d . "$root" | fzf --select-1 --query="$*" --preview='fzf-preview-file {}')"
    [[ -n "$dir" ]] && builtin cd "$dir"
}

pathed() {
    PATH="$(tr ':' '\n' <<<"$PATH" | ped | tr '\n' ':' | sed -E 's/:(:|$)//g')"
}

re() {
    [[ $# -eq 0 ]] && return 1
    local selected="$(rg --color=always --line-number "$@" | fzf -d ':' --preview='
        local file={1} line={2} n=10
        local start="$(( line > n ? line - n : 1 ))"
        bat --color=always --highlight-line="$line" --line-range="$start:" "$file"
    ')"
    [[ -z "$selected" ]] && return
    local file="$(cut -d ':' -f 1 <<<"$selected")" line="$(cut -d ':' -f 2 <<<"$selected")"
    "$EDITOR" +"$line" "$file"
}

### bat ###
if (( ${+commands[bat]} )); then
    export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"

    alias cat='bat --paging=never'
fi

### eza ###
if (( ${+commands[eza]} )); then
    alias ls='eza --group-directories-first'
    alias la='eza --group-directories-first -a'
    alias ll='eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='eza --group-directories-first --tree --icons'
fi

### diff ###
diff() {
    command diff "$@" | bat --paging=never --plain --language=diff
    return "${pipestatus[1]}"
}
alias diffall='diff --new-line-format="+%L" --old-line-format="-%L" --unchanged-line-format=" %L"'

### direnv ###
zinit wait lucid blockf light-mode as'program' from'gh-r' for \
    mv'direnv* -> direnv' \
    atclone'./direnv hook zsh >direnv.zsh; zcompile direnv.zsh' atpull'%atclone' \
    src'direnv.zsh' \
    @'direnv/direnv'

### zabrze ###
zinit wait lucid blockf light-mode as'program' from'gh-r' for \
    atclone'./zabrze init --bind-keys >zabrze.zsh; zcompile zabrze.zsh' atpull'%atclone' \
    src'zabrze.zsh' \
    @'Ryooooooga/zabrze'

### zsh-history-substring-search ###
__zsh_history_substring_search_atload() {
    bindkey "${terminfo[kcuu1]}" history-substring-search-up   # arrow-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down # arrow-down
    bindkey "^[[A" history-substring-search-up   # arrow-up
    bindkey "^[[B" history-substring-search-down # arrow-down
}
zinit wait lucid light-mode for \
    atload'__zsh_history_substring_search_atload' \
    @'zsh-users/zsh-history-substring-search'

### zsh-autopair ###
zinit wait'1' lucid light-mode for \
    @'hlissner/zsh-autopair'

### zsh plugins ###
zinit wait lucid blockf light-mode for \
    @'zsh-users/zsh-autosuggestions' \
    @'zsh-users/zsh-completions' \
    @'zdharma-continuum/fast-syntax-highlighting' \
    @'Ryooooooga/zsh-replace-multiple-dots'

### programs ###
zinit wait lucid light-mode as'program' for \
    @'Ryooooooga/commitizen-deno'

### asdf-vm ###
__asdf_atinit() {
    export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
    export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
}
zinit wait lucid light-mode for \
    atpull'asdf plugin update --all' \
    atinit'__asdf_atinit' \
    @'asdf-vm/asdf'

### hgrep ###
alias hgrep="hgrep --hidden --glob='!.git/'"

### navi ###
export NAVI_CONFIG="$XDG_CONFIG_HOME/navi/config.yaml"

__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}
zle -N __navi_search
bindkey '^N' __navi_search

### qwy ###
export QWY_TRIGGER_KEY="^P"
export QWY_DEFAULT_ACTION="expand-or-complete"
export QWY_CONFIG_HOME="$XDG_CONFIG_HOME/qwy"
export QWY_SCRIPT_PATH="$QWY_CONFIG_HOME/scripts"

zinit wait lucid light-mode as'program' from'gh-r' for \
    atclone'./qwy init >qwy.zsh; zcompile qwy.zsh' atpull'%atclone' \
    src'qwy.zsh' \
    @'Ryooooooga/qwy'

### Emojify ###
zinit wait lucid light-mode as'program' for \
    atclone'rm -f *.{py,bats}' atpull'%atclone' \
    @'mrowa44/emojify'

### Forgit ###
zinit wait lucid light-mode as'program' for \
    pick'bin/git-forgit' \
    @'wfxr/forgit'

### tmux-fzf ###
zinit wait lucid light-mode for \
    atload'alias t=tmux-fzf' \
    @'Ryooooooga/tmux-fzf'

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### Docker ###
docker() {
    if [[ "$#" -eq 0 ]] || [[ "$1" = "compose" ]] || ! command -v "docker-$1" >/dev/null; then
        command docker "${@:1}"
    else
        "docker-$1" "${@:2}"
    fi
}

docker-rm() {
    if [[ "$#" -eq 0 ]]; then
        command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
    else
        command docker rm "$@"
    fi
}

docker-rmi() {
    if [[ "$#" -eq 0 ]]; then
        command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
    else
        command docker rmi "$@"
    fi
}

### Editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

### GPG ###
export GPG_TTY="$TTY"

### less ###
export LESSHISTFILE='-'

### Node.js ###
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### irb ###
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

### Python ###
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

### pylint ###
export PYLINTHOME="$XDG_CACHE_HOME/pylint"

### SQLite3 ###
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"

### MySQL ###
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"

### PostgreSQL ###
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

### tealdeer ###
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"

### local ###
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi

### autoloads ###
autoload -Uz _zinit
zicompinit
