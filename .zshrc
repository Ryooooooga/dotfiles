# zplugin
source "$HOME/.zplugin/bin/zplugin.zsh"
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# pathes
path=(
	$HOME/.cargo/bin(N-/)
	$HOME/go/bin(N-/)
	$path
)

# history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_dups

# autoloads
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

add-zsh-hook chpwd chpwd_recent_dirs

# plugins
zplugin light zsh-users/zsh-syntax-highlighting
zplugin light zsh-users/zsh-history-substring-search
zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions

zplugin snippet OMZ::plugins/shrink-path/shrink-path.plugin.zsh

zplugin snippet "$HOME/.zsh/theme.zsh"
zplugin snippet "$HOME/.zsh/ls-colors.zsh"
zplugin snippet "$HOME/.zsh/aliases.zsh"
zplugin snippet "$HOME/.zsh/functions.zsh"
zplugin snippet "$HOME/.zsh/key-bindings.zsh"

# styles
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
