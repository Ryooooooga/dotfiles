#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

icon="$(print "\uf8e9")"
header="alias"

reset="$ansi[reset]"
header_style="$ansi[red]"
name_style="$ansi[bold]"
desc_style="\x1b[38;5;65m"

git --no-pager config \
    --get-regexp '^alias\.' \
    | sed -E 's/^alias\.//; s/ /\t/' \
    | awk -F '\t' "{
        printf \"$header_style$icon %-7s$reset  \", \"$header\"
        printf \"$name_style%-20s$reset  \", \$1
        printf \"$desc_style%s$reset\n\", \$2
    }"
