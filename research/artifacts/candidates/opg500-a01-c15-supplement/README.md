# C15 historical supplement: exact missing bytes

Verdict: candidate_only. This transaction preserves the previously supplied
55-entry research supplement plus its three delivery metadata files. Thirty-one
original member copies already match PR23 and are NOT stored again. The other
27 exact UTF-8 objects are archive members named in manifest.json, not separately
expanded repository files. No ZIP, patch, preview or old archive is uploaded.

The old inbox draft is a passive historical candidate member. Only
research/artifacts/web-inbox/opg500-a01-c15-supplement.packet.json is the current
packet. Historical checkpoint, unavailable-tool observations, and pending
verifier request describe their old event, not current state. No new admission
request is generated; preserving an old request does not execute it. Old numeric
checks are retained without replay in this transport transaction.

The separate original31 archive is pinned by manifest digest and PR23 merge in
this manifest. Its old relocated member path is recovered by the original31
historical disposition map; byte identity, not a shared C14 name, determines
reuse. PR22's different C14 and T01-T03 are unchanged.

From repository root, verify without executing any archived code:

    python research/artifacts/candidates/opg500-a01-transport-t01/unpack.py research/artifacts/candidates/opg500-a01-c15-supplement --repository-root .

Optional --output must be a fresh directory. Keep archived inbox drafts out of
active web-inbox when restoring. All new semantic replays and unelaborated Lean
source belong to a later separate packet. Transport/CI do not close mathematics.
