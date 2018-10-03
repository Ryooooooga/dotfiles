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
autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

add-zsh-hook chpwd chpwd_recent_dirs

# plugins
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-syntax-highlighting
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-history-substring-search
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-autosuggestions
zplugin ice silent wait"0"; zplugin light zsh-users/zsh-completions

zplugin snippet "$HOME/.zsh/theme.zsh"
zplugin ice silent wait"0"; zplugin snippet "$HOME/.zsh/ls-colors.zsh"
zplugin ice silent wait"0"; zplugin snippet "$HOME/.zsh/aliases.zsh"
zplugin ice silent wait"0"; zplugin snippet "$HOME/.zsh/functions.zsh"
zplugin ice silent wait"0"; zplugin snippet "$HOME/.zsh/key-bindings.zsh"

# styles
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
