#!/usr/bin/env zsh
icon='󰘳'
header="task"

monkeywrench deno tasks 2>/dev/null |
    "${0:a:h}/format.zsh" "$icon" "$header" "yellow"
