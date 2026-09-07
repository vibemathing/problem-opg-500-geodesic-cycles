# C16: shortest-walk tight lifting and different-core dual replay

Verdict: candidate_only. Status: NONTERMINAL_CHECKPOINT.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1. Target: obligation:opg500-root.
Read base: 73ae555464c10347c615a130927a2c7cc0e5ab49.
Contract: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.
Primary owner: math-formalization. No new admission request.

## 1. First bridge, reconstructed without a prior candidate conclusion

Let R be an adjacency relation, w a real edge cost and W a finite walk.
Its length sums edge costs WITH multiplicity. Define Shortest(W) by comparison
with EVERY finite walk with the same endpoints, not only a sampled table.
Define Tight(a,b) as R(a,b) and w(a,b)<=L(Q) for every a-b walk Q.
This definition needs no prior choice of distance function.

If W is e followed by P and is shortest, replace e by an arbitrary walk Q
between its endpoints. Since Q++P remains a walk, minimality gives
  w(e)+L(P) <= L(Q)+L(P).
Right cancellation gives w(e)<=L(Q). Thus e is tight. Replacing P by any
walk with the same endpoints, and cancelling w(e) on the left, proves P
shortest. Structural induction on W therefore proves every edge of EVERY
shortest walk tight. No strict comparison and no unique minimizer is used.

Lift the same vertex/edge sequence to the tight relation, supplying each
edge its just-derived tightness proof. Structural recursion preserves cost
exactly. Conversely forgetting tightness witnesses preserves cost exactly.
An attained distance value d is, by definition, a lower bound on lengths
of all walks, together with an actual walk of length d. Lift that attaining
walk; forgetting shows d is still a lower bound for all tight walks. Hence
the same d is an attained distance in the tight graph.

For an original edge ab, the one-edge walk has length w(ab). Given the
attained original distance d(a,b), all-walk Tight(ab) is equivalent to
w(ab)=d(a,b): compare a tight edge with an attaining walk for one inequality,
and use the one-edge walk for the other. The reverse follows from the
universal lower bound. Thus the formal predicate is not an unrelated
stronger notion secretly substituted for the metric tightness predicate.

In a finite positive-weight graph, loop deletion and the finite nonempty
simple-path family supply the distance value for each reachable pair.
The above construction consequently preserves components and distances.
It does not assert that the tight subgraph of a disconnected graph is
connected. For the fixed H, deletion of at most two vertices leaves a core
clique and a surviving core neighbor for every remaining apex, supplying
connectedness and three-connectivity separately.

## 2. Exact source scope, not source-only root closure

TightWalk.lean defines endpoint-indexed inductive walks, append, additive
cost, all-walk minimality, tight relation, lift and forget. It provides proof
terms for shortest_head, shortest_tail, shortest_all_tight, lift_cost,
forget_cost, distance_value_to_tight and tight_iff_distance.

The Init-only CostSpec explicitly supplies zero/add/order, identities,
associativity, antisymmetry and the two order-cancellation implications.
Real addition and its usual order satisfy these fields. No distance
preservation, triangle inequality, cycle-space result, shortest-path
uniqueness, finite-mask success or q-certificate is a CostSpec field.
This is a generic algebraic theorem, not a claim that integer or rational
verification covers real weights. The actual Lean real-number instance
and positive finite shortest-walk construction are STILL separate source
integration obligations. They are not imported from a compiled C13 theorem.

All-walk quantification and the dependent endpoint types matter: replacing
an edge can create repeated vertices, but still creates a walk. Restricting
the competitor quantifier to an incomplete collection would invalidate the
head/tail cancellation argument. Positivity is used to obtain an attained
simple minimizer, not to infer uniqueness or strict inequalities at ties.

Countermodel to silently dropping cancellation: give a triangle edges
ab=2, ax=1, xb=1 and a pendant edge bt=10, with path cost defined as the
MAXIMUM edge cost rather than its SUM. Walk a-b-t is bottleneck-shortest
(cost10), yet edge ab is not tight, since a-x-b costs1. This does not defeat
the additive-real bridge: max is not order-cancellative. The distinguishing
calculation is included in semantic-check.json.

No Lean executable is available in this runtime. The file was not parsed,
elaborated, kernel replayed, or subjected to an actual #print axioms run.
Its source scan is not an axiom-closure audit. No generic theorem in this
file, even after future compilation, would alone close the positive-real
root statement. Earliest uncompleted integration: instantiate CostSpec with
real costs and prove the loop-erasure/finite-minimum witness in the SAME
Walk representation; then replay this bridge and its statement map.

## 3. Other real bridges: explicit dependencies, no fatal counterexample found

Fix the original H: core 0..3, apex y_i=7-i adjacent to the other three
core vertices. There are no apex-apex edges. All long simple cycles have
a core chord; the four core triangles isolate an apex on vertex deletion;
the twelve apex triangles are exactly peripheral. Peripheral always means
induced AND connected-or-empty VERTEX deletion in H, not in a tight subgraph.

B2. If e=uv is nontight, ANY shortest simple endpoint path P avoids e.
P plus e is a simple cycle; every pair of its vertices has its P-subpath
as a globally shortest cycle arc. Positivity and finite path minima supply
P and its simple/subpath properties. Arbitrary complementary paths would
not suffice. A chord does not remove this cycle from consideration.

SPLIT. A nongeodesic cycle has a path shorter than both endpoint arcs.
Split that path at successive visits to the cycle. If every segment were
at least the intrinsic cycle distance of its endpoints, the triangle
inequality would contradict the strict shortcut. Hence some segment Q,
with internal vertices outside the cycle, is shorter than both its arcs
A,B. The simple cycles A+Q and B+Q have XOR equal to the parent and both
are strictly shorter. If one arc is an edge, Q cannot be that same edge
by strictness, and a distinct one-edge path is excluded by graph simplicity;
thus the children really have at least three edges.

GEN. Induct on the number of simple cycles strictly shorter than a given
cycle. This natural number strictly decreases for each child in SPLIT.
The base and induction therefore express every cycle as an F2 sum of
geodesic cycles. Real numbers are not assumed well ordered; ties elsewhere
cause no problem. Splits inside T remain inside T, and geodesicity transfers
from T to H through the distance bridge.

DOM. Under the supposition that all H-geodesic cycles are peripheral, the
tight core F has no triangle. For j outside N_i=N_T(y_i), edge jy_i is
nontight. Its shortest complementary cycle from B2 must be a peripheral
triangle. The third vertex is in N_i and adjacent to j in F, proving CLOSED
domination of F-i, including its isolated vertices. GEN then forces
Z(T) contained in the actual triangle span. In particular beta(T)<=rank,
not merely an assumed equality of rank and number of generators.

FINITE LINK. For each necessary mask the frozen certificate supplies a
simple cycle c and a linear parity functional q which vanishes on every
triangle and takes value1 on c. Therefore the triangle span is proper.
For the ACTUAL real length vector, a minimum-length q-odd simple cycle
exists in this finite nonempty family. SPLIT would give a strictly smaller
q-odd child, contradiction. This produces a geodesic nontriangle of T,
hence a nonperipheral geodesic cycle in H. No rational sampling is the
reason that this argument covers all positive real vectors.

## 4. A replayer without the previous implementation core

check_dual.py reads the frozen C15 certificate and exact input vectors only;
it imports neither produce.py nor replay.py nor metric_checks.py.

It enumerates ALL 18-bit edge subsets. Connected degree-two subsets give
simple cycles; connected subsets with two degree-one vertices and all other
used vertices degree two give simple paths. This differs from both historical
DFS and vertex-permutation enumerations. It regenerates the entire necessary
mask set and each of the 64 core cases, comparing exact coverage, not counts.

For triangle rank it enumerates coefficient KERNEL relations among all
peripheral generators. Restricting those relations to each selected family
and applying rank-nullity gives its actual rank. It does not reuse bit Gaussian
elimination or count distinct generated vectors. Vertex-star relation kernels
likewise compute incidence rank, cross-checked against 8-cc on every mask.
Every q parity, outside simple cycle, row component count and actual rank
is checked. Complete H has 12 peripheral generators but rank11; its only
coefficient relations are the zero vector and the all-generator vector.

Bellman-Ford using Fraction is compared with minima over the new full
edge-subset path tables. ALL tied minimizing paths are checked for tightness;
all nontight complementary-path cycles are checked for geodesicity. The 36
frozen rational inputs are reproduced as inputs, not borrowed conclusions.
Their output cycles are recomputed, including the shortest q-odd choice.

Actual ordinary and optimized runs both returned0 with identical output.
Outputs: 239 cycles,2628 paths,12 peripheral cycles,64 core cases,41
triangle-free core cases,5913 necessary patterns. Actual rank gaps:
1:768,2:2752,3:2019,4:366,5:8. The 36 metrics contain185 tied pairs,
308 nontight complementary cycles,16 minimum-odd cases. Twelve changed
certificates were rejected; zero, negative, floating and Boolean metric inputs
were also rejected. These counts are OUTPUTS, never acceptance
constants. Both runs are still generator-side, not another trust domain.

An initial harness invocation evaluated the resource-limit callback in the
parent process before subprocess creation, causing MemoryError before the
checker ran. The wrapper was repaired to pass the callable; checker source
and mathematics were unchanged. Only the actual successful invocations
have checker exit0 recorded. No infrastructure failure is a counterexample.

## 5. Persistence and verification boundary

The 31 old original members are preserved by PR23. PR24 separately preserves
all27 remaining supplement/delivery objects, with the old inbox draft passive.
C14/PR22, C13 and T01-T03 are reused by digest, not overwritten or retransmitted.
The stored C15 certificate SHA256 is
48a348703814d06ac5ca6ef49a4c8005af1ea4452c5adb6b698025254838d14c.
Restore it and metric-report.json using the existing T01 decoder before:
  python -I -S check_dual.py ../opg500-a01-c15-rank-interface
No archived program must be executed to restore these inputs.

A matching registered root verifier, imported candidate identity, admitted
real/Lean toolchain fingerprint, actual axiom/escape and semantic receipts,
and trusted closure decision are not present. Do not invoke the unrelated
scalar SMT fixture. No new admission_request is needed or created here.
The existing C15 request remains the pending locator; these new source and
replay digests are a supplement, not a replacement attestation.

best_verified_result: none. best_verified_candidate: none.
root_status: open. first_formal_replay: TightWalk.lean, then real/minimum bridge.
