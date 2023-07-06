#!/usr/bin/env zsh
icon=''
header="script"

monkeywrench node scripts 2>/dev/null |
    "${0:a:h}/format.zsh" "$icon" "$header" "yellow"
