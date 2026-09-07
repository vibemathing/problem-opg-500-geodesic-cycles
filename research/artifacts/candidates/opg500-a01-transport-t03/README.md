# T03: historical resolution supplement transport

Verdict: candidate_only. Issue: #3. No new mathematical research or replay.

This directory preserves the frozen 29-entry supplement: 27 distinct original
UTF-8 files in the lossless text payload and two byte-identical aliases to
existing C09 files. `manifest.json` retains every original path, byte count,
SHA-256 and storage disposition. Original paths are archive-member names,
NOT additional separately expanded repository files. No original ZIP, patch,
preview image or duplicated wrapper is stored here.

`delivery.json` is the unchanged historical delivery record. Its old base and
false write/Issue flags describe that historical event, not this transport.
Likewise the archived packet draft and checkpoint are historical objects;
only the new T03 packet in web-inbox binds the current PR. Historical execution
claims are preserved, not replayed or upgraded. Lean/SMT items lacking replay
remain pending/unverified. CI and merge confer no mathematical assurance.

`disposition-map.tsv` maps all 64 original files across T01/T02/T03. An archive
row is located by its batch manifest plus the original member path. An alias
row names the exact existing canonical file. `delivery-metadata.json` records
wrapper exclusions, the separate delivery record, and completed T01/T02
associations. Final live refs/checks/merge and remaining-work state belong to
the final checkpoint on Issue #3, not to these historical member files.

For byte-integrity verification only, from repository root:

    python research/artifacts/candidates/opg500-a01-transport-t01/unpack.py research/artifacts/candidates/opg500-a01-transport-t03 --repository-root .

The already-stored decoder verifies all chunks, decoded member hashes and
canonical aliases; it does not execute member code. Optional --output must
name a fresh directory. Do not overwrite or stage the historical packet draft
as a current inbox packet.
