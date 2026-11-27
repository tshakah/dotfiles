#!/bin/sh
# Triggered by "stls" (or "stlNs" for N screenshots) anywhere in the prompt.
set -eu

input=$(cat)
prompt=$(printf '%s' "$input" | jq -r .prompt)

match=$(printf '%s' "$prompt" | grep -oiE 'stl[0-9]*s' | head -1)
[ -n "$match" ] || exit 0

n=$(printf '%s' "$match" | grep -oE '[0-9]+' | head -1)
n=${n:-1}

if [ "$(uname)" = Darwin ]; then
  dir=$(defaults read com.apple.screencapture location 2>/dev/null) || dir="$HOME/Desktop"
  case $dir in "~"*) dir="$HOME${dir#\~}" ;; esac
  files=$(ls -t "$dir"/Screenshot*.png "$dir"/"Screen Shot"*.png 2>/dev/null | head -n "$n") || true
else
  files=$(ls -t "$HOME"/*_grim.png 2>/dev/null | head -n "$n") || true
fi
[ -n "$files" ] || exit 0

# Staged copies live in one fixed folder so a single Read permission rule covers them
# and no shell deletion (which needs its own prompt) is required afterwards.
stash="$HOME/.cache/stls"
rm -rf "$stash"
mkdir -p "$stash"
printf '%s\n' "$files" | while IFS= read -r f; do mv "$f" "$stash/"; done

ls -t "$stash"/* | jq -R . | jq -s --arg n "$n" '{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: ("Latest \($n) screenshot(s) found at: \(map("\"\(.)\"") | join(", ")) — read these files with the Read tool.")
  }
}'
