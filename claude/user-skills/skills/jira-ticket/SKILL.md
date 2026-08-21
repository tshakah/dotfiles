---
name: jira-ticket
disable-model-invocation: true
description: Use to draft and create a Jira ticket. Writes a plain-English summary and a separate technical-detail section, both stripped of filler, and drafts acceptance criteria for the dedicated Acceptance Criteria field. Always creates as a Story. Shows the full draft and waits for confirmation before writing anything to Jira. Takes the ticket's subject — a bug, feature, or task description, or "make one from this conversation" — as args.
---

# Jira Ticket

## Purpose

Tickets in this codebase's tracker must be Stories with acceptance criteria in the dedicated Acceptance Criteria field, not folded into the description. Left to its own devices, the model pads tickets with restated requirements, hedge words, and "As a user I want" boilerplate nobody asked for. This skill exists to produce the opposite: short, and split into a plain-English part anyone on the team can read and a technical part that says exactly what needs to change.

Creating a ticket is a write action. Draft it, show it, and wait for explicit go-ahead before calling anything that writes to Jira — the same rule as any other tracker write.

## Input

Supplied via `args`: the subject of the ticket — a bug report, feature ask, task description, or a pointer to conversation context to turn into a ticket. If the subject is too thin to write acceptance criteria from (no clear done-state), ask what "done" looks like rather than inventing criteria.

## Step 1: Resolve the project and cloud

Resolve `cloudId` via `getAccessibleAtlassianResources` if not already known this session.

Resolve the project key from context (an epic or sibling ticket already under discussion, a project named in `args`) or ask — don't default to a project key without one of those signals.

Confirm the target project actually has a **Story** issue type via `getJiraProjectIssueTypesMetadata`. If it doesn't, stop and ask the user how to proceed rather than silently substituting Task or Bug.

## Step 2: Find the Acceptance Criteria field

Call `getJiraIssueTypeMetaWithFields` for the project and the Story issue type ID, with `requiredFieldsOnly: false`, and search the field dump for "Acceptance Criteria". Its `customfield_*` key varies by project — don't assume it's `customfield_10806` just because that's what it was on a previous project.

If the project has no dedicated Acceptance Criteria field, stop and ask the user how they want to proceed — don't silently fold the criteria into the description as a substitute.

That field has rejected a plain string in the past, reporting it needs an Atlassian Document even though its schema reports as plain text. Build it as ADF:

```json
{
  "type": "doc",
  "version": 1,
  "content": [{
    "type": "bulletList",
    "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "..."}]}]}
    ]
  }]
}
```

## Step 3: Draft the ticket

**Summary** — one line, states the change or the bug, no punctuation flourishes.

**Description** — two headed sections, markdown:

- **Summary** — plain English. What's wrong or wanted, and why it matters, in terms someone outside the codebase can follow. A sentence or two. No jargon, no restating the ticket title.
- **Technical detail** — what actually needs to change: affected files, services, or approach. Only what's needed to act on it — not a design doc.

**Acceptance criteria** — a bullet list, drafted separately for the field from Step 2, not duplicated into the description. Each bullet is one observable pass/fail condition. If the subject doesn't yield a real done-state, that's a sign to ask rather than pad the list with restated requirements.

Cut anything that doesn't survive these checks:
- Would deleting this sentence lose information? If not, cut it.
- Is this adjective doing work ("intermittent", "read-only") or decoration ("robust", "comprehensive", "seamless")? Cut decoration.
- Does this restate the summary, the title, or something already obvious from the ticket type? Cut it.
- "As a user I want..." framing — only include if the user explicitly asked for that format.

## Step 4: Show the draft and confirm

Print the summary, both description sections, and the acceptance criteria bullets exactly as they will be created. Ask for edits or go-ahead. Do not call `createJiraIssue` until the user confirms.

## Step 5: Create

`createJiraIssue` with `issueTypeName: "Story"`, `contentFormat: "markdown"`, the two-section description. Then `editJiraIssue` on the new issue to set the Acceptance Criteria field to the ADF payload from Step 2 — the create call's `additional_fields` may not convert markdown for a custom field, so set it as its own follow-up call and confirm the response reflects it.

## Step 6: Report

Give the ticket key and URL. Nothing else — the user already saw the content in Step 4.

## Red flags — stop and reconsider

- Creating anything other than a Story
- Acceptance criteria only in the description, not in the dedicated field
- Passing a plain string to the Acceptance Criteria field without checking whether it needs ADF
- Calling `createJiraIssue` or `editJiraIssue` before the user has confirmed the draft
- Restated requirements, hedge words, marketing adjectives, or unrequested "As a user" framing anywhere in the draft
- Assuming a project key, issue type ID, or custom field ID from a previous ticket instead of looking it up for this project
- Padding acceptance criteria to look thorough when the subject only supports one or two real criteria
