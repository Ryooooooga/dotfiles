### Aliases ###
alias la='ls -a'
alias ll='ls -al'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias tailf='tail -f'
alias view='"$EDITOR" -R'
alias teepp="tee >(pp)"

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
        (( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
        (( ${+commands[gcp]} )) && alias cp='gcp -i'
        (( ${+commands[gmv]} )) && alias mv='gmv -i'
        (( ${+commands[grm]} )) && alias rm='grm -i'
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

(( ${+commands[trash]} )) && alias rm='trash'
(( ${+commands[colordiff]} )) && alias diff='colordiff'

mkcd() { command mkdir -p -- "$@" && builtin cd "$(realpath -- "${@[-1]}")" }

### direnv ###
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

### zabrze ###
zinit blockf light-mode as'program' from'gh-r' for \
    atload'eval "$(zabrze init --bind-keys)"' \
    'Ryooooooga/zabrze'

### exa ###
if (( ${+commands[exa]} )); then
    alias ls='exa --group-directories-first'
    alias la='exa --group-directories-first -a'
    alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='exa --group-directories-first -T --icons'
fi

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi'
export FZF_DEFAULT_COMMAND='fd --color=always --hidden'

### bat ###
export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"

alias cat='bat --paging=never'
alias batman='bat --language=man --plain'

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

### zsh-history-substring-search ###
__zsh_history_substring_search_atload() {
    bindkey "${terminfo[kcuu1]}" history-substring-search-up   # arrow-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down # arrow-down
    bindkey "^[[A" history-substring-search-up   # arrow-up
    bindkey "^[[B" history-substring-search-down # arrow-down
}
zinit wait lucid light-mode \
    atload'__zsh_history_substring_search_atload' \
    for 'zsh-users/zsh-history-substring-search'

### zsh plugins ###
zinit wait lucid light-mode for \
    'zsh-users/zsh-autosuggestions' \
    'zsh-users/zsh-completions' \
    'zdharma/fast-syntax-highlighting' \
    'hlissner/zsh-autopair' \
    'Ryooooooga/zsh-replace-multiple-dots'

### programs ###
zinit wait lucid light-mode as"program" from"gh-r" for \
    pick"delta*/delta"  @'dandavison/delta' \
    pick"mmv*/mmv"      @'itchyny/mmv' \
    pick"ripgrep*/rg"   @'BurntSushi/ripgrep' \
    pick"zouch*/zouch"  @'Ryooooooga/zouch'

### GitHub CLI ###
__gh_atload() {
    eval "$(gh completion -s zsh)"
}

zinit wait lucid light-mode as"program" from"gh-r" for \
    pick"gh*/bin/gh" \
    atload'__gh_atload' \
    'cli/cli'

### exa ###
__exa_atclone() {
    ln -sf "$PWD/completions/exa.zsh" "${ZINIT[COMPLETIONS_DIR]}/_exa"
}

zinit wait lucid light-mode as"program" from"gh-r" for \
    pick"bin/exa" \
    atclone'__exa_atclone' atpull'%atclone' \
    'ogham/exa'

### tealdeer ###
zinit wait lucid light-mode as"program" from"gh-r" for \
    if'[[ "$OSTYPE" =~ "linux" ]]' \
    mv"tldr* -> tldr" \
    'dbrgn/tealdeer'

### yq ###
__yq_atload() {
    eval "$(yq shell-completion zsh)"
}

zinit wait lucid light-mode as"program" from"gh-r" for \
    mv"yq* -> yq" \
    atload'__yq_atload' \
    'mikefarah/yq'

### bat-extras ###
zinit wait lucid light-mode as"program" from"gh-r" \
    pick"bin/batgrep" \
    for 'eth-p/bat-extras'

### pmy ###
__pmy_atload() {
    export PMY_TRIGGER_KEY="^P"
    export PMY_CONFIG_HOME="$XDG_CONFIG_HOME/pmy"
    export PMY_RULE_PATH="$PMY_CONFIG_HOME/rules"
    export PMY_SNIPPET_PATH="$PMY_CONFIG_HOME/snippets"
    export PMY_LOG_PATH="$XDG_CACHE_HOME/pmy/log.txt"
    export PMY_SCRIPT_PATH="$PMY_CONFIG_HOME/scripts"
    export PMY_FUZZY_FINDER_DEFAULT_CMD="fzf --exit-0 --select-1 --tiebreak=begin,index --height=40% --cycle --preview-window=right:50%"
    eval "$(pmy init)"

    pmy-widget-expand-abbrev() {
        (( ${+functions[zabrze::expand]} )) && {
            zle zabrze::expand
            zle -R -c
        }
        zle .pmy-widget
    }
    zle -N .pmy-widget pmy-widget
    zle -N pmy-widget pmy-widget-expand-abbrev
}

zinit wait lucid light-mode as"program" from"gh-r" \
    pick"pmy*/pmy" \
    atload'__pmy_atload' \
    for 'relastle/pmy'

### Emojify ###
zinit wait lucid light-mode as"program" \
    atclone'rm -f *.{py,bats}' atpull'%atclone' \
    for 'mrowa44/emojify'

### Forgit ###
__forgit_atinit() {
    export FORGIT_NO_ALIASES=1
}
__forgit_atload() {
    export FORGIT_PLUGIN_ZSH="${ZINIT[PLUGINS_DIR]}/wfxr---forgit/forgit.plugin.zsh"
    export FORGIT_GI_REPO_LOCAL="$XDG_DATA_HOME/gitignore"
    export FORGIT_GI_TEMPLATES="$FORGIT_GI_REPO_LOCAL/templates"
}

zinit wait'1' lucid light-mode \
    atinit'__forgit_atinit' \
    atload'__forgit_atload' \
    for 'wfxr/forgit'

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

### GPG ###
export GPG_TTY="$(tty)"

### wget ###
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

### Make ###
alias make='make -j$(($(nproc)+1))'

### CMake ###
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug -B "$(git rev-parse --show-toplevel)/build"'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release -B "$(git rev-parse --show-toplevel)/build"'
cmakeb() { cmake --build "${1:-$(git rev-parse --show-toplevel)/build}" -j"$(($(nproc)+1))" "${@:2}" }
cmaket() { ctest --verbose --test-dir "${1:-$(git rev-parse --show-toplevel)/build}" "${@:2}" }

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

### Vim ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file '{}'" --preview-window="right:60%")"
        [ -n "$selected" ] && "$EDITOR" -- ${(f)selected}
    else
        command "$EDITOR" "$@"
    fi
}

### Go ###
export GOPATH="$XDG_DATA_HOME/go"
export GO111MODULE="on"

path=("$GOPATH/bin"(N-/) "$path[@]")

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

export BUNDLE_USER_HOME="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle/plugin"

path=("$GEM_HOME/bin"(N-/) "$path[@]")

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

### tealdeer ###
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
export TEALDEER_CACHE_DIR="$XDG_CACHE_HOME/tealdeer"

### youtube-dl ###
if (( ${+commands[youtube-dl]} )); then
    alias youtube-audio='youtube-dl -x --no-playlist'
fi

### asdf-vm ###
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/.asdfrc"

if [ -e "$ASDF_DATA_DIR" ]; then
    source "$ASDF_DATA_DIR/asdf.sh"
fi

fpath=("$ASDF_DATA_DIR/completions"(N-/) "$fpath[@]")

### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zinit

### Tmux ###
source "${0:a:h}/tmux-fzf.zsh"
source "${0:a:h}/completions/tmux-fzf.completion.zsh"

alias t='tmux-fzf'

### local ###
if [ -f "$ZDOTDIR/.zshrc.local" ]; then
    source "$ZDOTDIR/.zshrc.local"
fi
