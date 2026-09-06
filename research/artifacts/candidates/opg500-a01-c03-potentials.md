# OPG-500 C03: compact potential encoding

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c03-potentials
Target: obligation:opg500-finite-linear-characterization
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Base: 48ca93f17da6cf4635b45f0758cb229f8819fecc
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Frozen scope and dependencies

Fix a finite simple undirected graph G=(V,E), a simple cycle C, and
positive real edge lengths w. Put n=|V|, m=|E|, k=|V(C)|.
Use the vertex-based, inclusive shortest-arc definition of C01.
The graph need not be connected away from the component containing C.
No existence assertion for all 3-connected graphs is made.

Candidate dependencies at this base:
- research/artifacts/candidates/opg500-a01-c01-linear.md
  SHA-256 e00b9f2518d3deb322ce00a5c1a9acd0dd1220f32d960a887a57a6abc60209d7
- research/artifacts/candidates/opg500-a01-c02-excursions.md
  SHA-256 c8bbc93b544180aae7b01939e5ab33f5f090e19dd9e8c15503c752ef684283d0

These are candidate deductions, not admitted proof dependencies.
The source comparison remains in the C01 source note. Only finite graph
arguments and ordered-field operations are used here.

## C03.1: the formula

For EACH source x in V(C), introduce a SEPARATE vector of real variables
t^x_v indexed by v in V. Define F_C(w,t) by the conjunction of:

(P) w_e>0 for all e in E.
(A) t^x_x=0 for every x in V(C).
(E) For each x in V(C) and every undirected edge e={u,v}, BOTH
      t^x_v-t^x_u <= w_e,
      t^x_u-t^x_v <= w_e.
(T) For each x,y in V(C), x!=y, the inclusive disjunction
      t^x_y=L(A_xy) OR t^x_y=L(B_xy).

Claim:
  w is positive and C is w-geodesic
  iff EXISTS t in R^(k*n), F_C(w,t).

No nonnegativity constraint on t is needed. It would be redundant for
the distance-based completeness construction, but soundness does not
assume it. The diagonal is represented by (A), not by two x-x arcs.

## C03.2: soundness by telescoping

Suppose F_C holds. Fix x,y in C and a finite graph walk
x=v_0,v_1,...,v_r=y. For each traversed edge choose from (E) the
inequality with the correct traversal direction. Summation gives
  t^x_y-t^x_x
    = sum_j(t^x_{v_j}-t^x_{v_{j-1}})
    <= sum_j w_{v_{j-1}v_j}
    = L(walk).
By (A), t^x_y is no larger than the length of ANY x-y walk.
By (T), one actual C-arc has exactly this length. Thus that arc attains
the graph distance, for every pair, which is the frozen definition.

In particular, (E) is a compact way of supplying every path lower bound
used by C01. It is not an assumed shortest-path algorithm or an appeal
to a numerical optimization result.

## C03.3: completeness, including disconnected graphs

Suppose C is geodesic and w>0. Let K be the component containing C.
For each x in C set t^x_v=dist_G(x,v) for v in K, and t^x_v=0 outside K.
Distances within K are finite attained minima by C01.
The empty walk gives t^x_x=0. Concatenating a shortest x-u path and
edge uv gives t^x_v <= t^x_u+w_uv. Exchanging u and v supplies the
reverse inequality. On components outside K the differences are zero.
There is no edge between K and another component.
Finally, geodesicity provides one C-arc with length t^x_y for every
cycle vertex y. Thus all four groups of constraints hold.

This avoids writing infinity as a real variable for unreachable vertices.

## C03.4: size and explicit arc sums

There are k*n potential variables, k anchors, 2*k*m weak edge
inequalities and k*(k-1) inclusive arc-choice clauses, plus m strict
positivity inequalities. Arc lengths are linear sums of cycle-edge
variables, not fixed constants and not new unconstrained symbols.

A shared prefix representation keeps their expression size small.
List C=(c_0,...,c_{k-1},c_0). Introduce s_0,...,s_k with
  s_0=0,
  s_{j+1}-s_j=w_{c_j c_{j+1}}  for 0<=j<k,
where c_k=c_0.
For any pair of DISTINCT FIXED indices, let r be the smaller index
and q the larger index. Its two arc lengths are
  s_q-s_r  and  s_k-s_q+s_r.
The choice of r,q sorts vertex indices, not variable lengths.
Substitute these expressions in (T). Each atom now has bounded size;
there are O(k*n+k*m+k^2+m) variables and scalar atoms in total.
All coefficients are integers in {-1,0,1}.

This is a polynomial-size EXTENDED Boolean linear formula. It is not
a single convex linear program, a polynomial-time decision claim, or
a claim that eliminating auxiliary variables preserves this size.
C01 supplies an explicit finite formula in edge variables alone.

## C03.5: exact mutation attacks

These are rational hand calculations, not program outputs.

Use G=K4, C=(0,1,2,0), cycle lengths 1 and all three edges to vertex 3
of length 1/4. The path 0-3-1 has length 1/2, shorter than both 0-1 arcs
(1 and 2). Hence C is not geodesic.

M1. Drop (T). Setting all potentials to zero satisfies the remaining
constraints for this non-geodesic cycle. Attainment is indispensable.

M2. Drop (A) but retain the absolute equalities in (T). For each source,
setting ALL potentials to 1 satisfies every edge inequality and makes
each other triangle vertex equal the length-1 arc. The false cycle is
accepted. Anchoring is necessary for this absolute-value formulation.
An alternative using differences t^x_y-t^x_x throughout could fix a
different gauge, but it is not the formula above.

M3. For labels u<v retain only t^x_u-t^x_v<=w_uv.
For each source x in {0,1,2}, set t^x_x=0, the other cycle potentials
to 1, and t^x_3=2. Triangle differences are at most 1; every retained
spoke difference is -1 or -2, hence <=1/4. The anchors and attainment
clauses hold. The missing reverse spoke inequalities would reject it.
Thus an undirected edge requires both directed constraints.

## C03.6: positive and negative test oracles

On K4 with C=(0,1,2,3,0), cycle lengths 1 and diagonals 2, the following
potential rows satisfy the full formula:
  source 0: (0,1,2,1)
  source 1: (1,0,1,2)
  source 2: (2,1,0,1)
  source 3: (1,2,1,0).
Each cycle edge difference has absolute value at most 1; diagonal
differences have absolute value at most 2. The cycle values attain arcs.

Change only w_02 to 1. Both 0-2 arcs still have length 2, so (T) forces
t^0_2=2. The anchor and edge inequality force t^0_2<=1, a contradiction.
This is an explicit infeasibility argument, not a solver receipt.

## C03.7: why the Boolean branches cannot simply disappear

For the same K4 and cycle, use edge order (01,12,23,03,02,13).
Consider two positive length vectors:
  u=(1,1,4,4,2,20),
  v=(4,4,1,1,2,20).
For either vector, chord 02 has length 2 and the shorter 0-2 arc has
length 2. Chord 13 has length 20 and the shorter 1-3 arc has length 5.
There are no outside vertices, so these are all external C-paths.
C02 therefore gives a geodesic cycle for both u and v.
At their midpoint the four cycle edges are 5/2, whereas chord 02 is 2.
Both 0-2 arcs now have length 5, and 2<5 supplies a strict shortcut.
The geodesic region is thus not convex, even for a fixed 3-connected G.
A projection of one convex linear feasible set would be convex, so this
example forbids replacing this exact encoding by one such feasible set
without Boolean branches or another nonconvex device.

## Adapter and negation audit

F_C is a candidate portable QF linear-arithmetic AST once w and t are
declared real. An SMT satisfiability query treats all free variables
existentially. For checking given weights, bind w first and seek t.
For comparing formulas symbolically in w, keep the projection quantifier
explicit. Failure to find potentials in a bounded search is not UNSAT.

In particular,
  NOT EXISTS t F_C(w,t)
is NOT interchangeable with EXISTS t NOT F_C(w,t).
To encode a non-geodesic cycle without this universal quantifier, reuse
C01/C02's strict common-path witness formula. Do not negate only one
chosen potential assignment.

No solver or kernel ran here. The repository's SMT fixture is not a
consumer for this formula. Proposed first authorized replay: the K4
oracles and M1--M3, exact rational arithmetic, at most 60 seconds, one
thread, 256 MiB and 1 MiB output, with implementation/version and input
digests recorded by the executing verifier.

## Checkpoint

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
next_action: derive strict-branch normalization and bounded integer
witnesses for fixed finite forbidden-cycle families; keep the root's
universal existence claim separate and open.
