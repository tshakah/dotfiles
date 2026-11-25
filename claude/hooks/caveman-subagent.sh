#!/bin/sh
# A spawned subagent has no memory of the parent conversation, so caveman
# mode needs to be re-told here, not assumed inherited.
set -eu

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r .session_id)

dir="$HOME/.claude/active-modes/caveman"

if [ -f "$dir/$session_id" ]; then
	jq -n '{hookSpecificOutput: {hookEventName: "SubagentStart", additionalContext: "Caveman mode is active in the parent session. Apply the caveman skill voice rules in this subagent too."}}'
fi

exit 0
