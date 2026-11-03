---
name: edit-notes
description: Create or revise LeanTheory research notes from the discussion in context. Invoke for "add notes" or "modify notes". Edit existing notes only before implementation starts; capture requested changes to partially or fully implemented notes in separate code patch notes.
---

# Add or modify research notes

Turn the current discussion into durable notes, preserving the user's scope, conclusions,
objections and open questions. Use the conversation as the primary input; do not invent research
results or start implementing Lean code as part of this workflow.

Read `notes/note-template.md`, the registries in `notes/implementation-plan.md`, and the relevant
notes. Search by topic, stable ID and declaration name to find existing coverage before creating
duplicates.

## Decide where each change belongs

Inspect each candidate note's metadata: implementation status and evidence, research status,
Lean evidence, dependencies and outputs. Check referenced modules/declarations and the registry
for work already started. Research readiness and implementation progress are separate:
`lean-ready` does not mean implemented, and `blocked` does not mean unstarted.

- **Implementation not started:** revise the relevant existing note in place, retaining its ID,
  provenance and useful failed approaches. Update metadata, claims, dependencies, barriers and
  next actions to match the discussion.
- **Fresh material:** create a new note using the template and a unique stable `N-*` ID. Link
  related notes and record exact dependency requirements rather than extending an unrelated note.
- **Implementation in progress or complete:** leave the original note unchanged, including its
  metadata. Create a separate patch note describing the changes needed in the code generated
  from that note. A note with any implementation started is protected as a whole, even if the
  requested edit concerns an unimplemented section.
- **Unknown or conflicting implementation evidence:** do not assume the note is editable. Search
  the referenced code and work log. If uncertainty remains, preserve the original and create a
  follow-up patch assessment note recording what must be checked before changing code.

For older notes without an implementation field, use recorded outputs, Lean evidence, registry
entries and matching source code to establish progress. Code or work in progress overrides a
stale `not started` label; `verified` is evidence that implementation has started. Missing compiled
evidence alone does not establish that implementation has not started. Do not relabel a protected
note to make it editable.

## Write a useful code patch note

Use the normal note template with `Kind: formalization` and a title identifying the proposed code
patch. Its own implementation status starts at `not started`; distinguish that from the status of
the original note. Record:

- The original note's ID/path, implementation evidence and relevant modules/declarations.
- The requested change and its provenance in the discussion, with the current and intended
  statements, hypotheses or behavior made explicit.
- The code changes required, affected callers, dependencies, sanity checks and validation needed.
  Mark targets that could not be located as unknown rather than inventing declarations.
- Whether the change corrects, extends or supersedes an existing claim, what remains unresolved,
  and the next implementation action. Do not present the proposed correction as already proved.

Reuse an existing unstarted patch note for the same change when appropriate. If that patch note
has itself entered implementation, create a new follow-up instead of rewriting it. Keep original
evidence and history intact; place links from new notes and the registry without editing protected
notes. Recording a code patch does not authorize carrying it out.

## Maintain evidence and hand off

For every new or editable note, fill in the template's metadata, including implementation status
and evidence. Preserve the distinction between user ideas, conjectures, sources, complete proofs
and compiled results. Only name a dependency as verified when its required declaration and
assumptions have been checked; discussion alone cannot promote it to verified.

Register new notes and synchronize affected links, dependency edges and next actions in
`notes/implementation-plan.md`. Do not rewrite protected notes' existing status or evidence to
describe a proposed patch; register that patch separately. Add a dated progress entry summarizing
the note changes. Avoid unrelated registry or goal changes.

Review the diff for accidental edits to protected notes, duplicate IDs and broken local links.
Report the notes created or modified, which originals were preserved, and the code patches queued.
Documentation-only changes do not require a Lean build.
