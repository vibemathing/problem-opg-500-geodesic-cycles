# OPG-500 C05: strict branches and exact infeasibility certificates

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c05-branch-certificates
Target: obligation:opg500-finite-linear-characterization
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Base: d697830e1f72a9743960a7c6db120ed1fff7e878
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Frozen local question

Fix a finite simple undirected G with m>=1 edges and a specified finite
family N of cycles that must NOT be geodesic. The root's fixed-G property
uses N equal to ALL nonperipheral cycles, where peripheral means induced
and deletion of its vertices leaves a connected or empty graph.
Using only a selected subset of those cycles gives a weaker condition.

Candidate dependencies at this base:
- C01: finite simple-path and strict common-witness characterization.
- C02: external C-path reduction and endpoint-localized strict witnesses.
- C04: strict normalization and bounded integer representatives.
They are located in research/artifacts/candidates/ under the same
opg500-a01-c01, c02 and c04 names. None is admitted mathematical evidence.

This candidate supplies a verifier interface and a completeness argument
for branch certificates. It supplies no infeasible graph and no actual
solver receipt. Source reuse is recorded at the end.

## C05.1: Boolean structure before linear algebra

For each C in N let S_C be C02's complete finite family of external
simple C-paths. For Q in S_C let u,v be its endpoints and A_CQ,B_CQ
its two u-v arcs on THAT cycle C. Then avoidance of every C in N is
  w_e>0 for all e
  AND AND_{C in N} OR_{Q in S_C}
      [L(A_CQ)-L(Q)>0 AND L(B_CQ)-L(Q)>0].               (F)

The two strict comparisons use the SAME chosen Q.
On expanding the finite Boolean formula, choose one path sigma(C)
from each S_C. For this branch form a matrix R_sigma containing:
- all m positive coordinate rows e_j;
- for each C the two rows chi_A_Csigma(C)-chi_sigma(C)
  and chi_B_Csigma(C)-chi_sigma(C).
The branch is exactly
  R_sigma w > 0.                                       (B)
All entries of R_sigma belong to {-1,0,1}.
The number of rows is m+2|N| before duplicate removal.

Finite positivity and homogeneity give
  EXISTS w, R_sigma w>0
  iff EXISTS w, R_sigma w>=1.
Scale by the minimum positive row value in the forward direction.
This is an existential feasibility equivalence. Do not replace a
particular unscaled witness by a unit-margin assertion.

If some S_C is empty, (F) has no branches and is false: that C cannot
be made non-geodesic, by C02. If N is empty, the product of choices has
one empty choice function, not zero; the single branch consists only
of positive coordinate rows and is feasible.

## C05.2: exact alternative for one frozen branch

For an r-by-m real matrix R, the following are mutually exclusive and
one holds:
  (P) EXISTS w in R^m, Rw>=1;
  (D) EXISTS lambda in R^r,
      lambda>=0, R^T lambda=0, sum_i lambda_i>0.

A certificate satisfying (D) rules out (P): multiplying and summing the
primal rows would give
  0 = lambda^T Rw >= sum_i lambda_i > 0.
This is exact arithmetic, not a residual-tolerance test.

Completeness follows from the finite theorem of alternatives applied
to -Rw<=-1. Its certificate y>=0, (-R)^T y=0, (-1)^T y<0 is precisely
(D). For this application no analytic separation axiom is needed:
Fourier-Motzkin eliminates one variable at a time by nonnegative
combinations of upper/lower bounds, retaining zero-coefficient rows.
The paired bounds characterize the projection because finitely many
compatible lower/upper bounds admit a value; one-sided bounds cause
no obstruction. If the original system is infeasible, after eliminating
all variables a false constant inequality remains. Tracking the
nonnegative combinations yields the stated y. With rational inputs,
these operations use rational coefficients.

The row direction and the nonzero condition both matter. The zero
vector lambda always lies in the nonnegative nullspace and proves
nothing. Negative multipliers are not allowed. A certificate for the
weak system Rw>=0 would not have this conclusion, since w=0 is feasible.

## C05.3: sparse bounded integer certificates

For our matrices R in {-1,0,1}^{r-by-m}, an infeasible branch has a
certificate mu satisfying
  mu in Z_{≥0}^r,  R^T mu=0,  sum_i mu_i>0,
with at most m+1 nonzero entries and every entry at most (m+1)!.

Proof. Normalize a certificate from (D) so that its coordinates sum to 1.
Choose such a normalized certificate with the least possible number s
of positive coordinates. This minimum exists among the finite possible
support sizes. Write J for its support.

The J-columns of the (m+1)-by-r matrix H=[R^T; 1^T] must be linearly
independent. Otherwise choose a nonzero vector h supported in J with
Hh=0. Its coordinates sum to zero, so h has a positive coordinate.
For tau=min_{h_i>0} lambda_i/h_i, the vector lambda-tau*h is nonnegative,
has the same H-image (0,...,0,1), and has smaller support. This contradicts
the choice of lambda. Therefore s<=m+1.

Select s rows giving an invertible s-by-s submatrix M of H_J.
The selected right side b has entries 0 or 1. The support vector is
the unique solution M lambda_J=b. Cramer's identity and the determinant
expansion bound from C04 make D=det(M) a nonzero integer and give
mu_J=|D| lambda_J in positive integers with each entry at most s!.
Set the other coordinates to zero. It remains a nonnegative nonzero
null vector, and s!<=(m+1)! gives the claimed bound.
No sparsity or bit bound is asserted for the number of BOOLEAN branches.

## C05.4: certificate coverage is a separate obligation

An infeasibility certificate for one R_sigma eliminates only that
branch. To conclude that (F) is infeasible for a fixed G and N, either
every branch must have a checked certificate, or a separately checked
coverage argument must show that certified partial choices cover the
entire finite product of path choices.

A sparse certificate may depend on only a few cycles' selected paths.
Freeze those choices and their row provenance; any branch extending
them contains the same certified row subset and is also infeasible.
This gives a valid pruning rule. It does not justify skipping uncovered
choices. A partial-choice cover must be checked against the COMPLETE
path tables; hashes alone do not prove enumeration completeness.

Conversely one exact w and one valid shortcut for each C in N supply a
positive certificate for (F). C04 bounds the possible integer w by m!
if a real witness exists. The two certificate types cannot both be
valid for the same completely frozen branch.

## C05.5: hand-constructed replay fixtures

See research/artifacts/candidates/opg500-a01-c05-fixtures.json.
The file contains proposed inputs and predicted hand-calculated
outcomes only. It is not a record of execution.

D-test: for rows
  (1,0), (0,1), (1,-1), (-1,1),
the integer vector mu=(0,0,1,1) has nonnegative entries, positive sum
and zero weighted row sum. It certifies infeasibility of all four rows
being strictly positive. Replacing strict comparisons by weak ones
instead permits w=(1,1). This is an ABSTRACT MATRIX fixture, not a
claim that these rows arise from a graph counterexample.

P-test: use K4 with sorted edge table
  01,02,03,12,13,23
and w=(1,1,1,1,1,1).
Its three distinct unoriented four-cycles may be represented by
  (0,1,2,3), (0,1,3,2), (0,2,1,3).
Choose shortcuts 02, 03 and 01 respectively.
Each chosen path has length 1 and each corresponding arc length 2;
each gap row is therefore 1. The JSON explicitly lists all six gap
vectors and all coordinate rows.

In K4, triangles are induced and leave one vertex on deletion, while
every four-cycle is chorded. There are no longer simple cycles.
Thus this positive fixture covers all its nonperipheral cycles.
This is a finite hand construction for K4, not evidence for arbitrary G.

Coverage-test: a Boolean formula with one contradictory branch and
another feasible branch is feasible. For example, with w_1,w_2>0,
  [(w_1>w_2) AND (w_2>w_1)] OR [w_1>w_2]
has a certificate for its first branch but is satisfied by (2,1).
This explicit algebraic mutation excludes one-branch-to-whole-formula
infeasibility upgrades.

## Exact adapter contract and bounds

A frozen branch request must include the graph edge table, cycle family,
complete external-path choice tables or a checked enumeration reference,
the chosen path for each cycle, both corresponding arcs, matrix row
provenance, and all relevant digests. A claimed complete-graph result
must additionally include the nonperipheral-cycle completeness audit.

For a primal certificate use exact integer/rational w and check every
row. For a dual certificate use exact nonnegative integer mu, check
sum(mu)>0 and R^T mu=0 coordinate by coordinate. Rational numbers must
be parsed exactly, never via floating-point rounding.

Suggested first authorized replay: these two small fixtures, at most
10000 rows and 1000 explicitly listed branches, 60 seconds, one thread,
256 MiB and 1 MiB output. On exceeding a cap, stop the replay without
an infeasibility conclusion. No such replay was run here. No solver
version, runtime output, mathematical receipt or EvidenceLink is claimed.

## Source and reuse note

Primary reference: Michel X. Goemans, MIT 18.433, Linear Programming
and Polyhedral Combinatorics, 2013-02-28,
https://math.mit.edu/~goemans/18433S13/polyhedral.pdf .
Theorem 3.1 on printed page 2 (PDF index 1) was read and visually
inspected on 2026-09-06. It gives the finite theorem of alternatives.
C05 specializes its signs and normalization to our strict branch
matrices and separately derives sparse integer witnesses and Boolean
coverage requirements. The reference does not establish OPG-500.
Cramer's source and assumption comparison is in the C04 source note.

## Checkpoint

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
failed_mutations: zero or signed dual multipliers; weak/strict confusion;
one certified branch treated as complete Boolean coverage; incomplete
cycle/path tables treated as complete because a hash exists.
next_action: isolate the order-theoretic arc-choice and common-witness
lemmas in a small formal-language candidate; keep graph realization and
the root conclusion as separate unclosed obligations.
