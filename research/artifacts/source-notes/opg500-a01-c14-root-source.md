# C14: frozen root statement and primary-source comparison

Verdict: candidate_only. Read date: 2026-09-07.
Repository: vibemathing/problem-opg-500-geodesic-cycles.
Read revision: b57bdd07a0a53c97685190c2e713bb7fb75ada55.
ProblemContract SHA-256: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## Sources actually read

1. Canonical repository contract, problem-library/records/canonical-problems.jsonl.
It fixes finite simple graphs, positive real lengths, vertex-pair arc attainment,
and peripheral as induced plus connected-or-empty VERTEX deletion. This is the
statement audited, including the ambient original graph H for both conditions.

2. Open Problem Garden, Geodesic cycles and Tutte's Theorem, problem and definition
paragraphs: https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
The question asks for a positive assignment on each finite 3-connected graph.
Its geodesic definition excludes an x-y path strictly shorter than both cycle
arcs, for cycle VERTICES x,y. C13's attained simple-path minimum makes this the
same inclusive one-arc definition. Ties are allowed; neither shortest-path
uniqueness nor inducedness of a geodesic cycle is imposed by that definition.

3. The manuscript linked by that entry: Georgakopoulos and Spruessel,
Geodesic topological cycles in locally finite graphs,
https://www.math.uni-hamburg.de/home/georgakopoulos/geo.pdf
Section 3.1, printed page 4, Theorem 3.1, is explicitly a FINITE weighted graph
theorem: every cycle decomposes into geodesic cycles no longer than itself.
Its proof splits a shortest failing cycle by a strict external shortcut into
two strictly shorter cycles. C14 B3 supplies the omitted external-segment
argument and finite termination explicitly. Printed page 14, Problem 3,
repeats the root question and calls peripheral induced and non-separating.
The repository explicitly resolves non-separating as vertex deletion, not
edge deletion; no alternative meaning is silently substituted.

The PDF parsed text was available. Screenshot requests for pages 4 and 14
returned internal errors, so no visual examination of figures is asserted.
No figure or numerical table is needed for the quoted theorem comparison.
No full source text is retained. The mutable Hamburg file is not claimed to
be byte-identical to arXiv:0911.3999v1, and no PDF byte hash is invented.
The infinite topological-circle results are not imported into the finite proof.

## Relation and limit

No mismatch was found for the frozen finite vertex-geodesic target. The
universal counterexample conclusion is the candidate deduction in C14, not a
claim made by these sources. No novelty, priority, trusted semantic verdict,
formal replay or Result admission follows from this source comparison.
The real weighting is fixed BEFORE T and its paths are selected. The contract's
existential assignment is negated for one explicitly 3-connected finite H.
