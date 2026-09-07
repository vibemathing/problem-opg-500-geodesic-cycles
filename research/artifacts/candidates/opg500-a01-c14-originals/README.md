# Original C14 attachment: preservation, not a second C14 theorem

Verdict: candidate_only. Issue: #3. Root remains open.

PR22 stores a distinct C14 implementation with four archived members and
89 rational cases / 22 mutations. This directory preserves all 31 original
files in the earlier attachment (96 rational cases / 19 mutations), with
451903 original UTF-8 bytes. No original is overwritten or silently replaced
by a later implementation. T01-T03 and PR22 are referenced, not retransmitted.

The manifest lists each original path, byte count and SHA-256. Member names
are archive names, NOT separately expanded repository paths. The source ZIP
itself is not uploaded. Concatenate the sixteen payload chunks, decode
base64 then XZ to obtain the exact path-to-text JSON object. The existing
T01 unpack.py validates each chunk/member and never executes member code:

    python research/artifacts/candidates/opg500-a01-transport-t01/unpack.py research/artifacts/candidates/opg500-a01-c14-originals --repository-root .

Use an optional fresh --output directory only; do not overwrite current C14
paths. In particular the archived packet-draft.json is historical, not a live
inbox packet. Only opg500-a01-c14-originals.packet.json binds this transaction.

Historical checkpoints, capability probes and pending flags describe the
original execution, not current main. Original generator-side logs are
preserved without mathematical replay or elevation to trusted evidence.
The recorded incompatible SMT-fixture attempt is historical and is not rerun.
A bounded byte/hash and decoding roundtrip was performed for this transport;
integrity-summary.json gives its precise scope. Future root reproof and actual
triangle-span-rank calculations belong to a separate immutable packet.
