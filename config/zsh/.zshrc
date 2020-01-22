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
export HISTFILE="$ZSH_DATA_HOME/history"
export HISTSIZE=1000
export SAVEHIST=1000

setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT

### theme ###
zinit ice from"gh-r" as"program" \
    mv"almel* -> almel" \
    atclone"chmod +x almel" atpull"%atclone"
zinit load 'Ryooooooga/almel'

almel_preexec() {
    ALMEL_START="$EPOCHREALTIME"
}

almel_precmd() {
    STATUS="$?"
    NUM_JOBS="$#jobstates"
    END="$EPOCHREALTIME"
    DURATION="$(($END - ${ALMEL_START:-$END}))"
    PROMPT="$(almel prompt zsh -s"$STATUS" -j"$NUM_JOBS" -d"$DURATION")"
    unset ALMEL_START
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd almel_precmd
add-zsh-hook preexec almel_preexec

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
        BUFFER="cd \"$(ghq list --full-path $selected)\""
        zle accept-line
    fi
    zle -R -c # refresh screen
}

select_dir() {
    local selected="$(fd --hidden --color=always --exclude='.git' --type=d . $(git rev-parse --show-cdup 2> /dev/null) | fzf --preview "fzf-preview-directory '{}'" --preview-window=right:50%)"
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

bindkey -v
bindkey "^R"       select_history        # C-r
bindkey "^F"       select_cdr            # C-f
bindkey "^G"       select_ghq            # C-g
bindkey "^O"       select_dir            # C-o
bindkey "^A"       beginning-of-line     # C-a
bindkey "^E"       end-of-line           # C-e
bindkey "^?"       backward-delete-char  # backspace
bindkey "^[[3~"    delete-char           # delete
bindkey "^[[1;3D"  backward-word         # alt + arrow-left
bindkey "^[[1;3C"  forward-word          # alt + arrow-right
bindkey "^[^?"     vi-backward-kill-word # alt + backspace
bindkey "^[[1;33~" kill-word             # alt + delete

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
