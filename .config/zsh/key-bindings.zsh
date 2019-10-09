if (( ${+commands[peco]} )); then
	fuzzy_finder=peco
elif (( ${+commands[fzy]} )); then
	fuzzy_finder=fzy
fi

select_history () {
	BUFFER="$(history -nr 1 | awk '!a[$0]++' | $fuzzy_finder --query "$LBUFFER" | sed 's/\\n/\n/')"
	CURSOR=$#BUFFER
	zle -R -c # refresh screen
}

select_cdr () {
	local selected_dir="$(cdr -l | awk '{print $2}' | $fuzzy_finder)"
	if [ -n "$selected_dir" ]; then
		BUFFER="cd $selected_dir"
		CURSOR=$#BUFFER
	fi
	zle -R -c # refresh screen
}

zle -N select_history
zle -N select_cdr

bindkey '^R' select_history # C-R
bindkey '^F' select_cdr # C-F
bindkey '^[[3~' delete-char # DELETE
bindkey '^[[1;5A' beginning-of-line # C-up
bindkey '^[[1;5B' end-of-line # C-down
bindkey '^[[1;5C' forward-word # C-left
bindkey '^[[1;5D' backward-word # C-right
