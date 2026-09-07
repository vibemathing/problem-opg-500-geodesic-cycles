# C17 statement and exact-version map

Verdict: candidate_only. Retrieved 2026-09-07 (UTC).
Repository: vibemathing/problem-opg-500-geodesic-cycles.
Read base: ac7b5331210322e82568d5a6fa5893aec90b47ae.

Canonical statement: problem-library/records/canonical-problems.jsonl.
Canonical digest: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.
Original OPG source, definition paragraph:
https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
It tests pairs of cycle vertices and excludes a path strictly shorter than
both cycle arcs. The inclusive shortest-arc reading is preserved. The page
links peripheral rather than defining it inline; the repository fixes induced
AND connected-or-empty deletion of cycle VERTICES. No claim of two identical
inline definitions is made. Chorded simple cycles remain in the domain.

C17's first theorem is a general walk bridge, NOT a new root verdict. It uses
exactly C16's endpoint-indexed Walk, cost and DistanceValue. Reachability is a
necessary premise for an attained finite real distance. Two isolated vertices
falsify the unqualified all-pairs nonempty-path wording, not the connected H
counterexample. The nil walk handles the diagonal. Positive weights force
strict closed-loop cost descent; a zero loop is an exact boundary falsifier.

Actual repository locks, read by connector and reconstructed byte-for-byte:
fixtures/lean-proof/lean-toolchain: leanprover/lean4:v4.33.0.
fixtures/lean-proof/lakefile.toml and lake-manifest.json:
mathlib rev db584cd6d46c92f209a44c0f1c829460d327499d.
The locked manifest's fixedToolchain=false is NOT treated as an admission.
The registered local source remains quarantined; no applicable toolchain
allowlist or root attestation is inferred from these files.

API discovery only (moving primary documentation, not a pinned-source replay):
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Fintype/List.html
  fintypeNodupList gives a finite type of duplicate-free vertex words.
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Finset/Max.html
  Finset.exists_min_image supplies a minimizer on a nonempty finite set.
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/List/Nodup.html
  List.nodup_cons and duplicate-free list rules.
No full external source is stored. None of the above resolves whether the new
Lean text elaborates at the locked commit; that is explicitly unobserved.

No new admission_request and no invocation of the unrelated scalar SMT fixture.
Source bodies, static escape scan, exact rational tests and PR checks remain
separate from actual Lean parsing, imported axiom closure and trusted gates.
