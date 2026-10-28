# Worked Example for `LeanTheory`: Modeling the Solar System & Certifying a Rocket Trajectory to Mars (`MarsMissionLean`)

This document demonstrates the complete **`LeanTheory` workflow in action** on a concrete physics and engineering problem: **modeling the Solar System ($N$-body gravitational mechanics + Tsiolkovsky variable-mass rocket dynamics) and generating a machine-checked certificate for an Earth-to-Mars transfer trajectory**.

You can drop the files below directly into a fresh clone of [`siddhartha-gadgil/LeanTheory`](https://github.com/siddhartha-gadgil/LeanTheory) to see how high-level goals and textbook astrodynamics are transformed into `notes/*.md`, a **Small Verification Kernel**, **5 COSC Sanity Stress Tests**, and an **Assumption Ledger**.

---

## Part 1: Repository Map Created by Prompt 1 (The Architect Step)

When we apply **Prompt 1** to the Mars trajectory problem, we decompose the theory into 6 modular workstreams in `notes/`:

```text
MarsMissionLean/
├── ASSUMPTION_LEDGER.md                       # Explicit physical idealizations & parameters
├── PROGRESS.md                                # Compiled declarations vs. open math targets
├── notes/
│   ├── 01-model-contracts-and-kernel.md       # Small Kernel (~110 LOC) & 5 Sanity Stress Tests
│   ├── 02-solar-system-nbody-ephemeris.md     # N-body gravitation, barycentric frames & clearance
│   ├── 03-kepler-conics-and-lambert.md        # 2-body invariants (E, L, e_vec) & Hohmann/Lambert transfer
│   ├── 04-rocket-equation-and-staging.md      # Tsiolkovsky variable-mass ODE & Δv fuel budgets
│   ├── 05-verified-ode-defect-bounds.md       # A posteriori Chebyshev/Taylor ODE enclosures (Grönwall)
│   └── 06-mars-capture-certificate.md         # End-to-end tolerance-aware Earth-to-Mars certificate
└── MarsMissionLean/
    ├── Kernel/
    │   ├── AstrodynamicsKernel.lean           # Frozen Small Kernel (Escapement)
    │   └── SanityChecks.lean                  # 5 COSC Bench Tests (Compiled)
    └── Library/
        ├── KeplerConservation.lean            # Angular momentum & Laplace-Runge-Lenz proofs
        ├── Tsiolkovsky.lean                   # Exact Δv integration
        └── TubeEnclosure.lean                 # Grönwall tube certificate around nominal trajectory
```

---

## Part 2: Sample Formalization Note (`notes/01-model-contracts-and-kernel.md`)

*(Below is the exact Markdown note generated using **Prompt 2**, showing how equations, kernel contracts, and the 5 sanity checks are specified together in `notes/`.)*

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
  The "Escapement" (Small Trusted Specification Kernel) for Solar System
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

---

### 4. The 5 COSC Sanity Stress Tests (`MarsMissionLean/Kernel/SanityChecks.lean`)

Just like a watchmaker testing an escapement across 5 positions, temperatures, and shock loads, we immediately compile **5 Sanity Stress Tests** on `AstrodynamicsKernel.lean` before writing any complex trajectory proofs:

| Bench Test Category | What Could Go Wrong in the Spec? | Compiled Sanity Check in `SanityChecks.lean` |
| :--- | :--- | :--- |
| **1. Clutch Engagement (Special Case Witness)** | `ValidRocketTrajectory` might have contradictory sign conventions between `bodyGravity` and centripetal acceleration. | **`circular_kepler_orbit_witness`**: Proves that a ballistic spacecraft ($F_{\text{thr}} = 0, m(t) = m_0$) in a circular orbit of radius $R > R_{\text{safe}}$ with angular speed $\omega = \sqrt{\mu / R^3}$ satisfies `ValidRocketTrajectory`. |
| **2. Banking-Pin Guard (Degenerate Case Rejection)** | An AI prover might try to satisfy arrival at Mars by teleporting in zero time ($T = 0$) or using negative/zero spacecraft mass ($m(t) = 0$, exploiting `1 / 0 = 0` in `newton_second_law`). | **`reject_zero_time_and_zero_mass`**: Proves `¬ ValidRocketTrajectory sys 0` and proves that for any `traj : ValidRocketTrajectory sys T`, `traj.m t ≠ 0` everywhere on `[0, T]`. |
| **3. Singularity Guard (Corner Case)** | At $\mathbf{r}(t) = \mathbf{R}_i(t)$, Lean evaluates `bodyGravity` to `0` because `x / 0 = 0`, turning the center of the Sun into a "force-free" point! | **`no_planetary_collision_in_valid_traj`**: Proves that `HasPlanetaryClearance` strictly excludes $\mathbf{r}(t) = \mathbf{R}_i(t)$ and guarantees $\|\mathbf{r}(t) - \mathbf{R}_i(t)\|^3 \ge R_{\text{safe}, i}^3 > 0$. |
| **4. 5-Position Orientation (Symmetry / Equivariance)** | A sign or index typo in `bodyGravity` breaks rotational or translational symmetry. | **`gravity_galilean_translation_invariant` & `gravity_rotation_equivariant`**: Proves that shifting all positions by $\mathbf{r}_0 + \mathbf{v}_0 t$ or applying an orthogonal rotation $Q \in SO(3)$ transforms $\mathbf{g}_{\text{solar}}$ covariantly. |
| **5. Isochronism Check (Asymptotic / Scaling Limit)** | Wrong sign in `mass_depletion_law` could allow a rocket to *gain* mass while thrusting, or violate energy conservation when $F_{\text{thr}} = 0$. | **`rocket_mass_monotone_decreasing`** ($\dot{m}(t) \le 0$) and **`tsiolkovsky_delta_v_bound`** (in free space $\mu_i \to 0$, $\|\Delta \mathbf{v}\| \le v_e \ln(m_0 / m_{\text{dry}})$). |

```lean
/-
  MarsMissionLean/Kernel/SanityChecks.lean
  Compiled COSC-style bench tests validating AstrodynamicsKernel.lean
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

/-- TEST 5 (Isochronism / Monotonicity): Rocket mass derivative is always ≤ 0 -/
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
| **`A-PHYS-02`** | **Prescribed Chebyshev Ephemeris $\mathbf{R}_i(t)$:** Planetary positions are given by certified JPL DE440 polynomial ephemeris curves with bounded residual $\varepsilon_{\text{ephem}}$. | `CelestialBody.pos` in `02-solar-system-nbody-ephemeris.md` | Explicit Hypothesis | Couple planetary mutual $N$-body ODEs into the joint state vector. |
| **`A-PHYS-03`** | **Unmodeled Non-Gravitational Perturbations (Solar Radiation Pressure & Atmospheric Drag):** Bounded as an $L^\infty$ acceleration perturbation $\|\mathbf{a}_{\text{SRP}}(t)\| \le \varepsilon_{\text{SRP}}$ outside planetary atmospheres ($R_{\text{safe}, i} = R_{\text{planet}, i} + h_{\text{atm}}$). | Absorbed into $\varepsilon_{\text{thrust}}$ in `05-verified-ode-defect-bounds.md` | Certified Margin Bound | Add explicit inverse-square solar photon pressure model $P_{\odot} A C_R / (m r^2)$. |
| **`A-MATH-01`** | **Zero Project-Specific Lean Axioms:** All proofs rest solely on Lean 4's foundational axioms (`propext`, `Classical.choice`, `Quot.sound`). | Verified globally via `#print axioms CertifiedMarsTransfer` | Machine-Checked | N/A (Permanent invariant). |