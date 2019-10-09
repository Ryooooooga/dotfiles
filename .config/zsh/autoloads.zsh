autoload -Uz compinit && compinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
autoload -Uz _zplugin

add-zsh-hook chpwd chpwd_recent_dirs
