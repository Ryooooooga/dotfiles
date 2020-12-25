#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

max_count=100
icon="\uf417"
header="commit"
hash="%h"
subject="%s"
commiter_date="%cr"

reset="$ansi[reset]"
header_style="$ansi[yellow]"
hash_style="$ansi[yellow]$ansi[bold]"
subject_style="$ansi[white]$ansi[dim]"
date_style="$ansi[blue]$ansi[dim]"

format="$(print "$icon\t$header\t$hash\t$subject\t$commiter_date")"

git --no-pager log \
    --color \
    --format="$format" \
    --max-count="$max_count" \
    2> /dev/null \
    | awk -F '\t' "{
        printf \"$header_style%s %-6s$reset  \", \$1, \$2
        printf \"$hash_style%-13s$reset  \", \$3
        printf \"$subject_style%s$reset \", \$4
        printf \"$date_style%s$reset\n\", \$5
    }"
