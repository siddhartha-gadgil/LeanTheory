# Research note template

Copy this template for each substantial unit of theory development. Use stable `N-*`, `G-*` and
`Q-*` identifiers from `notes/implementation-plan.md`. Remove guidance text after filling it in.

## Metadata

| Field | Value |
| --- | --- |
| ID | `N-...` |
| Title | ‹short descriptive title› |
| Kind | ‹source synthesis / definition / conjecture / research approach / proof / counterexample / computation / formalization / certificate / design› |
| Addresses | ‹`G-*`, `Q-*`› |
| Depends on | ‹note IDs and Lean declaration names› |
| Dependency requirement | ‹what exact statement/status is needed from each dependency› |
| Produces | ‹claims, definitions, data, declarations, new notes or registry updates› |
| Difficulty | ‹routine / moderate / hard / research; explain the main source of difficulty› |
| Status | ‹exploratory / stated / proof-ready / lean-ready / verified / blocked / refuted / superseded› |
| Lean evidence | ‹module and declaration names, or `none`› |
| Audit evidence | ‹audited commit and finding IDs, or `not audited`› |
| Last updated | ‹date and summary› |

## Purpose and scope

State the problem, why it matters, the intended output and what is outside scope. Give all models,
domains, units, conventions, quantifiers and parameter ranges needed to understand the claim.

## Dependencies

For each dependency, state whether it is a compiled theorem, a supplied model or empirical
assumption, a sourced but unformalized result, or a conjecture. An unverified dependency may guide
conditional exploration but may not be used as an established premise.

## Sources and prior work

Give stable source identifiers and theorem/equation/page locators. Distinguish published theorems,
formal calculations, numerical observations and empirical fits. Record user-contributed ideas and
their provenance without attributing more than is known.

## Theory development

Record definitions, conjectures, proof attempts, calculations, counterexample searches and
refinements. Preserve failed approaches when they identify a reusable barrier.

## Claims and evidence

List each claim separately with one status: conjecture, proof sketch, complete mathematical proof,
numerical observation, sourced theorem or compiled Lean theorem. For a compiled theorem, give the
declaration name and assumptions.

## Difficulty, barriers and readiness

Explain the mathematical difficulty, missing theory, missing source, model ambiguity, library gap
or computational cost. Say whether the note can generate Lean now. If not, name the smallest next
step that would change its readiness.

## Outputs and next dependencies

Record changes to goals/questions, new notes, declarations, counterexamples and suggested next
work. Identify which downstream notes become ready, if any.
