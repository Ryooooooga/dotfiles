### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

### zplugin ###
typeset -gAH ZPLGM
export ZPLGM[HOME_DIR]="$XDG_DATA_HOME/zplugin"
source "$XDG_DATA_HOME/zplugin/bin/zplugin.zsh"
(( ${+_comps} )) && _comps[zplugin]=_zplugin

### zsh ###
export ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"
export ZSH_DATA_HOME="$XDG_DATA_HOME/zsh"

export HISTFILE=$ZSH_DATA_HOME/history
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_dups

### locale ###
export LANG="en_US.UTF-8"

### theme ###
agnoster_theme_display_git_master_branch=1
agnoster_theme_display_status_success=1
agnoster_theme_newline_cursor=1
agnoster_theme_color_status_bg=15
agnoster_theme_color_git_user_bg=75

zplugin snippet OMZ::plugins/shrink-path/shrink-path.plugin.zsh
zplugin snippet "https://github.com/Ryooooooga/agnoster-zsh-theme/blob/master/agnoster.zsh-theme"

### plugins ###
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-syntax-highlighting
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-history-substring-search
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-autosuggestions
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-completions

zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/plugins.zsh"
