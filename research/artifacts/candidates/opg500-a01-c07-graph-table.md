# OPG-500 C07: graph-to-table and Boolean compiler faithfulness

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c07-graph-table
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Target: obligation:opg500-finite-linear-characterization
Base: fe19caf088da56204e3f6cf30b5078a276561dd3
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Purpose and dependency boundary

C06 isolates an order theorem conditional on a complete sound cost table.
This candidate supplies the missing mathematical construction of that
table and a graph-to-linear-form compiler specification. It does not
claim that the construction is already implemented or mechanically
verified. The C06 Lean source remains uncompiled.

Candidate dependencies at this base:
- research/artifacts/candidates/opg500-a01-c01-linear.md
- research/artifacts/candidates/opg500-a01-c02-excursions.md
- research/artifacts/candidates/opg500-a01-c06-order-slice.lean
- research/artifacts/candidates/opg500-a01-c06-faithfulness-map.md

Only the fixed finite-simple-graph and positive-real-length local target
is considered. No bound on all graphs and no root existence argument is
introduced. The graph-to-table construction below is a candidate proof,
not an extra axiom available to the Lean source.

## C07.1: validated finite representation

Choose a bijective labelling V(G)={0,...,n-1}. A graph input is an ordered
edge table E=(e_0,...,e_{m-1}), where e_j=(u_j,v_j) has
0<=u_j<v_j<n and all entries are distinct. The represented graph is
undirected: traversal in either direction uses the same edge index.
The edge order is fixed before any incidence vector or length vector.

A cycle input is a list c=(c_0,...,c_{k-1}) with k>=3, distinct entries in
V(G), every consecutive pair adjacent, and ALSO {c_{k-1},c_0} in E.
It represents a simple cycle with its closing edge, not merely a path.
The graph may have chords between cycle vertices; no inducedness filter
is allowed when interpreting this local geodesic predicate.

The length input w has exactly m real coordinates, with w_j>0.
A rational fixture serializes numerators/denominators exactly; floating
point substitution is not part of the abstract real semantics.

Reject invalid labels, loops, duplicate edge-table entries, missing
cycle edges, repeated cycle vertices, dimension mismatch or nonpositive
lengths before applying a theorem about this representation.

An isomorphism to these labels preserves walks, simplicity, cycle arcs,
and edge-length sums by relabelling. Thus labelling changes the encoding
only, not the domain of the local claim.

## C07.2: complete finite path objects

For distinct fixed endpoints x,y, define an oriented simple path object
to be a vertex list p=(x,v_1,...,v_j,y) satisfying:
- all vertices are distinct;
- 0<=j<=n-2;
- each consecutive unordered pair occurs in E.

Enumerate ALL ordered j-tuples of distinct elements of V\{x,y}, for
every j=0,...,n-2, and retain exactly those passing the adjacency test.
The case j=0 is the direct edge, when present.

Soundness: every retained list has the required endpoints, distinct
vertices and valid steps, so is a simple x-y path.
Completeness: reading any simple x-y path in traversal order gives
exactly one such intermediate tuple. Its vertices exclude x,y, are
distinct, and number at most n-2. It therefore appears and passes the
test. Distinct tuples cannot represent the same oriented vertex list.

The finite size bound is
  sum_{j=0}^{n-2} (n-2)!/(n-2-j)!.
The list can contain paths with equal LENGTHS; length ties must not be
mistaken for duplicate path objects in witness provenance.

An equivalent bounded-depth DFS uses a prefix beginning at x, never
repeats a used vertex, and extends by each unused adjacent vertex.
At y it emits the prefix and stops extending it. The remaining-vertex
count n-|prefix| strictly decreases at every recursive extension.
Prefix induction proves completeness: the next vertex of any target
simple path is unused and adjacent, so its prefix extension occurs.
Soundness is maintained by the same invariant. Stopping at y loses no
simple x-y path, since such a path cannot visit y and later revisit it
as the endpoint.

Neighbour sorting is only traversal order. It must not demand increasing
labels along a path. A global operation/output cap does not change the
mathematical family: on cap excess the consumer must return incomplete,
not quietly treat the generated prefix of the table as complete.

## C07.3: construct both cycle arcs without off-by-one gaps

Fix a pair x=c_r, y=c_s with r!=s. Let q be the unique integer in
{1,...,k-1} congruent to s-r modulo k.

The forward arc is the vertex sequence
  (c_{r+t mod k}) for t=0,...,q.
The backward arc is
  (c_{r-t mod k}) for t=0,...,k-q.

Both begin at x and end at y. Each has at least one edge and fewer than
k edges. Distinct cycle vertices and these index bounds show that each
sequence has distinct vertices. Every step is a consecutive cycle edge
in one direction, including wraparound. Hence both arcs are actual
members of the full simple-path table from C07.2.

Their interiors are disjoint and their edge sets partition E(C).
This follows by splitting the k cyclic edge positions into the q
forward positions and the remaining k-q positions. In particular, for
the incidence vectors
  chi_A + chi_B = chi_C.
This identity checks both the closing edge and endpoint conventions.
It does not mean both arcs are shortest.

If x=y, do not use q=0 or q=k as two candidate shortest arcs. The pair
criterion for distinct vertices is sufficient; diagonal distance is
zero via the empty walk.

## C07.4: exact incidence and cost semantics

For any finite walk W let count_W(j) be the number of its traversals
of e_j, in either direction. Grouping its finitely many summands gives
  L_w(W) = sum_{j=0}^{m-1} count_W(j)*w_j.
For a simple path no edge can be traversed twice: a repeated edge would
repeat an endpoint vertex. Thus count_P(j) belongs to {0,1}; call this
vector chi_P. Reversing the path preserves it.

Consequently
  L_w(A)-L_w(P) = (chi_A-chi_P) dot w.
Every coefficient belongs to {-1,0,1}. If A and P share an edge, its
coefficient is ZERO. The oriented traversal direction is irrelevant in
an undirected graph; it must not introduce a negative edge length.

At a fixed w, let xs be the finite list obtained by mapping every path
object in C07.2 to its cost. The full path type, not a truncated or
filtered type, is the index type iota of C06.
- C06 hcomplete holds because every simple path occurs in the table.
- C06 hsound holds because every table entry was obtained from a path.
- C06 hne holds because either constructed arc occurs.
- The distinguished indices ia,ib are the actual arc objects.

A minimum of xs is therefore attained by a real graph path. For any
finite x-y walk, repeated-vertex deletion removes a nonempty closed
subwalk of strictly positive length and strictly decreases edge count.
After finitely many deletions one of the enumerated simple paths remains.
Thus every walk has length at least the table minimum, which itself is
attained by a walk. The table minimum equals graph distance.
This does not assume that an infimum over an infinite walk family is
attained without proof.

## C07.5: typed finite Boolean compiler

Use a finite AST with constructors
  Atom(coefficients, relation, rhs), And(children), Or(children).
Relations used here are LE and LT. All coefficient lists have exactly
m integer entries and rhs=0. The semantics of an atom is respectively
coefficients dot w <= 0 or coefficients dot w < 0.
And over an empty list is true; Or over an empty list is false.

For each edge emit Atom(-unit_j, LT, 0), meaning w_j>0.
For each unordered DISTINCT pair of cycle vertices emit
  Or([
    And([Atom(chi_A-chi_P, LE, 0) for every P in the full pair table]),
    And([Atom(chi_B-chi_P, LE, 0) for every P in the full pair table])
  ]).
Conjoin all pair nodes and all positivity nodes.

The path tables and coefficients depend only on the fixed graph and
cycle, not on the unknown weights. Changing w does not change the
enumeration domain. This is essential when the formula is used to
search for lengths, instead of merely testing supplied lengths.

Atom soundness is C07.4; finite And/Or semantics then prove by structural
induction that the emitted AST equals C01's Boolean formula. C06's
proposed order theorem and C07.4's distance identification explain the
same pair equivalence without using any unsupported quantifier swap.

Using unordered pairs is faithful because G is undirected: reverse
every y-x walk to get an x-y walk of identical length, and reverse the
arcs. Thus the criterion is symmetric. Label ordering must be used only
to index each unordered pair once, never to restrict intermediate paths.

Under the positive-domain assumption, a separate non-geodesic AST is
  Or over all pairs and all P [
    And([
      Atom(chi_P-chi_A, LT, 0),
      Atom(chi_P-chi_B, LT, 0)
    ])
  ].
Outside that domain, negating the complete geodesic AST additionally
admits a nonpositive edge. These two different negation scopes must be
recorded explicitly in the adapter request.

A consumer may remove an identically zero LE atom as true, but removing
a zero LT atom as true would be an error. It may deduplicate identical
rows for truth evaluation while retaining provenance mapping to all
original pair/path/arc objects for witness checks.

## C07.6: precise hand attacks and fixture

The JSON companion is proposed data, not execution output.

A. Increasing-only intermediate vertices can miss the only relevant
shorter path even in a 3-connected graph. Use G=K5 with edge order
  01,02,03,04,12,13,14,23,24,34
and lengths
  (10,100,1,10,100,100,10,1,1,100).
Let C=(0,1,4). The path P=(0,3,2,4) has length 3.
Its 0-4 arcs have lengths 20 and 10, so it is a strict shortcut.
The order of its intermediate vertices is decreasing and would be lost.

For the 0-4 pair, an increasing-intermediate path not using vertex 1
is one of 04,024,034,0234, with lengths 10,101,101,201.
If it uses vertex 1, that vertex is first among its intermediate labels:
014 costs 20; any further intermediate step from 1 uses an edge of
length 100. Thus none of these increasing-only paths beats length 10.
For the other two cycle pairs, the direct cycle edge is length 10 and
any route not using it must first leave vertex 1 by an edge of length
at least 10, so no route is shorter than 10.
The incorrect filter would therefore falsely label this C geodesic.

B. For the same C and pair 0-4, the backward arc is (0,4), using the
CLOSING edge 40. It must not disappear because the displayed cycle
list ends at 4 without repeating 0.

C. Compare arc A=(0,1,4) with P'=(0,1,3,4). The shared edge 01 cancels:
  chi_A-chi_P' = (0,0,0,0,0,-1,1,0,0,-1).
At the fixture weights the dot product is -190, equal to 20-210.
Keeping a positive coefficient for 01 would change the expression.

D. A path input (0,1,2) without edge 20 is not a triangle. A compiler
that checks only consecutive displayed vertices has not validated its
cycle precondition. Such an invalid object cannot instantiate C06's
two-arc graph interpretation.

## Verification request and checkpoint

The generic construction, compiler and fixture have not been executed,
compiled or mechanically checked. C06 remains an uncompiled order slice.
Suggested first authorized replay: the K5 fixture plus earlier K4 tie
fixtures, at most n=6, 100000 atoms, 60 seconds, one thread, 256 MiB and
1 MiB output. Any truncation returns incomplete, never a universal pass.

Freeze the exact graph representation, enumerator and AST consumer
versions, input/candidate digests and limits before replay. Separate
checks must validate table completeness, arc construction, row semantics,
order proof and graph-distance faithfulness.

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
next_action: freeze a single integrated verification bundle referencing
C01/C06/C07 and list exactly which runtime and faithfulness receipts are
still missing, without promoting the bundle itself to Evidence.
