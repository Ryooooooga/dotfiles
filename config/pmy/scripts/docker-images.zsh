#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

icon="$(print "\uf7c9")"
header="image"

reset="$ansi[reset]"
header_style="$ansi[green]"
name_style="$ansi[bold]"
desc_style="\x1b[38;5;65m"
date_style="$ansi[blue]$ansi[dim]"

docker images --format="$icon\t$header\t{{.Repository}}:{{.Tag}}\t{{.ID}} {{.Size}}\t{{.CreatedSince}}" \
    | awk -F '\t' "{
        printf \"$header_style%s %-7s$reset  \", \$1, \$2
        printf \"$name_style%-20s$reset  \", \$3
        printf \"$desc_style%s$reset \", \$4
        printf \"$date_style%s$reset\n\", \$5
    }"

