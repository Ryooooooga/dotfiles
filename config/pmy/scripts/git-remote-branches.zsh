#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

icon="\uf65e"
header="remote"
name="%(refname:short)"
subject="%(subject)"
commiter_date="%(committerdate:relative)"

reset="$ansi[reset]"
header_style="$ansi[red]"
name_style="$ansi[red]$ansi[bold]"
subject_style="$ansi[white]$ansi[dim]"
date_style="$ansi[blue]$ansi[dim]"

format="$(print "$icon\t$header\t$name\t$subject\t$commiter_date")"

git --no-pager for-each-ref \
    'refs/remotes' \
    --format="$format" \
    --sort='-committerdate' \
    2> /dev/null \
    | awk -F '\t' "{
        printf \"$header_style%s %-6s$reset  \", \$1, \$2
        printf \"$name_style%-13s$reset  \", \$3
        printf \"$subject_style%s$reset \", \$4
        printf \"$date_style%s$reset\n\", \$5
    }"
