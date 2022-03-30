### zinit ###
typeset -gAH ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
ZINIT[ZCOMPDUMP_PATH]="$XDG_STATE_HOME/zcompdump"
source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"

### paths ###
typeset -U path
typeset -U fpath

path=(
    "$HOME/.local/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
    "$GOPATH/bin"(N-/)
    "$DENO_INSTALL/bin"(N-/)
    "$GEM_HOME/bin"(N-/)
    "$XDG_CONFIG_HOME/scripts/bin"(N-/)
    "$path[@]"
)

fpath=(
    "$XDG_DATA_HOME/zsh/completions"(N-/)
    "$fpath[@]"
)

### history ###
export HISTFILE="$XDG_STATE_HOME/zsh_history"
export HISTSIZE=12000
export SAVEHIST=10000

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVE_COMMENTS
setopt NO_SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir)($| )" ]]
}

### theme ###
zinit light-mode from'gh-r' as'program' for \
    mv'almel* -> almel' \
    @'Ryooooooga/almel'

almel_preexec() {
    unset ALMEL_STATUS
    ALMEL_START="$EPOCHREALTIME"
}

almel_precmd() {
    local s="${ALMEL_STATUS:-$?}"
    local j="$#jobstates"
    local end="$EPOCHREALTIME"
    local dur="$(($end - ${ALMEL_START:-$end}))"
    PROMPT="$(almel prompt zsh -s"$s" -j"$j" -d"$dur")"
    unset ALMEL_START
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd almel_precmd
add-zsh-hook preexec almel_preexec

### key bindings ###
clear-screen-and-update-prompt() {
    ALMEL_STATUS=0
    almel_precmd
    zle .clear-screen
}
zle -N clear-screen clear-screen-and-update-prompt

widget::history() {
    local selected="$(history -nr 1 | fzf --exit-0 --query "$LBUFFER" | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}

widget::ghq::source() {
    local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" checked="\uf631" unchecked="\uf630"
    local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

    ghq list | sort | while read -r repo; do
        session="${repo//[:. ]/-}"
        color="$blue"
        icon="$unchecked"
        if (( ${+sessions[(r)$session]} )); then
            color="$green"
            icon="$checked"
        fi
        printf "$color$icon %s$reset\n" "$repo"
    done
}
widget::ghq::select() {
    local root="$(ghq root)"
    widget::ghq::source | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{+2}" --preview-window="right:60%" | cut -d' ' -f2-
}
widget::ghq::dir() {
    local selected="$(widget::ghq::select)"
    if [ -z "$selected" ]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
    zle -R -c # refresh screen
}
widget::ghq::session() {
    local selected="$(widget::ghq::select)"
    if [ -z "$selected" ]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    local session_name="${selected//[:. ]/-}"

    if [ -z "$TMUX" ]; then
        BUFFER="qtmut -s ${(q)session_name} -c ${(q)repo_dir}"
        zle accept-line
    elif [ "$(tmux display-message -p "#S")" != "$session_name" ]; then
        qtmut -s "$session_name" -c "$repo_dir"
    elif [ "$PWD" != "$repo_dir" ]; then
        BUFFER="cd ${(q)repo_dir}"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

forward-kill-word() {
    zle vi-forward-word
    zle vi-backward-kill-word
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session
zle -N forward-kill-word

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^W"        vi-backward-kill-word           # C-w
bindkey "^X^W"      forward-kill-word               # C-x C-w
bindkey "^?"        backward-delete-char            # backspace
bindkey "^[[3~"     delete-char                     # delete
bindkey "^[[1;3D"   backward-word                   # Alt + arrow-left
bindkey "^[[1;3C"   forward-word                    # Alt + arrow-right
bindkey "^[^?"      vi-backward-kill-word           # Alt + backspace
bindkey "^[[1;33~"  kill-word                       # Alt + delete
bindkey -M vicmd "^A" beginning-of-line             # vi: C-a
bindkey -M vicmd "^E" end-of-line                   # vi: C-e

# Change the cursor between 'Line' and 'Block' shape
function zle-keymap-select zle-line-init zle-line-finish {
    case "${KEYMAP}" in
        main|viins)
            printf '\033[6 q' # line cursor
            ;;
        vicmd)
            printf '\033[2 q' # block cursor
            ;;
    esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

### plugins ###
zinit wait lucid null for \
    atinit'source "$ZDOTDIR/.zshrc.lazy"' \
    @'zdharma-continuum/null'
