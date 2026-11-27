#!/bin/sh
# Triggered by "stls" (or "stlNs" for N screenshots) anywhere in the prompt.
set -eu

input=$(cat)
prompt=$(printf '%s' "$input" | jq -r .prompt)

match=$(printf '%s' "$prompt" | grep -oiE 'stl[0-9]*s' | head -1)
[ -n "$match" ] || exit 0

n=$(printf '%s' "$match" | grep -oE '[0-9]+' | head -1)
n=${n:-1}

files=$(ls -t "$HOME"/*_grim.png 2>/dev/null | head -n "$n") || true
[ -n "$files" ] || exit 0

list=$(printf '%s' "$files" | tr '\n' ' ')
context="Latest $n screenshot(s) found at: $list — read these files with the Read tool, then delete them with Bash rm."

jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
