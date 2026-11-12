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

## PlasmaLean
