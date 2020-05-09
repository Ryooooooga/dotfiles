### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

### ZDOTDIR ###
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

### asdf-vm ###
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"

path=(
    "$HOME"/.local/bin(N-/)
    "$CARGO_HOME"/bin(N-/)
    "$GOPATH"/bin(N-/)
    "$XDG_CONFIG_HOME"/scripts/bin(N-/)
    "$path[@]"
)

fpath=(
    "$HOME/.local/share/asdf/completions"(N-/)
    "$fpath[@]"
)
