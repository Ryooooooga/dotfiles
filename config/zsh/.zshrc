### zinit ###
typeset -gAH ZINIT
export ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"
(( ${+_comps} )) && _comps[zinit]=_zinit

### zsh ###
export ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"
export ZSH_DATA_HOME="$XDG_DATA_HOME/zsh"
export ZSH_CACHE_HOME="$XDG_CACHE_HOME/zsh"

### history ###
export HISTFILE="$XDG_CACHE_HOME/zsh_history"
export HISTSIZE=1000
export SAVEHIST=1000

setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt NO_SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT

### theme ###
zinit ice from"gh-r" as"program" \
    mv"almel* -> almel" \
    atclone"chmod +x almel" atpull"%atclone"
zinit light 'Ryooooooga/almel'

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
clear_screen_and_update_prompt() {
    ALMEL_STATUS=0
    almel_precmd
    zle .clear-screen
}
zle -N clear-screen clear_screen_and_update_prompt

select_history() {
    local selected="$(history -nr 1 | awk '!a[$0]++' | fzf --exit-0 --query "$LBUFFER" | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}

select_cdr() {
    local selected="$(cdr -l | awk '{ $1=""; print }' | sed 's/^ //' | fzf --exit-0 --preview="fzf-preview-directory '{}'" --preview-window="right:50%")"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_ghq() {
    local selected="$(ghq list | sort | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{}" --preview-window="right:60%")"
    if [ -n "$selected" ]; then
        local repo_dir="$(ghq list --exact --full-path "$selected")"
        BUFFER="cd ${(q)repo_dir}"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_ghq_session() {
    local selected="$(ghq list | sort | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{}" --preview-window="right:60%")"

    if [ -z "$selected" ]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    local session_name="$(sed -E 's/[:. ]/-/g' <<<"$selected")"

    if [ -z "$TMUX" ]; then
        BUFFER="tmux new-session -A -s ${(q)session_name} -c ${(q)repo_dir}"
        zle accept-line
    elif [ "$(tmux display-message -p "#S")" = "$session_name" -a "$PWD" != "$repo_dir" ]; then
        BUFFER="cd ${(q)repo_dir}"
        zle accept-line
    else
        if ! tmux has-session -t "$session_name" 2> /dev/null; then
            tmux new-session -d -s "$session_name" -c "$repo_dir"
        fi
        tmux switch-client -t "$session_name"
    fi
    zle -R -c # refresh screen
}

select_dir() {
    local selected="$(fd --hidden --color=always --exclude='.git' --type=d . $(git rev-parse --show-cdup 2> /dev/null) | fzf --exit-0 --preview="fzf-preview-directory '{}'" --preview-window="right:50%")"
    if [ -n "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
    zle -R -c # refresh screen
}

zle -N select_history
zle -N select_cdr
zle -N select_ghq
zle -N select_ghq_session
zle -N select_dir

bindkey -v
bindkey "^R"        select_history                  # C-r
bindkey "^F^F"      select_cdr                      # C-f C-f
bindkey "^G"        select_ghq_session              # C-g
bindkey "^[g"       select_ghq                      # Alt-g
bindkey "^O"        select_dir                      # C-o
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
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
zinit ice lucid wait"0" as"program" \
    atinit'. "$ZDOTDIR/plugins.zsh"'
zinit light 'zdharma/null'
