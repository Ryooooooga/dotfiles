### zplugin ###
source "$HOME/.zplugin/bin/zplugin.zsh"
(( ${+_comps} )) && _comps[zplugin]=_zplugin

### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

### zsh ###
export ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"
export ZSH_DATA_HOME="$XDG_DATA_HOME/zsh"

export HISTFILE=$ZSH_DATA_HOME/history
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_dups

# pathes
path=(
	$HOME/go/bin(N-/)
	$path
)

# locale
export LANG="en_US.UTF-8"

# autoloads
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/autoloads.zsh"

# plugins
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-syntax-highlighting
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-history-substring-search
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-autosuggestions
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-completions

zplugin snippet "$ZDOTDIR/theme.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/aliases.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/functions.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/key-bindings.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/anyenv.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/direnv.zsh"
zplugin ice silent wait"0"; zplugin snippet "$ZDOTDIR/rust.zsh"

# styles
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# local
if [ -f $ZDOTDIR/.zshrc.local ]; then
	source $ZDOTDIR/.zshrc.local
fi
