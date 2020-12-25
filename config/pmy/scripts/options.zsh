#!/usr/bin/env zsh
# options <snippet> <icon> <header> <color>
. "${0:a:h}/ansi.zsh"

snippet="$1"
icon="$(print "$2")"
header="$3"
color="$4"

reset="$ansi[reset]"
header_style="$ansi[$color]"
name_style="$ansi[bold]"
desc_style="\x1b[38;5;65m"

command cat "${0:a:h}/../snippets/$snippet.txt" \
    | awk -F '\t' "{
        printf \"$header_style$icon %-7s$reset  \", \"$header\"
        printf \"$name_style%-20s$reset  \", \$1
        printf \"$desc_style%s$reset\n\", \$2
    }"
