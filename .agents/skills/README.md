# Skills

Agent skills for a LeanTheory theory-development and verification project (`.claude` is a symlink
to `.agents`).

| Skill | Use when |
| --- | --- |
| `develop-theory` | `start`; coordinating goals, questions and notes; `work on ...` and `keep working`, with sub-agents recommended for independent research, proof and audit strands |
| `audit-domain` | strictly auditing existing and new code, especially every kernel declaration; model changes; claim review; sanity triad plus risk-specific adversarial checks; audit ledger and scope statements |
| `formalize-theory` | formalizing a sourced result (paper, book, complete proof) as reusable Lean theory above the kernel |
| `discover-theory` | existing results do not give the needed bound or margin: conjecture, proof, counterexample, refinement |
| `certify-numerics` | turning a numerical candidate into a kernel-checked certificate (exact arithmetic, validated enclosures, remainder bounds) |
| `lean-proofs` | writing or repairing any Lean code: tactic choice, concrete checks with `kernel_fact`/`bool_cert`/`eval_cert`, the SubsetSum proof-term pattern, memory limits; no `decide` of any kind |
| `domain-design` | advancing a candidate design through verified milestones with composed certificates, tradeoff and tolerance studies |
| `workstation-update` | fetching, re-checking, merging and recording workstation runs (`workstation/*` branches) |

Worked examples referenced throughout: `LeanTheory/Kernel/Example.lean`, `LeanTheory/Sanity/Example.lean`, `LeanTheory/Bridge/Example.lean`, `LeanTheory/Certificates/Example.lean`, `LeanTheory/SubsetSum.lean`.
