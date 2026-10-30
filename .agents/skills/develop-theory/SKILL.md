---
name: develop-theory
description: Coordinate interactive or autonomous theory development in a LeanTheory project through goals, questions and dependency-aware research notes. Invoke this skill whenever a request contains `work status`, `summarise work`, `work on ...`, `keep working` or `start`, and for discussion that changes the research graph; route ready tasks while preserving Lean as the validity gate.
---

# Coordinate theory development

Read `docs/GettingStarted.md`, `notes/domain-libraries.md`, `notes/implementation-plan.md`,
`notes/note-template.md` and the notes relevant to the requested item. Inspect actual Lean
declarations before describing a dependency as verified.

## Maintain the research graph

Use stable identifiers for goals (`G-*`), questions (`Q-*`) and notes (`N-*`). Goals and questions
may be independent or auxiliary. Each note records what it addresses, dependencies and their
required evidence, outputs, difficulty, barriers, status and Lean evidence.

Processing a note may yield a proof, counterexample, source comparison, computation, new theory,
new notes or changes to goals/questions. Do not force exploratory mathematics into Lean before its
statement and argument are ready. Do not let an informal result become an established dependency:
only named compiled Lean declarations pass that gate. Conditional exploration on a conjecture is
allowed when every downstream result remains explicitly conditional and unverified.

## Interpret user requests

- For `start`, run `audit-domain` before ordinary work. If no audit record exists, perform a full
  strict audit of existing code, especially every kernel declaration. If an audit record exists,
  inspect all changes since its commit and refresh affected audits. Then report repository status,
  audit findings and ready choices. Do not begin new theory on an unaudited foundation.
- For `work status` or `summarise work`, report goals, questions, verified frontier,
  active/blocked notes and a few ready choices. Match the requested level of detail. Treat these
  exact phrases as explicit invocations of this skill, not as generic conversational requests.
- For `work on <item>`, resolve the ID, note path or topic. If it is broad, select and announce the
  nearest useful subnote. Respect the user's selection even when it is blocked: explain the
  missing prerequisites and work on one only when that is the closest in-scope way forward.
  Recommend launching sub-agents when independent strands can produce concrete inputs in parallel.
- For discussion, engage with the mathematics or source. Record durable conclusions, objections,
  sources and new subquestions in the graph when they materially affect future work.
- For `keep working`, enter autonomous mode and continue across work units without asking the user
  to select after each one. Proactively use available sub-agents for independent ready tasks or
  independent attacks on the same difficult question when this improves progress.

## Use sub-agents deliberately

In both `work on ...` and `keep working`, prefer launching sub-agents when at least two substantial
tasks can proceed independently. Useful assignments include primary-source review, counterexample
search, Mathlib/API reconnaissance, numerical exploration, proof attempts and an independent
kernel/specification audit. Give each sub-agent a precise item ID, inputs, output format and
non-overlapping scope; tell it which specialized skill to use when relevant.

The coordinating agent remains responsible for the research graph, mathematical consistency and
the final result. Before integrating a sub-agent result, inspect its claims and files, reconcile
definitions and hypotheses, and run the required Lean checks. A sub-agent report is not verified
evidence merely because it is confident or complete.

All agents share the checkout, so assign explicit file ownership and avoid concurrent edits to the
same files. Keep expensive Lean builds and certificate generation serialized unless resource
limits and disjoint outputs make concurrency clearly safe. Do not delegate a trivial task, a
tightly coupled proof step, or work whose coordination cost exceeds the likely gain.

## Run one work unit

1. Verify dependency status and choose one coherent outcome.
2. Route to the appropriate method: `discover-theory` for an open mathematical gap,
   `formalize-theory` for a complete sourced theorem or proof, `audit-domain` for model and
   specification risk, `certify-numerics` for a numerical certificate, `domain-design` for a
   candidate design, and `lean-proofs` when writing Lean.
3. Develop, test or formalize the result. Treat failed approaches and counterexamples as useful
   outputs and record the barrier they establish.
4. Compile and audit Lean output in proportion to the claim. Record exact declaration names and
   assumptions; otherwise leave the status below verified.
5. Update affected notes and `notes/implementation-plan.md`, including newly ready dependants.

Re-run the relevant strict audit after any kernel, foundational definition, law instance,
certificate soundness theorem or top-level claim changes. Existing code is in scope: do not audit
only the lines written in the current work unit.

## Select autonomous work

Choose among items whose established prerequisites are compiled. Prefer, in order of project
value rather than mechanically:

- a prerequisite that unlocks several important notes;
- a validity gap on the path to an active goal;
- an inexpensive counterexample test for a risky conjecture;
- a lean-ready theorem that advances the verified frontier;
- a research note likely to make a blocked question precise.

When several ready items are independent, keep multiple sub-agents productively occupied and
integrate their outputs at explicit checkpoints. Do not let autonomous delegation bypass audit,
authorization, resource or evidence requirements.

Create auxiliary notes or questions when discovery requires them, but do not silently replace a
user's top-level goal or make a materially new project commitment. Stop autonomous mode when no
useful item is ready, a real user choice is needed, authority or external input is missing, or the
user pauses it.

## Report and hand off

After each work unit, distinguish compiled results, complete but unformalized arguments,
conjectures, observations and barriers. In interactive mode, ask what to work on next and offer a
short set of ready notes/goals/questions plus free-form discussion. In autonomous mode, give a
concise progress update, name the next selected item and continue.
