# C19: real circle arcs and a derived intrinsic metric

`verdict=candidate_only`; `best_verified_result=none`; `NONTERMINAL_CHECKPOINT`.
Only vibemathing/problem-opg-500-geodesic-cycles. Base df9fb18cf6d4f3e4836bbb6e86be77995abcdcf5.
Attempt/Route/Graph: attempt:web-20260906-opg500-a01 / route:geodesic-linear-encoding-v1 /
graph:opg500-initial-v1. Target obligation:opg500-root, B3 atomic slice only.

## What is new

Four NEW Lean modules contain explicit source bodies. CircularMetric derives the
circle triangle inequality by four exact linear min branches and six line-order
cases. PrefixRecut proves positive cumulative-coordinate bounds and cost formulae
for actual ordered list slices in both endpoint orders. NativeArcs wraps a genuine
Mathlib Walk.IsCycle, constructs rotate/takeUntil/dropUntil.reverse arcs, and derives
pathness, edge partition, endpoint-only support intersection and total length.
NativeExternal supplies structural native/C16 Walk conversions and instantiates
C18's external-factor metric laws with the newly derived coordinate metric.
No internal-disjointness or simple-child witness is a field of the cycle wrapper.

The complete paper proof derives the native prefix/recut index relation, strict
externality (including the one-edge exception), genuine >=3-vertex simple children,
strict weighted descent and INTEGER child0+child1=parent+2*Q. It composes this B3
argument directly with a minimum cycle outside the triangle span. No forest/C4
tail or 5913-pattern enumeration was undertaken before this slice's formal gap.

## Explicit remaining boundary

ALL NEW LEAN IS UNCOMPILED. The first missing native proof body is
native_recut_prefix_distance: equality of the constructed native arc minimum and
the prefix-coordinate metric. Its exact typed target and idxOf/block proof are in
porting-guide.md/proof.md; it is not an axiom, stub or input hypothesis of a claimed
full B3 theorem. NativeExternal starts with a coordinate-metric strict inequality,
not yet the unconditionally connected native nongeodesic predicate. Native child,
incidence and outside-span assembly still require elaboration after that identity.
The literal external root declaration remains unavailable; the repo root has
formal_declaration=null. No same-name weaker root theorem was declared.

## Actual new exact checks

23 graph fixtures; 449 ordered circle pairs; 2139 circle triangle checks; 58 strict
competitor certificates (41 multi-visit; one positive-loop erasure); 592 recut/
reversal replays. A second implementation imports no producer: it reconstructs
circle paths and small cycle families from edge subsets, uses Floyd distances,
and checks four symbolic real-linear branches and all certificate rows. It rejects
23 mutations. Five small outside-span audits have three nonempty minimum families,
and each selected minimum is geodesic. Counts are outputs, not target-pass criteria.
All three final-source runs (construct, verify, verify -O) returned0 on Python3.13.5.
These are generator-side finite tests, not a different trust domain or all-real proof.

## Storage and reuse

The manifest/chunks preserve exactly twenty NEW logical text members by SHA256.
They are archive members, NOT separately expanded GitHub paths. Decode with the
already-stored T01 unpack.py; decoding never executes code. Old C16-C18 dependency
sources, PR23-27, T01-T03 and the 5913-row certificates are reused, not retransmitted.
A bounded replay driver records actual executable probes, source hashes, time/memory
limits and output hashes. No Lean executable or native run/axiom output was obtained;
a release-download attempt also failed. No registered adapter, admission_request,
EvidenceLink, Result, Solution or trusted closure was fabricated. Final PR/check/merge
and per-file receipts are appended to the existing Issue #3.
