#!/usr/bin/env zsh
. "${0:a:h}/ansi.zsh"

icon="\ue71e"
header="script"

reset="$ansi[reset]"
header_style="$ansi[yellow]"
name_style="$ansi[bold]"
desc_style="\x1b[38;5;65m"

root="$(npm root)"
package="$(dirname -- "$root")/package.json"

format=""
format+="$header_style$icon %-7s$reset  "
format+="$name_style%-20s$reset  "
format+="$desc_style%s$reset\n"

jq -r '.scripts | to_entries | map([.key, .value]) | flatten[]' "$package" 2> /dev/null \
    | xargs -d '\n' -n2 printf "$format" "$header"

