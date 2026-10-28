# Getting Started with `LeanTheory`: From Domain Papers & Goals to a Verified Theory via AI Agents

**Repository Template:** [`siddhartha-gadgil/LeanTheory`](https://github.com/siddhartha-gadgil/LeanTheory)  
**Methodology:** Literate Blueprint-Driven Development + Small-Kernel "Swiss Watch Verification"  

---

## 1. Philosophy: How `LeanTheory` Works

`LeanTheory` is a general-purpose template (extracted from `PlasmaLean`) for formalizing scientific, engineering, and mathematical theories in **Lean 4** using AI coding agents and chatbots.

When using an AI agent to formalize a complex domain (such as plasma confinement, astrodynamics, photonic crystals, or fluid dynamics), asking the agent to *"formalize this paper directly in Lean"* almost always fails at scale due to two failure modes:
1. **Context Loss & Hallucinated Architecture:** Over thousands of lines, the agent loses track of global design goals, invents incompatible definitions across files, or wanders down dead-end proof paths.
2. **Specification Drift & "Junk Value" Exploits:** Because Lean 4 is a strict type checker rather than a physical oracle, an agent under pressure to close a `sorry` may unintentionally weaken a definition, introduce contradictory hypotheses (making theorems vacuously true), or exploit total-function junk values (like `1 / 0 = 0` or `Real.sqrt (-1) = 0`).

### The `LeanTheory` Solution: The 4-Layer Architecture
To prevent these failure modes, `LeanTheory` enforces a strict separation between **Literate Domain Notes**, the **Small Trusted Kernel**, **COSC Sanity Stress Tests**, and the **Gear Train (Domain Library & Certificates)**:

| Layer in `LeanTheory` | Horological Metaphor ("Swiss Watch Verification") | Purpose & Who Audits It |
| :--- | :--- | :--- |
| **1. `notes/*.md` & `ASSUMPTION_LEDGER.md`** | **The Master Blueprint** | Detailed Markdown notes distilled from papers/textbooks *before* writing Lean code. Contains exact equations, coordinate conventions, and explicit physical approximations. |
| **2. `Kernel/*.lean` (~100–200 LOC)** | **The Escapement** | A tiny, self-contained Lean 4 module containing only the core types, differential/integral operators, and top-level certificate contracts. **Human-auditable in 10 minutes.** |
| **3. `Kernel/SanityChecks.lean`** | **COSC Chronometer Bench Tests** | Compiled theorems stress-testing the kernel across 5 regimes: *Special Cases (Witnesses)*, *Degenerate Cases*, *Corner/Singularity Cases*, *Symmetries*, and *Scaling Limits*. |
| **4. `Library/*.lean` & `Certificates/*.lean`** | **The Gear Train & Mainspring** | Thousands of lines of helper lemmas, Fréchet derivatives, interval enclosures, and *a posteriori* ODE/PDE bounds synthesized by AI coding agents that mesh with the Kernel. |

---

## 2. The 6-Step Workflow: Starting a New Theory with a Chatbot / Coding Agent

Whenever you instantiate `LeanTheory` for a new scientific or mathematical project, follow this six-step loop with your AI assistant (e.g., Claude Code, Cursor, GitHub Copilot, Gemini, or ChatGPT).

### Step 1: Ingest Papers & Define the "North Star Certificate"
Do **not** start by asking for Lean 4 code. Start by giving your chatbot the domain papers, notes, or physical problem statement, and ask it to identify:
1. **The North Star Certificate:** What is the single concrete theorem at the end of the project that certifies a real-world design or mathematical goal?
2. **The Minimal Mathematical Ontology:** What are the fewest standard `Mathlib` types needed to state that certificate (e.g., `EuclideanSpace ℝ (Fin 3)`, `Matrix`, `IntervalIntegral`)?
3. **The Workstream Decomposition:** Break the domain into 6–12 modular chapters for the `notes/` directory.

### Step 2: Generate the Literate Markdown Blueprint (`notes/*.md`)
Instruct the chatbot to write one self-contained Markdown file per workstream in `notes/`. Every note **must** follow a mandatory 5-section template:
1. **Motivation & Verification Strategy:** Why we model the problem this way (e.g., using an *a posteriori* defect bound or conservation law rather than formalizing a black-box numerical solver).
2. **Exact Mathematical Formulation:** Self-contained LaTeX equations with explicit domains, quantifiers, and sign conventions.
3. **Proposed Small-Kernel Contract (Lean 4 Stub):** The exact `structure` or `def` that belongs in the trusted kernel.
4. **The 5 Sanity Stress Tests:** Specific mathematical checks for vacuity, degeneracy, singularities (`x / 0 = 0`), symmetry, and scaling.
5. **Assumption Ledger Entries:** Every physical idealization (e.g., point-mass gravity, neglect of solar radiation pressure, rigid body assumption) logged with an ID (`A1`, `A2`, ...).

### Step 3: Extract & Freeze the Small Kernel (`Kernel/*.lean`)
Once the Markdown notes look right to a domain expert, instruct the coding agent to extract **only** the core definitions and top-level certificate structures into `Kernel/`.
* **Rule 1 (Zero Project Axioms):** Never allow `axiom` or `sorry` inside a `Kernel/` definition.
* **Rule 2 (Guard All Partial Operations):** Every division `a / b`, square root `Real.sqrt x`, or `sSup S` in a kernel specification must be accompanied by an explicit positivity or non-emptiness hypothesis (`b ≠ 0`, `x ≥ 0`, `S.Nonempty`).

### Step 4: Compile the 5 COSC Sanity Stress Tests (`Kernel/SanityChecks.lean`)
Before letting the coding agent write thousands of lines of domain proofs, instruct it to prove the 5 Sanity Check categories against the Kernel:
1. **Clutch Engagement (Special Case Witness):** Prove `∃ x, KernelContract x` using an analytical textbook solution (e.g., a circular Kepler orbit or a uniform field).
2. **Banking-Pin Guard (Degenerate Case Rejection):** Prove `¬ KernelContract trivialZeroState` (e.g., zero thrust, zero mass, or teleporting trajectories are rejected).
3. **Singularity Guard (Corner Case):** Prove that collision/singularity points ($r = r_i$, where $1 / \|r - r_i\|^3$ divides by zero) are strictly excluded from valid domains.
4. **5-Position Orientation (Symmetry / Equivariance):** Prove that Galilean/Euclidean transformations or time shifts preserve the equations of motion.
5. **Isochronism (Scaling / Asymptotic Limit):** Prove that rescaling units or taking a small parameter $\varepsilon \to 0$ recovers the expected limiting law.

### Step 5: Build the Gear Train from the Notes (`Library/*.lean`)
Now point your coding agent at a specific section of `notes/03-kepler-and-lambert.md` and ask it to formalize the intermediate lemmas in `Library/` that connect the textbook equations to the frozen `Kernel/` types. Because the Kernel is frozen and sanity-checked, the agent cannot "cheat" by changing the target specification!

### Step 6: Log Progress in `PROGRESS.md` and `ASSUMPTION_LEDGER.md`
After each module compiles (`lake build`), instruct the agent to update the status badges in `notes/` and record any physical modeling assumptions in `ASSUMPTION_LEDGER.md`.

---

## 3. Copy-Paste Prompt Templates for Chatbots & Coding Agents

Use the four prompts below verbatim (filling in the bracketed placeholders) to drive your AI assistant from initial papers to compiled Lean 4 code.

### Prompt 1: The "Architect Prompt" (Papers + Goals $\to$ Workstream Plan & Assumption Ledger)
```text
You are the Lead Formalization Architect for a new project built on the `LeanTheory` template (https://github.com/siddhartha-gadgil/LeanTheory), following the "Swiss Watch Verification" philosophy.

### Project Goal & Reference Material:
- **Domain:** [e.g., Astrodynamics: Solar System N-body mechanics and Earth-to-Mars rocket trajectory verification]
- **North Star Goal:** [e.g., Machine-check a tolerance-aware Earth-to-Mars transfer trajectory certificate guaranteeing arrival within the Mars capture sphere under ±ε thrust and initial-state uncertainties, with zero planetary collisions.]
- **Key Papers / Textbooks:** [Paste abstracts, LaTeX snippets, or textbook chapters]

### Your Task:
Do NOT write long proof files yet. Instead, produce:
1. **The North Star Certificate Contract:** A 20-line Lean 4 `structure` using only standard `Mathlib` types that states our final physical guarantee.
2. **A 6-to-10 Chapter `notes/` Blueprint Index:** List the markdown files we need in `notes/`, separating pure geometry/kinematics, physical laws (ODEs/PDEs), analytical approximations, verified numerics (*a posteriori* defect bounds), and engineering tolerances.
3. **Initial `ASSUMPTION_LEDGER.md`:** A table distinguishing:
   - *Physical Model Assumptions* (e.g., point-mass ephemeris, patched conics vs. full N-body),
   - *Mathematical Hypotheses* (explicit fields in our Lean structures), and
   - *Verified Theorems* (zero project-specific Lean `axiom`s allowed).
```

---

### Prompt 2: The "Note Builder Prompt" (Drafting a Detailed `notes/*.md` File)
```text
We are building the file `notes/[FILENAME.md]` for our `LeanTheory` repository.
Write a comprehensive, mathematically rigorous Markdown formalization note for this chapter that a coding agent will use as the blueprint to write Lean 4 code.

Include these exact 5 sections:
1. **Motivation & Verification Strategy:** Explain how we convert the continuum ODE/PDE or physical problem into something tractable for formal verification (e.g., conservation laws, comparison principles, or *a posteriori* polynomial defect bounds / Picard-Lindelöf / Radii Polynomials rather than trusting a black-box numerical integrator).
2. **Mathematical Formulation:** Complete LaTeX equations with explicit coordinate frames, domains, and regularity assumptions.
3. **Small-Kernel Specifications in Lean 4:** The exact Lean 4 `structure` and `def` declarations (using `Mathlib`) that define the model contracts for this chapter. Explicitly guard all divisions (`d_min > 0`), square roots, and suprema against Mathlib's total-function junk values (`1 / 0 = 0`).
4. **The 5 COSC Sanity Stress Tests:** State 5 concrete Lean 4 sanity-check theorems for this module covering:
   - (a) *Special Case Witness* (Clutch Engagement: proving a known analytical solution satisfies the contract),
   - (b) *Degenerate Case Rejection* (Banking Pin: proving trivial/unphysical states like zero mass or teleportation are rejected),
   - (c) *Corner/Singularity Guard* (proving collision/division-by-zero points are excluded),
   - (d) *Symmetry/Invariance* (proving frame/rotation/scaling equivariance), and
   - (e) *Asymptotic/Scaling Limit* (proving conservation laws or limiting reductions).
5. **Self-Contained Micro-Bounties:** 2 or 3 self-contained pure-math lemmas (30–50 lines of Lean 4 each) that a mathematician can prove using only `Mathlib` without needing domain background.
```

---

### Prompt 3: The "Kernel Auditor Prompt" (Red-Teaming the Specification for Junk Values)
```text
Act as a hostile "Red-Team Specification Auditor" for our `LeanTheory` Small Kernel below.
Remember: an AI theorem prover trying to prove a target theorem will ruthlessly exploit any loophole in our definitions.

Inspect the following Lean 4 kernel definitions for:
1. **Vacuous Premise Traps:** Can two fields in the `structure` subtly contradict each other so that `Contract → Goal` is proved via `False.elim`?
2. **Degenerate Witness Exploits:** Can the contract be satisfied by setting a vector field to `0`, a time interval to `T = 0`, a domain to `∅`, or a linear operator `A = 0`?
3. **Mathlib Total-Function Junk Values:** Are there any unguarded divisions `x / y` (where `y = 0` gives `0`), `Real.sqrt x` (where `x < 0` gives `0`), `Real.log x`, or `sSup ∅`?
4. **Missing Quantifier Bounds:** Are boundary conditions or tolerances quantified over the full continuous interval `[0, T]` and perturbation ball `‖δ‖ ≤ ε`?

For every vulnerability you find, output the corrected Lean 4 `structure` and write a compiled Negative Sanity Check theorem (`theorem ... : ¬ Contract degenerateInput`) that blocks the exploit permanently.
```

---

### Prompt 4: The "Gear-Train Coding Agent Prompt" (Building Lean 4 Code from `notes/*.md`)
```text
Read `notes/[FILENAME.md]` and `Kernel/[KERNEL_FILE.lean]`.
Your task is to implement the Lean 4 module `Library/[MODULE_NAME.lean]`.

### Strict Rules:
1. **Do NOT modify any definition in `Kernel/`** to make your proof easier. The Kernel is our frozen escapement.
2. **Do NOT introduce any `axiom`.**
3. Start by translating the Sanity Checks from Section 4 of `notes/[FILENAME.md]` into `Kernel/SanityChecks.lean` and proving them completely (zero `sorry`).
4. For the main domain theorems in `Library/[MODULE_NAME.lean]`, decompose complex calculus or ODE defect bounds into small, 15-to-30-line helper lemmas with clear docstrings referencing the equation numbers in `notes/[FILENAME.md]`.
5. After compiling with `lake build`, update `PROGRESS.md` with the exact declaration names and their status (`[Compiled]`, `[Sanity Check]`, or `[Proof Sketch / Open Bounty]`).
```