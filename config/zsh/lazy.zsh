### Aliases ###
alias la='ls -a'
alias ll='ls -al'

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
    if [ -n "$dir" ]; then
        builtin cd "$dir"
        echo "$PWD"
    fi
}

jj() {
    local root
    root="$(git rev-parse --show-toplevel)" || return 1
    builtin cd "$root"
}

pathed() {
    PATH="$(tr ':' '\n' <<<"$PATH" | ped | tr '\n' ':' | sed -E 's/:(:|$)//g')"
}

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
__zabrze_atload() {
    export ZABRZE_LOG_PATH="$XDG_STATE_HOME/zabrze/log.txt"
}
zinit wait lucid blockf light-mode as'program' from'gh-r' for \
    atclone'./zabrze init --bind-keys >zabrze.zsh; zcompile zabrze.zsh' atpull'%atclone' \
    src'zabrze.zsh' \
    atload'__zabrze_atload' \
    @'Ryooooooga/zabrze'

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'

### bat ###
export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"

alias cat='bat --paging=never'

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

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
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'delta*/delta'  @'dandavison/delta' \
    pick'mmv*/mmv'      @'itchyny/mmv' \
    pick'ripgrep*/rg'   @'BurntSushi/ripgrep' \
    pick'ghq*/ghq'      @'x-motemen/ghq' \
    if'! (( ${+commands[lazygit]} ))' @'jesseduffield/lazygit' \
    @'Ryooooooga/zouch' \
    @'Ryooooooga/monkeywrench'

zinit wait lucid light-mode as'program' for \
    @'Ryooooooga/qtmut' \
    @'Ryooooooga/commitizen-deno'

### asdf-vm ###
__asdf_atload() {
    export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
    export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
    source asdf.sh
}
zinit wait lucid light-mode for \
    atpull'asdf plugin update --all' \
    atload'__asdf_atload' \
    @'asdf-vm/asdf'

### GitHub CLI ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'gh*/bin/gh' \
    atclone'./gh*/bin/gh completion -s zsh >_gh' atpull'%atclone' \
    @'cli/cli'

### exa ###
__exa_atload() {
    alias ls='exa --group-directories-first'
    alias la='exa --group-directories-first -a'
    alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='exa --group-directories-first --tree --icons'
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'bin/exa' \
    atclone'cp -f completions/exa.zsh _exa' atpull'%atclone' \
    atload'__exa_atload' \
    @'ogham/exa'

### yq ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    mv'yq* -> yq' \
    atclone'./yq shell-completion zsh >_yq' atpull'%atclone' \
    @'mikefarah/yq'

### hgrep ###
__hgrep_atload() {
    alias hgrep="hgrep --hidden --glob='!.git/'"
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'hgrep*/hgrep' \
    atclone'./hgrep*/hgrep --generate-completion-script zsh >_hgrep' atpull'%atclone' \
    atload'__hgrep_atload' \
    @'rhysd/hgrep'

### navi ###
__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}
__navi_atload() {
    export NAVI_CONFIG="$XDG_CONFIG_HOME/navi/config.yaml"

    zle -N __navi_search
    bindkey '^N' __navi_search
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    atload'__navi_atload' \
    @'denisidoro/navi'

### qwy ###
__qwy_atload() {
    export QWY_TRIGGER_KEY="^P"
    export QWY_DEFAULT_ACTION="expand-or-complete"
    export QWY_CONFIG_HOME="$XDG_CONFIG_HOME/qwy"
    export QWY_SCRIPT_PATH="$QWY_CONFIG_HOME/scripts"
    source qwy.zsh
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    atclone'./qwy init >qwy.zsh; zcompile qwy.zsh' atpull'%atclone' \
    atload'__qwy_atload' \
    @'Ryooooooga/qwy'

### Emojify ###
zinit wait lucid light-mode as'program' for \
    atclone'rm -f *.{py,bats}' atpull'%atclone' \
    @'mrowa44/emojify'

### Forgit ###
__forgit_atload() {
    export FORGIT_INSTALL_DIR="$PWD"
    export FORGIT_NO_ALIASES=1
}
zinit wait lucid light-mode as'program' for \
    atload'__forgit_atload' \
    pick'bin/git-forgit' \
    @'wfxr/forgit'

### tmux-fzf ###
zinit wait lucid light-mode for \
    atload'alias t=tmux-fzf' \
    @'Ryooooooga/tmux-fzf'

### tealdeer ###
__tealdeer_atclone() {
    curl -sSL 'https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/zsh_tealdeer' -o _tealdeer
}
__tealdeer_atload() {
    export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
    export TEALDEER_CACHE_DIR="$XDG_CACHE_HOME/tealdeer"
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    mv'tealdeer* -> tldr' \
    atclone'__tealdeer_atclone' atpull'%atclone' \
    atload'__tealdeer_atload' \
    @'dbrgn/tealdeer'

### mdmg ###
__mdmg_atclone() {
    curl -sSL 'https://raw.githubusercontent.com/Ryooooooga/mdmg/master/completions/mdmg.completion.zsh' -o _mdmg
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    atclone'__mdmg_atclone' atpull'%atclone' \
    pick'mdmg*/mdmg' \
    @'himanoa/mdmg'

### GDB ###
__gdb_dashboard_atload() {
    export GDBHISTFILE="$XDG_STATE_HOME/gdb_history"
    alias gdb="gdb -q -nh -x '$PWD/.gdbinit'"
}
zinit wait lucid light-mode as'null' for \
    atload"__gdb_dashboard_atload" \
    @'cyrus-and/gdb-dashboard'

### chpwd-recent-dirs ###
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$XDG_STATE_HOME/chpwd-recent-dirs"

### ls-colors ###
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

### less ###
export LESSHISTFILE='-'

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### GPG ###
export GPG_TTY="$TTY"

### wget ###
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'

### Docker ###
docker() {
    if [ "$#" -eq 0 ] || [ "$1" = "compose" ] || ! command -v "docker-$1" >/dev/null; then
        command docker "${@:1}"
    else
        "docker-$1" "${@:2}"
    fi
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

### Editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file {}" --preview-window="right:60%")"
        [ -n "$selected" ] && command "$EDITOR" -- "${(f)selected}"
    else
        command "$EDITOR" "$@"
    fi
}

### run utility ###
run-c() {
    if [ "$#" -ne 1 ]; then
        echo "$0 <file>" >/dev/stderr
        return 1
    fi
    src="$1"
    out="${TMPDIR}run-c/${${src:t}%.*}-$(md5sum "$src" | awk '{print $1}').out"
    mkdir -p -- "${out:h}"
    [ -e "$out" ] || "${CC:-gcc}" "${(z)CFLAGS:--std=c2x -Wall -Wextra -pedantic ${(z)cflags}}" "$src" -o "$out" "${(z)LDFLAGS:-${(z)ldflags}}"
    [ "$?" -eq 0 ] && "$out"
}

run-cpp() {
    if [ "$#" -ne 1 ]; then
        echo "$0 <file>" >/dev/stderr
        return 1
    fi
    src="$1"
    out="${TMPDIR}run-cpp/${${src:t}%.*}-$(md5sum "$src" | awk '{print $1}').out"
    mkdir -p -- "${out:h}"
    [ -e "$out" ] || "${CXX:-g++}" "${(z)CXXFLAGS:--std=c++2a -Wall -Wextra -pedantic ${(z)cxxflags}}" "$src" -o "$out" "${(z)LDFLAGS:-${(z)ldflags}}"
    [ "$?" -eq 0 ] && "$out"
}

### Suffix alias ###
alias -s {bz2,gz,tar,xz}='tar xvf'
alias -s zip=unzip
alias -s c=run-c
alias -s cpp=run-cpp
alias -s d=rdmd

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

### local ###
if [ -f "$ZDOTDIR/local.zsh" ]; then
    source "$ZDOTDIR/local.zsh"
fi

### autoloads ###
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zinit
zicompinit
