#!/usr/bin/env bash
pane_current_path="$(tmux display-message -p -F "#{pane_current_path}")"

branch_icon=""
tag_icon=""
commit_icon=""

git_is_inside_repo() {
    command git -C "$pane_current_path" rev-parse 2>/dev/null
}

git_has_unstaged_changes() {
    ! command git -C "$pane_current_path" diff --quiet --exit-code
}

git_has_staged_changes() {
    ! command git -C "$pane_current_path" diff --quiet --exit-code --staged
}

git_head_status() {
    local branch tag commit

    branch="$(command git -C "$pane_current_path" branch --show-current)"
    if [[ -n "$branch" ]]; then
        command echo "$branch_icon $branch"
        return
    fi

    tag="$(command git -C "$pane_current_path" tag --points-at HEAD | head -n1)"
    if [[ -n "$tag" ]]; then
        command echo "$tag_icon $tag"
        return
    fi

    commit="$(command git -C "$pane_current_path" rev-parse --short HEAD)"
    command echo "$commit_icon $commit"
}

main() {
    local format=" "
    format+="#P: #[bold]#{pane_current_command}#[default]"

    if git_is_inside_repo; then
        local icons=""
        local colour="colour2"

        if git_has_unstaged_changes; then
            icons+="  "
            colour="colour3"
        elif git_has_staged_changes; then
            icons+="  "
        fi

        format+=" #[fg=colour246][#[default]"
        format+="#[fg=$colour,bold]$(git_head_status)$icons#[default]"
        format+="#[fg=colour246]]#[default]"
    fi

    format+=" "
    command echo "$format"
}
main
