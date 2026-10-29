# LeanTheory

A general workspace for developing mathematical theory across science and engineering, with
**Lean 4 as the validity gate**. Work may be autonomous or interactive: users can pose several
goals and questions, develop or discuss research notes, add sources and ideas, and choose what to
work on next. Results count as established dependencies only after they have been formalized and
checked by Lean.

The template keeps the following general machinery:

- an architecture that separates the *model* (laws stated as typeclasses, never axioms) from its
  *sanity checks*, *bridges*, general *theory*, numerical *certificates* and concrete *designs*;
- a certificate toolkit that turns large numerical checks into explicit proof terms checked by the
  Lean kernel (no `decide`, no `native_decide`, standard axioms only);
- general analysis used by such certificates (strip/Fourier Banach algebras, KAM-type Newton
  iterations, analytic composition, Sturm–Picone–Riccati comparison, ODE barriers);
- a research-note graph connecting goals, questions, sources, conjectures, barriers and verified
  declarations;
- agent skills for interactive and autonomous theory development, plus a workstation pipeline
  for offloading heavy numerics and builds.

A small worked example (a one-dimensional harmonic oscillator) runs through every layer.

## Getting started

Create a fresh topic-named repository from this GitHub template, then follow
[the theory-development workflow](docs/GettingStarted.md). In a project checkout, users can ask
the agent to **`start`**, which strictly audits existing code and the complete domain kernel before
reporting status. Afterwards users can say `work on <note/goal/question>`, discuss an idea or
source, or say `keep working` to run the autonomous work-selection loop.

```bash
scripts/setup.sh                    # installs elan if missing, fetches the Mathlib cache, builds
scripts/setup.sh --check-axioms     # ... and runs the axiom audit
scripts/setup.sh --python           # ... and creates the Python venv for oracle scripts
source .venv-ws/bin/activate        # activate it before running project Python scripts
```

`scripts/setup.sh` is idempotent (Linux and macOS); `scripts/setup.sh --help` lists its options.
Run `scripts/setup.sh --check-axioms` at the first Lean use if `lean --version` is unavailable or
the checkout has not been set up. Request the Python environment only when a task needs it, and
activate `.venv-ws` in every new shell rather than installing project packages globally.
By hand: install [elan](https://github.com/leanprover/elan), then `lake exe cache get`,
`lake build`, `lake env lean scripts/check_axioms.lean`. The toolchain is pinned in
`lean-toolchain` (Lean and Mathlib `v4.34.1`).

## Architecture

```text
LeanTheory.lean          Root: imports every module of the default build
LeanTheory/
  Kernel/                Model laws as typeclasses (no axioms)          Kernel/Example.lean
  Sanity/                Degenerate cases, instances, counterexamples  Sanity/Example.lean
  Bridge/                Composition theorems between laws and results Bridge/Example.lean
  Theory/                General mathematics (KAM, Stability, Fields)
  Certificates/          Certificate formats, soundness theorems, proof-term builders
  Design/                Concrete certified candidates (empty in the template)
  SubsetSum.lean         Reference pattern: large proofs as explicit proof terms
LeanTheoryMeta/          `meta` code of `eval_cert`, precompiled to native code
scripts/                 Setup, axiom audit, kernel_fact audit, workstation pipeline
notes/                   Goals, questions, research notes, dependencies and progress
.agents/skills/          Agent skills (`.claude` is a symlink to `.agents`)
```

- **Kernel.** The domain model: definitions, and laws as typeclasses that theorems take as
  hypotheses. Kept small. Never an `axiom`.
- **Sanity.** For each law: a degenerate case, a concrete instance (so the law is satisfiable and
  theorems are not vacuous) and a counterexample (so the law excludes what it should).
- **Bridge.** Theorems that compose laws with each other and with theory or certificate results,
  with every hypothesis explicit.
- **Theory.** General mathematics, independent of the domain model.
- **Certificates.** Exact data plus checkers with soundness theorems; large checks are built as
  explicit proof terms whose leaves are kernel facts.
- **Design.** Concrete candidates whose properties are proved by composing the layers above.

The worked example: `Kernel/Example` states Newton's law for the oscillator as the typeclass
`OscillatorLaw` and proves `energy_conserved`; `Sanity/Example` gives the free particle, the
instance `cos`/`-sin` and the non-instance `exp`; `Bridge/Example` proves time-shift invariance,
superposition and `amplitude_bound`; `Certificates/Example` certifies, with `kernel_fact`, an
energy bound for 21 exact initial states and concludes `amplitude_cert`: `3 x(t)² ≤ 1` for all
time along every trajectory starting at one of them.

## Certificate toolkit

| Tactic / pattern | Module | Certifies |
| --- | --- | --- |
| SubsetSum pattern | `SubsetSum` | Reference: inductive certificate predicate, soundness by induction, `meta` builder producing the proof term |
| `kernel_fact` | `Certificates/KernelFact` | Closed facts (`∧`, `≤`, `<`, `≠`, `=` on `ℕ`/`ℚ`, list and bounded quantifiers) as proof terms with kernel-fact leaves |
| `eval_cert [f…]`, `eval_decide` | `Certificates/EvalCert`, `LeanTheoryMeta/EvalCert` | Evaluation of closed terms (integers, rationals, balls, records, lists, recursion), node by node with shared subterms |
| `fiv_cert`, `fiv_decide` | `Certificates/EvalCertFIv` | `eval_cert` preset for fixed-point interval (ball) arithmetic |
| `bool_cert` | `Certificates/BoolCert` | Boolean checkers recursing over lists, as explicit certificates |
| `icc_cert`, `icc_close` | `Certificates/IccListCert` | Finite sums and quantifiers over integer intervals |
| `kron_proof`, `kron2_proof`, `kron_lt` | `Certificates/KronProof`, `KronProof2D` | Kronecker-substitution ball checks (polynomial norms) as proof terms |
| `l1kron_cert`, `fampack_cert` | `Certificates/DigitSumCert`, `FamPackCert` | Digit sums and packed images of polynomial families |
| `QPoly.checkOn` | `Certificates/PolyInterval` | Polynomial lower bounds on every real point of an interval |
| radii polynomial, contraction | `Certificates/RadiiPolynomial`, `Contraction` | Existence of a true zero near an approximate one |
| `FIv` balls, validated trig | `Certificates/ValidatedQuadrature`, `ValidatedTrig(Fast)` | Sound interval arithmetic, `sqrt`, `exp`, trig, quadrature |

(`eval_decide` and `fiv_decide` are evaluation certificates of `decide p`, not the `decide`
tactic.) See [LeanTheory/Certificates/README.md](LeanTheory/Certificates/README.md) for every
module.

## Policies

- **No `decide` of any kind** (`decide`, `decide +kernel`, `decide_cbv`, `native_decide`): use
  `norm_num`/`rfl` for a few closed facts, `kernel_fact`/`eval_cert` for medium checks and the
  SubsetSum pattern for large ones.
- **Standard axioms only**: `lake env lean scripts/check_axioms.lean` must pass (only `propext`,
  `Classical.choice`, `Quot.sound`). No `sorry`, `axiom`, `admit`.
- **Zero warnings** in `lake build` (including the 100-character line linter).
- **≤ 6 GB per Lean process**: split large certificates over several modules; build heavy
  modules in small groups rather than letting Lake compile many at once.
- Every module, definition and theorem has a docstring; every new definition or certificate
  format has sanity theorems (degenerate case, instance, accepted and rejected fixtures).
- **Strict audits include previous code.** On `start`, inventory and red-team every kernel
  declaration, run the build and axiom audit, record the audited commit, and inspect affected
  downstream results. Every kernel law has the sanity triad plus at least one risk-specific
  adversarial check; every discovered defect gets a compiled regression check.

## Workstation workflow

Heavy untrusted numerics and first builds of large certificates run on a workstation through
`scripts/workstation/run.sh <task>`, which pushes a `workstation/*` branch with measurements and
a laptop verdict. On the laptop, "update from workstation" (skill `workstation-update`) re-checks
and merges passing runs. Compiled modules can be shared with `scripts/workstation/oleans.py`.
See [Workstation.md](Workstation.md).

## Starting a new theory

1. State any number of goals (`G-*`) and questions (`Q-*`) in
   `notes/implementation-plan.md`, including auxiliary items and dependency links.
2. Create research notes from sources, user ideas, calculations or open questions. Follow
   [the note template](notes/note-template.md): every note records dependencies, outputs,
   difficulty, barriers and Lean readiness.
3. Develop theory by alternating literature study, conjecture, proof, counterexample and
   refinement. A processed note may update goals/questions and produce further notes.
4. Formalize a claim when its statement, hypotheses and proof are ready. Write model laws in the
   kernel as typeclasses, add their sanity checks, and put derived mathematics in `Theory/` and
   `Bridge/`.
5. Generate certificates with an untrusted oracle when needed, validate every bound in exact
   arithmetic, and check the result with Lean.
6. Only use a result as an established prerequisite after its corresponding Lean declaration
   compiles. Exploratory work may be conditional on an unverified conjecture, but must remain
   labelled as such.
7. After each work unit, update the note graph and status report. In interactive mode ask the
   user what to work on next; in autonomous mode select the next ready, useful item.

The skills in [.agents/skills](.agents/skills/README.md) (`develop-theory`, `lean-proofs`,
`certify-numerics`, `discover-theory`, `formalize-theory`, `audit-domain`, `domain-design`,
`workstation-update`) describe each step for an agent.

**Future work.** A configurable documentation pipeline (handbook site and progress slideshow
generated from the notes) existed in the original project and was removed from the template.

## License

Apache 2.0; see [LICENSE](LICENSE).
