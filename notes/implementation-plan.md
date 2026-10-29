# Theory development and verification plan

This is the project index and plan of record. Replace every `‹…›` slot with domain content. Keep
stable identifiers when titles or priorities change; detailed work belongs in notes following
`notes/note-template.md`.

## 0. Current status

‹Summarize the domain, verified foundation, active research, main barriers and the most useful
ready choices. Separate compiled facts from conjectures, sources and observations.›

## 1. Goal registry

Several goals may coexist. Goals may be independent or support other goals.

| ID | Goal and success criterion | Supports / supported by | Status | Evidence needed |
| --- | --- | --- | --- | --- |
| `G-...` | ‹precise mathematical, scientific or engineering outcome› | ‹IDs› | ‹open / active / achieved / blocked / superseded› | ‹contracts and declarations› |

## 2. Question registry

Questions may be primary research outputs or auxiliary prerequisites.

| ID | Question | Needed by | Status | Current best answer / barrier |
| --- | --- | --- | --- | --- |
| `Q-...` | ‹precise question› | ‹`G-*`, `Q-*`, `N-*`› | ‹open / active / answered / blocked / refuted› | ‹summary and evidence level› |

## 3. Note registry and dependency graph

| ID | Note | Addresses | Depends on | Difficulty | Status / Lean readiness | Next action |
| --- | --- | --- | --- | --- | --- | --- |
| `N-...` | ‹path and title› | ‹`G-*`, `Q-*`› | ‹notes and declarations› | ‹routine / moderate / hard / research› | ‹exploratory / stated / proof-ready / lean-ready / verified / blocked / refuted / superseded› | ‹one work unit› |

A dependency is established only when its required output is a compiled Lean declaration. A note
may explore a conditional dependency, but the edge and all downstream status must remain marked
unverified.

## 4. Corrections and assumption ledger

‹List false or underspecified starting claims with precise replacements. Record every model law,
empirical input, parameter range, unit convention and validity envelope, together with its source.›

## 5. Theory tracks and model ladder

‹Group related notes into theory tracks. For each track give the current verified frontier,
questions, proof or certificate techniques, and first useful deliverable. List model rungs from
simple to realistic and the verified reduction or explicit error envelope needed between rungs.›

## 6. Work selection

Interactive mode: after each work unit report status and ask the user to choose a ready note, a
goal/question or a topic for discussion. Record user ideas and sources in the affected notes.

Autonomous mode (`keep working`): choose the highest-value ready note, preferring work that
unblocks several dependants, closes a validity gap, tests a risky conjecture or produces a reusable
theorem. Continue across work units without waiting for a choice; stop for a genuine user decision,
missing authorization or absence of useful ready work.

Current priority order:

1. ‹ready item and reason›
2. ‹ready item and reason›

## 7. Running a work unit

1. Resolve the selected `G-*`, `Q-*`, `N-*` or discussion topic to one coherent task.
2. Check dependency evidence and read the relevant notes, sources and compiled declarations.
3. Perform literature study, discovery, proof, counterexample search, computation, formalization or
   certification as appropriate to readiness.
4. Compile and audit any Lean output. Do not promote an output to verified on informal evidence.
5. Update the note graph, registries, barriers and this progress log.
6. Report verified and unverified outcomes separately and identify ready next work.

## 8. Definition of done

For a research note: claims and evidence are classified, dependencies and barriers are current,
outputs are recorded, and the next readiness-changing action is explicit.

For a verified result: declarations compile with docstrings and sanity theorems, zero warnings,
the axiom audit passes, entry points are registered, and the note gives an honest scope statement.

For a goal: all required contracts hold for compatible witnesses and models, and every claimed
dependency is backed by the recorded level of evidence. A formal theorem alone does not validate
the physical model.

## 9. Evidence gates

‹For each goal or design, list which contracts must hold for the same witness and which evidence
is required: compiled proof, exact certificate, empirical data or external model validation.›

## 10. Progress log

‹One dated entry per work unit: selected item, theory or note changes, declarations proved, failed
approaches and barriers, checks run, status changes, new dependencies and next ready choices.›

## 11. Implementation and workstation log

‹Technical notes: certificate formats, build time and memory, refactors and workstation runs. Keep
these distinct from mathematical evidence. See `workstation/REVIEWED.md`.›
