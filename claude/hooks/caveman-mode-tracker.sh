#!/bin/sh
# Flags this session, not the model's memory: /compact and a spawned
# subagent don't carry forward whether caveman was on.
set -eu

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r .session_id)
prompt=$(printf '%s' "$input" | jq -r .prompt)

dir="$HOME/.claude/active-modes/caveman"

case "$prompt" in
	'/caveman off')
		rm -f "$dir/$session_id"
		;;
	'/caveman')
		mkdir -p "$dir"
		touch "$dir/$session_id"
		;;
esac

exit 0
