### paths ###
typeset -gU PATH path
typeset -gU FPATH fpath

path=(
  '/usr/local/bin'(N-/)
  '/usr/bin'(N-/)
  '/bin'(N-/)
  '/usr/local/sbin'(N-/)
  '/usr/sbin'(N-/)
  '/sbin'(N-/)
)

path=(
  "$HOME/.local/bin"(N-/)
  "$CARGO_HOME/bin"(N-/)
  "$GOPATH/bin"(N-/)
  "$DENO_INSTALL/bin"(N-/)
  "$GEM_HOME/bin"(N-/)
  "$GHRD_DATA_HOME/bin"(N-/)
  "$XDG_CONFIG_HOME/scripts/bin"(N-/)
  "$path[@]"
)

fpath=(
  "$GHRD_DATA_HOME/completions"(N-/)
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
# setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS
setopt NO_SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT
setopt NO_FLOW_CONTROL

disable r

### source ###
source() {
  local input="$1"
  local cache="$input.zwc"
  if [[ ! -f "$cache" || "$input" -nt "$cache" ]]; then
    zcompile "$input"
  fi
  \builtin source "$@"
}

### hooks ###
zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ! "$line" =~ "^(cd|history|j|lazygit|la|ll|ls|rm|rmdir|trash)($| )" ]]
}

chpwd() {
  printf "\e[34m%s\e[m:\n" "${PWD/$HOME/~}"
  if (( ${+commands[eza]} )); then
    eza --group-directories-first --icons -a
  else
    ls -a
  fi
}

### key bindings ###
widget::history() {
  local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle -R -c # refresh screen
}

widget::ghq::source() {
  local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" checked="󰄲" unchecked="󰄱"
  local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

  ghq list | while read -r repo; do
    session="${repo//[:. ]/-}"
    color="$blue"
    icon="$unchecked"
    if (( ${+sessions[(r)$session]} )); then
      color="$green"
      icon="$checked"
    fi
    printf "$color$icon %s$reset\n" "$repo"
  done | sort
}
widget::ghq::select() {
  local root="$(ghq root)"
  widget::ghq::source | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{+2}" --preview-window="right:60%" | cut -d' ' -f2-
}
widget::ghq::dir() {
  local selected="$(widget::ghq::select)"
  if [[ -z "$selected" ]]; then
    return
  fi

  local repo_dir="$(ghq list --exact --full-path "$selected")"
  BUFFER="cd ${(q)repo_dir}"
  zle accept-line
  zle -R -c # refresh screen
}
widget::ghq::session() {
  local selected="$(widget::ghq::select)"
  if [[ -z "$selected" ]]; then
    return
  fi

  local repo_dir="$(ghq list --exact --full-path "$selected")"
  local session_name="${selected//[:. ]/-}"

  if [[ -z "$TMUX" ]]; then
    BUFFER="tmux new-session -A -s ${(q)session_name} -c ${(q)repo_dir}"
    zle accept-line
  elif [[ "$(tmux display-message -p "#S")" != "$session_name" ]]; then
    tmux new-session -d -s "$session_name" -c "$repo_dir" 2>/dev/null
    tmux switch-client -t "$session_name"
  else
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
  fi
  zle -R -c # refresh screen
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^Q"        push-line-or-edit               # C-q
bindkey "^W"        vi-backward-kill-word           # C-w
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

# sheldon
sheldon::load() {
  local profile="$1"
  local plugins_file="$SHELDON_CONFIG_DIR/plugins.toml"
  local cache_file="$XDG_CACHE_HOME/sheldon/$profile.zsh"
  if [[ ! -f "$cache_file" || "$plugins_file" -nt "$cache_file" ]]; then
    mkdir -p "$XDG_CACHE_HOME/sheldon"
    sheldon --profile="$profile" source >"$cache_file"
    zcompile "$cache_file"
  fi
  \builtin source "$cache_file"
}

sheldon::update() {
  sheldon --profile="eager" lock --update
  sheldon --profile="lazy" lock --update
  sheldon --profile="update" --quiet source | zsh
  git -C "$GHRD_DATA_HOME/src" pull
  gh-rd
}

sheldon::load eager
