# OPG-500 C04: bounded integer representatives of comparison cells

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c04-integer-cells
Target: obligation:opg500-finite-linear-characterization
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Base: c2c0d1bd84bf02dd569e2508a556c60f43ea40f6
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Frozen scope and novelty boundary

This is a further candidate audit of the finite linear encoding, not a
solution of the root existence question. Fix a finite simple undirected
graph G with m>=1 edges. All edge lengths are positive real numbers.
We use only finite linear algebra and ordered-field operations; no
continuity, compactness, genericity, rational-density or solver axiom is
needed. Cramer's identity follows from finite determinant algebra.

Candidate dependency: C01 at this base,
research/artifacts/candidates/opg500-a01-c01-linear.md,
SHA-256 e00b9f2518d3deb322ce00a5c1a9acd0dd1220f32d960a887a57a6abc60209d7.
The original definition audit remains in its source note.
C02/C03 are compatible refinements, not verification receipts.

The finite-dimensional matrix argument is standard in spirit. The
explicit comparison-cell statement and m! specialization are deductions
given in full here. The source note records basic-feasible-solution and
Cramer references without claiming those sources state OPG-500 results.

## C04.1: exact sign-cell lemma

Let F be ANY finite set of vectors in {-1,0,1}^m and let w in R^m
have all coordinates positive. Then there is an integer vector z with
  1 <= z_j <= m!  for every j,
such that
  sign(f dot z) = sign(f dot w)  for every f in F.

The zero sign is preserved exactly. We do not require z to be a scalar
multiple of w, and do not assert that distances, ratios or a chosen
normalization are preserved. The conclusion concerns comparisons only.

### Step 1: separate equality rows from strict rows

Put all f with f dot w=0 into a matrix B of equality rows.
For each remaining f put either f or -f into a matrix A so that the
selected row has positive scalar product with w.
Also put every coordinate row e_j into A.

Thus the original sign cell is
  A x > 0,  B x = 0.
All matrix entries remain in {-1,0,1}. A has at least m rows and its
coordinate rows explicitly enforce positivity.
The zero vector, if present in F, belongs only to B.

### Step 2: normalize only the strict rows

Since A has finitely many rows and every row has positive value at w,
  delta = min_i (A_i dot w)
exists and is positive. The scaled vector x=w/delta satisfies
  A x >= 1,  B x=0.                       (N)
Conversely every solution of (N) satisfies the original sign cell.

This is feasibility equivalence under rescaling, not equality of the
two feasible sets. In particular, equality rows must NOT be changed to
unit-slack rows. The coordinate rows imply x_j>=1.

### Step 3: reach a full-rank active set in at most m moves

Start at any solution x of (N). The active rows are all rows of B and
the rows A_i with A_i dot x=1. Let their row-span rank be r.

If r<m, finite linear algebra gives a nonzero vector h annihilated by
every active row. Choose its sign so that some h_j<0. Because row e_j
belongs to A, at least one row A_i has A_i dot h<0.

For each such decreasing row define
  tau_i = (A_i dot x - 1) / (-A_i dot h).
A decreasing row cannot be active, since h annihilates all active rows.
Its numerator and denominator are therefore positive.
Set tau to the minimum of this nonempty finite list, so tau>0.

Move to x'=x+tau*h. All B equalities and all previously active A rows
are preserved. Decreasing A rows remain >=1 by the definition of tau;
nondecreasing rows do not lose feasibility. At least one decreasing row
now attains equality. That new row is outside the old active row span:
its scalar product with h is negative while every old active row
annihilates h. Hence the active rank strictly increases.

After at most m-r such moves, select m linearly independent active rows.
They give a square invertible integer matrix M and a right side b whose
entries are 0 for B rows and 1 for active A rows:
  M x*=b.
The constructed x* still satisfies ALL rows of (N), not just M.

This argument supplies the needed basic feasible point explicitly.
It does not invoke minimization over a compact set or assume that an
arbitrary nonempty polyhedron has a vertex. Coordinate lower bounds
were used to guarantee a finite positive blocking step.

### Step 4: clear one determinant and bound the coordinates

Let D=det(M), a nonzero integer. Let D_j be the determinant obtained by
replacing column j of M by b. Cramer's identity gives x*_j=D_j/D.
Every entry of M and of each replaced-column matrix has absolute value
at most 1. The determinant expansion has m! signed products, each of
absolute value at most 1; hence |D|<=m! and |D_j|<=m!.

Set z=|D|*x*. Then
  z_j=sign(D)*D_j
is an integer, and x*_j>=1 gives z_j>=|D|>=1.
The determinant bound gives z_j<=m!.
Moreover
  A z >= |D| > 0,  B z=0.
Thus z has the prescribed complete sign pattern. This proves C04.1 as a
candidate derivation, including lower-dimensional cells with ties.

## C04.2: apply to all simple-path comparisons

For every pair of simple paths P,Q in G with the same distinct
endpoints, include chi_P-chi_Q in F. Every entry lies in {-1,0,1}
because each simple path uses an edge at most once. G has only finitely
many such paths, so F is finite. Disconnected endpoint pairs with no
path contribute nothing.

C04.1 preserves the sign of L(P)-L(Q) for all these comparisons.
Consequently, for each connected endpoint pair, the SET of minimizing
simple paths is identical for w and z, including every tie.
By C01's positive-length walk reduction this also preserves which
C-arcs are shortest in G. Therefore EVERY cycle has exactly the same
geodesic/non-geodesic status under w and z simultaneously.

One could instead use the smaller finite family consisting only of the
arc/path differences appearing in all C01 formulas; preserving those
signs is already sufficient for cycle-status preservation.

## C04.3: fixed-graph finite search corollary

For a fixed finite G with m>=1 edges and ANY specified subset T of its
cycles, the following existence statements are equivalent:
  (i) a positive real assignment has precisely T as its geodesic cycles;
  (ii) an assignment in {1,...,m!}^E has precisely T as its geodesic cycles.

The direction (ii)->(i) is immediate. For (i)->(ii), use C04.2.
Peripheral status depends on G and C, not on edge lengths.
In particular, the INNER existence question for this fixed G is
equivalent to testing the finite box {1,...,m!}^E for an assignment under
which no nonperipheral cycle is geodesic.

This does not bound the size of G, provide an efficient enumeration,
or decide the universal statement over ALL finite 3-connected graphs.
There are (m!)^m vectors before symmetry reductions. No such search was
performed. For a graph with no edges there are no cycles and the
empty assignment handles the case separately; graphs in the root domain
are not that degenerate case.

The corollary eliminates real-number representability as a separate
obstruction to the fixed-instance encoding. It does not remove the
Boolean branch or all-graphs obligations.

## C04.4: exact attacks on tempting shortcuts

These are hand-derived examples and proof audits, not executed tests.

R1. Rounding can change geodesicity even when all rounded weights stay
positive. On K4 with C=(0,1,2,3,0), give each cycle edge length 3/5 and
each diagonal length 6/5. The two diagonals tie their C-arcs, so C02
makes C geodesic. Rounding each edge to the nearest integer makes every
edge length 1. Either diagonal then has length 1 versus two C-arcs of
length 2, so C is no longer geodesic. Exact sign-cell preservation is
not coordinatewise rounding.

R2. Arbitrary tie-breaking can lose a prescribed geodesic cycle:
on the unit-edge K4 square with both diagonals 2, reducing only w_02
to 2-epsilon, for 0<epsilon<1, creates a strict shortcut.
The full-status preservation theorem must keep equalities, rather
than assuming that all valid assignments can be replaced by generic
ones with the same set of geodesic cycles.

R3. Normalizing weak constraints as strict constraints can make a valid
cell empty. The equality x_1=x_2 can be written as two weak inequalities.
Replacing both by unit-positive inequalities would demand simultaneously
x_1-x_2>=1 and x_2-x_1>=1. Their sum is impossible. In C04.1 equality
rows remain zero; only already strict rows receive unit margins.

R4. Clearing denominators alone proves no uniform bound. The m! bound
uses a full-rank active subsystem whose coefficients and right side
are bounded. The positivity rows are necessary in the rank-growth proof;
without them its guaranteed blocking direction has not been justified.

R5. Arbitrary walks would have incidence multiplicities beyond {0,1}.
The coefficient bound used here is for SIMPLE paths. C01 must first
justify reduction to simple paths; otherwise the stated determinant
bound does not follow from this argument.

## ToolPlan and replay inputs

The sign-cell theorem is generic in m and F. A consumer can check a
frozen candidate z simply by exact dot products against a frozen sign
table, but it must separately validate completeness of the path/arc
table when using it for G.

For rational test inputs, a proposed implementation may follow Steps
1--4 using rational row reduction. Suggested tests:
- F empty, m>=1: positivity-only case;
- F containing zero and equality rows: ties retained;
- the rational K4 inputs in R1 and R2;
- degenerate active sets: each step must increase rank;
- infeasible prescribed sign patterns: no witness may be reported.

No implementation or solver was executed. Proposed first replay cap:
m<=6, at most 10000 rows, 60 seconds, one thread, 256 MiB, 1 MiB output.
Abort on cap excess without a mathematical verdict. Freeze the actual
implementation, graph/path table, candidate and output digests and exact
tool versions before any verification request is admitted.

## Checkpoint

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
failed_mutations: nearest-integer rounding; arbitrary tie-breaking for
exact cycle-status preservation; converting equality/weak rows to
unit-strict rows; deriving a uniform bound merely by clearing denominators.
next_action: derive a finite strict-witness branch system for eliminating
a specified finite family of cycles and specify exact infeasibility
certificates without confusing one branch with the entire Boolean formula.
