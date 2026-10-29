---
name: discover-theory
description: Develop new mathematical theory in a LeanTheory project using conjecture, proof, counterexample and refinement loops. Use for open questions and research notes when existing verified results do not yield a needed margin, bound, existence theorem, error estimate or constructive design condition.
---

# Discover useful mathematics

Read the selected research note, its goal/question and dependencies, the actual verified kernel,
`notes/formalization/00-model-contracts.md`, `notes/implementation-plan.md` and the method notes in
`notes/goals/`. Prefer theoretical advances; use numerical experiments to discover structure and
to produce counterexamples or candidate certificates. Do not assume an upstream note is true
unless its required Lean declaration compiles.

## Choose a precise gap

Select one missing implication on the path to a useful result or design. Specify inputs, output, model, norm, boundary conditions, parameter range and quantifiers. Prefer a reusable inequality or reduction over another opaque objective function.

Typical targets: completing squares in an energy functional, identifying the right quotient by symmetry or neutral modes, bounding a coupling block, certifying an invariant barrier, bounding drift through an approximate invariant, a derivative estimate from design parameters to the quantity of interest, a robust margin under parameter uncertainty.

## Run the discovery loop

1. Formulate the proposed theorem with all constants and hypotheses.
2. Look up the closest primary literature and its limitations. Record novelty as provisional until the search and source comparison are complete.
3. Seek a proof by algebraic rearrangement, conservation, symmetry, comparison, compactness, variational arguments, perturbation theory or validated computation.
4. Independently seek counterexamples: zero modes, resonances, degenerate parameters, singular points, boundary effects, large gradients, truncated modes, adversarial corners of the uncertainty set.
5. Check an experimental counterexample against the exact definitions. A floating-point failure is evidence to investigate; an exact witness refutes the statement.
6. If refuted, repair the claim by an interpretable hypothesis or a narrower conclusion, and record why the change is necessary.
7. Prove the repaired theorem when possible and test useful special cases. Formalize it with
   `formalize-theory` when the argument and prerequisites are ready; otherwise create the next
   research note or record a clearly stated obstruction.

Keep conjectures, exact counterexamples, proof sketches, compiled Lean theorems and numerical observations separate. Never add a conjecture as an axiom, claim novelty from Lean acceptance, or hide an unresolved estimate inside a typeclass instance.

## Make the mathematics constructive

Prefer conclusions supplying a margin, an explicit radius, a parameter interval or a checkable witness. For example, seek `q(ξ) ≥ c ‖ξ‖²` on a declared admissible quotient with computable `c > 0`, rather than an unquantified positivity claim; the template's `amplitude_bound` (`LeanTheory/Bridge/Example.lean`) is the simplest instance of this shape: an explicit bound from a conserved quantity. For uncertainty, prove bounds for every parameter in the stated set; do not replace universal quantifiers by a sample grid.

Keep the theorem's actual scope when the strong form fails. Explore weaker but true statements (nonnegativity instead of coercivity, finite-time instead of all-time, parameter-restricted results) or an explicit witness of failure.

## Finish with an actionable record

Update the note with the final claim, proof or obstruction, exact hypotheses, literature
comparison, counterexample attempts, difficulty, barriers, Lean readiness, design implication and
next dependencies. Create new `N-*` or `Q-*` entries for substantial branches. Update
`notes/implementation-plan.md` after every work unit, not only after successful formalization. Do
not inflate a restricted mathematical improvement into a verified result or a claim about the
full real-world system.
