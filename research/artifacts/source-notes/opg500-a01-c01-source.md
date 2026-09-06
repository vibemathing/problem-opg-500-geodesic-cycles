# OPG-500 source note C01

Status: candidate_only. Primary owner: math-formalization.
Source comparison supports a candidate definition audit, not a Result.

## Frozen repository sources

At 241c4b930d8ce1db231fff1647092554f55f3afb:
- problem-library/records/canonical-problems.jsonl
- research/records/obligation-graphs.jsonl
- research/records/failed-routes.jsonl (empty)
- governance/control-plane/math-knowledge-source.v1.json
- scripts/vibe_mathing/smt.py

ProblemContract SHA-256 (declared):
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Original problem source

Title: Geodesic cycles and Tutte's Theorem.
Authors listed: Agelos Georgakopoulos and Philipp Spruessel.
Posted: 2007-08-04. Retrieved: 2026-09-06.
URL: https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
Locator: definition paragraph directly after the question.
Bounded exact phrase: "than both".
The source excludes a vertex-to-vertex path shorter than both cycle arcs.
The frozen repository definition requires at least one cycle arc to
attain graph distance. C01 supplies the explicit equivalence using
finite positive-length shortest-path attainment. Both definitions use
vertices, not all interior points of metric edges; both allow ties.
No stronger all-points or unique-shortest-path statement is substituted.

The local lemma is derived from definitions and finite ordered minima.
No claim of novelty for this elementary equivalence is made. The source's
separate cycle-space discussion is not used as a proof dependency.

## Reuse and interface findings

The registered Mathlib source is quarantined; remote documentation is
design-only. A lookup of
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Path.html
returned 404. No declaration at that guessed path was imported or claimed.
This is a source-locator failure only, not a mathematical obstruction.

The repository SMT module accepts one fixed unrelated fixture statement.
It is not evidence of an implemented exact-linear-inequality graph
adapter. C01 defines a portable candidate AST and a bounded ToolPlan.
Neither a registry entry, a source hit, nor later transport CI verifies
the graph encoding.

## Limits

This is a bounded paraphrase and locator record, not a paper mirror.
The original page is mutable and no content digest for it was computed.
The repository contract, rather than any mutable page status, is the
frozen research target. No solver or kernel ran in this source audit.
