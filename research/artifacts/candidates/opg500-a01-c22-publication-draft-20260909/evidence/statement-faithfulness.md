# Statement-faithfulness draft

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**  
Gate role: candidate input for an independent trusted `statement_faithfulness` review; not a signed receipt.

## Verdict proposed to the trusted reviewer

**PASS, with one notation note:** the original page writes `R^+` rather than spelling out `R_{>0}`. Its surrounding weighted-metric context and the later journal formulation use positive edge lengths; the canonical contract explicitly freezes strict positivity. No material domain, quantifier, definition, assumption, or polarity mismatch was found under that frozen interpretation.

## Logical comparison

| Dimension | Original/canonical assertion | Lean witness theorem | Audit |
|---|---|---|---|
| graph domain | finite simple 3-connected graph | fixed `H : SimpleGraph (Fin 8)` plus `IsThreeConnected H` | match |
| weight domain | `ℓ:E(G)→R^+`; contract says positive real | `EdgeWeight H := H.edgeSet → ℝ`; `IsPositive ℓ := ∀e, 0<ℓ e` | match under strict-positive reading |
| original quantifiers | `∀G, ThreeConnected G → ∃ℓ, Positive ℓ ∧ ∀C, Geodesic C → Peripheral C` | `∃H, ThreeConnected H ∧ ∀ℓ, Positive ℓ → ∃C, Geodesic C ∧ ¬Peripheral C` | exact negative-witness order |
| cycle | ordinary finite simple cycle | closed walk with Mathlib `walk.IsCycle` | match |
| geodesic | no path is shorter than both cycle arcs | for every pair, a globally shortest simple path is supported on the cycle | equivalent for finite positive weighted graphs; proof below |
| peripheral | induced non-separating cycle | chordless; deletion complement connected or empty | match |
| assumptions | finite simple graph; positive real lengths | no additional theorem hypothesis beyond definitions | match |
| polarity | asks whether a suitable weighting always exists | one fixed graph defeats every positive weighting | direct negation |

## Geodesic-definition equivalence

For two distinct vertices `x,y` of a simple cycle, the simple paths supported on the cycle are its two `x–y` arcs. If one arc is globally shortest, no path can be strictly shorter than both arcs. Conversely, if no path is shorter than both arcs, let `A` be the shorter arc. A shortest simple `x–y` path exists because the graph is finite. Its length is at most `len(A)`; strict inequality would make it shorter than both arcs, so equality holds and `A` is globally shortest. For `x=y`, Lean includes the diagonal pair and the zero-edge path witnesses shortestness; the source wording does not create a contrary condition.

Strict positivity is used to remove repeated vertices without increasing length, to make nontrivial subpaths have positive length, and to force strict descent in the geodesic-generation proof. Ties are retained because shortestness uses `≤`.

## Definition and boundary checks

* `Cycle.IsPeripheral` requires chordlessness **and** connected-or-empty complement after deleting all cycle vertices.
* The graph is fixed before `∀ℓ`; the cycle may depend on `ℓ`.
* Weights are arbitrary positive reals, not rationals, generic weights, or a finite sample.
* No claim of minimality follows from the theorem.
* The vector-space obstruction is over `ZMod 2`, but the theorem's weights remain real.
* The figure is explanatory; the formal edge list is controlling.

## Source identity

Accepted root SHA-256: `30088256cdd8ed371c2d65d68688d4db7598be598ba401d3ac1a9d60d07267f6`. Replay root SHA-256: `f70767b732b7b97cff3acafeacb862441a77dc2076821ed7ff3493733a21279e`. The only accepted-to-replay changes are canonical declaration naming and axiom-print commands.

## Remaining action

A trusted reviewer independent under repository policy must check this mapping against the immutable ProblemContract/source, issue an accepted receipt, and link it to the single Candidate. Until then, repository Result admission is pending.
