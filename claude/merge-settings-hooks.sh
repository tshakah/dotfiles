#!/bin/sh
# Hook events listed in settings-hooks.json are owned by dotfiles and replaced wholesale.
# Every other settings key belongs to Claude Code and the user.

set -eu

here=$(cd "$(dirname "$0")" && pwd)
settings=${1:-$HOME/.claude/settings.json}

mkdir -p "$(dirname "$settings")"
[ -f "$settings" ] || echo '{}' >"$settings"

tmp=$(mktemp "$settings.XXXXXX")
trap 'rm -f "$tmp"' EXIT
jq --slurpfile hooks "$here/settings-hooks.json" '.hooks = ((.hooks // {}) + $hooks[0])' "$settings" >"$tmp"
cat "$tmp" >"$settings"
