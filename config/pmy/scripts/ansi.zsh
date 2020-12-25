#!/usr/bin/env zsh
typeset -A ansi
ansi[reset]="$(print "\e[m")"
ansi[bold]="$(print "\e[1m")"
ansi[dim]="$(print "\e[2m")"

ansi[red]="$(print "\e[31m")"
ansi[green]="$(print "\e[32m")"
ansi[yellow]="$(print "\e[33m")"
ansi[blue]="$(print "\e[34m")"
ansi[magenta]="$(print "\e[35m")"
ansi[cyan]="$(print "\e[36m")"
