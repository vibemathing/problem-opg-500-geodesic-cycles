# OPG-500 C08: simultaneous root compiler and executed exact cases

Verdict: candidate_only. Target: obligation:opg500-root.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1. Graph: graph:opg500-initial-v1.
Base: 05024fd4721b7f3e88dc575b92f5796b154e2b3c.
ProblemContract SHA-256: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## Frozen root interpretation

G is finite, simple, undirected and 3-connected. The variables w are ONE
positive real vector indexed by a fixed edge table. Enumerate every simple
cycle, including chorded cycles. A cycle is peripheral precisely when it
has no chord AND deletion of its vertices leaves at most one component.
This predicate depends only on G, not on the weights. Do not require the
converse that every peripheral cycle is geodesic.

Write A_Cuv,B_Cuv for the two arcs of C, and P_uv for ALL simple u-v paths.
With chi denoting edge incidence, the exact fixed-G root formula is

  R_G(w) = AND_e(w_e>0) AND
    AND_{C nonperipheral} OR_{unordered distinct u,v in C} OR_{P in P_uv}
       [ (chi_A_Cuv-chi_P).w>0 AND (chi_B_Cuv-chi_P).w>0 ].

The executable compiler uses the equivalent LT-zero sign convention.
Every atom indexes the same m variables. Nonperipheral includes both
chorded cycles and induced separating cycles. C01/C07 give each cycle's
semantics, so finite conjunction proves both root-formula directions.
Canonical minimum-start/orientation cycle enumeration changes multiplicity,
not the family. Its DFS retains every unused adjacent next vertex whose
label exceeds the start; it imposes no increasing order along the path.
The second ALGORITHM used for cross-checking (not a separate trust
domain) exhausts every nonempty edge subset and recognizes connected
2-regular subgraphs and connected two-endpoint paths.

## Geometry and integer witness bound

Choose one shortcut branch for every nonperipheral cycle. Each resulting
system is R_sigma w>0, including the m coordinate rows. Its entries are
in {-1,0,1}. R_G is a finite union of open rational homogeneous polyhedral
sets, stable under positive scaling; the origin is excluded. A conjunction
of cycle-wise unions is not a single convex program. Empty branches are
allowed. Signs on the finite arrangement of nonzero row hyperplanes
control truth; only realizable sign patterns are usable. An oriented
matroid description would encode this same realizability constraint,
not remove it. Since R_G is open, a solution can be perturbed off finitely
many comparison hyperplanes while retaining the root property. This
need not preserve which PERIPHERAL cycles are geodesic.

For completeness, fixed-G feasibility implies an integer witness
1<=z_e<=m!, strengthening rational existence. This is the C04 bound
specialized to strict root branches, with no numerical approximation:
scale a feasible branch point to R_sigma x>=1. Include x_e>=1. If active
rows have rank less than m, take a nonzero vector h annihilating them,
with a negative coordinate (replace h by -h if needed). Move a positive
amount along h until the first currently slack decreasing row becomes
tight. Such a row exists because of that coordinate's bound. The amount
is the minimum of finitely many positive blocking ratios. All previous
active rows stay tight, and the new row is outside their span because
it does not annihilate h. Repeat to rank m. The resulting point solves
Mx=1 for an invertible integer m-by-m matrix with entries in {-1,0,1}.
Let d=|det M|>=1. Cramer's rule makes z=dx integral and positive; each
coordinate is at most m! by the determinant permutation expansion.
R_sigma z>=d*1>0. Thus a witness needs O(m log m) bits per coordinate,
O(m^2 log m) in total. This bound does not assert that the region is
nonempty, or that exhaustive search is practical.

## Actual candidate computations

The current user explicitly requested actual exact searches. They ran in
the current local candidate-generation sandbox, not in the GitHub channel
runtime and not through a registered verifier. The profile's
command_execution=false was not changed. No verifier receipt, EvidenceLink
or Result was written. The executable code uses Python 3.13.5 standard
library integer arithmetic for all mathematical comparisons; elapsed-time
measurements do not participate in a mathematical predicate.

The root_search.py run used a 90-second internal budget and a 95-second
external timeout. exact_audit.py additionally imposed a 768 MiB address
space limit; thread-count environment limits were set to one. The final
exact audit completed successfully, exit status 0, in about 1.975 seconds.
It was rerun after adding explicit all-pair path-minimum checks.

| Graph | vertices | edges | all cycles | peripheral | geodesic at witness |
|---|---:|---:|---:|---:|---:|
| K4 | 4 | 6 | 7 | 4 | 4 |
| wheel, rim 4 | 5 | 8 | 13 | 5 | 5 |
| wheel, rim 5 | 6 | 10 | 21 | 6 | 6 |
| wheel, rim 6 | 7 | 12 | 31 | 7 | 6 |
| triangular prism | 6 | 9 | 14 | 5 | 5 |
| K3,3 | 6 | 9 | 15 | 9 | 9 |
| cube | 8 | 12 | 28 | 6 | 6 |
| Petersen | 10 | 15 | 57 | 22 | 12 |
| triangular bipyramid | 5 | 9 | 22 | 6 | 5 |

All except cube and triangular bipyramid use unit lengths. In sorted
edge order the cube witness is (1,1,1,1,1,1,1,1,1,2,2,1); only edges
46 and 57 have length 2. The bipyramid witness is
(2,2,1,2,3,3,1,3,1) in edge order 01,02,03,04,12,13,14,23,24.
The complete graph/length/cycle audits are in cases.json. Unit cube has
four bad geodesic six-cycles. Unit bipyramid has one bad geodesic triangle.
Exhaustion of all 2^9 bipyramid vectors in {1,2}^9 found none satisfying
the root; a vector in {1,2,3}^9 succeeds. This bounded exclusion is NOT
an UNSAT result over positive reals.

For every graph the actual audit checked all deletion sets of size 0,1,2;
compared all DFS simple cycles and simple paths against full edge-subset
exhaustion; compared all path minima with Floyd-Warshall distances for
every vertex pair on three exact integer probes; evaluated the complete
root AST on those probes; and supplied a strict external-path witness
for EVERY nonperipheral cycle at the successful assignment. Full root
ASTs are regenerated and hashed without truncation, not silently replaced
by a table prefix. cases.json has every cycle's inducedness, deletion
components, geodesicity and a strict shortcut when one exists, plus the
shared exact distance matrix and the complete-table hashes.

## Reproduction and limitations

From repository root, in an explicitly authorized candidate sandbox:

  python research/artifacts/candidates/opg500-a01-c08/root_search.py --out research/artifacts/candidates/opg500-c08-replay --seconds 90 --tries 4000
  python research/artifacts/candidates/opg500-a01-c08/exact_audit.py research/artifacts/candidates/opg500-c08-replay

Keep generated outputs out of unrelated paths; do not stage them blindly.
The code returns incomplete on caps, never mathematical UNSAT. Finite
cross-checks are not a general compiler proof or a replay of C06. Lean,
Elan and Lake were absent in the actual preflight; C06 remains uncompiled,
and its quarantined toolchain was not changed. The existing repository
SMT module is a different fixed fixture, not a root-formula consumer.

## Checkpoint

best_verified_result: none. best_verified_candidate: none.
Both existing obligations remain open. The nine witnesses are reproducible
candidate computations, not universal positive evidence. Next task is
C09: audit the eight-vertex clique-with-four-triple-neighbours obstruction,
using peripheral-cycle count, cycle-space dimension, loose core edges,
and an explicit tie-removal argument. No random-search failure is used
as a universal certificate.
