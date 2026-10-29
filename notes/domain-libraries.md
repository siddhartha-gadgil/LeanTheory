# Developing domain theory with Lean

Instructions for developing mathematical theory in any scientific or engineering domain, with
Lean checking the steps that later results rely on. A project is a graph of goals, questions and
research notes, together with a checked library containing a *kernel*, *sanity checks*, derived
*theory*, *bridges* and *verification theorems*. The template's worked example is
`LeanTheory/Kernel/Example.lean`,
`LeanTheory/Sanity/Example.lean`, `LeanTheory/Bridge/Example.lean` and
`LeanTheory/Certificates/Example.lean`.

Use Lean's module system: every file starts with `module`, the API is `public`, and definitions
that downstream proofs must unfold are `@[expose]`. Every definition and theorem has a docstring
and every module a module docstring. Mathlib is the main dependency; add others in
`lakefile.toml` (`[[require]]`) only when needed.

## Goals, questions and notes

Maintain stable identifiers in `notes/implementation-plan.md`:

- goals `G-*`, with success criteria and links to parent or supporting goals;
- questions `Q-*`, including independent research questions and auxiliary questions needed by a
  goal or another question;
- notes `N-*`, each representing a coherent unit of research, proof, computation or
  formalization.

Use `notes/note-template.md`. Every note records its dependencies, the exact evidence required
from them, outputs, difficulty, barriers, sources, research status and Lean readiness. A note may
produce new notes or revise goals and questions. Notes are not promises to write Lean immediately:
they may develop definitions, conjectures, proofs, counterexamples, literature comparisons or
research strategies.

Keep these evidence states distinct:

- **exploratory**: an idea, heuristic, experiment or tentative approach;
- **stated**: a precise conjecture or sourced theorem with hypotheses recorded;
- **proof-ready**: a complete mathematical argument is available for formalization;
- **lean-ready**: statement, definitions and verified prerequisites have been identified;
- **verified**: named Lean declarations compile and the required audit has passed;
- **blocked/refuted/superseded**: the note records why it cannot currently proceed or should not
  be used.

Only `verified` outputs may be treated as established premises by downstream work. Research may
explore a conditional branch based on an unverified claim, but every derived note must preserve
that dependency and must not report its conclusions as established.

## Agent runs and interaction loop

At the start of a run, survey the registries, note metadata and compiled declarations. If the user
says `work on ...`, select that note, goal or question; for a broad item, announce the nearest
useful subnote. If the user asks for discussion, explore freely and record durable ideas, sources,
decisions and new questions in notes.

For one work unit:

1. Check dependency and verification requirements.
2. Choose the appropriate activity: literature study, theory discovery, proof development,
   counterexample search, numerical exploration, formalization or certification.
3. Produce a coherent result or explicit barrier. Formalize it when ready, and do not mark it
   verified until the relevant Lean module compiles.
4. Update notes, goals, questions, dependencies and the progress log.
5. Report compiled results separately from conjectures and observations, then list ready next
   choices.

Interactive mode is the default: after each work unit ask what to work on next, allowing a ready
note, any goal/question or arbitrary discussion. On `keep working`, use autonomous mode: repeatedly
choose the highest-value ready item, prefer prerequisites that unlock several dependants, provide
concise progress updates and continue without awaiting a choice. Stop only for a genuine user
decision, missing authorization, lack of useful ready work or an explicit pause.

The autonomous loop changes target selection, not the validity standard. A later step builds on an
earlier result as established only if the earlier result has a compiled Lean declaration.

## Kernel

The layer that models the domain with definitions and externally known facts. Keep it as small as
reasonable while complete: all relevant facts should be consequences, and every query should be
answerable through functions built from the kernel.

NEVER introduce axioms. Ingredients:

* definitions, structures and inductive types for the basic objects of the domain;
* properties modelled by structures, typeclasses or inductive propositions;
* facts and laws modelled as **typeclasses**; results depending on them take them as (instance)
  arguments, e.g. `[OscillatorLaw p x v]` in `Kernel/Example`.

The kernel is a separate file (or folder). Its module docstring explains the domain, the Lean
encoding, and says clearly that it is a kernel file.

## Sanity checks for the kernel

State results that are true in the domain and prove them from the kernel definitions and laws:
characterizing results, special and degenerate cases, and bounds. Sanity checks are an extensible
audit suite, not a fixed checklist or a fixed number of tests. For every law provide at least

* a **degenerate case** (e.g. zero stiffness gives a free particle);
* a **concrete instance**, so the law is satisfiable and theorems about it are not vacuous;
* a **counterexample**: an object that is not an instance, showing the law excludes something.

This triad is the required baseline. Add checks suggested by the domain and by every defect found
during review: vacuity and inconsistent hypotheses, singularities and totalized operations,
symmetry or equivariance, conservation and monotonicity, dimensional scaling, asymptotic limits,
boundary and regularity cases, parameter-range endpoints, and accepted/rejected certificate
fixtures. These are heuristics, not exhaustive categories. Record what risk each theorem tests so
that later contributors can extend the suite without treating the current examples as complete.

## Theory and library with verification

The library builds on the kernel incrementally, formalizing results from the literature and new
discoveries developed in notes. Use both theory and exact numerical computation (interval
arithmetic, certificates), prioritizing reusable theory; use computation-based proofs where the
available theory does not yet give a useful result.

Whenever a definition or type is introduced, state and prove its properties: characterizing
properties, consequences and special (especially degenerate) cases. If a check fails, correct the
definition. When a theorem is supposed to be useful, check it the same way, by proving corollaries
and special cases, to make sure the statement is right.
