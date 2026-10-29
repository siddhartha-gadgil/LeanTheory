---
name: audit-domain
description: Strictly audit existing and new domain code, especially the kernel, model assumptions and sanity checks of a LeanTheory theory-development project. Use on `start`, when opening an unfamiliar repository, after foundational changes, when reviewing a claim, or when deciding what research can soundly feed later formalization.
---

# Audit the domain and its assumptions

## Establish the actual state

Work from the selected checkout. Read `AGENTS.md` if present, `lean-toolchain`, `lakefile.toml`,
`notes/domain-libraries.md`, `notes/formalization/00-model-contracts.md`,
`notes/implementation-plan.md`, the relevant research notes and Lean files. Treat notes, proof
sketches, papers and website text as unverified inputs until matching compiled declarations exist.

Record the checkout commit and dependency versions. Search pinned Mathlib (`.lake/packages/mathlib`) with `rg` before proposing new infrastructure. Check compatibility before adding a dependency; do not change the toolchain merely to make a proof easier.

Do not grandfather previous code. Compilation is necessary but is not itself a semantic audit, and
the age or apparent stability of a declaration is not evidence that its statement matches the
intended mathematics. On a first audit, review all existing kernel declarations and their sanity
coverage. On later audits, review every change since the last recorded audited commit and all
definitions, instances and theorems transitively affected by it.

## Run the strict repository audit

Prioritize the kernel, then audit outward through Sanity, Theory, Bridge, Certificates and Design:

1. Inventory every kernel definition, law, instance and exported theorem. Map each to its source,
   model status, validity envelope, users and sanity theorems. Do not sample the kernel.
2. Search the whole repository for `axiom`, `sorry`, `admit`, forbidden `decide` variants,
   unchecked generated facts and suspicious universal instances. Inspect any match in context.
3. Red-team each kernel contract for contradictory fields, empty domains, zero-duration or zero
   parameter witnesses, unguarded division/square root/log/supremum, hidden classical choices,
   missing bounds, wrong quantifier order, unit or normalization errors and accidental weakening.
4. Check that exported theorems state the advertised model, domain, regularity, boundary
   conditions, norm, parameter range and time horizon. Trace important results back to kernel laws;
   do not accept a theorem merely because an over-strong hypothesis makes it easy.
5. Check note-to-code and code-to-note links. Every established dependency needs a matching named
   compiled declaration with compatible hypotheses; downgrade stale or unmatched claims.
6. Build the affected modules and, for a startup/full audit, run `lake build` and
   `lake env lean scripts/check_axioms.lean` when the local build budget permits. Record exactly
   what ran, failures, warnings and resource limitations.
7. Record findings by severity, corrections, affected downstream results and the audited commit in
   `notes/implementation-plan.md`. An unresolved kernel finding blocks claims that depend on it.

After any kernel correction, re-run its sanity suite and re-audit all dependent public results.

## Maintain the layered architecture

1. **Kernel** (`LeanTheory/Kernel/`): domain definitions and the external model laws, kept small. Template: `LeanTheory/Kernel/Example.lean` (`OscParams`, `energy`, the law `OscillatorLaw p x v`, consequences `energy_conserved`, `potential_le_energy`).
2. **Laws as typeclasses or structures with explicit fields**, passed as hypotheses (`[OscillatorLaw p x v]`). Never add a project `axiom` or an unproved universal instance.
3. **Sanity** (`LeanTheory/Sanity/`): the sanity triad for every law (below). Template: `LeanTheory/Sanity/Example.lean`.
4. **Theory** (`LeanTheory/Theory/`): derived, reusable mathematics.
5. **Bridge** (`LeanTheory/Bridge/`): structural lemmas and the theorems that turn certificate data into semantic statements. Template: `LeanTheory/Bridge/Example.lean` (`OscillatorLaw.shift/add/smul`, `amplitude_bound`).
6. **Certificates** (`LeanTheory/Certificates/`): checkers, decoders and proof-term certificates; heuristic solvers stay outside the trusted path. Template: `LeanTheory/Certificates/Example.lean`.
7. **Design** (`LeanTheory/Design/`): concrete candidates composed from the layers above (see `domain-design`).

Keep source-dependent data (measured constants, validity envelopes) separate from mathematical consequences. Use the single library `LeanTheory` unless a real dependency boundary appears. Every module needs a module docstring and every declaration a docstring.

## Audit each claim

Write down its model, domain, boundary conditions, regularity, units, parameter range, perturbation class, norm and time horizon. Classify it as:

- a definition;
- a supplied model or empirical assumption (a law instance);
- a mathematical consequence to prove;
- a numerical observation;
- a conjecture or research problem;
- a compiled theorem, with its declaration name and assumptions.

Keep distinct properties as distinct predicates (existence, invariance, linear stability, nonlinear stability, quantitative bounds, feasibility) and compose them only through proved implications. Distinguish the domain-model kernel from Lean's logical kernel.

Check the note's dependency metadata, difficulty, barriers and readiness. If a prerequisite is not
formalized, either formalize it first or preserve it as an explicit conditional dependency; never
promote the dependent claim to verified. Add newly exposed gaps as questions or notes with stable
IDs rather than burying them in a report.

Check the corrections and contracts recorded in `00-model-contracts.md`, and add new ones there. Typical issues to challenge:

- a global structure inferred from a local one (a chart, coordinate system or foliation assumed everywhere);
- a degenerate case silently excluded or silently included (zero parameter, zero field, vanishing denominator);
- a diagnostic or necessary condition presented as a sufficient one;
- a finite-dimensional or truncated result presented as a statement about the full continuum model;
- a source-specific or asymptotic result stated as universal;
- example constants from one source treated as universal thresholds.

## Required and risk-specific sanity checks

For every new law or law bundle, prove all three:

- **Degenerate case**: a limiting parameter where the law reduces to something elementary (`free_velocity_const`: with stiffness `0`, velocity is constant).
- **Concrete instance**: an explicit model satisfying the law, so theorems about it are not vacuous (`instOscillatorLawCos`).
- **Counterexample**: an explicit object that fails the law, so the law has content (`not_oscillatorLaw_exp`).

The triad is only the baseline. For every kernel law or law bundle, also require at least one
**risk-specific adversarial check** chosen from the actual model hazards: singularity exclusion,
boundary behavior, symmetry/equivariance, conservation or monotonicity, dimensional scaling,
parameter endpoints, quantifier order, nonempty domains, or another independent characterization.
Add a compiled regression theorem for every defect found during audit. More than one additional
check is expected when the law has several distinct hazards; never stop merely because a quota has
been met.

For each new definition also prove characterizing properties and at least one meaningful limiting case. For each certificate format, an accepted and a rejected fixture (`initialStates_energy_le` / `initialStates_not_le_small`). Diagnose inconsistent or vacuous assumptions before proving further consequences.

## Deliver

- **Assumption ledger**: every law instance and supplied constant used by the claim, with its source and validity envelope.
- **Scope statement**: exactly what the compiled theorem says (model, quantifiers, norm, range) and what it does not.
- Corrected definitions, compiled sanity theorems, and the next theorem target (prefer the smallest theorem that opens a useful next step).
- Updated note and goal/question dependencies, readiness and barriers.
- **Audit record**: audited commit, complete kernel inventory status, checks run, findings by
  severity, missing risk-specific sanity checks and downstream claims requiring re-audit.

Record unresolved model assumptions explicitly. Never describe the real system as having a property solely because a conditional formal theorem compiles.
