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

### Step 2: Seed goals, questions and sources

Give the agent the scientific context, relevant papers or books, user ideas and desired outputs.
Do not force a single “north star” if the project naturally has several aims. Ask it to create:

- a goal registry with precise success conditions;
- a question registry, including which questions support which goals;
- an assumption and source ledger with validity ranges;
- initial notes and their dependency edges;
- a provisional priority order, clearly separated from verified facts.

### Step 3: Develop the note graph

Choose a goal, question or note and process one coherent work unit. Depending on readiness, this
may mean studying literature, testing definitions, deriving a lemma, searching for a
counterexample, running an exploratory calculation, writing a proof, or formalizing it in Lean.

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

Add further checks suggested by the domain: singularities, symmetry, conservation,
monotonicity, dimensional scaling, parameter endpoints, boundary behavior, or accepted and
rejected certificate fixtures.

### Step 5: Pass the validity gate

Compile the affected modules, run the axiom audit where appropriate, and record exact declaration
names and hypotheses. No downstream note may mark the result as an established dependency until
this succeeds. A failed formalization returns useful information to the research note: a missing
hypothesis, false conjecture, unsuitable definition or library gap.

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

- **`status` / `summarize`** — summarize goals, questions, verified results, active notes,
  barriers and ready choices at the requested level of detail.
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

### Project architect

```text
Initialize this topic as a LeanTheory research project. From the supplied goals, questions,
sources and ideas, create stable G-*, Q-* and N-* identifiers; map their dependencies; and propose
the first ready work items. Do not assume that every target is already formalization-ready.
Separate sourced results, conjectures, empirical assumptions, calculations and compiled Lean
theorems. Use notes/note-template.md for every new note.
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
