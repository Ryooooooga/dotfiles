### Aliases ###
alias la='ls -a'
alias ll='ls -al'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

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
        alias pp='cat >/dev/clipboard'
        alias p='cat /dev/clipboard'
    ;;
    darwin*)
        alias pp='pbcopy'
        alias p='pbpaste'
        alias chrome='open -a "Google Chrome"'
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

mkcd() { command mkdir -p -- "$@" && builtin cd "$(realpath -- "${@[-1]}")" }

### diff ###
(( ${+commands[colordiff]} )) && alias diff='colordiff'

alias diffall='command diff --new-line-format="+%L" --old-line-format="-%L" --unchanged-line-format=" %L"'

### direnv ###
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

### zabrze ###
zinit wait lucid blockf light-mode as'program' from'gh-r' for \
    atclone'./zabrze init --bind-keys >zabrze.zsh; zcompile zabrze.zsh' atpull'%atclone' \
    atload'source zabrze.zsh' \
    'Ryooooooga/zabrze'

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
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

### zsh-autopair ###
zinit wait'1' lucid light-mode for \
    'hlissner/zsh-autopair'

### zsh plugins ###
zinit wait lucid blockf light-mode for \
    'zsh-users/zsh-autosuggestions' \
    'zsh-users/zsh-completions' \
    'zdharma-continuum/fast-syntax-highlighting'

### programs ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'delta*/delta'  @'dandavison/delta' \
    pick'mmv*/mmv'      @'itchyny/mmv' \
    pick'ripgrep*/rg'   @'BurntSushi/ripgrep' \
    pick'zouch*/zouch'  @'Ryooooooga/zouch'

### asdf-vm ###
__asdf_atload() {
    export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
    export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/.asdfrc"
}
zinit wait lucid light-mode for \
    atpull'asdf plugin update --all' \
    atload'__asdf_atload' \
    @'asdf-vm/asdf'

### GitHub CLI ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'gh*/bin/gh' \
    atclone'./gh*/bin/gh completion -s zsh >_gh' atpull'%atclone' \
    'cli/cli'

### exa ###
__exa_atload() {
    alias ls='exa --group-directories-first'
    alias la='exa --group-directories-first -a'
    alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='exa --group-directories-first -T --icons'
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'bin/exa' \
    atclone'cp -f completions/exa.zsh _exa' atpull'%atclone' \
    atload'__exa_atload' \
    'ogham/exa'

### tealdeer ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    if'[[ "$OSTYPE" =~ "linux" ]]' \
    mv'tldr* -> tldr' \
    'dbrgn/tealdeer'

### yq ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    mv'yq* -> yq' \
    atclone'./yq shell-completion zsh >_yq' atpull'%atclone' \
    'mikefarah/yq'

### hgrep ###
__hgrep_atload() {
    alias hgrep="hgrep --hidden --glob='!.git/'"
}

zinit wait lucid light-mode as'program' from'gh-r' \
    pick'hgrep*/hgrep' \
    atload'__hgrep_atload' \
    for 'rhysd/hgrep'

### navi ###
__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}

__navi_atload() {
    export NAVI_CONFIG="$XDG_CONFIG_HOME/navi/config.yaml"

    zle -N __navi_search
    bindkey '^K' __navi_search
}

zinit wait lucid light-mode as'program' from'gh-r' for \
    atload'__navi_atload' \
    'denisidoro/navi'

### pmy ###
__pmy_atload() {
    export PMY_TRIGGER_KEY="^P"
    export PMY_CONFIG_HOME="$XDG_CONFIG_HOME/pmy"
    export PMY_RULE_PATH="$PMY_CONFIG_HOME/rules"
    export PMY_SCRIPT_PATH="$PMY_CONFIG_HOME/scripts"
    export PMY_FUZZY_FINDER_DEFAULT_CMD="fzf --exit-0 --select-1 --tiebreak=begin,index --height=60% --cycle --preview-window=right:50%"
    source pmy.zsh

    pmy-widget-expand-abbrev() {
        (( ${+functions[__zabrze::expand]} )) && {
            zle __zabrze::expand
            zle -R -c
        }
        zle .pmy-widget
    }
    zle -N .pmy-widget pmy-widget
    zle -N pmy-widget pmy-widget-expand-abbrev
}

zinit wait lucid light-mode as'program' from'gh-r' \
    atclone'./pmy init >pmy.zsh; zcompile pmy.zsh' atpull'%atclone' \
    atload'__pmy_atload' \
    for 'Ryooooooga/pmy'

### Emojify ###
zinit wait lucid light-mode as'program' \
    atclone'rm -f *.{py,bats}' atpull'%atclone' \
    for 'mrowa44/emojify'

### Forgit ###
__forgit_atload() {
    export FORGIT_INSTALL_DIR="${ZINIT[PLUGINS_DIR]}/wfxr---forgit"
    export FORGIT_NO_ALIASES=1
    export FORGIT_GI_REPO_LOCAL="$XDG_DATA_HOME/gitignore"
    export FORGIT_GI_TEMPLATES="$FORGIT_GI_REPO_LOCAL/templates"
}

zinit wait lucid light-mode as'program' \
    atload'__forgit_atload' \
    pick'bin/git-forgit' \
    for 'wfxr/forgit'

### zsh-replace-multiple-dots ###
__replace_multiple_dots_atload() {
    __replace_multiple_dots_exclude_go() {
        if [[ "$LBUFFER" =~ '^go ' ]]; then
            zle self-insert
        else
            zle .__replace_multiple_dots
        fi
    }

    zle -N .__replace_multiple_dots __replace_multiple_dots
    zle -N __replace_multiple_dots __replace_multiple_dots_exclude_go
}

zinit wait lucid light-mode \
    atload'__replace_multiple_dots_atload' \
    for 'Ryooooooga/zsh-replace-multiple-dots'

### tmux-fzf ###
zinit wait lucid light-mode \
    atload'alias t=tmux-fzf' \
    for 'Ryooooooga/tmux-fzf'

### qtmut ###
zinit wait lucid light-mode as'program' \
    for 'Ryooooooga/qtmut'

### commitizen-deno ###
zinit wait lucid light-mode as'program' \
    for 'Ryooooooga/commitizen-deno'

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
    if [ "$#" -eq 0 ] || [ "$1" = "compose" ] || ! command -v "docker-$1" >/dev/null; then
        command docker "${@:1}"
    else
        "docker-$1" "${@:2}"
    fi
}

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

### Editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"

export GIT_EDITOR="$EDITOR"

e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file {}" --preview-window="right:60%")"
        [ -n "$selected" ] && "$EDITOR" -- ${(f)selected}
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

### local ###
if [ -f "$ZDOTDIR/.zshrc.local" ]; then
    source "$ZDOTDIR/.zshrc.local"
fi

### autoloads ###
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zinit
