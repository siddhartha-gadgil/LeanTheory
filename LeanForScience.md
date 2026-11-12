# Lean Prover for AI for Science and Engineering

## Mathematics in Science

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

<a href="https://live.lean-lang.org/#codez=CYUwZgBAdgXhAUUIC4IDkCGAXAlCiA3gG76ZYQD0FEJgJkTQC%2BKAvBALbYDGAFtBAO4BLLNwBQECAB8IABgjMAfBEAX5DIA0EAEYBPCAHMAToKjBAl%2BTipfANQQAjPIUWJ3DERARugQIJ8iOFBwAdEQYADYQ9EjIrL7QgQAOBgD2cSAGWNpOKjEx%2FkGhgcEhGjr6RibmoqKgkLAA5AhQqGR4UQ1%2BBaGiQA" target="_blank">Infinitude of Primes</a>

## Trust and Verification for Lean

### Kernel

### Definitions and Statements

## Autonomous Verification of Models/Definitions

### Proof Challenges

### Small Kernels

### Swiss-Watch Verification

## Maths in the future; Example: Stellarator

## Building Theories: plug-and-play setup

## PlasmaLean
