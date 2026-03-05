#!/usr/bin/env zsh
icon='󰏪'
header="alias"

git --no-pager config get --all --show-names --regexp '^alias\.' |
  sed -E $'s/^alias\\.//; s/ /\t/' |
  "${0:a:h}/format.zsh" "$icon" "$header" "red"
