_tmux-fzf-switch() {
    _arguments \
        '1:session:->sessions'

    case "$state" in
        sessions)
            local sessions="$(tmux list-sessions -F "#S")"

            _values 'sessions' \
                "${(f)sessions}"
            ;;
    esac
}

_tmux-fzf-kill() {
    _arguments \
        '1:session:->sessions'

    case "$state" in
        sessions)
            local sessions="$(tmux list-sessions -F "#S")"

            _values 'sessions' \
                "${(f)sessions}"
            ;;
    esac
}

_tmux-fzf() {
    _arguments \
        '1:command:->commands'

    case "$state" in
        commands)
            _values 'commands' \
                'switch' \
                'kill' \
                'help' \
                'version'
            ;;
        *)
            local cmd="$words[2]"

            shift words
            (( CURRENT -- ))

            case "$cmd" in
                switch|sw)
                    _tmux-fzf-switch
                    ;;
                kill|k)
                    _tmux-fzf-kill
                    ;;
            esac
            ;;
    esac
}

compdef _tmux-fzf tmux-fzf
