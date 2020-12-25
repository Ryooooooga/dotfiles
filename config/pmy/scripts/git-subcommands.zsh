#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

icon="$(print "\ufb32")"
header="command"

reset="$ansi[reset]"
header_style="$ansi[yellow]"
name_style="$ansi[bold]"
desc_style="\x1b[38;5;65m"

command cat "${0:a:h}/../snippets/git-subcommands.txt" \
    | awk -F '\t' "{
        printf \"$header_style$icon %-7s$reset  \", \"$header\"
        printf \"$name_style%-20s$reset  \", \$1
        printf \"$desc_style%s$reset\n\", \$2
    }"
