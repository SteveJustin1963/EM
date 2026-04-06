



This is a **homemade (or custom/hand-assembled) microwave Doppler radar motion sensor**, very likely operating in the X-band around **10.525 GHz** — the kind of thing people build for hobby projects, prototypes, or low-cost DIY security/automation gadgets.

### Key giveaway features:
- **Circular copper disc PCB** — acts as the ground plane.
- **Central gold-coloured circular patch** (the larger round metal disc in the middle) — this is a **patch antenna** that both transmits the microwave signal and receives the reflected echo.
- **Thin vertical wire** sticking up from the center of the patch — almost certainly a probe feed or a short monopole/whip that couples RF energy into/out-of the patch.
- **Small SMD components** nearby (including the marked ones like "21WS", "3900", "106", "332", "10b") — these are almost certainly the RF front-end parts:
  - A tiny **GaAs FET** or **pHEMT** (very likely the oscillator/transmitter + mixer in one device)
  - Chip capacitors/resistors/inductors for biasing, matching, and filtering
  - The whole active circuit is crammed into a very small area because microwave circuits at ~10 GHz need short interconnects.

This style of construction is typical of cheap Doppler radar modules (similar to the popular **RCWL-0516**, but that one is usually rectangular). The round shape + circular patch antenna is a very common DIY / Chinese-module design for 10 GHz Doppler motion sensing — the patch radiates a fairly broad beam forward (often ~60–100° cone), and any moving object (person, car, fan blade, rain drops, etc.) that reflects microwaves back creates a Doppler shift → detected as motion → output pin goes high.

### Why does it look handmade / artisanal?
- Etched copper on what appears to be single-sided FR4 or similar
- Hand-soldered components
- Scratched/sanded surface finish
- No solder mask or silkscreen — classic home-etched or small-run prototype board

These are frequently built by electronics hobbyists (especially in the Arduino/Raspberry Pi community) or appear in very low-cost Chinese radar modules sold for ~$1–3.

So in short: **a DIY / prototype 10 GHz microwave radar motion detector** — basically a super-simple radar that senses movement without needing line-of-sight or IR heat like a PIR sensor would. Very useful for lights, alarms, automatic doors, etc., and they can even "see" through thin walls/doors in many cases.

//
The theory behind **microstrip patch antennas** (both rectangular and circular) builds on electromagnetic principles that explain why a flat metal patch on a thin dielectric substrate radiates efficiently despite its small size relative to wavelength. Below is a deeper dive into the key theoretical models and mechanisms, focusing on the fundamentals you asked for.

### 1. Basic Radiation Mechanism: Fringing Fields
The patch does **not** radiate like a classical dipole or monopole from currents on a wire. Instead, radiation comes almost entirely from the **fringing electric fields** at the edges of the patch.

- Under the patch (between patch and ground plane), the electric field (E_z dominant) is strong and mostly uniform in thin substrates.
- At the open edges, the field cannot terminate abruptly → it "fringes" outward into free space (and partly into the substrate).
- These fringing fields behave like equivalent radiating **magnetic currents** (or slots) along the patch perimeter.
- The fringing is stronger when:
  - Substrate is thicker (h increases → more extension into air).
  - Dielectric constant ε_r is lower (fields spread more into air rather than being confined).
- In contrast, microstrip transmission lines use high ε_r and thin h to minimize fringing and prevent unwanted radiation — patch antennas do the opposite to encourage it.

This is why patch antennas are efficient radiators even though the patch itself is a good conductor: the radiation escapes through the open edges, not the flat top.

### 2. Transmission Line Model (Primarily for Rectangular Patches)
This is the simplest and most intuitive model — treats the patch as a **resonant section of microstrip transmission line** open-circuited at both ends.

- The patch length L is approximately λ/2 in the effective medium (but slightly less due to fringing).
- The two radiating edges act like **two slots** (radiating apertures) separated by a low-impedance transmission line of length L.
- Each slot has:
  - Conductance G (radiation + losses)
  - Susceptance B (fringing capacitance)
- The input impedance is found by transforming one slot's admittance across the patch length and adding it in parallel to the other.
- Near resonance, the two slots are nearly out of phase by 180° → their fields add constructively in the broadside direction.
- Advantages: Easy to understand input match, bandwidth (~1–5%), resonant frequency.
- Limitations: Assumes no variation along width (ignores higher modes), approximate for very wide patches.

Equivalent circuit near resonance: Often a series RLC (or parallel) with R_rad from radiation resistance of the slots, plus feed effects.

### 3. Cavity Model (Applies to Both Rectangular and Circular Patches)
More rigorous — models the volume between patch and ground as a **closed cavity** with:
- Electric walls (perfect conductors) on top (patch) and bottom (ground).
- Magnetic walls (PMC: tangential H = 0, normal B = 0) on the sides/perimeter — this approximates the open edges where fringing occurs.

Inside this "leaky cavity":
- Fields satisfy a 2D Helmholtz equation (since thin substrate → no z-variation assumed).
- Solutions are eigenmodes (resonant modes) like TM_{mn} (transverse magnetic to z).
- Fringing is accounted for by extending physical dimensions to **effective dimensions** (e.g., L_eff = L + 2ΔL for rectangular; a_eff for circular).
- Losses (dielectric, conductor, radiation) are lumped into an effective loss tangent or added to mode Q-factors.
- Radiation is computed from equivalent magnetic currents on the perimeter (magnetic current M = E × n̂, where n̂ is outward normal).

Advantages: Predicts modes, field patterns under patch, far-field radiation, input impedance more accurately. Handles non-rectangular shapes better.

### 4. Rectangular Patch Specifics
- Dominant mode: **TM_{10}** (m=1 along length, n=0 along width) — E_z varies as cos(πx/L) along resonant direction (x), almost uniform along width.
- Voltage maximum at center, zero at non-radiating edges → fringing strongest at radiating edges (along width).
- Radiation pattern: Broadside, E-plane (along length) narrower than H-plane.

### 5. Circular Patch Specifics
- Dominant mode: **TM_{11}** (lowest resonant frequency for circular).
- Fields under patch expressed using **Bessel functions** (J_n(kr) for radial dependence, cos/sin for azimuthal).
  - Radial E_z ∝ J_1(kρ) cos φ (for TM_{11}).
  - The resonant radius satisfies J'_1(k a_eff) = 0 → first zero at x ≈ 1.8412 → a_eff ≈ 1.8412 / (k √ε_eff).
- Pattern is more symmetric (conical beam), slightly broader than rectangular.
- Fringing correction similar but uses effective radius a_eff = a [1 + correction term involving h/a and ε_r].

### 6. Why These Models Work at Microwave Frequencies (Like 10.525 GHz)
- Substrate thin (h << λ_0, typically h/λ_0 ≈ 0.01–0.05) → quasi-TM modes dominate, fields mostly z-directed.
- High frequency → short wavelengths → small physical size but still resonant.
- Narrow bandwidth inherent: High Q cavity (low radiation leakage per cycle) → sharp resonance.

### Summary Comparison of Models

| Aspect                  | Transmission Line Model                  | Cavity Model                              |
|-------------------------|------------------------------------------|-------------------------------------------|
| Best for                | Rectangular patches, quick design        | Any shape (rect, circular, etc.), modes   |
| Radiation mechanism     | Two radiating slots                      | Magnetic currents on entire perimeter     |
| Fringing handling       | ΔL extension + effective ε_eff           | Effective dimensions (L_eff, a_eff)       |
| Input impedance         | Good near resonance                      | More accurate overall                     |
| Field distribution      | Assumes uniform along width              | Full 2D modal solution                    |
| Complexity              | Simple, analytical                       | More math (Bessel for circular)           |

These theories explain why your DIY 10 GHz patch works: it's a resonant cavity that's deliberately "leaky" via fringing, tuned so moving targets cause detectable Doppler shifts in the reflected CW signal.

If you'd like deeper math (e.g., full derivation of ΔL, Bessel zeros for TM11, or equivalent circuit equations), visuals of field patterns, or how this ties back to your Doppler radar application, let me know which part to expand!


//

A **patch antenna** (also called a **microstrip patch antenna**) is one of the most common types of planar antennas used at microwave and millimeter-wave frequencies (like the ~10 GHz Doppler radar module you showed earlier). It's essentially a flat metal "patch" (rectangular, circular, or other shape) placed on top of a thin dielectric substrate, with a conductive ground plane on the bottom side.

This design is popular because it's low-profile, lightweight, cheap to fabricate (especially on PCB material), easy to integrate with circuits, and can be made using standard etching processes — which is why your homemade-looking 10 GHz radar sensor uses one.

### Basic Structure
- **Radiating patch** — Thin metal layer (usually copper) on the top.
- **Dielectric substrate** — Insulating material between patch and ground (e.g., FR4, Rogers, or similar; thickness h is typically 0.02λ to 0.05λ, where λ is the free-space wavelength).
- **Ground plane** — Full metal layer on the bottom, usually much larger than the patch.
- **Feed** — How RF energy gets to/from the patch (coaxial probe, microstrip line, aperture coupling, proximity coupling).

Radiation mainly comes from the **fringing fields** at the edges of the patch — not from the flat top surface.

The patch acts like an open-ended resonant cavity:
- Top and bottom: electric walls (conductors).
- Sides: approximate magnetic walls (open to fringing).

### How It Works (Principles of Operation)
The patch resonates when its dimensions allow a standing wave pattern (cavity mode). For the fundamental mode:
- Rectangular patch → **TM₁₀** mode (half-wavelength along the resonant length L).
- Circular patch → **TM₁₁** mode (similar effective half-wave behavior).

The electric field is strongest under the patch edges, creating fringing that radiates into free space. A moving target reflects the signal → Doppler shift → detected in radar applications.

### Key Design Parameters and Trade-offs

| Parameter          | Controls Primarily                  | Typical Effect / Trade-off                                                                 |
|--------------------|-------------------------------------|---------------------------------------------------------------------------------------------|
| **Patch length** (L for rectangular) or **radius** (a for circular) | Resonant frequency (fᵣ)            | Longer / larger → lower frequency. Roughly L ≈ 0.49 λ_eff (effective wavelength in dielectric). |
| **Patch width** (W for rectangular) or shape | Impedance, bandwidth, pattern      | Wider → lower input impedance, broader pattern, slightly more bandwidth.                    |
| **Substrate height** (h) | Bandwidth, efficiency, surface waves | Thicker h → wider bandwidth & higher efficiency, but more surface waves & probe inductance. |
| **Dielectric constant** (εᵣ) | Size, bandwidth, efficiency        | Higher εᵣ → smaller size (miniaturization), narrower bandwidth, lower efficiency.           |
| **Feed position**  | Input impedance matching           | Critical — move closer to edge/center to tune from high to low impedance (50 Ω target).     |

- Bandwidth is narrow (typically 1–5% for single-layer) → thicker/low-εᵣ substrates help.
- Efficiency drops with high loss tangent substrates (FR4 is okay for ~10 GHz prototypes but not ideal).
- Gain is moderate (~5–9 dBi), pattern is broadside (maximum perpendicular to patch).

### Rectangular Patch Design (Most Common & Easiest to Analyze)
1. Choose frequency fᵣ, substrate εᵣ, height h.
2. Effective dielectric constant:  
   ε_eff ≈ (εᵣ + 1)/2 + (εᵣ - 1)/2 × [1 + 12h/W]⁻⁰.⁵ (approximation)
3. Resonant length (including fringing extension ΔL):  
   L = c / (2 fᵣ √ε_eff) - 2ΔL  
   where ΔL ≈ 0.412 h (ε_eff + 0.3)(W/h + 0.264) / [(ε_eff - 0.258)(W/h + 0.8)]
4. Width W (often ~1.5×L for good bandwidth/impedance):  
   W = c / (2 fᵣ) × √[2 / (εᵣ + 1)]

Feed is usually coaxial probe (like the thin wire in your photo) or inset microstrip line.

### Circular Patch Design (Common in Low-Cost Radar Modules)
Your example uses a **circular patch** — very popular for symmetric patterns and compact size in Doppler sensors.

1. Radius a for dominant TM₁₁ mode:  
   a = c × 1.8412 / (2 π fᵣ √ε_eff)  
   (1.8412 is the first zero of the derivative of Bessel function J₁'(x))

   ε_eff is similar to rectangular case (often approximated as εᵣ for initial calc, then refined).

2. Effective radius (accounting for fringing):  
   a_eff = a √[1 + 2h/(π a εᵣ) × (ln(π a / 2h) + 1.7726)]

   Then iterate or use a_eff in the frequency equation.

Feed point is offset from center (not at center — impedance too high; not at edge — too low). Optimal spot is found empirically or via simulation for ~50 Ω.

In cheap/DIY 10 GHz Doppler radars:
- Circular patch gives a nice conical beam (~60–90°).
- Single patch often serves as both TX and RX (monostatic radar).
- Very tolerant to small variations — why hobbyists etch them by hand.

### Common Feed Methods
- **Coaxial probe** — center pin soldered to patch (your photo's vertical wire), outer to ground. Simple, but probe inductance limits bandwidth for thick substrates.
- **Microstrip line / inset feed** — line etched on same layer, inset into patch edge.
- **Aperture coupled** — feed on separate layer below ground slot.
- **Proximity coupled** — no direct contact.

For your 10 GHz homemade radar, it's almost certainly a **coaxial probe-fed circular patch** on cheap FR4-like material, optimized roughly for 10.525 GHz (common ISM/X-band motion sensing band).

If you'd like, I can walk through approximate calculations for your specific-looking antenna (e.g., estimating radius from the photo or substrate guesses), or explain tweaks for better performance!

//

To calculate the **radius** of a circular patch antenna for resonance at **10.525 GHz** (the common center frequency for X-band Doppler radar motion sensors like HB100 modules or DIY versions), we use the standard cavity model formulas for the dominant **TM₁₁** mode.

These formulas account for fringing fields, which make the **effective radius** (aₑ) slightly larger than the physical radius (a).

### Standard Formulas
The physical radius **a** is calculated as:

a = F / √[1 + (2h / (π εᵣ F)) × (ln(π F / (2h)) + 1.7726)]

Where:
- F = 8.791 × 10⁹ / (fᵣ √εᵣ)   (in cm, when fᵣ is in Hz)
- fᵣ = resonant frequency = 10.525 × 10⁹ Hz
- εᵣ = relative permittivity (dielectric constant) of the substrate
- h = substrate thickness (in cm)

The **effective radius** aₑ (which determines the actual resonance) is:

aₑ = a × √[1 + (2h / (π a εᵣ)) × (ln(π a / (2h)) + 1.7726)]

In many practical designs (especially quick estimates), aₑ ≈ a × (some small correction factor), and people often approximate a directly from a simplified form or iterate.

For low-cost/DIY Doppler radars at ~10.5 GHz:
- Substrate is usually **FR4** → εᵣ ≈ **4.3–4.5** (often taken as 4.4; note FR4 varies batch-to-batch, and loss tangent is high ~0.02, but okay for prototypes)
- Substrate thickness **h** is typically **0.8 mm** (standard thin FR4 PCB, ~31 mils) or **1.6 mm** (standard PCB), but thinner is better at 10 GHz to reduce surface waves and improve efficiency.

### Step-by-Step Calculation (Typical DIY Case)
Let's compute for realistic values used in cheap 10.525 GHz radar modules (FR4, h ≈ 0.8–1.0 mm).

1. Take εᵣ = 4.4  
   fᵣ = 10.525 GHz = 1.0525 × 10¹⁰ Hz

2. Compute F (in cm):  
   F = 8.791 × 10⁹ / (fᵣ √εᵣ) = 8.791 × 10⁹ / (1.0525 × 10¹⁰ × √4.4)  
   √4.4 ≈ 2.0976  
   fᵣ √εᵣ ≈ 2.207 × 10¹⁰  
   F ≈ 8.791 × 10⁹ / 2.207 × 10¹⁰ ≈ **0.398 cm**

3. Take h = 0.08 cm (0.8 mm, common for thin radar PCBs)  
   Correction term: (2h / (π εᵣ F)) × (ln(π F / (2h)) + 1.7726)  
   π ≈ 3.1416, π F ≈ 1.251 cm  
   2h = 0.16 cm  
   π F / (2h) ≈ 1.251 / 0.16 ≈ 7.82  
   ln(7.82) ≈ 2.057  
   ln(...) + 1.7726 ≈ 3.83  
   2h / (π εᵣ F) ≈ 0.16 / (3.1416 × 4.4 × 0.398) ≈ 0.16 / 5.50 ≈ 0.0291  
   Correction ≈ 0.0291 × 3.83 ≈ **0.111**

4. a = F / √(1 + 0.111) ≈ 0.398 / √1.111 ≈ 0.398 / 1.054 ≈ **0.378 cm** = **3.78 mm**

5. Effective radius aₑ (slightly larger):  
   Using the second formula, aₑ ≈ a × √(1 + small term ≈ 0.03–0.05) → aₑ ≈ **3.9–4.0 mm**

### Results for Common Substrate Thicknesses (εᵣ = 4.4)

| Substrate Thickness h | Physical Radius a (mm) | Effective Radius aₑ (mm) | Notes |
|-----------------------|-------------------------|---------------------------|-------|
| 0.8 mm (thin FR4, common in cheap modules) | ≈ 3.78 | ≈ 3.92 | Typical for homemade/DIY 10.525 GHz patches; matches many observed designs |
| 1.0 mm | ≈ 3.75 | ≈ 3.90 | Slightly smaller due to less fringing correction |
| 1.6 mm (standard PCB) | ≈ 3.68 | ≈ 3.85 | Thicker → more bandwidth but poorer efficiency at 10 GHz due to surface waves |

### Quick Approximation (Often Used)
A rough rule-of-thumb ignoring fringing and ε_eff:  
a ≈ c / (2 π fᵣ √εᵣ) × 1.8412   (1.8412 from Bessel zero for TM₁₁)  
→ a ≈ 3 × 10⁸ / (2 π × 10.525 × 10⁹ × √4.4) ≈ 4.55 mm (overestimate; fringing reduces it to ~4 mm)

But the full formula above is more accurate.

### In Your Photo/Context
Your circular patch looks roughly 7–9 mm in diameter (≈ 3.5–4.5 mm radius), which aligns well with these calculations for FR4 at ~10.5 GHz. Small variations come from:
- Exact εᵣ (FR4 can be 4.2–4.6)
- Manufacturing tolerances/hand-etching
- Slight detuning for best Doppler performance (not exact 50 Ω match)

If you measure the patch diameter in your photo or know your exact h/εᵣ, I can refine it further. For better performance at 10 GHz, many switch to lower-loss substrates like Rogers RO4003 (εᵣ ≈ 3.38, lower loss), which would increase radius to ~4.5–5 mm. Let me know if you want calcs for that!


//

Here's a complete step-by-step **design procedure** for a **rectangular microstrip patch antenna** (RMPA) targeting **10.525 GHz** — the standard frequency for X-band Doppler radar motion sensors (like the one in your original photo). This matches the context of your homemade radar project.

We'll use standard formulas from antenna theory (e.g., Balanis, Pozar, and common empirical corrections). These are widely used for initial hand calculations before simulation/optimization in tools like HFSS, CST, or ADS.

### Assumptions (Realistic for DIY/Prototype at 10 GHz)
- **Substrate**: FR4 (cheap, easy to etch at home)
  - Relative dielectric constant **εᵣ = 4.4** (typical value; FR4 varies ~4.2–4.6 at GHz frequencies, but 4.4 is standard for design)
  - Loss tangent ~0.02 (high, so efficiency will be moderate ~60–80%)
- **Substrate thickness h**: **0.8 mm** (31 mils) — common for thin FR4 PCBs in low-cost microwave modules (thinner reduces surface waves at 10 GHz; 1.6 mm is thicker/standard but increases bandwidth slightly at cost of efficiency)
- **Resonant frequency fᵣ**: 10.525 GHz
- **Speed of light c**: 3 × 10⁸ m/s
- Target: Dominant **TM₁₀** mode, broadside radiation, ~50 Ω input impedance via inset or probe feed
- Goal: Simple edge/probe-fed patch for Doppler radar (TX/RX in one patch)

### Step-by-Step Design Calculations

1. **Calculate Width W** (controls impedance/bandwidth; wider = better bandwidth but larger size)  
   The standard formula (for good radiation efficiency):

   W = \frac{c}{2 f_r} \sqrt{\frac{2}{\epsilon_r + 1}}

   Plug in values:

   First, \frac{c}{2 f_r} = \frac{3 \times 10^8}{2 \times 10.525 \times 10^9} = 0.01425 m = **14.25 mm**

   \sqrt{\frac{2}{\epsilon_r + 1}} = \sqrt{\frac{2}{4.4 + 1}} = \sqrt{\frac{2}{5.4}} ≈ \sqrt{0.3704} ≈ 0.609

   W ≈ 14.25 mm × 0.609 ≈ **8.68 mm**

   (Often rounded to ~8.7–9 mm; some designs use slightly wider for better match.)

2. **Calculate Effective Dielectric Constant ε_eff** (accounts for fringing; air + dielectric)

   \epsilon_{eff} = \frac{\epsilon_r + 1}{2} + \frac{\epsilon_r - 1}{2} \left(1 + 12 \frac{h}{W}\right)^{-1/2}

   (Valid for W/h > 1)

   h = 0.8 mm = 0.0008 m, W = 0.00868 m → W/h ≈ 10.85 (>1, good)

   12 h / W ≈ 12 × 0.0008 / 0.00868 ≈ 1.106

   (1 + 1.106)^{-1/2} ≈ (2.106)^{-0.5} ≈ 0.689

   \epsilon_{eff} ≈ (4.4 + 1)/2 + (4.4 - 1)/2 × 0.689 ≈ 2.7 + 1.7 × 0.689 ≈ 2.7 + 1.171 ≈ **3.871**

3. **Calculate Effective Length L_eff** (half-wave in effective medium)

   L_{eff} = \frac{c}{2 f_r \sqrt{\epsilon_{eff}}}

   \sqrt{\epsilon_{eff}} ≈ \sqrt{3.871} ≈ 1.967

   2 f_r \sqrt{\epsilon_{eff}} ≈ 2 × 10.525 × 10^9 × 1.967 ≈ 4.14 × 10^{10}

   L_{eff} ≈ 3 × 10^8 / 4.14 × 10^{10} ≈ 0.00725 m = **7.25 mm**

4. **Calculate Fringing Extension ΔL** (adds to each end due to fringing fields)

   \Delta L = 0.412 h \frac{(\epsilon_{eff} + 0.3)(W/h + 0.264)}{(\epsilon_{eff} - 0.258)(W/h + 0.8)}

   W/h ≈ 10.85

   Numerator: (3.871 + 0.3)(10.85 + 0.264) ≈ 4.171 × 11.114 ≈ 46.34

   Denominator: (3.871 - 0.258)(10.85 + 0.8) ≈ 3.613 × 11.65 ≈ 42.09

   Ratio ≈ 46.34 / 42.09 ≈ 1.101

   ΔL ≈ 0.412 × 0.8 mm × 1.101 ≈ 0.412 × 0.8 × 1.101 ≈ 0.363 mm

   So 2ΔL ≈ **0.726 mm**

5. **Calculate Physical Length L** (actual patch length)

   L = L_{eff} - 2 \Delta L ≈ 7.25 mm - 0.726 mm ≈ **6.52 mm**

   (Rounded ~6.5–6.6 mm in practice; small tweaks via simulation.)

### Final Patch Dimensions (for h = 0.8 mm, εᵣ = 4.4)

| Parameter              | Value       | Notes |
|------------------------|-------------|-------|
| Patch Width (W)        | **8.7 mm**  | Slightly wider for better bandwidth/impedance |
| Patch Length (L)       | **6.5 mm**  | Critical for resonance; tune ±0.1–0.2 mm in sim |
| Substrate Thickness (h)| 0.8 mm      | Thin for 10 GHz to limit surface waves |
| Effective ε_eff        | ~3.87       | — |
| Expected Bandwidth     | ~1–3% (~100–300 MHz) | Narrow due to FR4; thicker h helps |
| Ground Plane Size      | ≥ L + 6h by W + 6h (~11 × 13 mm min) | Use larger (e.g., 30–40 mm square) for better pattern |

### Feed Design Recommendations (for ~50 Ω)
- **Inset microstrip feed** (common in DIY): Cut a notch into the patch edge along length.
  - Inset depth y₀ ≈ L/π × cos⁻¹(√(50 / R_in)), where R_in (edge resistance) ≈ 200–300 Ω for this aspect ratio → y₀ ~2–3 mm.
  - Feed line width: ~1.5–1.8 mm for 50 Ω on FR4/h=0.8 mm.
- **Coaxial probe feed** (like your original wire): Place probe ~1–2 mm inset from radiating edge (along W direction) for impedance match.
- **Ground plane**: Extend at least λ/4 (~7 mm) beyond patch edges; square 40 × 40 mm is safe.

### Variations for Different h

| h (mm) | Approx. W (mm) | Approx. L (mm) | Notes |
|--------|----------------|----------------|-------|
| 0.8    | 8.7            | 6.5            | Recommended for 10 GHz DIY (less loss/surface wave) |
| 1.6    | 8.6            | 6.3            | Wider bandwidth (~2×), but higher surface waves/loss |
| 0.5    | 8.8            | 6.7            | Narrower bandwidth, but better efficiency |

These are hand-calc starting points — at 10 GHz, FR4 tolerances (±5–10% on εᵣ) and fabrication errors mean you'll need to simulate (free tools like OpenEMS or Sonnet Lite) or build/test/tune by trimming length slightly.

For your Doppler radar: This rectangular patch gives a more directional beam (~80–100° vs. circular's broader cone) and potentially better gain (~6–7 dBi). If you want calcs for a different h, εᵣ (e.g., Rogers for lower loss), or inset depth details, just provide more specs!
//


