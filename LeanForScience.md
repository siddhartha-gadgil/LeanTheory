# Lean Prover for AI for Science and Engineering

Artificial Intelligence systems have become very powerful at mathematics. It is natural to hope to use this and other capabilities of AI to accelerate scientific discovery (including engineering and mathematics). We need high reliability and autonomy to be able to do this on a large scale.

For AI discovered mathematical proofs, checking has been done by translating to computer checkable proofs, primarily with the Lean prover. The translation is also done by AI - a process called **Autoformalization**.

My goal today is to show how to use AI and Lean in (mathematical aspects of) science in a way that is fairly straightforward, and in particular requires relatively little AI or Lean expertise. I will discuss this at different levels - via general principles, a specific example, and a plug-and-play repository with which you can begin building a theory.

## Expanding Mathematics in Science

### Abstraction and Mathematics

All knowledge beyond cataloguing of facts (so called “stamp collection”) depends on abstraction - hiding away of details that are not relevant to what we seek to understand and considering only the essential features. This is sometimes at the cost of simplifying, or taking an ideal model of, what we are studying.

Thus, Newton’s laws of motion can be used to calculate the trajectory of a point-mass. When studying a point-mass we are ignoring a lot of irrelevant features, such as the colour, material and geographical location of the body. We are further ignoring the size and shape, which do affect the trajectory, as their effect is small.

Abstraction is done most explicitly in working with modular systems in engineering, for instance in software engineering. For example, when processing data we abstract the source as a data stream, hiding away whether this is loaded from a drive, streamed over the internet or input by the user.

In all these cases, we abstract by specifying the properties of our system that we are concerned with and studying the system (or its idealised version) in terms of those properties. This has many advantages - what we deduce applies to all systems for which the abstraction is valid, and our attention is focussed on what matters for the questions at hand.

In mathematics, we turn things on their head and consider fully abstracted systems. Thus, rather than saying that we study systems in terms of the properties of their idealised, abstracted forms, we define our objects of study as those satisfying some properties (or axioms) and think of these as real objects. We go further by thinking of each new abstraction as giving real objects. We make further abstractions as we study these new objects. These are based on things we discover about them as well as techniques we use to study them. This leads to a tower of abstractions.

### Applicability of Mathematics

When we abstract nature to obtain mathematics, we typically simplify. This means that there is a gap between the empirical and the mathematical. This limits the applicability of mathematics to some extent.

However, even if the match between mathematics and some aspect of science and engineering is very good, alternatives to mathematical proofs such as simulations, numerics and even experiments are often used. This is because the underlying mathematics is too hard, too tedious, or a combination. It is this limitation that we can hope to overcome with AI greatly accelerating mathematical discovery.

One such example is the design of fusion reactors called Stellarators. I take this as a model example. Going ahead, I hope to build (and invite others to build) many smaller but interesting and useful mathematical theories.

## Mathematics by AI

Artificial Intelligence systems have rapidly progressed in mathematics over the last couple of years. They famously solved a millenium prize problem in September, showing that the Navier-Stokes equations (the equations of fluids) can blow up in finite time.

However, the event that established the power of AI in mathematics was the 700+ preprints posted by OpenAI on October 6, 2026. These included several results that were:

* Fundamental to (a field of) mathematics.
* Which had been long open, so presumably should be regarded as hard.
* With proofs that were long in many cases (and have not been shortened greatly).
* Both constructions/counterexamples and "positive" theorems.

### Example: Rational Solutions of Diophantine Equations

A Diophantine equation is a polynomial equation with integer coefficients, such as $x^2 + y^2 = z^2$. A fundamental question in mathematics is to determine when such an equation has a solution with $x$, $y$ and $z$ integers.

Given a candidate solution, it is straightforward to plug in and check if it is indeed a solution. By plugging in candidates successively, if there is a solution we can find it. However, we don't know when to give up. And indeed we may need to search a long time - the smallest **positive integer** solutions of the equation $x^2 - 61y^2$ are $x = 1,766,319,049$ and $y = 226,153,980$.

A whole host of methods in number theory can be used to rule out solutions. These range from the elementary, such as taking remainders (for example modulo $4$ for $x^2 + y^2 = 3$) to very deep.

Hilbert's 10th problem (one of 20 famous problems stated in 1900) asked if there is an algorithm to determine whether a Diophantine equation has a solution. This became a precise question after the work of Church and Turing.

Tarski showed in 1948 that there is indeed an algorithm to determine whether an equation has a **real** solution. However, work of Davis, Putnam, Robinson and Matiyasevich, completed in 1970, showed that there is no algorithm to determine whether there is an integer solution.

This left open the question of whether there is an algorithm to determine if such an equation has a rational solution. One of the October 6 preprints of OpenAI proved that it is algorithmically undecidable.

The proof was based on using a postulated rational-solvability algorithm to construct a sequence of finite tests so that integer solutions exist if and only if all the tests pass. This gives an algorithm for testing integer solutions by alternately plugging in candidates and carrying out tests. One of these must succeed, giving a contradiction.

## Lean Prover: An Example

As an example, we see the proof that there are
<a href="https://live.lean-lang.org/#codez=CYUwZgBAdgXhAUUIC4IDkCGAXAlCiA3gG76ZYQD0FEJgJkTQC%2BKAvBALbYDGAFtBAO4BLLNwBQECAB8IABgjMAfBEAX5DIA0EAEYBPCAHMAToKjBAl%2BTipfANQQAjPIUWJ3DERARugQIJ8iOFBwAdEQYADYQ9EjIrL7QgQAOBgD2cSAGWNpOKjEx%2FkGhgcEhGjr6RibmoqKgkLAA5AhQqGR4UQ1%2BBaGiQA" target="_blank">infinitely many primes</a>.

## Trust and Verification with Lean

### Kernel

Lean is large and complex software. However, the part that checks proofs is a few thousand lines of code called the **kernel**. This is analogous to the part of a chess engine that checks whether moves are legal.

So correctness of proofs checked by Lean depends not on the correctness of all of Lean but just its kernel. Furthermore, independent kernels have been written in other languages, and so an invalid proof is accepted only if it passes these. Other ways of checking like model building have also been recently implemented.

### Definitions and Statements

Even if a proof is correct, it may be proving the wrong thing - different from what we intend in mathematics, and mismatched with reality in science. This could be because of an error in definitions or statements. We need to guard against these.

## Autonomous Verification of Models/Definitions

While checking definitions and statements is typically significantly easier than checking proofs, manually checking these will limit scale. We use three principles to reduce this source of errors with modest manual intervention.

### Proof Challenges

To test a definition, we can generate many statements using AI that hold if the definition is correct. If these are generated following sanity check recipes well known to mathematicians, being able to prove all these greatly increases our confidence in the definitions.

### Small Kernels

Just as Lean itself has a small kernel, we can isolate the key defining model of our domain into a modest amount of code. Other results can be verified in terms of these. The kernel itself can be intensively tested with proof challenges, and even manually inspected.

### Swiss-Watch Verification

In a complex interlocking design, such as a swiss watch or a mathematical theory, an error will cause failures such as jamming or compilation errors. Further, a few errors are highly unlikely to cancel, but will instead result in worse failures. Thus, interlocking theories built on stress-tested kernels are largely self-correcting.

## Building Theories: plug-and-play setup

The principles above are packaged in a template repository, <a href="https://github.com/siddhartha-gadgil/LeanTheory" target="_blank">LeanTheory</a>. To build a theory in some domain, we create a fresh repository from this template, named for the topic, and work with an AI coding agent in it. The repository contains instructions for the agent (called **skills**), so most of the interaction is in natural language. Little expertise in Lean, or in setting up AI agents, is needed.

### Developing Theory, not just Translating It

Building a theory is not merely translating finished mathematics into Lean. We typically begin with several goals, open questions, partial approaches, sources, calculations and design problems. These are developed interactively or autonomously, and are tracked as a graph with three kinds of items:

* **Goals:** desired mathematical, scientific or engineering outcomes.
* **Questions:** unresolved issues, whose answers may be the output we seek or a step towards a goal.
* **Notes:** units of work, such as a literature summary, a definition, a conjecture, a counterexample, a proof, a computation or a formalization.

Each note records what it depends on, what it is expected to produce, its difficulty and the barriers to completing it. Working on a note need not end in Lean code. It may instead produce new theory, split a question into simpler ones, expose an obstacle or refute an approach.

### Lean as the Validity Gate

Literature summaries, proof sketches, numerical experiments and conjectures are valuable, but they are not established results. Notes pass through stages - from *exploratory*, to *stated* precisely, to having a complete proof, to being ready for formalization. Only when the corresponding Lean code compiles is a result *verified*, and only then can later work rely on it.

We can still explore the consequences of a conjecture, as long as the dependence is recorded and the conclusions are not reported as established. This guards against two common failures of long AI runs:

* **Research drift:** losing the motivating question, repeating abandoned approaches or silently changing definitions.
* **Validity drift:** treating a plausible argument, a sampled computation or a cited result as if it had been checked under the exact hypotheses needed.

### Layers of a Theory

The Lean code is organized in layers, separating the model from what is deduced from it.

* **Kernel:** the small domain model. Basic objects are definitions, and laws of nature or known facts are *hypotheses* (never axioms) that theorems explicitly assume.
* **Sanity:** proof challenges testing the kernel.
* **Theory:** general mathematics, independent of the domain.
* **Bridge:** theorems connecting the theory and computations to claims about the domain.
* **Certificates:** exact numerical checks, proved correct in Lean.
* **Design:** concrete scientific or engineering candidates, with properties proved by combining the layers above.

The template includes a small worked example running through all the layers - the harmonic oscillator, that is, a mass on a spring. The kernel states Newton's law for the oscillator, from which conservation of energy is proved. Combined with certified numerical checks, this gives bounds on the motion for all time.

The domain kernel is different from Lean's kernel. Lean verifies the consequences of the model we have encoded. Whether the model applies to the physical situation is a matter for experts and experiments - this is the gap between the empirical and the mathematical that we saw earlier.

### Sanity Checks and Audits

Every law in the kernel is tested by at least three proof challenges:

* A **degenerate case**: for example, with zero stiffness the oscillator is a free particle.
* A **concrete instance**: for example, $x(t) = \cos t$ is a solution. This shows the law can be satisfied, so theorems about it are not vacuously true.
* A **counterexample**: for example, $x(t) = e^t$ is not a solution. This shows the law rules out something.

This is a baseline. Further checks are chosen from the specific risks of each law, such as singularities, symmetries, conservation laws, scaling, boundary behaviour and the order of quantifiers. Every error found later becomes a permanent check.

Audits are strict and include old code - code is not trusted just because it compiles, or because it was written earlier. The first command in any repository runs an audit of the whole kernel before any new work begins.

### Numerics as Proofs

Recall that simulations and numerics are often used in place of mathematics. We can use them, but as **untrusted oracles**. Fast numerical code proposes candidates and bounds, which are then checked using exact arithmetic and interval arithmetic (computing with guaranteed upper and lower bounds). The checks are turned into proofs that Lean's kernel verifies.

The template includes a toolkit for such certificates, together with general mathematics they need - for example, results giving existence of a true solution near an approximate one. Heavy computations can be offloaded to a workstation, with results re-checked before they are used.

### Working with the Agent

We interact with the agent using a few conventional phrases:

* **`start`:** audit the repository and summarize goals, questions, verified results, barriers and choices of what to do next.
* **`work status`:** report on the state of the project.
* **`work on ...`:** work on a particular goal, question or note.
* **`discuss ...`:** explore an idea, source or objection, recording durable outcomes as notes.
* **`add notes` / `modify notes`:** turn a discussion into new or revised notes.
* **`update notes from ...`:** read papers, documents or web pages and integrate them into the notes.
* **`keep working`:** work autonomously, repeatedly choosing the most valuable task that is ready.

By default the agent asks what to work on after each unit of work. In autonomous mode it chooses for itself, stopping only when a decision by the user is genuinely needed. Autonomy changes how work is chosen, not the standards of evidence.

### Getting Started

1. Create a repository from the template on GitHub, named for your topic.
2. Run the setup script, which installs Lean and its mathematical library, Mathlib.
3. Tell the agent to `start`.
4. Seed the project with your goals, questions, sources, ideas and constraints, using a prompt provided in the documentation.
5. Choose what to work on, or say `keep working`.

## PlasmaLean

<a href="https://github.com/siddhartha-gadgil/PlasmaLean" target="_blank">PlasmaLean</a> is a library of Lean and AI-assisted mathematics aimed at the design of a stellarator. It is the project from which the `LeanTheory` template was extracted, so it follows the model described above. Its <a href="https://siddhartha-gadgil.github.io/PlasmaLean/index.html" target="_blank">website</a> has background on stellarators, a handbook, progress slides and an exposition suite.

### Stellarators

Nuclear fusion requires heating hydrogen isotopes (deuterium and tritium) to over a hundred million degrees, where matter becomes a plasma of charged particles. To keep the plasma away from solid walls, it is confined by magnetic fields in a doughnut shaped (toroidal) "magnetic bottle".

A simple toroidal field does not work - charged particles drift, ions one way and electrons the other, and the plasma is pushed into the wall. The cure is for field lines to twist as they go around the torus, measured by the **rotational transform** $\iota$.

* A **tokamak** gets the twist from a large current (millions of amperes) driven through the plasma itself. This current brings instabilities and sudden disruptions.
* A **stellarator** gets the twist from shaped external coils, with little or no plasma current. Such a field cannot be symmetric under rotation about the axis of the torus, so stellarators are genuinely three-dimensional.

The price is that a generic three-dimensional field confines particles poorly, so stellarators must be carefully designed. The underlying mathematics is rich - invariant tori, KAM theory and Grad's conjecture on the existence of equilibria all appear - and hard.

### The Stellarator Contract

The goal is a single candidate design satisfying five clauses, with the same objects witnessing all of them:

* **C1, current-free twist:** rotational transform $\iota \ge \iota_{min} > 0$ provided by the external field, with zero (or very small) net plasma current. This rules out tokamaks.
* **C2, omnigeneity:** small transport of thermal ions and electrons out of the plasma.
* **C3, stability:** stability against the main magnetohydrodynamic instabilities at a positive plasma pressure.
* **C4, existence:** nested surfaces on which field lines lie (flux surfaces), with force balance.
* **C5, thermal performance:** the core stays above a burn temperature (e.g. 10 keV), from a balance of heating and losses.

Being non-symmetric is a consequence of these clauses, not a goal in itself. A non-symmetric result with no other content counts as mathematical infrastructure, not design progress.

### Kernel and Audits

The domain kernel has six modules, about 900 lines in all: force balance, vacuum fields, simplified one-dimensional plasma and heat laws, radial transport and fusion power balance. Each law is a hypothesis, never an axiom. On top of this sits a library of over 600,000 lines of Lean, using only Lean's standard axioms.

Audits of this kernel and the code built on it have caught real errors, which illustrate why proof challenges are needed:

* **Force balance:** the law $J \times B = g$ holds for every field $B$ and current $J$ if $g$ is unconstrained. So it means nothing until $g$ is proved to be the gradient of the pressure, and every claim using it must cite such a proof.
* **Current-free twist:** an early version of clause C1 measured the plasma current through a surface that could be chosen to be degenerate. With this surface the current was zero for every field, so any field passed. This was caught by an audit, recorded as a permanent regression check, and fixed by measuring the current by Ampère's law.
* **Plasma composition:** the law for a physical plasma allowed contradictory values for its impurity content and fuel fraction. This too now has regression checks.

### Results

As of early November 2026, the compiled results include:

* **Lead candidate:** an exact, purely rational vacuum field of a kind first found by Dommaschk, with two field periods. It was found by untrusted numerics on a workstation and then certified in Lean. A KAM theorem with explicit constants gives two nested invariant tori, with zero net current and $|\iota| \ge 0.2386$ on both (clause C1), and a certified small deviation from quasi-axisymmetry (a symmetry of particle motion that helps C2).
* **Confinement for all time:** an earlier exact stellarator vacuum field has a KAM-certified invariant torus, so every field line starting inside stays inside forever. Certain high-energy alpha particles produced by fusion are also confined for all time.
* **Coils:** a concrete set of closed polygonal coils produces a field whose lines near the axis are certified to stay confined for 52 circuits of the torus. A separate certificate bounds field errors caused by manufacturing tolerances, for a simple test coil pair.
* **Grad's conjecture:** an explicit non-symmetric plasma equilibrium of Landreman satisfies, in Lean, the hypotheses of a counterexample to Grad's conjecture.
* **Stability and burn, on test beds:** stability results for a band of one of Landreman's equilibria and for a tokamak equilibrium (Solov'ev), and a proof that the tokamak model keeps its core above 10 keV for every supplied solution of a transport model.

### Honest Status

No candidate yet satisfies all of C1-C5. The lead candidate has C1 and a certified near-symmetry, but only in vacuum. Transport of thermal particles (C2), stability of a current-free plasma at positive pressure (C3) and thermal performance of a stellarator (C5) remain open.

Assumptions are stated, not hidden. For example, the burn result assumes that a solution of the transport model exists, and standard reductions used in the stability results are listed as supplied. Graphics and sandbox outputs on the website that are not Lean certificates are labelled as illustrative.

### How it was Built

The library was built almost entirely by AI agents, using the workflow above: a research graph of goals, questions and notes, Lean as the validity gate, and strict audits. Heavy numerics run on a workstation as untrusted oracles, and their certificates are re-checked before they are merged. Large checks are written as explicit proof terms that Lean's kernel verifies.

Work produced in this way can be queried and understood, and ideas at various levels can be added to guide it. The exposition suite includes a "Rosetta stone" translating stellarator physics into geometry, a guide to auditing the kernel in ten minutes, and challenges inviting pure mathematicians to contribute.
