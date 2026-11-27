#!/bin/sh
# Hook events in settings-hooks.json replace their local versions wholesale; allow rules in
# settings-permissions.json are appended, so "don't ask again" rules saved locally survive.

set -eu

here=$(cd "$(dirname "$0")" && pwd)
settings=${1:-$HOME/.claude/settings.json}

mkdir -p "$(dirname "$settings")"
[ -f "$settings" ] || echo '{}' >"$settings"

tmp=$(mktemp "$settings.XXXXXX")
trap 'rm -f "$tmp"' EXIT
jq --slurpfile hooks "$here/settings-hooks.json" \
  --slurpfile perms "$here/settings-permissions.json" '
  .hooks = ((.hooks // {}) + $hooks[0])
  | .permissions.allow = reduce $perms[0].allow[] as $rule (.permissions.allow // [];
      if index([$rule]) then . else . + [$rule] end)
' "$settings" >"$tmp"
cat "$tmp" >"$settings"
