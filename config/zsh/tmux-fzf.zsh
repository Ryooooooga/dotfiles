tmux-fzf-switch() {
    local query="$1"
    local create_session_msg="Create a New Session"
    local selected="$((tmux list-sessions -F "#S" 2>/dev/null; print "\x1b[33m\x1b[1m$create_session_msg\x1b[m") \
        | fzf --height='40%' --cycle --query="$query")"

    local session_name="$selected"

    if [ -z "$selected" ]; then
        # no sessions were selected
        return
    elif [ "$selected" = "$create_session_msg" ]; then
        # create a new session
        session_name="$((random-word 2>/dev/null || echo "$RANDOM") | sed -E $'s/[:. \'"]/-/g')"
        tmux new-session -d -s "$session_name" || return 1
    fi

    if [ -z "$TMUX" ]; then
        tmux attach-session -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

tmux-fzf-kill() {
    local query="$1"
    local current_session="$([ -n "$TMUX" ] && tmux display-message -p "#S" 2>/dev/null)"

    local selected
    if [ "$#" -le 1 ]; then
        selected="$(tmux list-sessions -F "#S" 2>/dev/null \
            | fzf --multi --height='40%' --cycle --query="$query")"
    else
        selected="${(F)@}"
    fi

    [ -z "$selected" ] && return

    local kill_current_session=0
    for session in "${(f)selected}"; do
        if [ "$session" = "$current_session" ]; then
            kill_current_session=1
        else
            tmux kill-session -t "$session"
        fi
    done

    if [ "$kill_current_session" -ne 0 ]; then
        tmux kill-session -t "$current_session"
    fi
}

tmux-fzf-help() {
    command echo \
'tmux-fzf [cmd] ...

commands:
    switch  sw                  switch sessions (default)
    kill  k                     kill sessions
    help  h  --help  -h         display help message
    version  --version  -v  -V  display tmux version'
}

tmux-fzf-version() {
    tmux -V
}

tmux-fzf() {
    case "$1" in
        switch|sw)
            tmux-fzf-switch "${@:2}"
            ;;
        kill|k)
            tmux-fzf-kill "${@:2}"
            ;;
        help|h|--help|-h)
            tmux-fzf-help "${@:2}"
            ;;
        version|--version|-v|-V)
            tmux-fzf-version "${@:2}"
            ;;
       *)
            tmux-fzf-switch "$@"
            ;;
    esac
}
