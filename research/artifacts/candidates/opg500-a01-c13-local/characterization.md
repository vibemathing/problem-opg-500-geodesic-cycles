# C13: local finite-linear characterization with exact mutation replay

Status: RESULT_CANDIDATE_READY. Verdict: candidate_only.
Target: obligation:opg500-finite-linear-characterization.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1.
Read base: 7ae092f383ae891be51dd21fd423eeecec54fa66.
ProblemContract SHA-256: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.
Primary owner: math-formalization. No Lean execution is asserted.

## Scope and source fidelity

Fix a finite simple undirected graph G=(V,E), a simple cycle C of length
k>=3, and positive real lengths l:E->R_{>0}. The local theorem does not
need three-connectivity; its specialization includes the root domain.
No simultaneous choice of lengths for all cycles is asserted.

The canonical definition says that for each pair of cycle vertices one
of the two cycle arcs is a shortest path in G. Thus equality with distance
is the meaning of this definition, not a newly discovered stronger theorem.
The substantive reduction below removes the distance operation and all
infinite walk quantification. The original OPG definition forbids a path
strictly shorter than both arcs; it is equivalent under these assumptions.

For different x,y in V(C), write A0_xy,A1_xy for the two simple cycle arcs.
An arc includes both endpoints and all its consecutive edges, including
any cycle-closing edge. Put a_i=L_l(Ai_xy). For a walk W, L_l(W) sums
edges with multiplicity. For a simple path P it is chi_P dot l, where
chi_P is the 0/1 incidence vector in one fixed edge order.

The arc formula uses unordered DISTINCT pairs I=binom(V(C),2). Reversing
endpoints changes no undirected length. If an all-pairs distance formulation
includes x=y, its diagonal is d_C(x,x)=d_G(x,x)=0, attained by the empty
walk. We do not manufacture two nonempty simple x-x arcs.

## L1. Walk reduction and attained finite minimum

If a finite x-y walk repeats a vertex, delete the nonempty subwalk between
two occurrences. Endpoints and adjacency are preserved. The number of
traversed edges strictly decreases and the length strictly decreases,
since every removed edge has positive length. Iteration terminates in the
nonnegative integer edge count and gives a simple x-y path. In particular,
a minimum-length walk cannot have a repeated vertex. For x=y the unique
minimum-length possibility is the empty walk.

For x!=y, a simple path has r distinct internal vertices, 0<=r<=n-2.
There are at most (n-2)!/(n-2-r)! ordered choices for them. Consequently
P_xy, the family of ALL simple x-y paths, is finite, with
  |P_xy| <= sum_{r=0}^{n-2} (n-2)!/(n-2-r)!.
Both cycle arcs belong to P_xy, so the family is nonempty even when G
has other disconnected components.

A finite nonempty list of real lengths has an attained minimum: for a
singleton take its entry; adjoining a new entry replaces a current minimum
by the smaller of the two. This induction permits ties. Call the minimum d.
Every walk reduces to a member of P_xy of no greater length, while the
minimizing simple path is itself a walk. Hence
  dist_l^G(x,y) = min_{P in P_xy} L_l(P) = d.
There is no circular assumption that a shortest walk already exists.
Nonnegative lengths would preserve existence of a simple minimizer but
not force every minimizing walk to be simple; zero detours show the gap.
Negative lengths are outside the domain.

## L2. Pairwise arc choice

Because both arcs are paths, d<=a_0 and d<=a_1. Therefore
  (a_0=d OR a_1=d) iff min(a_0,a_1)=d.
Here 'shorter arc' means an arc attaining the weak minimum. If the arcs
tie, both attain d or neither does. No uniqueness is imposed.

For i=0,1 separately,
  a_i=d iff forall P in P_xy, a_i<=L_l(P).
The forward implication uses minimality of d. For the reverse implication,
compare with a path attaining d to obtain a_i<=d; combine with d<=a_i.
Thus the exact pair predicate is
  (AND_{P in P_xy} a_0<=L_l(P))
  OR (AND_{P in P_xy} a_1<=L_l(P)).                         (1)
The chosen arc is fixed across all competitors FOR THIS PAIR; it may differ
for another pair. OR is inclusive. It is not replaced by AND.

For source comparison, absence of a path shorter than BOTH arcs is
  forall P, (a_0<=L_l(P) OR a_1<=L_l(P)).
This equals (1): compare a_0 and a_1 once. If a_0<=a_1, either alternative
for any P implies a_0<=L_l(P); otherwise select a_1. This uses total order,
not an invalid general interchange of forall and OR. L1 also handles a
source convention allowing arbitrary walks. No statement mismatch is
found on the ordinary distinct-vertex arc domain.

## L3. Finite Boolean linear characterization

On the assumed positive length domain define
  Phi_C(l) = AND_{xy in I} [
    (AND_{P in P_xy} (chi_A0_xy-chi_P) dot l <= 0)
    OR
    (AND_{P in P_xy} (chi_A1_xy-chi_P) dot l <= 0)].          (2)
Every atom is homogeneous linear with integer coefficients in {-1,0,1}.
Shared edges cancel. All atoms use the SAME edge-indexed vector l.
Both I and every P_xy are finite. For an unrestricted real input vector,
add AND_e NOT(l_e<=0); positivity itself is then also a finite Boolean
combination of weak inequalities. The checker instead validates the
positive domain before evaluating (2).

Soundness: a true branch of (2) supplies, for each distinct pair, an actual
cycle arc no longer than every simple competing path. L1 and L2 identify
its length with graph distance. Thus the repository geodesic definition
holds for every pair. The diagonal is already automatic.

Completeness: if C is geodesic, for every pair one actual arc attains graph
distance. Its comparison with every simple path is weakly true by L1.
The corresponding OR branch satisfies (2). No numeric tolerance is used.

Equivalently, take the OR over all functions sigma:I->{0,1} of the AND
of the selected arc comparisons. This is a finite disjunction of linear
systems, not the conjunction of all branch constraints.

An optional equality presentation introduces a real t_xy for each pair:
  exists (t_xy), AND_xy [
    (AND_P t_xy<=chi_P dot l)
    AND (t_xy=chi_A0_xy dot l OR t_xy=chi_A1_xy dot l)].      (3)
Attainment at an actual arc forces t_xy=d. Eliminating t_xy gives (2),
which has only the original edge variables and weak linear atoms.

Within the positive domain only, the exact failure condition is
  exists xy in I, exists P in P_xy,
    L_l(P)<a_0 AND L_l(P)<a_1.
A minimizing path supplies the SAME strict witness for both arcs. Equality
with either shorter arc is not a violation. Outside the positive domain,
negating a positivity-guarded formula also includes nonpositive edges.

## Boundary and falsifier audit

- Equal arcs and additional equal shortest paths are accepted. A tied
  chord of length 2 in a unit four-cycle is not a strict shortcut.
- A chord need not destroy geodesicity: unit four-cycle edges and chords
  of length 3 are geodesic. All chords remain in competing path tables.
- An arc is its own competitor. Replacing <= by < makes every such branch
  false; deleting self comparisons does not repair rejection of other ties.
- A triangle has one-edge and two-edge arcs, not a missing/empty branch.
  Unit triangle lengths give 1 versus 2, defeating 'both arcs shortest'.
  A triangle inside K4 with external spokes 1/4 is not geodesic: the path
  through the fourth vertex has length 1/2 versus arcs 1 and 2.
- For the unit square plus chord 02 of length 1, arcs from 0 to 2 have
  length 2. Removing just the competing path (0,2) makes the mutated
  whole-cycle formula true even though the actual distance is 1.
- Complete path enumeration does not require increasing vertex labels.
  A K5 fixture contains the strict shortest path 0-3-2-4.

## Implementation, completed checks, and remaining assurance

check.py uses Fraction throughout. DFS enumerates simple paths; a separate
permutation enumeration checks exact path-table equality. Floyd's algorithm
computes graph distances without consulting the emitted AST. Every simple
cycle in each tested graph is compared using both arc/distance semantics
and the finite integer-row AST. The input/atom/runtime caps reject without
silently truncating a path family.

Observed execution: Python 3.13.5, exit 0. Nine fixed fixtures cover 73
cycles and 59 pair tables; all 64 labelled four-vertex simple graphs with
two deterministic exact assignments cover another 88 cycle checks across
128 instances. Five mutations are distinguished by explicit fixtures:
sign flip, omit one competitor, <= changed to <, strictness after removing
self-comparisons, and OR changed to AND. Zero, negative and float-valued
inputs are rejected. fixtures.json, checks.json and execution.json retain
the exact inputs, selected-pair audits, outcomes and actual run hashes.
These finite tests validate implementation behavior, not the universal
all-real theorem. The all-real claim is the proof L1->L2->L3 above.

The loop-deletion invariant is endpoint preservation; its monovariant is
edge count. Enumeration terminates by distinct-vertex depth <=n-1. Positive
scaling preserves all comparisons; vertex relabeling only permutes indices.
No probabilistic assumption, asymptotic extrapolation, induction over graph
construction or root-cycle-space bridge is used.

C01 is the earliest candidate for this same reduction; this packet adds
executed exact falsifier tests and consolidates its local proof. C10/C11
root arguments are not imported. C11 source existence is not compilation;
C12 only supplies an abstract finite minimum and does not close its six
graph bridges. None is needed for this local proof.

best_verified_candidate: none.
state: RESULT_CANDIDATE_READY (local deduction and implementation package).
minimal_unclosed_pair: none in the candidate proof.
minimal_unclosed_boolean_branch: none in the candidate proof.
Both admitted obligations remain open in trusted records. No EvidenceLink,
Result or Solution is produced. Next: trusted statement-faithfulness and
formal replay of THIS frozen local reduction, not six deeper root bridges.
