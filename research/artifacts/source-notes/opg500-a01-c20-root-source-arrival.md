# Late fresh-state source note: C21 root arrival during PR28 checks

verdict=candidate_only; best_verified_result=none.
Observed main: 5b9021bf308a25994ee73bfc869f12aaf5644900.
Only repository: vibemathing/problem-opg-500-geodesic-cycles.

The initial C20 source generation did not have the literal external root
source. That historical limitation is no longer the current read state.
During final-head checks, main advanced by the C21 publication. This caused
the old-base diff gate to see two packets in the synthetic merge tree.
PR28 is being fast-forward synchronized through the GitHub-created merge
commit e54ceff42644af88588b4b173a6d323a26782870 (parents: new main and
ed6fe1d6e7f1d0f7a0befe64c9efb3b7ece48ca0), with force=false. Its own sole
packet base is updated; the C21 packet/source is neither removed nor changed.

Fresh-read actual files under opg500-a01-c21-prove2me-root-replay:
- replay/Definitions/Def_opg500_weighted_cycle_models.lean
  SHA256 dad1aeb2bfcc9d6eeb0c2cb884574c914a7c5c68fef7cccff6a2cd8d996b166a
- replay/Theorems/Thm_OPG500Counterexample_eight_vertex_counterexample.lean
  SHA256 f70767b732b7b97cff3acafeacb862441a77dc2076821ed7ff3493733a21279e
- replay-receipt.json
  SHA256 d9581521fef7da52ddf2629ba5b4244df545dca263e0b89462e3ac566eb35179
These SHA256 identities are from the freshly read C21 packet; this note
records source inspection, not a fresh independent whole-file hash replay.

Actual Cycle fields are base, native closed Walk, and Walk.IsCycle, matching
the structural shape of C19 CycleView. EdgeWeight maps the graph edge subtype
to real numbers; IsPositive quantifies strict positivity on actual edges.
WeightedLength sums the attached edge list, with multiplicity. IsShortest
requires IsPath and compares all simple competing walks. IsGeodesic requires,
for each two cycle vertices including the diagonal, a shortest simple path
whose edgeSet lies inside that of the cycle. IsPeripheral is IsChordless and
empty-or-connected vertex deletion. This is not a read of an obsolete stub.

The root theorem body was read near the end of the published file:
IsThreeConnected H AND forall positive EdgeWeight H, exists Cycle H,
IsGeodesic AND NOT IsPeripheral. It calls the published tight-graph,
finite-geodesic-generation and core-link/rank results; a proof body is present.

C21's archived receipt reports five module exits0 under Lean4.33.1/Mathlib
0df444a360eaa60ab8c11dca51a86af692955474, with propext, Classical.choice and
Quot.sound, and an accepted external root state. Its own repository admission
field is pending_governed_ingestion. These are read claims from another
candidate publication, NOT executions performed by this review or a trusted
gate success. C20Review still has no compiler run in either exact profile.

The semantic adapter now has concrete targets: native CycleView/Cycle
bijection; attached-edge versus extended-weight sum identity; parity-count
versus cycle membership indicator; and VertexGeodesic iff Cycle.IsGeodesic.
The last equivalence needs the two-simple-arcs classification on the actual
cycle edge subgraph and positive erasure. Do not identify this with the
induced vertex subgraph when chords exist. No root is renamed or weakened.

Next root assurance should inspect/replay the now-present C21 exact sources,
then apply actual registered trust and closure gates; do not continue calling
the root merely an unavailable Open/sorry source. This new read state does
not turn the uncompiled C20 alternative into native or independent evidence.
