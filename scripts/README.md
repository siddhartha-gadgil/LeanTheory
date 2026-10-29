# scripts/

| Script | Purpose |
| --- | --- |
| [`setup.sh`](setup.sh) | Idempotent setup (Linux/macOS): installs elan if missing, `lake exe cache get`, `lake build`; `--check-axioms` runs the axiom audit, `--python` creates the venv `.venv-ws` from `requirements.txt`, `--no-build`, `--help` |
| [`check_axioms.lean`](check_axioms.lean) | Axiom audit: `lake env lean scripts/check_axioms.lean` checks every declaration of the library (only `propext`, `Classical.choice`, `Quot.sound`) and prints the axioms of the main entry points; add new entry points here |
| [`audit_kernel_fact.py`](audit_kernel_fact.py) | Classifies the kernel-fact leaves of `kernel_fact` proofs (closed literal facts vs. opaque recursive evaluations), to find leaves that should become explicit certificates |
| [`requirements.txt`](requirements.txt) | Python packages for untrusted oracle scripts and the workstation pipeline |
| [`workstation/`](workstation/README.md) | Workstation pipeline: heavy numerics and builds on a big machine, re-checked on the laptop |

At the first Lean use, run `scripts/setup.sh --check-axioms`; it installs `elan` when Lean is not
available and selects the repository's pinned toolchain. Do not substitute an unrelated system
Lean version.

Create the Python environment only when a project script needs it, then activate the environment
in each shell:

```bash
scripts/setup.sh --python --no-build
source .venv-ws/bin/activate
python --version
```

Use the activated environment's `python` and `pip`; do not install project dependencies globally.
Run `deactivate` when finished.

Oracle scripts (untrusted numerics that propose certificate data and emit Lean) go in their own
subfolder per family. They must validate every emitted bound in exact arithmetic before writing
Lean, and be run with `python3 -I` on any downloaded data.
