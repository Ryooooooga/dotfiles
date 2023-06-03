#!/usr/bin/env zsh
icon='󰋊'
header="image"

docker images --format="{{.Repository}}:{{.Tag}} {{.ID}}\t{{.Size}}\t{{.CreatedSince}}" |
    "${0:a:h}/format.zsh" "$icon" "$header" "green" "white" "dark_green" "dark_blue"
