# C14: root counterexample, four-bridge audit and finite certificate interface

Status: RESULT_CANDIDATE_READY / root-counterexample-proof-drafted.
Verdict: candidate_only. Primary owner: math-proof.
Repository: vibemathing/problem-opg-500-geodesic-cycles.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1. Target: obligation:opg500-root.
Base: b57bdd07a0a53c97685190c2e713bb7fb75ada55.
ProblemContract SHA-256: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## 0. Exact claim, provenance and assurance

Let B={0,1,2,3}. The fixed graph H has vertex set {0,...,7}, core K4 on B,
and four pairwise nonadjacent vertices y_i=7-i with N_H(y_i)=B minus {i}.
Claim: for EVERY l:E(H)->R_{>0}, SOME simple cycle of H is l-geodesic
and is not peripheral IN H. This is the quantified negation at a specific
graph of the repository's existential-length root statement.

Canonical sorted edge order:
01 02 03 04 05 06 12 13 14 15 17 23 24 26 27 35 36 37.
All paths/walks below are finite and undirected. A simple cycle has at least
three distinct vertices with a closing edge; it need not be induced.
A cycle is geodesic when for every distinct pair of its vertices at least
one cycle arc attains H-distance. Peripheral means induced AND deleting
its vertices leaves a connected or empty graph. The diagonal is 0=0.

The earlier T02 member proof uses p_i=4+i instead. Its exact isomorphism to
these labels fixes B and sends each apex v to 11-v. Edge vectors are
permuted by that map; no historical vector is reinterpreted without it.
The T02/T03 original manifests and member hashes were checked and reused;
none of their original content is being retransmitted. C10's all-ties
argument is the proof under audit, not C09's different perturbation CNF.
C13 provides the local shortest-path reduction, not a root admission.

This audit is by the current generator, not a second trusted principal.
No new Lean source, kernel success, axiom receipt, EvidenceLink or Result
is asserted. Tests and certificate validation have the precise finite
scope below. The universal real-weight conclusion rests on G0--R below.

## G0. Fixed graph, simplicity and connectivity

Every edge in the displayed list joins distinct vertices, occurs once,
and is prescribed by the construction. Thus H is finite and simple.
Delete a set S of at most two vertices. At least two core vertices remain;
they are pairwise adjacent. Any surviving y_i has three core neighbors
before deletion, so at least one survives. Hence all remaining vertices
are connected to the remaining core clique. H is 3-connected (and has at
least four vertices). No planar drawing or numerical weight is used.

The exact checker independently reconstructs the displayed graph from
its construction, enumerates vertex-simple cycles by both DFS and vertex
permutations, and emits spanning-tree witnesses for every such deletion.
Its acceptance does not assume the expected number of cycles or deletions.

## G1. Complete peripheral classification

Every cycle of length at least four has a chord. With at least three core
vertices it contains a nonconsecutive core pair: a cycle of length at least
four cannot have three positions that are pairwise consecutive. The edge
joining that pair is a chord. With exactly two core vertices, independence
of the apices forces an alternating four-cycle, whose core edge is a chord.
With fewer core vertices there is no cycle. This covers spanning cycles
as well: empty vertex complement never removes a chord obstruction.

The triangles have either three core vertices or two core vertices and one
apex. A core triangle B minus {i} is not peripheral: its deletion isolates
y_i while leaving i and the other three apices in a nonempty component.
A triangle {y_i,j,k}, j,k in B minus {i}, is peripheral: two adjacent core
vertices remain, and every surviving apex has a neighbor among those two.
There is no triangle with two apices. Thus exactly these twelve apex
triangles are peripheral. Connected deletion alone is not sufficient.

## B1. Tight-edge subgraph preserves distances (C10 T1; T02 section 2)

Fix one arbitrary positive real vector l, and let d=d_H. The finite local
reduction gives attained simple shortest paths. Let T be the SPANNING
subgraph consisting of edges uv with l(uv)=d(u,v).

Every edge on every shortest path P is tight. If an edge were nontight,
replace it with a shorter endpoint path. The resulting walk has the same
endpoints as P and strictly smaller length. Deleting closed subwalks gives
a no-longer simple path, contradicting the minimality of P. This argument
does not require the replacement walk itself to be simple, nor uniqueness
of any shortest path. It covers ALL tied minimizers, not only one selected
by an implementation.

For each pair u,v in H a shortest H-path is consequently contained in T,
so d_T(u,v)<=d_H(u,v). Inclusion T subset H gives the reverse inequality.
Thus T is connected and d_T=d_H. Its vertex set remains all eight vertices.

Scope repair: T is not connected for an arbitrary DISCONNECTED positive
weighted graph. The general lemma preserves connected components and the
distances within each component. H is connected by G0. T02's introductory
unqualified connectedness sentence is read with this required premise;
it is not a failure of this fixed-H proof. The general rank formula is
m-n+cc, and m-7 is used for this connected T only.

## B2. A nontight edge plus any shortest complementary path is geodesic

(C10 T2; T02 section 2.) Let e=uv be nontight and choose ANY shortest
u-v path P. Then L(P)=d(u,v)<l(e). P is simple. It cannot use e: in a
simple path between u and v containing uv, that edge already joins the
endpoints; alternatively its positive length alone exceeds L(P).
Every edge of P is tight by B1. Because H is simple, P has at least two
edges, so P together with e is a simple cycle of length at least three.

Any pair a,b of its cycle vertices lies on P. The P-subpath between them
is globally shortest: replacing a shorter subpath would give a shorter
u-v walk, then a shorter u-v path. That subpath is one of the two arcs
of P union e. Therefore the cycle is geodesic, regardless of ties and
regardless of chords. The OTHER arc is not required to be shortest.

The statement uses shortest P, not an arbitrary complementary path and
not an arbitrary shortest WALK under zero weights. Strict positivity
ensures deletion of a nonempty repeated portion strictly reduces length.
With zero lengths a simple minimizer can still exist, but not every
minimizing walk is simple. Zero/negative inputs are outside this claim.

## B3. Geodesic cycles generate the binary cycle space

(C10 T3; T02 section 3; GS section 3.1, Theorem 3.1.) Here the finite graph
K may be disconnected; work within the component containing a cycle.
The binary cycle space is the span of simple-cycle edge incidence vectors
in F2^{E(K)}. Equivalently it is the even-degree edge-subset space: every
nonempty even-degree edge set contains a simple cycle, which can be removed
by XOR, reducing its edge count; iteration gives a finite cycle sum.

Let C be non-geodesic. Some x,y on C have a shortest
simple K-path P with L(P)<d_C(x,y). Split P at consecutive visits to C.
If every segment had length at least the intrinsic C-distance between
its endpoints, add these inequalities and use the triangle inequality
for d_C to obtain L(P)>=d_C(x,y), a contradiction.

One segment Q is therefore strictly shorter than d_C of its endpoints,
and hence strictly shorter than BOTH arcs A,B on C. Its endpoints are
distinct because P is simple; its internal vertices avoid C. It cannot
be an edge of C, since that edge is an available intrinsic C-path. Thus
Q is edge-disjoint from C, and A union Q and B union Q are simple cycles
of length at least three, not closed walks or two-edge artifacts.

Their incidence vectors XOR to chi_C. Moreover
  L(A union Q)=L(A)+L(Q)<L(A)+L(B)=L(C),
  L(B union Q)=L(B)+L(Q)<L(C).
Every non-geodesic cycle is the sum of TWO strictly shorter simple cycles.
Induct over the finitely many cycle lengths: a minimal counterexample
to generation has two shorter children which both have the desired
representation, a contradiction. Equivalently the number of cycles of
length <= the current length strictly decreases along a chosen shorter
child. No well-ordering of all positive reals, fixed decrease size, or
unique length is assumed. Ties outside the strict descent are harmless.

For T, the entire argument is made INSIDE T. Hence the shortest path and
both children lie in T. By B1 every T-geodesic cycle is H-geodesic.
One must still test peripheral in H, not in T: equality of distances
is not equality of inducedness or of deletion connectivity.

The graph-independent proof above is self-contained. The freshly read GS
Theorem 3.1 supplies an exact finite-weight source match, not a theorem
about only unit-weight isometric cycles or only infinite topological ones.

## B4. Necessary domination and dimension inequality

(C10 T4; T02 section 4.) Suppose for contradiction every H-geodesic cycle
is H-peripheral. Put F=T[B], f=|E(F)| and N_i=N_T(y_i) subset B minus {i}.

F has no triangle. Three tight core edges give a geodesic core triangle,
contradicting G1. For j!=i, if y_i j is tight, j lies in N_i. If not,
B2 constructs a geodesic cycle from that edge and any shortest endpoint
path. Under the supposition and G1 it must be {y_i,j,k}. The other two
edges are tight, so k lies in N_i and jk lies in F.

Thus N_i is a CLOSED dominating set of F-i: for every j!=i either j is
in N_i or some k in N_i has jk in F. All vertices of F-i, including
isolated ones, are tested. In particular N_i is nonempty and intersects
each component of F-i. This implication uses the root supposition; it is
not asserted for arbitrary input weights unconditionally.

Write n_i=|N_i|, e_i=|E(F[N_i])| and c_i=cc(F[N_i]). Triangle-free F[N_i]
has at most three vertices and is a forest, so e_i=n_i-c_i. All triangles
of T contain exactly one apex, hence their NUMBER is tau(T)=sum_i e_i.
Since T is connected on eight vertices, beta(T)=f+sum_i n_i-7.

For completeness, the dimension formula follows from a spanning forest:
for each nontree edge its fundamental cycle has a unique nontree pivot.
These cycles are linearly independent. Removing all nontree coordinates
from any even subgraph leaves an even subgraph of a forest, necessarily
empty by leaf deletion. They span and their number is m-n+cc.

By B3 and B1 the cycle space of T is generated by H-peripheral cycles
contained in T, and by G1 these are a subset of its triangles. Therefore
  beta(T) <= dim(span(T-triangles)) <= tau(T),
which is exactly
  f+sum_i c_i-7 <= 0.                                      (R)
No independence of triangles is assumed. In H itself the twelve peripheral
triangles have rank eleven, so equality of count and rank is false.

## R. Every necessary tight pattern contradicts (R)

A triangle-free graph on four vertices is a forest or C4. If it contains
a cycle, that cycle must be a spanning four-cycle and an additional edge
would be a triangle-producing chord. This proves the dichotomy exhaustively.

For C4, f=4 and every c_i>=1, giving f+sum c_i-7>=1.
For a forest, set c=cc(F)=4-f and d_i=deg_F(i). Removing i gives
cc(F-i)=c+d_i-1, including when i is isolated. Domination forces
c_i>=cc(F-i), because different components cannot become connected by
taking an induced subgraph on N_i. Sum d_i=2f to obtain
  f+sum_i c_i-7 >=3f+4c-11=5-f>=2.
Both cases contradict (R). The chosen l was arbitrary. Hence EVERY
positive real vector on H admits a nonperipheral geodesic cycle.
This is the universal candidate proof, not inference from tested vectors.

## Finite certificate interface and real-weight soundness bridge

certificate.json contains the exact graph; all simple cycles with chord
lists and vertex-complement components; every zero/one/two-vertex deletion
spanning tree; all 64 core cases; the sorted eligible 18-bit tight masks
in a bounded lossless XZ/base64 array; and symbolic split identities.
The bit position for an edge is its position in the displayed edge order.
The mask payload decodes to concatenated unsigned three-byte big-endian
integers. Its SHA-256 and size are checked before coverage/rank checking.
It is DATA, not executable code and not a root-SMT proof artifact.

Verifier obligation: independently enumerate every mask t in {0,1}^18;
reject those with a core triangle or failed closed domination. For every
remaining mask recompute components, incidence rank, triangle count and
triangle rank. Verify beta>tau and the stronger m-7>tau. Require exact
set equality between these masks and the decoded certificate, not just
cardinality equality. Missing a case and updating its hash must fail.

B1--B4 map every hypothetical real solution to a mask that would have
beta<=tau, while this finite interface excludes every such mask. It is
not necessary to assume every boolean pattern is metrically realizable.
In this run all eligible masks happened to be connected; the proof never
replaces B1 by that observation. For other disconnected patterns the
checker separately verifies beta=m-n+cc rather than silently using m-7.

Actual regeneration uses (a) 64 core masks plus cartesian products of
closed dominating subsets and (b) all 262144 edge masks with adjacency
closure. Neither imports historical producers, nor uses expected 41 or
5913 as an acceptance oracle. It obtained 41 and 5913, with positive gaps
1:768, 2:2752, 3:2019, 4:366, 5:8. Actual incidence-matrix and triangle-span
ranks are recomputed for every eligible mask. Full rows are reproducibly
hashed; the actual mask array, not just its hash, is stored.

All 4770 external-path splits in H were checked symbolically for two
simple children, edge XOR and exact integer length-row identities. This
includes peripheral and chorded parents. Every subgraph containing parent
and Q necessarily contains both children; a non-geodesic T-cycle obtains
Q in T from B3. Thus the finite table is not silently restricted to H
paths when reasoning about T.

## Executed property tests, attacks, and limitations

89 exact rational vectors cover unit and five core/spoke ratios, 32 seeded
rational samples, near ties at denominators 2^20,2^60,2^100 on both sides,
single-edge perturbations, positive scales 2^-80,7/13,2^80, and all 24 core
relabelings. All simple paths are cross-checked against permutation tables.
Floyd distances are independently compared with exact all-path minima;
ALL tied shortest paths are checked for tightness. Every nontight edge
is checked with every minimizing complementary path. Geodesic-cycle span
ranks are tested in both H and T. Each non-geodesic cycle has a concrete
strict two-child split; membership inheritance to T is checked explicitly.

Observed: 21271 cycle predicates, 2492 endpoint distance tests, 684 nontight
edge/shortest-path cycle checks, 19850 strict splits (2719 inside T), and
473 tied endpoint pairs. These are finite tests, not coverage of all real
vectors. The all-real part is the proof above.

22 mutations include graph/adjacency corruption, a missing peripheral
triangle, zero/negative/float input, induced-only enumeration, generator
count mistaken for rank, both wrong domination conventions, uniqueness
assumptions, arbitrary complementary paths, ties treated as strict
shortcuts, the wrong ambient graph, edge versus vertex deletion, the
connected rank formula on disconnected data, weak descent, set union
instead of XOR, requiring both arcs shortest, and rehashed missing cases.
Each has an explicit rejected input or a computed distinguishing witness
in results.json. A killed mutation is not a failed admitted route.

Storage and replay: audit.py, certificate.json, results.json and execution.json
are the FOUR actual UTF-8 members of this new C14 text archive. They are not
separately expanded repository paths. No historical T01--T03 member is copied.
The plain proof and admission request refer to those member names. From the
repository root, restore into a NEW directory using the existing safe decoder:

    python research/artifacts/candidates/opg500-a01-transport-t01/unpack.py research/artifacts/candidates/opg500-a01-c14-root-audit --output replay-c14

Then change into replay-c14/research/artifacts/candidates/opg500-a01-c14-root-audit
and run python -I -S audit.py --check. The stored code bytes are exactly those
bound to the actual execution record; restoration alone never executes them. The --emit mode
regenerates certificate.json and results.json; default mode does not run.
The certificate reader enforces bounded decompression. Loops are finite;
the internal wall cap is 34 seconds. Actual invocations use one process,
40 seconds wall, 36 CPU seconds, 256 MiB address space and 1 MiB output.
All successful replay claims are bound to the final code digest in
execution.json. One initial JSON-key normalization error is retained as
an implementation diagnostic, not a mathematical counterexample.

## Admission request and stop boundary

No counterexample to B1--B4 or the root candidate was found in this audit.
The general connectedness wording was corrected as described in B1.
The admitted local and root records still require kernel_check,
axiom_escape_audit and statement_faithfulness. C13 readiness is not an
EvidenceLink. Current candidate-artifacts.jsonl is empty; the registered
Lean adapter first requires an imported candidate and admitted toolchain.
The runtime has no Lean/lake/elan executable. The registered SymPy SMT
adapter accepts a different hard-coded scalar fixture, not this statement.
Calling that fixture would not check the root, so no success is borrowed.

admission-request.json pins this candidate and requests the trusted
importer/verifier/closure flow approved by the user. It does not create a
principal, whitelist, ledger record or receipt. A compiled small CNF slice
alone would not discharge B1--B4. Until the appropriate real root receipts
exist, both obligations remain open in trusted state.
