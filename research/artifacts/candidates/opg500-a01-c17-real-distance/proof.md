# C17: attained real distance in the C16 Walk type, then strict cycle splitting

Status: NONTERMINAL_CHECKPOINT. Verdict: candidate_only.
Problem: problem:opg-500-geodesic-cycles. Target: obligation:opg500-root.
Attempt: attempt:web-20260906-opg500-a01; route:geodesic-linear-encoding-v1;
graph:opg500-initial-v1. Read base: ac7b5331210322e82568d5a6fa5893aec90b47ae.
Primary owner: math-formalization. This is a separately readable GENERATOR proof,
not a report of a human or a second trusted reviewer. No mathematical admission.

## 0. Freeze, correction and scope

Let V be a finite type, R a binary adjacency relation, and w:V x V -> R a real
function strictly positive on R-edges. The first bridge even allows directed
adjacency and loops; the original root specializes to simple undirected H and
symmetric edge weights. Nonedges carry no cost in a walk. No real distance is
assigned to an unreachable pair.

The Walk type is EXACTLY OPG500C16.Walk: nil:a->a and cons of h:R(a,b) with a
b->c walk. An occurrence of an edge contributes its weight each time. Empty
walk cost and edge count are zero. Appending p:a->v and q:v->b concatenates
at the shared v once, and adds counts and costs.

The unqualified assertion that every pair has a nonempty simple-path family is
false. Counterexample: V={0,1}, R empty, a=0,b=1. The corrected statement is
  Nonempty(Walk R a b) iff there exists a unique real DistanceValue(a,b).
For a=b the empty walk supplies reachability even for an isolated vertex.
C16 itself already conditioned transfer on an attained DistanceValue; the
correction does not withdraw C16 or the connected eight-vertex candidate.

No 5913-pattern enumeration or retransmission of C14/C15/T01-T03 occurs here.
The existing finite certificate is a downstream dependency, not a proof premise
for the general real-weight lemmas below.

## 1. The real CostSpec is an instance, not an assumed bridge

Set zero=0, add=real addition, le=real <=. Antisymmetry, 0+x=x, x+0=x,
(x+y)+z=x+(y+z), and left/right order cancellation are properties of real
addition. FiniteRealWalk.lean constructs every field of this instance.
There is no field saying that a minimum exists or tight edges preserve distance.

## 2. Erasing a positive closed factor

Suppose a walk is p * r * q with p:a->v, r:v->v, q:v->b, and r has k>0
edges. Its replacement p*q has the SAME endpoints and valid consecutive edges.
The count decreases by exactly k. Its length decreases by exactly L(r), which
is a finite sum of k positive reals, hence positive. This is
`erase_closed_factor`. Edge-count descent uses k>0, not positivity; strict
length descent additionally uses positive weights. Dropping either hypothesis
invalidates strictness. Deleting an arbitrary open factor is not this theorem.

Every repeated vertex in a finite vertex word supplies such a factor: if
v_i=v_j, i<j, take the prefix through v_i, the segment from i through j, and
the suffix from j. Deletion preserves endpoints/adjacency and strictly lowers
the nonnegative integer count. Thus repeated deletion terminates at a simple
walk. Its length is no greater than the original length, and is strictly less
when at least one nonempty factor was deleted.

For a source-level construction avoiding a separate factorization library,
C17 uses a structurally recursive equivalent. First erase the tail of cons
(a,b,p), yielding a simple b->c walk q. If a is absent from q, prepend the
edge. If a occurs in q, retain the suffix of q beginning at a instead.
That suffix is a legal a->c walk, simple, no longer and with no greater count
than q. A suffix cannot cost more because the omitted prefix has nonnegative
length. Induction proves `exists_simple_le` on the original Walk structure.
It never assumes a shortest walk exists.

Every minimizing walk is itself simple. Its tail is minimizing, by replacement
and cancellation. Inductively the tail is simple. If the original head a
occurs in that tail, the corresponding suffix has cost at most the tail cost,
strictly below the full cost because w(a,b)>0. This contradicts minimality.
Otherwise prepending a retains duplicate-free vertices. This proves
`shortest_is_simple` for ALL minimizing walks, with no unique-path assumption.

## 3. Genuine finite family and attained minimum

Map a simple Walk to its entire vertex word including endpoints. This word is
Nodup. The map is injective: nil and cons are distinguished by word shape;
for two cons walks the words fix the next vertex and recursively the tail.
R-edge witnesses are propositions, so proof irrelevance identifies them.
C17 proves `vertices_injective` and `finite_simple_walks` in the C16 type.

For |V|=n, such words have at most n vertices. Equivalently, duplicate-free
words can be enumerated by subsets of V and permutations of each subset.
This supplies a finite type of all Nodup lists, used by the pinned Mathlib
`fintypeNodupList` interface. Filter it by existence of a SAME-TYPE Walk with
those endpoints and that word. This is `pathWords`, not a smaller family of
increasing-label paths and not a supplied finite-coverage axiom.

The cost computed from adjacent letters equals C16's recursively defined cost
(`wordCost_vertices`). A word belongs to pathWords iff some original Walk
has that word. PathWords is nonempty iff a Walk exists: erase any witness in
the reverse direction; extract a witness in the forward direction.

For a reachable pair, choose a word of minimum real cost in this nonempty
finite set. Existence is finite induction: retain the smaller of the previous
minimum and the newly added value; equality may retain either. C17 uses
`Finset.exists_min_image`, not completeness of R or an unjustified infimum.
Recover its original Walk p. For ANY competing Walk r, erasure gives a simple
q with L(q)<=L(r); minimum-word choice gives L(p)<=L(q). Hence L(p)<=L(r).
This constructs `exists_shortest_simple` and an attained value d=L(p).

DistanceValue means (for all Walks r, d<=L(r)) AND (some Walk attains d).
Uniqueness follows by comparing each of two values with the other's witness.
An unreachable pair cannot have DistanceValue because its attainment field
would give a Walk. At a=a all costs are nonnegative and nil attains zero.
Thus no convention dist(unreachable)=0 is introduced.

Finite V is essential for this route. In an infinite graph with vertices a,b,
and z_n for n>=0, let the only edges be a-z_n and z_n-b, both of weight
1/2+1/(2(n+1)). The simple endpoint path costs are 1+1/(n+1), strictly
approaching 1 from above. There is no shortest a-b path. This does not affect
the finite root; it blocks silently dropping Fintype in the existence theorem.

## 4. Finish the tight-distance bridge without an attainment assumption

Given shortest cons(e,p), compare with q*p for ANY endpoint competitor q to e.
Cancel the common tail cost: w(e)<=L(q). Compare with e*r and cancel the head
cost to show p shortest. Structural induction gives all edges tight.
This is the C16 shortest_all_tight theorem at the explicit real instance.

C16 tightness is R(a,b) AND (for all a-b walks q, w(a,b)<=L(q)). When a
DistanceValue d exists and R(a,b) holds, it is equivalent to w(a,b)=d:
compare with a minimizing path for one inequality and the direct edge for the
other. The R-edge premise MUST remain. Example against deleting it: the path
0-1-2 with unit edges, and an arbitrary nonedge value w(0,2)=2, has d(0,2)=2
but no tight edge 02 because it is not an edge at all.

The SAME shortest walk now lifts edge by edge into the Tight relation. Forgetting
a tight walk recovers an original walk, and both maps preserve cost exactly.
Thus all tight-walk costs are >=d and the lifted minimizer attains d. Since
Section 3 supplies d from reachability, the final `finite_real_tight_distance`
assumes only finite V, positive weights and a reachable pair; it does NOT
assume a distance witness. For undirected graphs this preserves every component
and its distances. It does not connect previously distinct components.

## 5. Next bridge: exact strict-simple-cycle splitting

Here restrict to the finite SIMPLE UNDIRECTED graph and symmetric positive
weights required by the root. A simple cycle has at least three distinct
vertices and a closing edge. It is not required to be induced. Work in its
component even if the ambient graph is disconnected.

If C is non-geodesic, choose a simple x-y path P with L(P)<d_C(x,y), where
d_C is the intrinsic shortest arc length. This follows from the finite attained
minimum, not a floating comparison. Split P at successive visits to V(C),
with visited vertices v_0=x,...,v_r=y. If each segment P_j had
L(P_j)>=d_C(v_j,v_{j+1}), summing and using the intrinsic triangle inequality
would give L(P)>=d_C(x,y), a contradiction. Hence some segment Q has
L(Q)<d_C(u,v), and so L(Q) is strictly less than BOTH C-arcs A,B.

P is simple, so u!=v, Q is simple and its internal vertices avoid C.
If Q has one edge and it were a C-edge, it could not be shorter than d_C.
If Q has multiple edges, each has at least one internal outside vertex except
possibly at the two ends, so none is a C-edge. Thus E(Q) is disjoint from C.
The two arcs intersect only in u,v; each is simple. Each concatenation of an
arc with reversed Q therefore forms a simple cycle. A putative two-edge child
would require an arc and Q both to be distinct single edges joining u,v,
which is impossible in a simple graph. Both children thus have at least three
vertices. Chords among their vertices do NOT disqualify them as cycles.

Write a=L(A), b=L(B), q=L(Q). Parent length is a+b, children a+q and b+q.
The inequalities q<a and q<b give both children strictly shorter.
At the integer incidence level,
  chi_child0 + chi_child1 = chi_C + 2 chi_Q.
At every Q-edge there are exactly two occurrences; every parent edge occurs
exactly once; all other coefficients are zero. Reducing modulo two gives
  chi_C = chi_child0 XOR chi_child1.
Replacing XOR by union, or dropping the coefficient 2 before reduction, is
incorrect. ShortcutAlgebra.lean separates the order and per-coordinate algebra
from the geometry: it does not pretend disjointness/simplicity has been
kernel-derived merely because arc variables were named A and B.

If C and Q lie in a tight spanning subgraph T, both children do too. Therefore
strict descent can be used inside T. Rank(c) = number of T-cycles strictly
shorter than c decreases at each step; the finite family, not a claimed
well-order of all positive reals, justifies termination. With a separating
F2 functional q0, an odd parent has an odd child; a shortest odd cycle is
therefore geodesic. The general minimum/simple-cycle geometry integration in
Lean remains open; no repeat of the finite 5913-pattern check is substituted.

## 6. Actual attacks, source status and next obligation

check.py executed in ordinary and optimized modes on 13 explicit fixtures,
including empty V, isolated vertices, disconnected components, directed graphs,
triangle and diamond ties, and short/tied/long chords. Both modes returned 0
with identical output. It checked 9654 walks of at most five edges, 12573
closed-factor deletions, 53589 endpoint-correct appends, 153 ordered endpoint
pairs (18 unreachable), 539 simple paths including diagonal nil walks, and
454 localized strict splits. There were 16 tied endpoint pairs. Seventeen
mutations distinguish domain, endpoint, strictness and XOR errors. Full fixture
weights, all minimizing simple paths, representative deletion/split traces and
exact outputs are in checks.json. No numerical tolerance and no 5913 recount.
These are generator tests of finite implementation behavior only.

The final first-bridge source has proof bodies rather than placeholders, but
it is UNELABORATED. No Lean/lake/elan executable was found by actual process
probes; no #print axioms output or runtime toolchain fingerprint exists. Static
escape scanning is not a kernel axiom audit. The repository fixture locks Lean
v4.33.0 and Mathlib db584cd6d46c92f209a44c0f1c829460d327499d; all three lock
file bytes were reconstructed and matched their freshly retrieved Git blobs.
This fixed local source is quarantined and the registry provides no applicable
allowlisted toolchain. No unmatched scalar SMT fixture or new admission_request.

First assurance action: elaborate the C16 import and C17 exists_simple_le /
exists_shortest_simple / finite_real_tight_distance at those locks, repair any
concrete API errors without weakening the statement, and record actual axioms.
First graph geometry still without a full Lean body: obtaining the internally
C-disjoint shortcut and proving both children simple in the original cycle
representation. Section 5 and exact tests advance it without claiming closure.
No fatal flaw in the additive positive finite root chain was found in this step.
Root and local trusted obligations remain open; best_verified_result=none.
