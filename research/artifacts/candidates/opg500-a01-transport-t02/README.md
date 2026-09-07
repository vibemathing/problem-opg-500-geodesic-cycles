# Historical research transport archive

Verdict: candidate_only. This change only transports existing chat artifacts.
No new mathematical derivation, graph search, Lean build or SMT replay occurred.
The original UTF-8 files are stored losslessly as archive members, NOT as
separately expanded repository paths. manifest.json records every original
path, byte count, SHA-256 and any existing-repository alias. The payload chunks
contain actual file contents, not merely hashes or instructions to recompute.

Historical checkpoint fields, runtime observations and candidate conclusions
inside the archive remain historical and unverified where originally marked.
They do not override current main, Issue state, schemas or verifier records.
Transport and the three required checks cannot close either mathematical
obligation. Distinct implementations/output tables are retained even where
later candidates cover a similar theorem. Exact duplicate files are aliases.

The decoder is in ../opg500-a01-transport-t01/unpack.py. From repository root:

    python -S research/artifacts/candidates/opg500-a01-transport-t01/unpack.py ARCHIVE_DIRECTORY --repository-root .

This verifies all chunk and member hashes without executing any member code.
An optional --output NEW_DIRECTORY restores bytes only into a fresh directory.
The archive members were inspected and privacy-scanned before compression;
encoding is not used to hide prohibited content. Only UTF-8 candidate paths
are materialized. Original filenames and historical labels are not normalized.

The source ZIP and patch are distribution wrappers. Their contents, rather
than a second binary wrapper, are retained. integrity.json describes only the
observed transport decoding check; it is not a mathematical execution receipt.
