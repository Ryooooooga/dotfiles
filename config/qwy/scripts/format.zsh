#!/usr/bin/env zsh
# format.zsh <icon> <header> <header_color> [main_color] [desc_color] [note_color] [header_width] [main_width]
icon="$1"
header="$2"
header_color="$3"
main_color="${4:-bold}"
desc_color="${5:-dark_green}"
note_color="$6"
header_width="${7:-7}"
main_width="${8:-20}"

typeset -A ansi
ansi[reset]=$'\x1b[m'
ansi[bold]=$'\x1b[1m'
ansi[dim]=$'\x1b[2m'

ansi[red]=$'\x1b[31m'
ansi[green]=$'\x1b[32m'
ansi[yellow]=$'\x1b[33m'
ansi[blue]=$'\x1b[34m'
ansi[magenta]=$'\x1b[35m'
ansi[cyan]=$'\x1b[36m'

ansi[gray]=$'\x1b[38;5;250m'
ansi[dark_green]=$'\x1b[38;5;65m'
ansi[dark_blue]="$ansi[dim]$ansi[blue]"

reset="$ansi[reset]"
header_style="$ansi[$header_color]"
main_style="$ansi[bold]$ansi[$main_color]"
desc_style="$ansi[$desc_color]"

fmt=""
fmt+="${header_style}%s %-${header_width}s${reset}"
fmt+="  ${main_style}%-${main_width}s${reset}"
fmt+="  ${desc_style}%s${reset}"

if [ -n "$note_color" ]; then
    note_style="$ansi[$note_color]"
    fmt+=" ${note_style}%s${reset}"
fi

fmt+="\n"

awk -F '\t' \
    -v fmt="$fmt" \
    -v icon="$icon" \
    -v header="$header" \
    '{ printf fmt, icon, header, $1, $2, $3 }'
