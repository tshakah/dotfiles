#!/bin/sh
# Re-injects only on compact: startup/resume/clear/fork all start caveman
# off, same as a session that never turned it on.
set -eu

input=$(cat)
source_=$(printf '%s' "$input" | jq -r .source)
session_id=$(printf '%s' "$input" | jq -r .session_id)

dir="$HOME/.claude/active-modes/caveman"

# Opportunistic cleanup: drop flags from sessions untouched for a week.
find "$dir" -type f -mtime +7 -delete 2>/dev/null || true

if [ "$source_" = "compact" ] && [ -f "$dir/$session_id" ]; then
	jq -n '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: "Caveman mode is active for this session and survives this compaction. Keep responding in caveman voice per the caveman skill."}}'
fi

exit 0
