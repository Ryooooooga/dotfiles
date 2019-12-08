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
case $OSTYPE in
    linux*)
        zplugin ice from"gh-r" as"program" bpick"*linux*" mv"almel* -> almel"
        zplugin load Ryooooooga/almel
    ;;
    msys)
        zplugin ice from"gh-r" as"program" bpick"*windows*" mv"almel* -> almel"
        zplugin load Ryooooooga/almel
    ;;
    darwin*)
        zplugin ice from"gh-r" as"program" bpick"*darwin*" mv"almel* -> almel"
        zplugin load Ryooooooga/almel
    ;;
esac

if (( ${+commands[almel]} )); then
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
else
    agnoster_theme_display_git_master_branch=1
    agnoster_theme_display_status_success=1
    agnoster_theme_newline_cursor=1
    agnoster_theme_color_status_bg=15
    agnoster_theme_color_git_user_bg=75

    zplugin snippet 'OMZ::plugins/shrink-path/shrink-path.plugin.zsh'
    zplugin snippet 'https://github.com/Ryooooooga/agnoster-zsh-theme/blob/master/agnoster.zsh-theme'
fi

### plugins ###
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/plugins.zsh"
