#!/usr/bin/env zsh
icon=''
header="container"

docker ps -a --format="{{.Names}}\t{{.ID}} {{.Image}}\t{{.Status}}" |
  "${0:a:h}/format.zsh" "$icon" "$header" "yellow" "white" "dark_green" "dark_blue"
