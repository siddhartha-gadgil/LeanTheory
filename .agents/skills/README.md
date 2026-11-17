# Skills

Agent skills for a LeanTheory theory-development and verification project (`.claude` is a symlink
to `.agents`).

| Skill | Use when |
| --- | --- |
| `develop-theory` | exact triggers `start`, `work status`, `summarise work`, `work on ...` and `keep working`; sub-agents recommended for independent research, proof and audit strands |
| `edit-notes` | `add notes` or `modify notes`; record the discussion, edit only unstarted notes, and create separate code patch notes for implemented material |
| `update-notes-from` | `update notes from ...` supplied theory files or URLs; analyze sources and provenance with the source-study method, `proof-techniques`, `examples-counterexamples` and conjecture stress tests, then apply the same implementation gate and code patch note workflow |
| `audit-domain` | strictly auditing existing and new code, especially every kernel declaration; model changes; claim review; sanity triad plus risk-specific adversarial checks; audit ledger and scope statements |
| `formalize-theory` | formalizing a sourced result (paper, book, complete proof) as reusable Lean theory above the kernel |
| `discover-theory` | existing results do not give the needed bound or margin: conjecture, proof, counterexample, refinement |
| `try-to-prove` | `try to prove ...`: a proof attempt on a precise claim, running `reasoning-loop` in problem-solving mode |
| `explore-mathematics` | `explore ...`: an open-ended question, running `reasoning-loop` in exploratory mode to find questions and stress-tested conjectures |
| `reasoning-loop` | the mathematical reasoning loop behind both: deconstruct, triage, strategy or probes, execute, verify, metacognition and termination, with all artifacts in a task folder under `notes/reasoning/` |
| `examples-counterexamples` | constructing examples, boundary cases, counterexamples and existence witnesses to test statements, hypotheses and definitions; assesses whether an evolutionary search could find the object and launches one in parallel |
| `proof-techniques` | a library of proof techniques with a registry and worked examples, used when planning proofs |
| `certify-numerics` | turning a numerical candidate into a kernel-checked certificate (exact arithmetic, validated enclosures, remainder bounds) |
| `lean-proofs` | writing or repairing any Lean code: tactic choice, concrete checks with `kernel_fact`/`bool_cert`/`eval_cert`, the SubsetSum proof-term pattern, memory limits; no `decide` of any kind |
| `domain-design` | advancing a candidate design through verified milestones with composed certificates, tradeoff and tolerance studies |
| `ensure-theory-server` | before using the task server: check that `theory_server` is running, start it and wait until it is ready if not |
| `check-compilation` | checking whether Lean code compiles on the task server (task `check`) without changing its environment, for example for search candidates |
| `evaluate-on-server` | evaluating terms on the task server (task `eval`), optionally after defining functions, without changing its environment |
| `evolve-optimize` | `evolve ...` or `optimize ... subject to ...`: evolutionary search for a term of a given type with proved constraints and an optimal measure, checked on the task server (population, analysis, generation by sub-agents, evaluation, selection) |
| `workstation-update` | fetching, re-checking, merging and recording workstation runs (`workstation/*` branches) |

Worked examples referenced throughout: `LeanTheory/Kernel/Example.lean`, `LeanTheory/Sanity/Example.lean`, `LeanTheory/Bridge/Example.lean`, `LeanTheory/Certificates/Example.lean`, `LeanTheory/SubsetSum.lean`.
