#!/usr/bin/env zsh
icon=''
header="tool"

for k in "${(k@)commands[(R)*/git-*]}"; do
  printf "%s\t%s\n" "${k#git-}" "${(D)commands[$k]}"
done |
  sort |
  "${0:a:h}/format.zsh" "$icon" "$header" "green"
