# notes/reasoning/

One folder per proof attempt or exploration, created by the `try-to-prove` and
`explore-mathematics` skills through `reasoning-loop`. Folders are named
`<YYYY-MM-DD>-<short-slug>/` and hold every artifact of the task:

- `README.md`: the task card, with the input, modes, linked goals, questions or notes, status,
  outcome and an index of the artifacts;
- `log.md`: a dated log of phases, decisions and commands;
- `01_` to `05_` files: formalization, examples, sources, questions, strategy or exploration
  plans, execution or research traces, and the final manuscript, failure report, research brief
  or obstacles report;
- `lean/`: Lean drafts checked with `lake env lean`; `computations/`: exploratory scripts and
  their outputs; `subtasks/`: recursive loops on hard lemmas.

A task's outcome is linked into the research graph in `../implementation-plan.md` when it ends.
Its evidence state follows `../domain-libraries.md`: an informal proof is proof-ready, a checked
Lean draft is lean-ready, and only a result promoted into `LeanTheory/` and passing the validity
gate is verified.
