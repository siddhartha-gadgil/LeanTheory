# Getting Started with `LeanTheory`: Develop Theory, Check It with Lean

**Repository template:** [`siddhartha-gadgil/LeanTheory`](https://github.com/siddhartha-gadgil/LeanTheory)
**Methodology:** research-note graphs + small, auditable domain kernels + Lean validity gates

## 1. Purpose

`LeanTheory` supports the development of mathematical theory throughout science and engineering.
It is not merely a pipeline for translating finished mathematics into Lean. A project may begin
with several independent or related goals, open questions, partial approaches, sources,
calculations and design problems. Agents and users develop these interactively or autonomously.

Lean provides the validity gate. Literature summaries, proof sketches, numerical experiments and
conjectures are valuable research artifacts, but they are not established results. A later step
may rely on an earlier result as proved only after a corresponding Lean declaration compiles.
Exploratory work may investigate consequences of an unverified conjecture, provided the
dependency remains explicit and no conclusion is reported as established.

Compilation does not rule out a badly stated or vacuous theorem. Strict semantic audits therefore
review old as well as new code, with complete coverage of the small domain kernel. An audit checks
that definitions express the intended model, assumptions are consistent, sanity checks are strong
enough, and downstream claims use the verified statement they advertise.

The method prevents two common failures:

1. **Research drift:** long agent runs lose the motivating question, repeat abandoned approaches
   or silently change definitions.
2. **Validity drift:** a plausible argument, sampled computation or cited result is treated as if
   it had already been checked under the exact hypotheses needed downstream.

## 2. The project graph

A project tracks three kinds of first-class items:

- **Goals (`G-*`)** are desired mathematical, scientific or engineering outcomes. There may be
  several goals, and a goal may support another goal.
- **Questions (`Q-*`)** are unresolved issues whose answers may be the project output or a
  prerequisite for a goal. A question can be independent, auxiliary, blocked or refuted.
- **Notes (`N-*`)** are work units. A note may synthesize literature, develop a definition,
  explore a conjecture, record a counterexample, give a proof, specify a computation, prepare a
  Lean formalization or document a verified result.

The registries and current priorities live in `notes/implementation-plan.md`. Detailed work lives
in topic-specific notes. Every note follows [the note template](../notes/note-template.md) and
records:

- the goals and questions it addresses;
- note and Lean-declaration dependencies, with the verification required from each;
- its expected outputs and any new notes it creates;
- difficulty, barriers and unknowns;
- research status and formalization readiness;
- claims, counterexamples, sources and compiled Lean declarations without conflating them.

Processing a note need not end in Lean code. It may produce new theory, split a question into
tractable subquestions, expose a barrier, refute an approach, update priorities, or create further
notes. When a claim becomes precise and justified enough to formalize, its note moves to
`lean-ready`; only successful compilation moves the result to `verified`.

## 3. Repository architecture

| Part | Purpose |
| --- | --- |
| `notes/` | Goals, questions, research notes, sources, dependency graph, barriers and status |
| `Kernel/` | Small domain specification: core objects and external laws as structures or typeclasses, never project axioms |
| `Sanity/` | Degenerate cases, concrete instances, counterexamples and domain-specific regression tests |
| `Theory/` | Reusable proved mathematics |
| `Bridge/` | Theorems connecting abstract theory and finite certificates to domain claims |
| `Certificates/` | Exact checkers, enclosures and certified data; external solvers remain untrusted |
| `Design/` | Concrete scientific or engineering candidates composed from verified layers |

The domain kernel is distinct from Lean's logical kernel. Lean verifies consequences of the
encoded model; expert review and validation determine whether the model applies to the intended
physical regime.

## 4. Starting a project

### Step 1: Create a topic-specific repository

On GitHub, open the [`LeanTheory` template](https://github.com/siddhartha-gadgil/LeanTheory),
select **Use this template**, and create a fresh repository in your account or organization. Name
it for the topic—for example `MarsMissionLean`, `PhotonicCrystalLean` or
`FluidStabilityLean`—rather than continuing in a repository named `LeanTheory`.

Clone the new repository and open that checkout in the coding-agent environment. Keep its notes,
history and Lean theory independent from other domain projects.

The startup audit is the first point at which Lean is needed. Check whether it is available:

```bash
lean --version
```

If that command is unavailable—or if this checkout has not yet fetched its dependencies—run:

```bash
scripts/setup.sh --check-axioms
```

On Linux and macOS this idempotent script installs `elan` if necessary, selects the Lean version
pinned by `lean-toolchain`, fetches the Mathlib cache, builds the project and runs the axiom audit.
If a newly installed `lean` or `lake` is not visible in the current shell, open a new shell or run
`source "$HOME/.elan/env"`. Do not install an arbitrary Lean version separately from the pinned
toolchain.

The first command to give the agent in any new or unfamiliar checkout is:

```text
start
```

`start` means: inspect the repository, strictly audit the existing kernel and affected code, run
the available build and axiom checks, record the audited commit and findings, then summarize goals,
questions, verified results, barriers and ready choices. It does not begin new theory until the
foundation has been audited.

### Step 2: Seed goals, questions and sources

Give the agent the scientific context, relevant papers or books, user ideas and desired outputs.
Do not force a single “north star” if the project naturally has several aims. Ask it to create:

- a goal registry with precise success conditions;
- a question registry, including which questions support which goals;
- an assumption and source ledger with validity ranges;
- initial notes and their dependency edges;
- a provisional priority order, clearly separated from verified facts.

Use this copy-paste prompt, replacing the bracketed fields:

```text
Seed the goals, questions, sources and initial research-note graph for this LeanTheory project.

Domain and context:
- Topic: [scientific or engineering domain]
- Background and intended scope: [what system or mathematics is being studied]
- Desired outcomes: [one or more goals; do not force them into a single goal]
- Open questions: [known primary or auxiliary questions]
- User ideas or proposed approaches: [ideas, conjectures, calculations or design directions]
- Sources: [papers, books, standards, datasets, links and precise locators where available]
- Constraints: [models, parameter ranges, units, tolerances, computational limits or exclusions]

Read notes/implementation-plan.md, notes/note-template.md and the startup audit before editing.
Then:
1. Create stable G-* entries for each distinct goal, with precise success criteria and
   parent/support relationships.
2. Create stable Q-* entries for independent and auxiliary questions, recording which goals,
   questions or notes need their answers.
3. Create an assumption and source ledger. Distinguish published theorems, empirical inputs,
   proposed models, user ideas, conjectures and numerical observations; record validity ranges
   and source locators without inventing missing details.
4. Propose initial N-* notes using notes/note-template.md. For each, record dependencies and the
   evidence required from them, expected outputs, difficulty, barriers, research status and Lean
   readiness.
5. Build the dependency graph and identify which notes are ready now. An earlier result counts as
   established only when its named Lean declaration compiles and its required audit has passed.
6. Suggest a provisional priority order, favoring work that resolves model ambiguity, tests risky
   conjectures or unlocks several downstream notes.

Do not begin formalization merely to fill the graph, and do not label sourced or plausible claims
as verified. Update notes/implementation-plan.md and create the initial note files. Finally report
the seeded graph, unresolved ambiguities and 2–5 ready choices, then ask what to work on next.
```

### Step 3: Develop the note graph

Choose a goal, question or note and process one coherent work unit. Depending on readiness, this
may mean studying literature, testing definitions, deriving a lemma, searching for a
counterexample, running an exploratory calculation, writing a proof, or formalizing it in Lean.

Most work does not require Python. When a note first needs a Python oracle, generator, exploratory
calculation or workstation helper, create the repository's managed environment and activate it:

```bash
scripts/setup.sh --python --no-build
source .venv-ws/bin/activate
python --version
```

The setup command creates `.venv-ws` and installs `scripts/requirements.txt`; it is safe to run
again when requirements change. Activate `.venv-ws` in each new shell used for project Python
work, run project scripts with its `python`, and use `deactivate` when finished. Do not install
project packages globally or use a different virtual environment without recording and justifying
the change.

The work unit ends by updating the affected notes and registries. New mathematical ideas belong
in notes even if they are not ready for formalization. New obstacles should become explicit
barriers or questions rather than disappearing into a progress narrative.

### Step 4: Formalize ready mathematics

Formalize only when the claim, hypotheses, definitions and proof route are sufficiently precise.
Search Mathlib and the existing project before adding infrastructure. Put model laws in `Kernel/`
as explicit hypotheses, derived mathematics in `Theory/`, domain connections in `Bridge/`, and
exact checks in `Certificates/`.

Every new law needs the sanity triad:

1. a meaningful degenerate or limiting case;
2. a concrete satisfying instance, guarding against vacuity;
3. a counterexample, showing that the law excludes something.

The triad is a baseline, not sufficient audit coverage. Every kernel law or law bundle also needs
at least one risk-specific adversarial check selected from its real hazards: singularities,
symmetry, conservation, monotonicity, dimensional scaling, parameter endpoints, boundary
behavior, quantifier order, nonempty domains, or accepted and rejected certificate fixtures. Add a
compiled regression check for every defect discovered later; use several additional checks when
the model has several independent risks.

### Step 5: Pass the validity gate

Compile the affected modules, run the axiom audit where appropriate, and record exact declaration
names and hypotheses. No downstream note may mark the result as an established dependency until
this succeeds. A failed formalization returns useful information to the research note: a missing
hypothesis, false conjecture, unsuitable definition or library gap.

Then perform semantic review. For kernel or foundational changes, re-audit all affected existing
code rather than only the new lines. Check vacuity, degenerate witnesses, totalized operations,
quantifiers, units, source fidelity, model scope and the continued validity of downstream
theorems. Record the audited commit and unresolved findings in the implementation plan.

### Step 6: Report and select the next work

After every work unit, report:

- what changed in the theory and note graph;
- what is compiled and therefore available downstream;
- what remains conjectural, empirical or blocked;
- newly created questions, notes and barriers;
- ready next choices and why they are ready.

In interactive mode, ask the user what to work on next. The user may select a ready note, any goal
or question, or an arbitrary topic for discussion. If prerequisites are missing, explain them and
offer to work on the closest prerequisite.

## 5. Ways to interact

These phrases are conventions rather than a rigid command language:

- **`start`** — the canonical first command after opening a repository. Run or refresh the strict
  audit, record its scope and results, then give a status summary and ready choices.
- **`work status` / `summarise work`** — invoke the theory-development skill to report goals,
  questions, verified results, active notes, barriers and ready choices at the requested level of
  detail. These distinctive phrases are preferred over generic `status` or `summarize` requests so
  Claude reliably selects the project skill.
- **`work on N-...`**, **`work on G-...`** or **`work on Q-...`** — begin a work unit on that
  item. For a broad goal or question, choose and announce the nearest useful subnote.
- **`discuss ...`** — explore an idea, source or objection with the user. Record durable outcomes
  as new or updated notes and dependency edges.
- **`keep working`** — enter autonomous mode. Repeatedly choose the highest-value ready item,
  develop or formalize it, update the graph, and continue without waiting for the user after each
  step. Give concise progress updates. Stop when a real user decision is required, no useful item
  is ready, authorization is needed, or the user asks to pause.

Interactive mode is the default. After an interactive work unit, present a short menu that may
include prerequisite-ready notes, open goals/questions and free-form discussion. Autonomous mode
uses the same validity gates; it changes work selection, not standards of evidence or authority.

## 6. Prompts for agents

### Repository startup

```text
Start. Before doing new work, strictly audit this repository at its current commit. Review every
existing kernel declaration and its sanity coverage, red-team assumptions and degenerate cases,
inspect affected downstream results, run the feasible build and axiom checks, and record findings
and the audited commit. Add missing risk-specific sanity or regression checks. Then summarize the
project and offer ready choices.
```

### Note worker

```text
Work on [N-ID, G-ID, Q-ID or topic]. Read its dependencies and verification requirements first.
Choose the appropriate activity: literature synthesis, theory discovery, counterexample search,
proof development, numerical exploration or Lean formalization. Do not use an unformalized claim
as an established premise. Update the note graph, readiness and barriers, then report verified
outputs separately from conjectural progress and offer ready next choices.
```

### Specification auditor

```text
Audit this model or proposed theorem for vacuity, contradictory hypotheses, degenerate witnesses,
unguarded total operations, missing quantifier bounds, unit or normalization errors, and a mismatch
between the claim and its cited source. Produce corrections, sanity checks and new research
questions. A correction is not verified until its Lean declaration compiles.
```

### Autonomous coordinator

```text
Keep working. Survey the goal/question/note graph, select the highest-value item whose established
prerequisites are compiled, and complete one coherent work unit. Update notes and verification
evidence, report a concise status update, then select the next ready item. Continue until genuinely
blocked or a user decision or new authorization is required.
```
