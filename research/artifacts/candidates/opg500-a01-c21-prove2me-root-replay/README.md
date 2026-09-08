# OPG-500 Prove2Me accepted-root publication and replay bundle

Status: `candidate_only` for this repository's admission system.

This bundle publishes the source and reproducibility material behind the Prove2Me root theorem state reported on 2026-09-08. Publishing these files does not itself create an EvidenceLink, Result, or Solution View. Those remain trusted-admission operations.

## External theorem identity

- Mission: `b72b3a1f-71d5-4490-b5fc-854f39ae8beb`
- Root theorem: `OPG500Counterexample.eight_vertex_counterexample`
- Theorem ID: `5c4997cd-9945-4028-b853-4ad91c324535`
- Accepted submission ID: `ed7c185a-9a49-4ded-90af-24839db25038`
- Reported theorem state: `Proved`
- Reported submission state: `ACCEPTED`
- Reported open leaves: `0`

`accepted/` contains the exact five accepted solution source files downloaded from Prove2Me. Their byte hashes are recorded in `manifest.json` and `replay-receipt.json`.

## Replay material

`replay/` is a standalone Lean project overlay containing:

- the two OPG-500 definition modules;
- the four accepted dependency theorem modules;
- the accepted root theorem module;
- exact Lean and Mathlib pins.

The replay copies each accepted `solution` declaration to its canonical theorem name. For four modules it also adds a final `#print axioms`; the graph-structure source already contained an axiom print and its target name was changed with the theorem name. No mathematical body is changed. The exact accepted and replay hashes are both recorded.

Reproduce from a fresh directory by copying the contents of `replay/` to that directory, then run:

```bash
lake update
lake build Theorems.Thm_OPG500Counterexample_eight_vertex_graph_structure
lake build Theorems.Thm_OPG500Counterexample_tight_edge_metric_bridge
lake build Theorems.Thm_OPG500Counterexample_core_link_rank_gap
lake build Theorems.Thm_OPG500Counterexample_finite_geodesic_cycles_generate
lake build Theorems.Thm_OPG500Counterexample_eight_vertex_counterexample
```

The recorded replay used:

- Lean `4.33.1`, commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`;
- Lake `5.0.0-src+819816b`;
- Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.

Mathlib is not copied into this repository. `replay/lakefile.lean` pins its upstream Git commit, and `replay/lake-manifest.json` pins the resolved dependency graph. This avoids publishing a duplicate multi-gigabyte vendor tree while preserving exact source identity.

## Recorded results

All five theorem builds returned exit code `0`. The root build completed in 21.41 seconds with maximum RSS 7,956,600 KiB in the recorded environment. Every printed theorem reports only:

```text
[propext, Classical.choice, Quot.sound]
```

Static scans of all five accepted sources counted zero occurrences of proof placeholders or declared escape constructs tracked by this audit: `sorry`, `admit`, declared `axiom`, and `unsafe`.

See:

- `replay-receipt.json` — structured replay and platform identity receipt;
- `logs/` — complete captured build and axiom-print output;
- `statement-faithfulness.md` — definition and quantifier mapping to the canonical ProblemContract;
- `platform-readback.json` — bounded Prove2Me state readback;
- `manifest.json` — byte size and SHA-256 for every published payload file.

## Trust boundary

The Prove2Me state and the local replay are separate observations. GitHub PR checks validate transport structure only. The repository's trusted importer must still bind this frozen candidate to verifier receipts, append EvidenceLinks, derive a `kind=counterexample`, `outcome=refuted` Result, and regenerate the Solution View before this repository may claim governed Result admission.
