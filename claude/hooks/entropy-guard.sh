#!/bin/sh
# PostToolUse guard: flags oversized single edits and over-long comment runs.
# Exits 2 so the message on stderr reaches the agent that made the edit. The
# edit is already written; this is feedback, not a block.

findings=$(jq -r '
  def prefixes:
    {"ts":"//","tsx":"//","js":"//","jsx":"//","groovy":"//","java":"//","gradle":"//",
     "rs":"//",
     "ex":"#","exs":"#","py":"#","sh":"#","fish":"#","yml":"#","yaml":"#","toml":"#",
     "elm":"--","sql":"--"};

  # Prose, not code: plans/specs routinely run long and have no comment syntax to check.
  def is_prose: . == "md" or . == "markdown" or . == "txt";

  # Rustdoc (/// and //!) and shebangs are documentation or directives, not
  # explanatory comments, so a long run of them is legitimate.
  def excluded: startswith("#!") or startswith("///") or startswith("//!");

  def longest_run($pfx):
    reduce (.[] | sub("^[[:space:]]*"; "")) as $line ({cur: 0, max: 0};
      if ($line | startswith($pfx)) and (($line | excluded) | not)
      then .cur += 1 | .max = ([.max, .cur] | max)
      else .cur = 0
      end
    ) | .max;

  (.tool_input // {}) as $in
  | (if .tool_name == "Write" then ($in.content // "")
     elif .tool_name == "Edit" then ($in.new_string // "")
     else "" end) as $text
  | if $text == "" then empty else
      ($in.file_path // "") as $path
      | ($path | split("/") | last | split(".") | last) as $ext
      | ($text | split("\n")) as $lines
      | [
          (if ($lines | length) > 80 and ($ext | is_prose | not)
           then "\($path): this edit wrote \($lines | length) lines in one go (threshold 80). State the behaviour that drove it, or split it."
           else empty end),

          # Only line comments are checked, which leaves out every doc-comment
          # form in these languages without needing an exception list.
          (prefixes[$ext] as $pfx
           | if $pfx == null then empty
             else ($lines | longest_run($pfx)) as $run
               | if $run > 2
                 then "\($path): a comment run of \($run) consecutive lines (threshold 2). Comments explain why, briefly — cut it down or delete it."
                 else empty end
             end)
        ]
      | .[]
    end
')

if [ -n "$findings" ]; then
  printf 'entropy-guard:\n%s\n' "$findings" >&2
  exit 2
fi
exit 0
