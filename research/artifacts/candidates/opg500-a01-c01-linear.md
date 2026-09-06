# OPG-500 C01: finite linear characterization

Status: Candidate only. No solver, kernel, axiom audit or verifier receipt is claimed.

## Frozen identity and scope

Problem: problem:opg-500-geodesic-cycles
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Target: obligation:opg500-finite-linear-characterization
Target statement SHA-256: 2f3ae878173cf0c4283d949014261bb9ae0072a1b283776ef47e581122993e5d
Candidate: candidate:opg500-a01-c01-linear
Base: 241c4b930d8ce1db231fff1647092554f55f3afb
Primary owner: math-formalization

Let G=(V,E) be a fixed finite simple undirected graph, C a simple cycle,
and w:E -> R with w_e>0 for every edge. Write n=|V|, k=|V(C)|>=3.
The local lemma needs no connectivity assumption beyond C being a cycle.
This explicitly generalizes the local domain, not the root conclusion.
The root still quantifies over all finite simple 3-connected graphs and
asks for existence of one length assignment making every geodesic cycle
peripheral. No such universal existence result is claimed here.

For any finite walk W, L(W) is the sum of edge lengths with multiplicity.
For distinct x,y in C, let P_xy be ALL simple x-y paths in G, including
both C-arcs A_xy and B_xy. Fix an ordering of the vertices and use
unordered distinct pairs I={{x,y}: x,y in V(C), x!=y}.
The diagonal has distance zero via the empty walk and imposes no extra
condition. We do not invent two positive x-x arcs.

Sources: the frozen ProblemContract and original OPG entry
https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
(retrieved 2026-09-06, definition paragraph). That entry quantifies over
vertices, not arbitrary interior points of a metric realization.

Allowed mathematical background: finite-graph-basic; real-ordered-field.
All claims below are candidate deductions, not imported Evidence.

## C01.1: finite shortest-path reduction

Every finite x-y walk with a repeated vertex contains a nonempty closed
subwalk between two occurrences of that vertex. Delete it. This preserves
the endpoints and gives a walk with strictly fewer edges and strictly
smaller length, because each removed edge has positive length.
Iteration terminates since the edge count is a nonnegative integer.
The final walk is a simple x-y path.

A simple x-y path uses a sequence of distinct intermediate vertices from
V\{x,y}. Thus
  |P_xy| <= sum_{j=0}^{n-2} (n-2)!/(n-2-j)!.
Adjacency can only reduce this finite bound. P_xy is nonempty because
it contains A_xy and B_xy. Consequently its finite list of real lengths
has a minimum d_xy attained by a simple path. Every walk reduces to a
path of no larger length, so this minimum is exactly the infimum over
all finite x-y walks, namely dist_w^G(x,y).

Strict positivity proves every shortest walk is simple. Nonnegative
lengths would still give a simple minimizer, but not that every minimizer
is simple: a zero-length detour can remain. This weaker extension is not
used. Negative lengths are outside the contract; in an undirected graph
a negative edge permits arbitrarily negative backtracking walks.
Neither n nor path lengths require a pre-existing bound in the theorem;
n is fixed before enumeration.

## C01.2: faithful pairwise equivalence

Put a=L(A_xy), b=L(B_xy), d=d_xy. Since both arcs are available paths,
d<=a and d<=b. The following are equivalent:

(1) At least one C-arc is a shortest path in G.
(2) a=d OR b=d, using inclusive OR.
(3) min(a,b)=d.
(4) For every P in P_xy, a<=L(P) OR b<=L(P).
(5) (For every P in P_xy, a<=L(P))
    OR (For every P in P_xy, b<=L(P)).
(6) There is no P in P_xy with L(P)<a AND L(P)<b.

(1)<->(2) is the definition of attaining distance, proved meaningful by
C01.1. (2)<->(3) follows from d<=a,b. If (3), every path has length at
least d=min(a,b), proving (4). For (4)->(5), compare a and b ONCE:
if a<=b, then each disjunction in (4) implies a<=L(P); if b<=a,
each implies b<=L(P). The selected smaller arc is independent of P.
This is NOT a general rule commuting a universal quantifier with OR.
For (5)->(2), if a is no larger than every path, test a minimizing path
to obtain a<=d; combine with d<=a. The b branch is identical.
(4)<->(6) is De Morgan plus the total order identity not(u<v) iff v<=u.
C01.1 also shows that allowing arbitrary walks in (6) gives the same test.

The geodesic predicate is the conjunction of these equivalent pairwise
predicates over I. Choosing one branch for one pair does not force the
same named arc branch for other pairs.

## C01.3: finite Boolean linear formulas

Index edges once. For a simple path P let chi_P in {0,1}^E be its
incidence vector, so L(P)=chi_P dot w. Write a_i=chi_Ai dot w,
b_i=chi_Bi dot w and p_P=chi_P dot w. All coefficients below are integers.

The exact positive-domain formula is
  Phi_C(w) :=
    AND_e (w_e>0)
    AND AND_{i in I} [
      (AND_{P in P_i} ((chi_Ai-chi_P) dot w <= 0))
      OR
      (AND_{P in P_i} ((chi_Bi-chi_P) dot w <= 0))
    ].

Equivalent path-factored formula:
  Psi_C(w) :=
    AND_e (w_e>0)
    AND AND_{i in I} AND_{P in P_i}
      [a_i<=p_P OR b_i<=p_P].

Equivalent branch expansion:
  OR_{sigma:I->{0,1}} [
    AND_e (w_e>0)
    AND AND_{i in I} AND_{P in P_i}
        ((chi_{arc(i,sigma(i))}-chi_P) dot w <= 0)
  ].
There are 2^{k(k-1)/2} possible arc-choice branches before simplification.
Each branch is one finite linear system. The union need not be represented
as a single convex system. Keeping the Boolean syntax avoids expanding
all branches in memory.

An alternative equality encoding uses one real auxiliary d_i per pair:
  EXISTS (d_i) [
    AND_e (w_e>0)
    AND AND_i (
       AND_{P in P_i} (d_i<=p_P)
       AND (d_i=a_i OR d_i=b_i)
    )
  ].
A saturated arc and all lower-bound constraints force d_i to be the true
shortest-path distance. Merely requiring d_i<=a_i,b_i would be unsound:
it allows a value below all path lengths without any attainment.
Existential elimination returns a finite Boolean combination over w.

Soundness of Phi: the selected arc in each pair is itself a path and is
no longer than every simple path; C01.1 makes it a shortest walk.
Completeness: for every geodesic pair select an arc attaining its
distance; its weak comparison with every simple path holds. Hence some
branch of Phi is satisfied. Positive-edge constraints are part of the
domain, not an implicit solver assumption.

## C01.4: negation and strictness audit

WITH w>0 already assumed,
  C is not geodesic
  iff OR_{i in I} OR_{P in P_i} [p_P<a_i AND p_P<b_i].

The same P must beat BOTH arcs. Negating the two universal branches
initially produces witnesses P and Q with L(P)<a_i and L(Q)<b_i.
Choose the shorter of P and Q: its length is <= both witness lengths,
hence strictly below both corresponding arcs. This proves the reduction
to a common witness without silently changing quantifiers.
The negation of the FULL Phi on unrestricted R^E additionally includes
OR_e(w_e<=0). Dropping that domain clause would be a logical error.

Equality of p_P with either arc prevents this P from being strictly
shorter than both; such a tied path is not itself a counterexample. Positive w does not imply uniqueness
of shortest paths, inequality of arc lengths, or inducedness of C.
Comparing an arc to itself forces equality; replacing all <= by < makes
the associated branch impossible. Even if self-comparisons are removed,
other equal shortest paths must still be allowed.

## C01.5: exact hand checks and rejected mutations

These are explicit arithmetic examples, NOT execution receipts.

T1. In unit-length K4 let C be a triangle. For any pair its arcs have
lengths 1 and 2 and the graph distance is 1. C is geodesic; requiring
BOTH arcs to attain distance incorrectly rejects it.

T2. In K4 on 0,1,2,3 put length 1 on the four edges of
C=(0,1,2,3,0) and length 2 on both diagonals.
Adjacent distances are 1, opposite distances 2. C is geodesic.
Opposite arcs and the corresponding diagonal tie at 2. Thus a <=
shortcut is NOT a witness of non-geodesicity. C is not induced, which
also defeats silently restricting the cycle enumeration to induced cycles.

T3. Change length(02) in T2 to 1. The 0-2 diagonal is length 1 while
both 0-2 C-arcs have length 2. The SAME simple path is a strict witness
and Phi_C is false.

T4. A zero-length closed detour appended to a minimizing path leaves its
length unchanged. This rejects the extension 'every minimizing walk is
simple' when positivity is replaced by nonnegativity.

The three bad transformations rejected are: inclusive OR -> AND,
weak comparisons -> strict comparisons, and strict common-witness
shortcut -> weak shortcut or a path required to beat only one arc. The admitted route
itself is not rejected.

## Candidate adapter interface and ToolPlan

Use a finite AST with nodes And, Or and linear atoms
  {coefficients: integer vector indexed by E, relation: "<=" or "<",
   rhs: integer or rational}.
The convention is coefficients dot w relation rhs; encode w_e>0 as
(-unit_e) dot w < 0. Incidence differences encode all path comparisons.
This AST is a candidate interface, not an asserted existing adapter API.

An authorized exact-linear-inequality consumer should:
1. Validate a graph edge table, a cyclic list with distinct vertices and
   every cycle edge present, and strictly positive length variables.
2. Enumerate distinct-vertex paths with at most n-1 edges by deterministic
   DFS, sorted labels, and retain incidence vectors and endpoint tags.
3. Emit Phi/Psi and the common-witness negation; maintain provenance for
   every atom. Check T1--T3 by exact rational substitution.
4. Check the two directions on each frozen finite instance, or return
   an exact path/arc counterexample to an asserted encoding equivalence.
5. Pin implementation and solver versions, freeze all inputs/digests and
   produce a genuine bounded replay receipt with limitations.

Suggested FIRST replay cap: n<=6, one graph at a time, <=100000 emitted
atoms, one CPU thread, 256 MiB, 60 seconds, 1 MiB output, no retry after
deterministic parse/logic failure. Abort without a verdict on cap excess.
These bounds constrain the test, not the mathematical lemma.

No execution was performed. scripts/vibe_mathing/smt.py at the base is
a hard-coded fixture for a different statement, not a general graph
formula endpoint; its version constants are not observed runtime versions.
The channel declares command_execution=false. Formatting and artifact
hashing do not provide mathematical verification.

## Dependency closure and checkpoint

Candidate deduction chain:
  C01.1 -> C01.2 -> C01.3 -> C01.4;
  T1--T4 attack the listed stronger/weaker mutations.

best_verified_result: none
best_verified_candidate: none
open_obligations:
  - obligation:opg500-finite-linear-characterization
  - obligation:opg500-root
next_action: audit an alternative finite C-path shortcut encoding, and
then supply a small arithmetic formalization slice plus exact adapter
replay request. The graph/simple-path correspondence still needs an
authorized statement-faithful verification before the target can close.
