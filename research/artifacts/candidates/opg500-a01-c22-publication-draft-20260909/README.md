# OPG-500 publication review draft

Status: `candidate_only`; public review material; not a governed Result or a peer-reviewed publication.

This bundle publishes the text sources and reproducibility records for the conventional presentation of the fixed eight-vertex OPG-500 counterexample already frozen in C21. It does not alter the accepted Lean proof or the C21 packet.

## Main reading paths

- English manuscript source: [`paper/main.tex`](paper/main.tex)
- Chinese technical exposition: [`paper-zh/exposition.md`](paper-zh/exposition.md)
- Paper-to-Lean declaration map: [`formal/paper-lean-crosswalk.csv`](formal/paper-lean-crosswalk.csv)
- Exact replay record: [`formal/replay-receipt.json`](formal/replay-receipt.json)
- Axiom report: [`formal/axiom-audit.txt`](formal/axiom-audit.txt)
- Escape audit: [`formal/escape-audit.json`](formal/escape-audit.json)
- Statement comparison: [`evidence/statement-faithfulness.md`](evidence/statement-faithfulness.md)
- Claim ledger: [`evidence/claim-ledger.json`](evidence/claim-ledger.json)
- Remaining review and admission work: [`review/unresolved-items.md`](review/unresolved-items.md)

The immutable accepted sources and standalone Lean replay project remain in [`../opg500-a01-c21-prove2me-root-replay/`](../opg500-a01-c21-prove2me-root-replay/).

## Exact scope

The manuscript presents a fixed finite simple 3-connected graph on eight vertices and eighteen edges. For every strictly positive real edge weighting, the accepted theorem asserts the existence of a geodesic nonperipheral cycle. Under the audited canonical formulation, this is a negative answer to OPG-500.

The exact replay record uses Lean 4.33.1 and Mathlib commit `0df444a360eaa60ab8c11dca51a86af692955474`; all five recorded target modules exited successfully. The reported root axiom set is `[propext, Classical.choice, Quot.sound]`, so this bundle does not describe the theorem as axiom-free.

## Publication boundary

The repository candidate gate accepts UTF-8 text artifacts only. Therefore this candidate transaction publishes the TeX/Markdown sources, deterministic build logs, PDF metadata, and font reports, but not binary PDF files. The sources reproduce a 10-page English draft and a 2-page Chinese draft in the recorded build environment.

Author names, affiliations, disclosure wording, rights, venue choices, conventional external peer review, independent trusted statement review, and repository Result admission remain pending. No minimality or priority claim is made.

`PUBLICATION_MANIFEST.json` and `SHA256SUMS.txt` bind every file in this bundle. Transport through an Issue, PR, checks, and merge remains transport evidence only.
