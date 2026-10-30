# LeanTheory/

The Lean library is the checked layer of a broader theory-development workspace. Research may
begin in notes, but a result becomes an established prerequisite only when its Lean declaration
has compiled. Every module is imported by the root [`LeanTheory.lean`](../LeanTheory.lean) (the
default build) and audited by `scripts/check_axioms.lean`.

For a new domain, first create a fresh, topic-named GitHub repository using
[`siddhartha-gadgil/LeanTheory`](https://github.com/siddhartha-gadgil/LeanTheory) as a template;
then continue with the [getting-started workflow](../docs/GettingStarted.md) in that repository.
That workflow covers multiple goals and questions, research-note dependencies, interactive
commands such as `work status`, `summarise work` and `work on ...`, and the autonomous
`keep working` loop. After opening the repository, the canonical first command is **`start`**: it
strictly audits existing code—especially the complete domain kernel—before reporting status or
beginning new work.

| Folder | Content | Start with |
| --- | --- | --- |
| [`Kernel/`](Kernel/README.md) | Domain model: definitions and laws as typeclasses, no axioms | `Kernel/Example.lean` |
| [`Sanity/`](Sanity/README.md) | Degenerate cases, concrete instances, counterexamples | `Sanity/Example.lean` |
| [`Bridge/`](Bridge/README.md) | Composition theorems between laws, theory and certificates | `Bridge/Example.lean` |
| [`Theory/`](Theory/README.md) | General, domain-independent mathematics | `Theory/KAM/KamSequence.lean` |
| [`Certificates/`](Certificates/README.md) | Certificate formats, soundness theorems, proof-term builders | `Certificates/Example.lean` |
| [`Design/`](Design/README.md) | Concrete certified candidates (empty in the template) | — |
| [`SubsetSum.lean`](SubsetSum.lean) | Reference pattern for building large proofs as explicit proof terms | — |

Conventions: files start with `module`; the API is `public`/`@[expose]`; `meta` imports only for
proof builders; every module, definition and theorem has a docstring; no `decide` of any kind,
no `sorry`/`axiom`; zero warnings (100-character lines).
