# OPG-500 C02: external C-path reduction

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c02-excursions
Target: obligation:opg500-finite-linear-characterization
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Base: 188d5cc158fae50d4c2caa7f05c55b1c485f7d2e
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Scope, prior candidate and falsifier

G is a fixed finite simple undirected graph, C a simple cycle and all
edge lengths are positive real numbers. As in C01, graph connectivity
outside the component of C is irrelevant to this local lemma.
Only pairs of distinct cycle vertices are considered.

Candidate dependency:
research/artifacts/candidates/opg500-a01-c01-linear.md
SHA-256 e00b9f2518d3deb322ce00a5c1a9acd0dd1220f32d960a887a57a6abc60209d7.
It remains a candidate, not an admitted lemma or EvidenceLink.
The source-faithfulness note is
research/artifacts/source-notes/opg500-a01-c01-source.md.
This refinement changes only the finite comparison set, not the
definition of geodesicity or the root's quantifiers.

Cheapest attack: an induced triangle in K4 with a cheaper two-edge
route through the fourth vertex. This rules out checking only chords
or only pairs nonadjacent on C. The correct family below retains both.

## C02.1: the intrinsic cycle distance

For u,v in C define d_C(u,v) to be the smaller of the two arc lengths
when u!=v, and zero when u=v. This is the shortest-path distance in the
subgraph C: positive-length walks simplify, and its only simple u-v
paths are the two arcs. For any u,v,z in C, concatenate a shortest
u-v arc and a shortest v-z arc. It is a C-walk of length
d_C(u,v)+d_C(v,z), so
  d_C(u,z) <= d_C(u,v)+d_C(v,z).
This proves the triangle inequality used below from graph paths,
rather than adding a new assumption.

## C02.2: the smaller test family

Let S_C be the simple paths Q with two distinct endpoints u,v in C,
every internal vertex outside V(C), and Q not a single edge of C.
Thus S_C includes graph chords of C (one edge), and longer excursions
through outside vertices. It includes excursions between adjacent
vertices of C. Such paths need not be induced paths in G.

Claim:
  C is geodesic
  iff L(Q) >= d_C(u,v) for every Q in S_C with endpoints u,v.

Necessity: geodesicity gives dist_G(u,v)=d_C(u,v); Q is an available
graph path, so its length is at least this distance.

Sufficiency: take any simple x-y path P in G, with x,y in C.
List, in path order, every vertex where P meets C:
  x=v_0, v_1, ..., v_t=y.
These vertices are distinct because P is simple.
Split P at consecutive entries of this list. Each resulting segment
has no internal vertex on C. It is either a single C-edge or belongs
to S_C. A C-edge has length at least d_C of its endpoints by C02.1;
a segment in S_C has that lower bound by hypothesis.
Therefore
  L(P) >= sum_{j=1}^t d_C(v_{j-1},v_j) >= d_C(x,y).
By C01's shortest-path reduction the same lower bound holds for every
walk. The shorter x-y arc in C attains d_C(x,y), so it is shortest in G.
This holds for all pairs, proving sufficiency.

## C02.3: extract a localized strict witness

Given a simple x-y path P with L(P)<d_C(x,y), apply the same splitting.
If every segment had length at least its intrinsic endpoint distance,
the inequalities above would contradict L(P)<d_C(x,y).
Hence some segment Q satisfies
  L(Q)<d_C(u,v)=min(L(A_uv),L(B_uv)).
A single C-edge cannot satisfy this. Thus Q is in S_C and is strictly
shorter than BOTH u-v arcs.

The endpoints u,v of the extracted witness need not equal the original
x,y. A consumer must attach each atom to the arcs of its own endpoints,
not compare every segment with the original x-y arcs.

Conversely any such Q is itself a common-path witness of
non-geodesicity. Consequently C is non-geodesic exactly when
  OR_{Q in S_C} [
    (chi_Q-chi_Aend(Q)) dot w < 0
    AND (chi_Q-chi_Bend(Q)) dot w < 0
  ].
The implicit domain here is w>0.

## C02.4: finite Boolean linear encoding and size

Within positive lengths the reduced geodesic formula is
  AND_{Q in S_C} [
    (chi_Aend(Q)-chi_Q) dot w <= 0
    OR (chi_Bend(Q)-chi_Q) dot w <= 0
  ].
Attach AND_e(w_e>0) to obtain the full-domain formula. C02.2 proves
soundness and completeness with respect to C01's all-simple-path formula.
No strict inequality replaces a weak comparison in this formula.

Let m=|V(G)\V(C)| and k=|V(C)|. For a fixed unordered endpoint pair,
every Q in S_C has j distinct intermediate vertices chosen in order
from the m outside vertices, where 0<=j<=m. Hence the number of paths
for that pair is at most
  sum_{j=0}^m m!/(m-j)!.
For j=0 include a path only if the endpoints are joined by a non-C edge.
Multiplying by k(k-1)/2 bounds |S_C|. This replaces n-2 in C01's
per-pair permutation bound by m. It is a genuine finite reduction,
not a polynomial-time claim.

All paths in S_C use no C-edge: any such edge has both endpoints on C,
which would contradict internal avoidance unless Q were a single C-edge.
That one excluded case already satisfies its comparison automatically.

If S_C is empty, its conjunction is true and the empty disjunction of
strict witnesses is false. This correctly says C is geodesic, including
G=C with any positive edge lengths. Do not reject an empty test family.

## Exact hand attacks, not executed tests

A. G=K4, C=(0,1,2,0). Set all triangle edges to 1 and each edge
from vertex 3 to the triangle to 1/4.
Q=(0,3,1) has length 1/2; its two C-arcs have lengths 1 and 2.
It belongs to S_C and is a strict witness.
The triangle has no chords and every pair on it is adjacent, so either
'chords only' or 'nonadjacent endpoint pairs only' would falsely pass it.
Q is not an induced path because 01 is an edge; induced-path-only
enumeration would also miss this witness.

B. G=K4, C=(0,1,2,3,0), cycle edges 1 and both diagonals 2.
S_C consists of the two diagonals; each ties both corresponding arcs
at 2. The reduced weak formula passes, agreeing with C01.

C. Change the 02 diagonal of B to length 1.
One two-inequality strict branch is satisfied: 1<2 and 1<2.
The reduced formula fails, agreeing with C01.

D. G=C, including a cycle with a very long single edge.
S_C is empty. The cycle is nevertheless geodesic because graph paths
are precisely its own arcs after walk simplification. It is incorrect
to assume every individual C-edge is shortest in G.

## Candidate enumeration and verification request

For each sorted distinct pair u,v of C:
- include edge uv only when uv is in E(G)\E(C);
- enumerate ALL ordered sequences of distinct outside vertices of length
  <=m, in deterministic lexicographic output order; do not require the
  vertices within a sequence to be increasing;
- retain exactly sequences u,...,v whose successive edges exist;
- attach the two actual u-v C-arcs and their edge incidence vectors.

Every retained object meets the S_C definition; conversely the
intermediate vertex sequence of every S_C path occurs in this
enumeration. This is the completeness argument for the candidate
enumerator, not a claim that an implementation has run.

A first authorized replay can compare C01 and C02 on n<=6 graphs,
one graph at a time, <=100000 atoms, 60 seconds, one thread, 256 MiB
and 1 MiB output. Exact rational test inputs A--D are sufficient to
attack the three listed incomplete test families. A timeout is not a
mathematical counterexample. No graph solver or kernel ran here.

## Checkpoint

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
failed_mutations: chords-only; nonadjacent-pairs-only; induced-path-only;
rejecting an empty external test family.
next_action: replace factorial path constraints by linear vertex
potentials with an attainment branch, and prove both projection directions.
The graph-to-formula bridge still needs authorized verification.
