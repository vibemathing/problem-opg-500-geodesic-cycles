# C09: universal eight-vertex obstruction candidate

Verdict: candidate_only. Target: obligation:opg500-root.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1.
Base: 76c8b56770a0894211bccd215cf23ec60021b871.
ProblemContract SHA-256: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## Frozen claim and status

The graph H below is finite, simple and 3-connected. For EVERY positive
real edge-length assignment on H, some geodesic cycle is nonperipheral.
Geodesic uses pairs of VERTICES and an inclusive choice of shortest arc.
Peripheral means induced and connected-or-empty after VERTEX deletion.
This is a universal counterexample proof candidate, not a sampling claim.
The finite graph and Boolean checks were executed. The metric bridge
lemmas remain paper proofs without trusted kernel or admission replay.

## Graph, connectivity, and all peripheral cycles

Let B={0,1,2,3} induce K4. For each i in B add y_i=7-i adjacent to
exactly B minus {i}. White vertices are pairwise nonadjacent. Edge order:

    01 02 03 04 05 06 12 13 14 15 17 23 24 26 27 35 36 37.

Thus n=8, m=18. Deleting at most two vertices leaves at least two black
vertices forming a clique; every surviving white retains a black neighbor
because it originally had three. Hence H is 3-connected. Its binary
cycle-space dimension is m-n+1=11. For completeness, fundamental cycles
of a spanning tree form a basis: cancel each non-tree edge; the remainder
is an even subgraph of a tree and must be empty.

Every induced cycle is a triangle. In a longer cycle, three or more
black vertices give a clique chord. With exactly two black vertices,
independence of the whites forces an alternating four-cycle, whose black
edge is a chord. At most one black vertex cannot support a cycle.

There are four black triangles T_i=B minus {i}. Deleting T_i isolates
y_i; vertex i and the other three whites form another component, a star.
All four T_i are nonperipheral. The remaining twelve triangles are
F_{i;ab}={y_i,a,b}, where a,b are distinct elements of B minus {i}.
Deleting F leaves two adjacent black vertices, and each surviving white
attaches to at least one. Thus exactly these twelve are peripheral.
Every black edge belongs to two peripheral triangles; each peripheral
triangle contains exactly one black edge.

## M1: weighted geodesic cycles span

In any finite graph with positive lengths, a non-geodesic cycle C admits
a simple path P shorter than BOTH C-arcs between its endpoints. Shortest
paths exist: removing a nonempty repeated-vertex subwalk strictly shortens
a walk, and the family of simple paths for connected endpoints is finite
and nonempty.

Split P at consecutive visits to C. If every segment had length at least
the intrinsic C-distance of its endpoints, summation and the intrinsic
triangle inequality would contradict L(P)<d_C(x,y). Therefore some
segment Q, internally disjoint from C, is shorter than both corresponding
C-arcs A,B. It is not a C-edge. A union Q and B union Q are simple cycles,
both strictly shorter than C, and their binary sum is C. Induction in
the finite set of simple cycle lengths expresses every cycle as a sum
of geodesic cycles. Consequently H has at least eleven distinct geodesic
cycles under EVERY positive weighting.

The finite spanning statement also appears in Georgakopoulos--Spruessel,
Geodetic topological cycles in locally finite graphs, arXiv:0911.3999v1,
Theorem 3.1. This source is not claimed to contain the obstruction below.

## M2: perturbation makes shortest paths unique without creating bad cycles

For fixed positive w, collect all differences a=chi_P-chi_Q of distinct
simple paths with the same ordered endpoints. They form a finite set of
nonzero vectors in {-1,0,1}^m. Such paths cannot have identical edge sets:
a simple path's edge set and ordered endpoints fix its traversal.

Number edges e_0,...,e_(m-1), and put b_j=2^j. In a dot b the largest
nonzero position dominates all smaller positions, so a dot b is nonzero.
Choose epsilon>0 less than each |a dot w|/(2|a dot b|) with a dot w!=0;
if this finite list is empty choose any positive epsilon. Then
w'=w+epsilon*b is positive, every previously nonzero comparison keeps
its sign, and every former tie becomes unequal. Thus shortest paths are
unique. Every originally non-geodesic cycle retains its original strict
shortcut, so NO NEW geodesic cycle appears.

A root solution would therefore give one with unique shortest paths.
Some old geodesic cycles may disappear. Complete cycle-status preservation
is not asserted; this is compatible with C04's tie-breaking warnings.

## M3: a non-tight edge belongs to at most one geodesic cycle

Assume shortest paths are unique. Call e=uv tight when w_e=d_G(u,v).
Always w_e>=d_G(u,v). If e is not tight and occurs in a geodesic cycle,
the complementary u-v arc must be the unique shortest u-v path. It
fixes the entire cycle. Therefore a non-tight edge belongs to at most
one geodesic cycle; an edge in two distinct geodesic cycles is tight.

## M4: three tight triangle edges imply geodesicity

Each pair of triangle vertices is joined by its direct edge, a shortest
path. This is exactly the required shortest-arc condition. Hence a
non-geodesic triangle contains a non-tight edge. The converse is not used.

## Universal contradiction

Suppose H has a root solution. Apply M2. By M1 at least eleven cycles
are geodesic; the root assumption puts all of them among the twelve
peripheral triangles. At most one peripheral triangle is missing.

A black edge with both incident peripheral triangles geodesic is tight
by M3. Thus the sole possibly non-tight black edge is the black edge of
the missing triangle, if there is one. At most one black edge is non-tight.
But each of the four black triangles must be non-geodesic, and M4 requires
a non-tight edge in each. A single black edge belongs to only two of those
four triangles. Contradiction.

Explicit coverage: with no missing face every black edge is tight. If
the missing face contains black edge ab, choose T_a, which avoids ab.
Its three black edges are tight, so it is a nonperipheral geodesic cycle.
These are all thirteen possible missing-face patterns.

The premise excludes ALL nonperipheral cycles, including chorded cycles.
Excluding just the four black triangles is insufficient. Without the
full premise the obstruction need not be a black triangle.

## Exact finite necessary-condition UNSAT certificate

Variables g_1,...,g_12 describe peripheral triangles being geodesic;
t_1,...,t_6 describe black edges being tight. Necessary conditions are:

1. g_i OR g_j for each i<j (at most one missing face, by M1).
2. NOT g_f OR NOT g_h OR t_e for each black edge and its two faces (M3).
3. For each black triangle, the OR of NOT t_e over its three edges (M4).

The resulting CNF has eighteen variables and seventy-six clauses.
The frozen unsat-tree.json certificate has fifteen nodes, eighty-nine
unit implications, and eight conflict leaves. Its checker regenerates
clauses from the graph, validates each implication and conflict, and
replays BOTH branches at every decision. An additional exhaustive check
covers thirteen eligible face assignments and all sixty-four tight-edge
assignments: 832 cases, zero satisfying assignments.

The graph audit finds 239 simple cycles, exactly twelve peripheral and
227 nonperipheral. Visited-vertex DFS and exhaustive testing of all
262144 edge subsets yield identical cycle sets. All 37 vertex deletions
of size at most two are connected, and the binary cycle rank is eleven.

These checks certify a necessary Boolean abstraction. The paper bridges
M1--M4 are essential to its implication for all positive real lengths.
Earlier full LRA searches timed out; those observations are NOT UNSAT.
No float infeasibility result is used here.

## Adversarial mutation and correction log

Give black edges length 3 and white spokes length 1. All four black
triangles are non-geodesic, yet twelve peripheral triangles, six chorded
four-cycles and FOUR six-cycles are geodesic: 22 in total, ten bad.
The complete exact lists are generated in mutation.json. This guards
against excluding just four triangles in the rank argument. It also
shows why M3 needs uniqueness: non-tight black edges can lie in two
geodesic triangles when shortest paths tie.

An earlier draft incorrectly predicted 18 geodesic cycles and six bad
cycles; the full audit rejected that assertion. The missing four six-cycles
were then retained and the checker rerun. Earlier quoted DPLL counts
11/44/6 also do not describe this frozen certificate; the actual replay
reports 15/89/8. Neither erroneous count was a premise of M1--M4 or of
the universal contradiction. Only the corrected frozen outputs apply.

## Reproduction and remaining verification

Using Python 3.13.5 and the standard library, from this directory run:

    python check.py --verify --write-audit

Do not use -O: checks use assertions. The command reconstructs all graph
and mutation data and checks the existing frozen unsat-tree.json, without
regenerating that proof tree. It writes the complete 239-cycle table to
graph-audit.json and the mutation lists to mutation.json. Both generated
files are also supplied in the downloadable reproduction bundle.

The successful direct frozen replay and exact source/output digests are
recorded in execution.json. The finite run uses no network or solver.
Recommended replay bounds: one process, 20 seconds, 256 MiB memory and
1 MiB stdout. Tool timeouts from other invocations are not successful
receipts and must not replace the observed frozen replay.

Trusted review must separately validate M1's external segment argument,
M2's one-sided perturbation, M3's uniqueness use, peripheral classification,
and the graph-to-CNF implication. C06 remains a local, unreplayed Lean
slice; compiling it alone would not validate this root proof. No trusted
ledger, EvidenceLink or Result is written by this candidate change.

best_candidate: C09 universal obstruction for H.
best_verified_result: none.
best_verified_candidate: none.
open_obligations: obligation:opg500-finite-linear-characterization;
obligation:opg500-root.
next_action: trusted proof replay and statement-faithfulness audit of
M1--M4 and the universal obstruction; keep candidate_only meanwhile.
