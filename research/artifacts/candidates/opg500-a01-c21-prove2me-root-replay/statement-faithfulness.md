# Statement-faithfulness audit for the OPG-500 root counterexample

Status: candidate input to the trusted statement-faithfulness gate.

## Canonical question

The frozen ProblemContract asks whether

> for every finite simple 3-connected graph `G`, there exists a strictly positive real edge-length assignment `ℓ` such that every `ℓ`-geodesic cycle is peripheral.

Its logical form is:

```text
∀ G, ThreeConnected(G) → ∃ ℓ, Positive(ℓ) ∧
  ∀ C, Geodesic(G, ℓ, C) → Peripheral(G, C).
```

A direct negative witness has the form:

```text
∃ H, ThreeConnected(H) ∧ ∀ ℓ, Positive(ℓ) →
  ∃ C, Geodesic(H, ℓ, C) ∧ ¬ Peripheral(H, C).
```

## Lean root statement

The published replay module proves:

```lean
theorem OPG500Counterexample.eight_vertex_counterexample :
    IsThreeConnected H ∧
      ∀ ℓ : EdgeWeight H, IsPositive ℓ →
        ∃ C : Cycle H, C.IsGeodesic ℓ ∧ ¬ C.IsPeripheral
```

This has the required negative-witness quantifier order: one fixed graph `H`, followed by every strictly positive real edge weighting, followed by a counterexample cycle that may depend on the weighting.

## Definition mapping

| ProblemContract term | Lean definition | Audit |
|---|---|---|
| finite simple graph | `SimpleGraph (Fin 8)` | `SimpleGraph` is loopless and symmetric; `Fin 8` is finite |
| fixed graph | `H` from `eightVertexEdges` | exactly 8 vertices and the explicit 18-edge set in `Def_opg500_eight_vertex_graph.lean` |
| 3-connected | `IsThreeConnected H` | at least four vertices and connected after deletion of every vertex set of cardinality below 3 |
| positive real edge lengths | `EdgeWeight H := H.edgeSet → ℝ`, `IsPositive ℓ := ∀ e, 0 < ℓ e` | quantifies over all strictly positive real edge weights |
| cycle | `Cycle H` with a closed `SimpleGraph.Walk` satisfying `walk.IsCycle` | simple graph cycle representation |
| geodesic cycle | `Cycle.IsGeodesic` | for every two cycle vertices there exists a globally shortest simple path whose edge set lies in the cycle |
| peripheral cycle | `Cycle.IsPeripheral` | chordless plus connected-or-empty deletion complement |
| negative answer | `∃ C, C.IsGeodesic ℓ ∧ ¬ C.IsPeripheral` for every positive `ℓ` | directly negates the original existential assignment property for the fixed `H` |

## Scope and edge cases

- The weights range over `ℝ`, not rationals or a finite test set.
- Positivity is strict (`0 < ℓ e`); zero and negative weights are excluded exactly as required.
- Tied shortest paths are allowed because shortestness uses `≤`.
- The diagonal vertex pair is included by the universal pair quantifier in `Cycle.IsGeodesic`.
- Peripheral means induced/chordless and non-separating under vertex deletion, with the empty complement accepted.
- The graph is fixed before the edge-weight quantifier; it is not chosen separately for each weighting.

## Source identity check

The two local definition modules matched the Prove2Me definition text after normalizing one trailing newline. The replay receipt records:

- weighted-cycle-model normalized SHA-256: `c9137b19120924494ad6b0f39c0c6c1b412dde5c766671f90fe376d2101779e8`;
- eight-vertex-graph normalized SHA-256: `bfb48b8ae67d67f36dbba1f84fde69d3c7e092b793773a45b90172f60162151c`.

## Conclusion and remaining repository gate

The Lean theorem has the direct counterexample strength required for a negative answer to the frozen ProblemContract; it is not merely a bounded computation or a supporting lemma. This document is published as audit material. The repository must still admit it through an independently accepted `statement_faithfulness` EvidenceLink before deriving a Result.
