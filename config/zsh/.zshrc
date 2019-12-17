### zplugin ###
typeset -gAH ZPLGM
export ZPLGM[HOME_DIR]="$XDG_DATA_HOME/zplugin"
source "${ZPLGM[HOME_DIR]}/bin/zplugin.zsh"
(( ${+_comps} )) && _comps[zplugin]=_zplugin

### zsh ###
export ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"
export ZSH_DATA_HOME="$XDG_DATA_HOME/zsh"
export ZSH_CACHE_HOME="$XDG_CACHE_HOME/zsh"

### history ###
export HISTFILE="$ZSH_DATA_HOME/history"
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_dups

### theme ###
zplugin ice from"gh-r" as"program" \
    mv"almel* -> almel" \
    atclone"chmod +x almel" atpull"%atclone" \
zplugin load 'Ryooooooga/almel'

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

### plugins ###
zplugin ice lucid wait"0"
zplugin snippet "$ZDOTDIR/plugins.zsh"
