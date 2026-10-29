# Worked Example for `LeanTheory`: Modeling the Solar System & Certifying a Rocket Trajectory to Mars (`MarsMissionLean`)

This document illustrates the **`LeanTheory` workflow** on a concrete physics and engineering problem: **modeling the Solar System ($N$-body gravitational mechanics + Tsiolkovsky variable-mass rocket dynamics) and specifying a route toward a machine-checked Earth-to-Mars transfer certificate**.

The example shows how a goal and its auxiliary questions become a dependency graph of research
notes, a **small domain kernel**, an **extensible suite of compiled sanity checks**, and an
**assumption ledger**. It is a design sketch: declarations shown below must still be placed in the
repository, compiled, and audited before they count as verified results.

---

## Part 1: Goal, Questions, and Repository Map

One possible initial graph is:

| ID | Item | Depends on / supports | Initial status |
| --- | --- | --- | --- |
| `G-MARS-1` | Certify a tolerance-aware Earth-to-Mars transfer | supported by all questions below | open |
| `Q-MARS-1` | Which dynamical model and validity envelope are adequate? | required by `G-MARS-1` | research |
| `Q-MARS-2` | Which defect bound controls every admissible perturbed trajectory? | requires the model contracts | research |
| `Q-MARS-3` | Which exact data establish capture and clearance margins? | requires a verified tube theorem | blocked |

This is only one project goal; the same repository could contain independent goals concerning
staging, ephemeris validation or transfer optimization. Each note below should include the
metadata from `notes/note-template.md`, including exact dependencies, difficulty, barriers and
Lean readiness.

The Mars trajectory goal initially decomposes into six notes:

```text
MarsMissionLean/
├── ASSUMPTION_LEDGER.md                       # Explicit physical idealizations & parameters
├── notes/
│   ├── implementation-plan.md                 # G/Q/N registries, dependencies and progress
│   ├── note-template.md                       # Shared research-note metadata
│   ├── N-01-model-contracts-and-kernel.md      # Model choice; research → Lean-ready
│   ├── N-02-solar-system-nbody-ephemeris.md    # Source/data assumptions and clearance
│   ├── N-03-kepler-conics-and-lambert.md       # Analytical theory and transfer approaches
│   ├── N-04-rocket-equation-and-staging.md     # Tsiolkovsky theory and engineering questions
│   ├── N-05-verified-ode-defect-bounds.md      # Research/proof of a posteriori enclosure
│   └── N-06-mars-capture-certificate.md        # Blocked until N-01, N-02 and N-05 verify inputs
└── MarsMissionLean/
    ├── Kernel/
    │   └── AstrodynamicsKernel.lean           # Small domain specification
    ├── Sanity/
    │   └── Astrodynamics.lean                 # Triad plus domain-specific stress tests
    ├── Theory/
    │   ├── KeplerConservation.lean            # Angular momentum and Laplace-Runge-Lenz proofs
    │   └── Tsiolkovsky.lean                   # Exact Δv integration
    ├── Bridge/
    │   └── TubeEnclosure.lean                 # Connects analytic bounds to the domain model
    └── Certificates/
        └── MarsTransfer.lean                  # Exact certificate data and checker
```

---

## Part 2: Sample Research and Formalization Note (`notes/N-01-model-contracts-and-kernel.md`)

The full note would begin with the standard metadata. For example:

| Field | Value |
| --- | --- |
| ID | `N-MARS-01` |
| Kind | model definition and formalization plan |
| Addresses | `G-MARS-1`, `Q-MARS-1` |
| Depends on | astrodynamics sources and ephemeris specifications; no theorem-note dependency yet |
| Produces | model contracts, kernel declarations, sanity obligations, new model-validity questions |
| Difficulty | hard: continuum dynamics, perturbations and source validity must be separated |
| Status | stated; not yet Lean-ready |
| Lean evidence | none—the code below is illustrative until compiled |

The remainder shows how equations, kernel contracts and sanity checks can be developed together.

### 1. Motivation & Verification Strategy
How do we formally verify in Lean 4 that a rocket launched from Earth orbit at $t = 0$ reaches the Mars capture sphere at $t = T_{\text{arr}}$ without colliding with any celestial body or running out of propellant, even under $\pm\varepsilon$ engine thrust and navigation uncertainties?

1. **Why We Do Not Formalize an RK45 Solver:** Formalizing floating-point Runge–Kutta integration directly does not bound global truncation error over a 250-day interplanetary transfer.
2. **The `LeanTheory` Oracle + Certificate Strategy:**
   * An external astrodynamics optimizer (e.g., NASA GMAT, JPL HORIZONS, or a Python Chebyshev collocation script) acts as an **untrusted oracle**, outputting a smooth polynomial trajectory $\bar{\mathbf{r}}(t) : [0, T] \to \mathbb{R}^3$ and mass profile $\bar{m}(t) : [0, T] \to \mathbb{R}$.
   * Inside Lean 4, our **Small Kernel** defines the exact continuum $N$-body + variable-mass rocket ODEs, the **Planetary Collision Avoidance Contract** ($\|\mathbf{r}(t) - \mathbf{R}_i(t)\| \ge R_{\text{safe}, i} > 0$), the **Propellant Margin Contract** ($m(t) \ge m_{\text{dry}} > 0$), and the **Differential Inequality / Grönwall Defect Tube** that certifies that *every* true physical trajectory starting within $\delta_0$ of $\bar{\mathbf{r}}(0)$ under thrust perturbation $\|\delta\mathbf{u}(t)\| \le \varepsilon$ remains inside a certified tube $\|\mathbf{r}(t) - \bar{\mathbf{r}}(t)\| \le \rho(t)$ all the way to the Mars Sphere of Influence (SOI).

---

### 2. Mathematical Formulation

#### 2.1 Solar System $N$-Body Gravitational Acceleration
In an inertial Solar System Barycentric (SSB) frame $\mathbb{R}^3$, let $N$ celestial bodies (Sun, Earth, Moon, Mars, Jupiter, ...) have gravitational parameters $\mu_i = G M_i > 0$, safe exclusion radii $R_{\text{safe}, i} > 0$, and smooth ephemeris trajectories $\mathbf{R}_i : [0, T] \to \mathbb{R}^3$.

At any spacecraft position $\mathbf{r} \in \mathbb{R}^3$ strictly outside the exclusion spheres ($\|\mathbf{r} - \mathbf{R}_i(t)\| \ge R_{\text{safe}, i} > 0$), the gravitational acceleration is:
$$\mathbf{g}_{\text{solar}}(\mathbf{r}, t) := -\sum_{i=1}^{N} \mu_i \frac{\mathbf{r} - \mathbf{R}_i(t)}{\|\mathbf{r} - \mathbf{R}_i(t)\|^3}.$$

#### 2.2 Variable-Mass Rocket Equation of Motion
Let the spacecraft have instantaneous mass $m(t) \in [m_{\text{dry}}, m_0]$, effective exhaust velocity $v_e = I_{\text{sp}} g_0 > 0$, and mass-flow burn rate $\dot{m}(t) \le 0$. Under thrust vector $\mathbf{F}_{\text{thrust}}(t) = -\dot{m}(t) v_e \hat{\mathbf{u}}(t)$ (with $\|\hat{\mathbf{u}}(t)\| \le 1$), the coupled equations of motion on $t \in [0, T]$ are:
$$\ddot{\mathbf{r}}(t) = \mathbf{g}_{\text{solar}}\big(\mathbf{r}(t), t\big) + \frac{\mathbf{F}_{\text{thrust}}(t)}{m(t)}, \qquad \dot{m}(t) = -\frac{\|\mathbf{F}_{\text{thrust}}(t)\|}{v_e}.$$

#### 2.3 A Posteriori Grönwall Tube Certificate Around an Oracle Trajectory
Given an oracle reference trajectory $\bar{\mathbf{r}}(t)$ with minimum planetary clearance $d_{i, \min} > \rho_{\max} + R_{\text{safe}, i}$, the gravitational Hessian $\|\nabla \mathbf{g}_{\text{solar}}(\mathbf{r}, t)\|$ on the tube $\|\mathbf{r} - \bar{\mathbf{r}}(t)\| \le \rho_{\max}$ is Lipschitz-bounded by:
$$L_{\text{grav}}(t) := \sum_{i=1}^{N} \frac{2 \mu_i}{\big(\|\bar{\mathbf{r}}(t) - \mathbf{R}_i(t)\| - \rho_{\max}\big)^3}.$$
If the oracle ODE residual defect $\|\ddot{\bar{\mathbf{r}}}(t) - \mathbf{g}_{\text{solar}}(\bar{\mathbf{r}}(t), t) - \bar{\mathbf{a}}_{\text{thrust}}(t)\| \le \eta_{\text{res}}$ and thrust uncertainty is bounded by $\varepsilon_{\text{acc}}$, then any true solution $(\mathbf{r}(t), \dot{\mathbf{r}}(t))$ with initial phase-space error $E(0) \le \delta_0$ satisfies the Grönwall phase-space enclosure:
$$\|\mathbf{r}(t) - \bar{\mathbf{r}}(t)\| + \tau_0 \|\dot{\mathbf{r}}(t) - \dot{\bar{\mathbf{r}}}(t)\| \le \left(\delta_0 + \frac{\eta_{\text{res}} + \varepsilon_{\text{acc}}}{L_{\max}}\right) e^{L_{\max} t} \le \rho_{\max} \qquad \forall t \in [0, T].$$

---

### 3. Small-Kernel Specifications in Lean 4 (`MarsMissionLean/Kernel/AstrodynamicsKernel.lean`)

```lean
/-
  MarsMissionLean/Kernel/AstrodynamicsKernel.lean
  Small domain specification for Solar System
  N-body mechanics and Earth-to-Mars trajectory verification.
-/
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2

open scoped RealInnerProductSpace

namespace MarsMissionLean.Kernel

abbrev ℝ³ := EuclideanSpace ℝ (Fin 3)

/-- A celestial body i with gravitational parameter μ = G*M > 0,
    safe collision-avoidance radius R_safe > 0, and ephemeris curve R(t). -/
structure CelestialBody where
  name   : String
  μ      : ℝ
  R_safe : ℝ
  pos    : ℝ → ℝ³
  hμ_pos : 0 < μ
  hR_pos : 0 < R_safe

/-- A Solar System ephemeris model consisting of N celestial bodies -/
structure SolarSystem (N : ℕ) where
  bodies : Fin N → CelestialBody

/-- Pairwise gravitational acceleration exerted by body B on position r at time t -/
noncomputable def bodyGravity (B : CelestialBody) (r : ℝ³) (t : ℝ) : ℝ³ :=
  - (B.μ / (‖r - B.pos t‖ ^ 3)) • (r - B.pos t)

/-- Total N-body gravitational acceleration at position r and time t -/
noncomputable def solarSystemGravity {N : ℕ} (sys : SolarSystem N) (r : ℝ³) (t : ℝ) : ℝ³ :=
  ∑ i : Fin N, bodyGravity (sys.bodies i) r t

/-- Strict Planetary Clearance Contract (guards against 1 / 0 = 0 in bodyGravity!):
    At every time t ∈ [0, T], spacecraft position r(t) stays at least R_safe
    away from every celestial body i. -/
def HasPlanetaryClearance {N : ℕ} (sys : SolarSystem N)
    (r : ℝ → ℝ³) (T : ℝ) : Prop :=
  0 < T ∧ ∀ t ∈ Set.Icc 0 T, ∀ i : Fin N,
    ‖r t - (sys.bodies i).pos t‖ ≥ (sys.bodies i).R_safe

/-- Variable-Mass Rocket State & Propellant Contract on [0, T] -/
structure ValidRocketTrajectory {N : ℕ} (sys : SolarSystem N) (T : ℝ) where
  r       : ℝ → ℝ³      -- Spacecraft position in SSB frame
  v       : ℝ → ℝ³      -- Spacecraft velocity
  a       : ℝ → ℝ³      -- Spacecraft acceleration
  m       : ℝ → ℝ       -- Instantaneous spacecraft mass
  F_thr   : ℝ → ℝ³      -- Applied engine thrust vector
  v_e     : ℝ           -- Effective exhaust velocity (I_sp * g_0)
  m_dry   : ℝ           -- Dry structural mass of spacecraft
  F_max   : ℝ           -- Maximum engine thrust magnitude
  hv_e    : 0 < v_e
  hm_dry  : 0 < m_dry
  hF_max  : 0 ≤ F_max
  clearance : HasPlanetaryClearance sys r T
  mass_ok   : ∀ t ∈ Set.Icc 0 T, m_dry ≤ m t
  thrust_ok : ∀ t ∈ Set.Icc 0 T, ‖F_thr t‖ ≤ F_max
  kinematic_r : ∀ t ∈ Set.Icc 0 T, HasDerivAt r (v t) t
  kinematic_v : ∀ t ∈ Set.Icc 0 T, HasDerivAt v (a t) t
  newton_second_law : ∀ t ∈ Set.Icc 0 T,
    a t = solarSystemGravity sys (r t) t + (1 / m t) • F_thr t
  mass_depletion_law : ∀ t ∈ Set.Icc 0 T,
    HasDerivAt m (- ‖F_thr t‖ / v_e) t

/-- Top-Level North Star Contract: Tolerance-Aware Earth-to-Mars Transfer Certificate -/
structure CertifiedMarsTransfer
    {N : ℕ} (sys : SolarSystem N) (mars_idx : Fin N)
    (r_dep v_dep : ℝ³) (T_flight R_capture v_rel_max δ_init ε_thrust : ℝ) : Prop where
  tolerances_pos : 0 < T_flight ∧ 0 < R_capture ∧ 0 < δ_init ∧ 0 ≤ ε_thrust
  guaranteed_capture :
    ∀ (traj : ValidRocketTrajectory sys T_flight),
      ‖traj.r 0 - r_dep‖ + ‖traj.v 0 - v_dep‖ ≤ δ_init →
      -- Every valid trajectory within initial/thrust tolerances arrives inside Mars SOI:
      ‖traj.r T_flight - (sys.bodies mars_idx).pos T_flight‖ ≤ R_capture ∧
      ‖traj.v T_flight - deriv (sys.bodies mars_idx).pos T_flight‖ ≤ v_rel_max

end MarsMissionLean.Kernel
```

This structure is a pedagogical starting point, not yet the promised tolerance-aware certificate.
In particular, `ε_thrust` is stored but not used by `guaranteed_capture`, and the connection from
oracle residual bounds to every admissible perturbed trajectory has not been encoded. A complete
version must represent those perturbations explicitly, prove the tube-enclosure bridge, and record
the ephemeris and physical constants with sources and validity envelopes.

---

### 4. Extensible Sanity Suite (`MarsMissionLean/Sanity/Astrodynamics.lean`)

Before writing complex trajectory proofs, compile a sanity suite for the astrodynamics kernel. The required baseline is the triad from `notes/domain-libraries.md`: a degenerate case, a concrete satisfying instance, and a counterexample. The singularity, symmetry, and monotonicity checks below are additional tests motivated by this model. Future audits should add further regression theorems rather than preserve an arbitrary fixed number of checks.

| Check category | Specification risk | Planned or compiled check |
| :--- | :--- | :--- |
| **Concrete instance** | `ValidRocketTrajectory` might be inconsistent because of contradictory sign conventions. | **`circular_kepler_orbit_witness`**: prove that a ballistic spacecraft ($F_{\text{thr}} = 0$, $m(t) = m_0$) in a circular orbit satisfies `ValidRocketTrajectory`. |
| **Degenerate case** | Zero flight time or zero mass could exploit a vacuous interval or Lean's totalized division. | **`reject_zero_flight_time`** and **`spacecraft_mass_ne_zero`**: reject `T = 0` and prove positive mass throughout the modeled interval. |
| **Counterexample** | The law could accidentally accept arbitrary curves. | Add an explicit discontinuous or non-Keplerian trajectory and prove that it does **not** satisfy `ValidRocketTrajectory`. This required triad member is still a target until a compiled declaration is supplied. |
| **Singularity guard** | At $\mathbf{r}(t) = \mathbf{R}_i(t)$, totalized division would make the gravitational expression misleading. | **`gravity_denominator_pos`**: planetary clearance makes every gravitational denominator strictly positive. |
| **Symmetry / equivariance** | A sign or index error could break translational or rotational behavior. | **`bodyGravity_translation_invariant`**, followed by a rotation-equivariance theorem where needed. |
| **Monotonicity and limiting behavior** | A wrong sign in `mass_depletion_law` could allow mass to increase while thrusting. | **`rocket_mass_deriv_nonpos`**; later add free-space and scaling limits used by the mission proof. |

```lean
/-
  MarsMissionLean/Sanity/Astrodynamics.lean
  Compiled sanity checks for the astrodynamics domain kernel
-/
import MarsMissionLean.Kernel.AstrodynamicsKernel

namespace MarsMissionLean.Kernel.SanityChecks

/-- TEST 2 (Degenerate Case Guard): Zero flight time T = 0 is strictly rejected -/
theorem reject_zero_flight_time {N : ℕ} (sys : SolarSystem N) :
    ¬ Nonempty (ValidRocketTrajectory sys 0) := by
  rintro ⟨traj⟩
  exact lt_irrefl 0 traj.clearance.1

/-- TEST 2B (Degenerate Mass Guard): Spacecraft mass can never vanish (blocks 1/0 = 0 in F/m) -/
theorem spacecraft_mass_ne_zero {N : ℕ} {sys : SolarSystem N} {T : ℝ}
    (traj : ValidRocketTrajectory sys T) {t : ℝ} (ht : t ∈ Set.Icc 0 T) :
    traj.m t ≠ 0 := by
  have h1 : 0 < traj.m_dry := traj.hm_dry
  have h2 : traj.m_dry ≤ traj.m t := traj.mass_ok t ht
  linarith

/-- TEST 3 (Singularity / Corner Guard): Spacecraft never coincides with a planet center,
    guaranteeing the denominator ‖r t - R_i t‖³ in bodyGravity is strictly positive! -/
theorem gravity_denominator_pos {N : ℕ} {sys : SolarSystem N} {T : ℝ}
    (traj : ValidRocketTrajectory sys T) {t : ℝ} (ht : t ∈ Set.Icc 0 T) (i : Fin N) :
    0 < ‖traj.r t - (sys.bodies i).pos t‖ ^ 3 := by
  have h_clear := traj.clearance.2 t ht i
  have h_rad   := (sys.bodies i).hR_pos
  have h_pos   : 0 < ‖traj.r t - (sys.bodies i).pos t‖ := lt_of_lt_of_le h_rad h_clear
  exact pow_pos h_pos 3

/-- TEST 4 (Symmetry / Equivariance): Shifting both spacecraft and planet positions by a
    displacement vector d ∈ ℝ³ leaves pairwise gravitational acceleration strictly invariant! -/
theorem bodyGravity_translation_invariant
    (B : CelestialBody) (r d : ℝ³) (t : ℝ) :
    let B_shifted : CelestialBody := { B with pos := fun s => B.pos s + d }
    bodyGravity B_shifted (r + d) t = bodyGravity B r t := by
  intro B_shifted
  simp only [bodyGravity, B_shifted, add_sub_add_right_eq_sub]

/-- Monotonicity check: the modeled rocket mass derivative is always nonpositive. -/
theorem rocket_mass_deriv_nonpos {N : ℕ} {sys : SolarSystem N} {T : ℝ}
    (traj : ValidRocketTrajectory sys T) {t : ℝ} (ht : t ∈ Set.Icc 0 T) :
    - ‖traj.F_thr t‖ / traj.v_e ≤ 0 := by
  have h_norm : 0 ≤ ‖traj.F_thr t‖ := norm_nonneg (traj.F_thr t)
  have h_ve   : 0 < traj.v_e := traj.hv_e
  exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr h_norm) (le_of_lt h_ve)

end MarsMissionLean.Kernel.SanityChecks
```

---

## Part 3: Sample `ASSUMPTION_LEDGER.md` for `MarsMissionLean`

Every `LeanTheory` project maintains an explicit `ASSUMPTION_LEDGER.md` so reviewers can immediately distinguish mathematical theorems from physical modeling approximations:

| Ledger ID | Physical Assumption / Idealization | Where Used in `notes/` & `Kernel/` | Epistemic Status | How to Relax in Future Workstreams |
| :--- | :--- | :--- | :--- | :--- |
| **`A-PHYS-01`** | **Point-Mass / Spherical Harmonics $J_0$ Gravity:** Celestial bodies act as point masses $\mu_i = G M_i$ outside their safe exclusion radius $R_{\text{safe}, i}$. | `bodyGravity` in `AstrodynamicsKernel.lean` | Explicit Model Contract | Add $J_2$ oblateness quadrupole term $\nabla \Phi_{J_2}$ to `bodyGravity` near Earth/Mars departure & arrival. |
| **`A-PHYS-02`** | **Prescribed Chebyshev Ephemeris $\mathbf{R}_i(t)$:** Planetary positions are given by certified JPL DE440 polynomial ephemeris curves with bounded residual $\varepsilon_{\text{ephem}}$. | `CelestialBody.pos` in `N-02-solar-system-nbody-ephemeris.md` | Explicit Hypothesis | Couple planetary mutual $N$-body ODEs into the joint state vector. |
| **`A-PHYS-03`** | **Unmodeled Non-Gravitational Perturbations (Solar Radiation Pressure & Atmospheric Drag):** Bounded as an $L^\infty$ acceleration perturbation $\|\mathbf{a}_{\text{SRP}}(t)\| \le \varepsilon_{\text{SRP}}$ outside planetary atmospheres ($R_{\text{safe}, i} = R_{\text{planet}, i} + h_{\text{atm}}$). | Absorbed into $\varepsilon_{\text{thrust}}$ in `N-05-verified-ode-defect-bounds.md` | Certified Margin Bound | Add explicit inverse-square solar photon pressure model $P_{\odot} A C_R / (m r^2)$. |
| **`A-MATH-01`** | **Zero Project-Specific Lean Axioms:** All proofs rest solely on Lean 4's foundational axioms (`propext`, `Classical.choice`, `Quot.sound`). | Verified globally via `#print axioms CertifiedMarsTransfer` | Machine-Checked | N/A (Permanent invariant). |
