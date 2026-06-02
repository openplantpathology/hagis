# Roadmap

## Goal

Bring the package into closer functional alignment with the original HaGiS spreadsheet described by Herrmann, Gisi, and Shaner (1999), focusing first on scientific correctness and then on core HaGiS-specific race-coding and comparison features.

## Priority roadmap

### 1. Fix the Pathogenicity Index implementation

**Why this matters**

The paper defines cultivar pathogenicity using the raw-score Pathogenicity Index:

\[
PI_\delta = \frac{\sum a_{\delta j}}{MAX \cdot N}
\]

The current package summarizes cultivars using thresholded binary counts instead, which is not equivalent.

**Tasks**

- Add a raw-scale pathogenicity summary function that calculates `PI` for each differential.
- Accept the scale maximum explicitly, e.g. `max_score`.
- Keep the existing binary-summary workflow, but distinguish it clearly from the paper-defined PI summary.
- Add tests using small hand-checked datasets.

**Deliverables**

- New function, e.g. `summarize_gene_pi()`
- Documentation explaining the distinction between binary summary and raw-score PI
- Unit tests with exact expected values

---

### 2. Fix the Simpson diversity formula

**Why this matters**

The paper defines Simpson diversity as:

\[
S = 1 - \frac{\sum (n_i^2 - n_i)}{N^2 - N}
\]

The package currently uses:

\[
1 - \sum p_i^2
\]

These are related but not identical for finite samples.

**Tasks**

- Update `calculate_diversities()` to use the paper’s finite-sample formula.
- Document the formula explicitly in the help file.
- Add regression tests against hand-calculated examples.

**Deliverables**

- Corrected Simpson calculation
- Updated Rd/docs/examples
- Unit tests verifying the exact paper formula

---

### 3. Add reverse binary/octal race naming

**Why this matters**

Reverse binary/octal naming is one of the defining features of HaGiS and a major advantage of the original spreadsheet.

**Tasks**

- Implement encoding of binary pathotype vectors into reverse octal race names.
- Group differentials into triplets in the correct left-to-right order.
- Handle differential sets whose size is not divisible by three.
- Document the reverse-octal conventions used.
- Add examples matching the paper’s triplet logic.

**Suggested functions**

- `encode_race_octal()`
- `decode_race_octal()`

**Deliverables**

- Octal encoder
- Octal decoder
- Tests for known triplet patterns and round-trip conversion

---

### 4. Add reverse binary/decanary race naming

**Why this matters**

The paper describes both reverse binary/octal and reverse binary/decanary naming, and the spreadsheet exposes both.

**Tasks**

- Implement encoding of binary pathotype vectors into reverse binary/decanary names.
- Preserve cultivar order exactly as defined in the input.
- Add decoding back to pathotype vectors.
- Add tests using hand-checked examples.

**Suggested functions**

- `encode_race_decanary()`
- `decode_race_decanary()`

**Deliverables**

- Decanary encoder
- Decanary decoder
- Round-trip tests and examples

---

### 5. Add race decoding and conversion utilities

**Why this matters**

The original HaGiS `conv` sheet allows users to move between race-name systems and recover pathotype vectors.

**Tasks**

- Convert reverse octal names to vectors.
- Convert reverse decanary names to vectors.
- Convert octal ↔ decanary.
- Provide a user-facing wrapper that identifies or accepts the naming system.
- Add round-trip and cross-system consistency tests.

**Suggested functions**

- `decode_race_name()`
- `convert_race_name()`

**Deliverables**

- Conversion API
- Clear documentation with worked examples
- Tests for vector → name → vector and octal ↔ decanary consistency

---

### 6. Add virulence difference from the dominant race (`virdif`)

**Why this matters**

The paper includes a `virdif` analysis that measures how far each race departs from the dominant race in the sample.

**Definition**

For race \(i\), relative to dominant race \(i_0\):

\[
V_i = \sum |p_\delta - q_\delta|
\]

**Tasks**

- Identify the dominant race from the observed sample.
- Compute virulence difference for each race.
- Return both a table and a plotting-ready object.
- Add unit tests using small binary toy datasets.

**Suggested function**

- `calculate_virdif()`

**Deliverables**

- `virdif` computation
- Print/summary method if appropriate
- Plot method or helper

---

### 7. Add pairwise proximity metrics

**Why this matters**

The paper’s `pairw` sheet provides one of the most useful comparison tools in HaGiS.

**Metrics to implement**

- Dice 1
- Dice 2
- Russell–Rao 1
- Russell–Rao 2
- Simple match
- Simple mismatch

**Tasks**

- Build contingency counts for all pathotype pairs:
  - `VV`
  - `AA`
  - `AV`
  - `VA`
- Implement each coefficient exactly as defined in the paper.
- Return both a matrix and long-form table.
- Add a frequency-weighted sample-average summary where appropriate.
- Add tests for each coefficient on small hand-checked examples.

**Suggested functions**

- `calculate_pairwise_proximity()`
- `pairwise_proximity_matrix()`

**Deliverables**

- Pairwise coefficient engine
- Matrix output
- Optional heatmap/autoplot support
- Tests for each coefficient

---

## Suggested delivery phases

### Phase 1 — scientific correctness
- Fix Pathogenicity Index
- Fix Simpson formula

### Phase 2 — core HaGiS naming
- Add reverse octal naming
- Add reverse decanary naming
- Add decoding/conversion utilities

### Phase 3 — comparative analysis
- Add `virdif`
- Add pairwise proximity metrics

---

## Validation strategy

For each feature:

- Create small toy datasets with manually verified expected outputs.
- Add round-trip tests where encoding/decoding is involved.
- Add one or more examples taken directly from the paper where possible.
- Ensure all formulas in documentation match implementation exactly.

---

## Success criteria

The roadmap is complete when the package can:

- calculate the paper-defined raw-score Pathogenicity Index,
- calculate Simpson diversity using the paper’s finite-sample formula,
- encode and decode reverse octal race names,
- encode and decode reverse decanary race names,
- convert between race-name systems and pathotype vectors,
- compute `virdif`,
- compute pairwise pathotype proximity matrices using the paper’s coefficients.
