# C20 native recut statement map

Verdict: candidate_only. Source-level inspection is not native replay.
Only repository: vibemathing/problem-opg-500-geodesic-cycles.
Read base: df9fb18cf6d4f3e4836bbb6e86be77995abcdcf5.

Repository contract: geodesicity quantifies circle vertices and permits either
arc to be a shortest ambient path. Peripheral is induced AND connected-or-empty
deleting cycle vertices. The diagonal is zero distance, not two simple loops.
OPG comparison: https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
The no-path-strictly-shorter-than-both-arcs version matches the inclusive
one-shortest-arc quantifiers. It supplies no trusted verification of our proof.

The final native source uses genuine SimpleGraph.Walk.IsCycle through
OPG500C19.CycleView. Costs use all undirected Sym2 edge occurrences. Chords are
not deleted from the ambient graph and cycles are not restricted to induced
cycles. Native all-walk geodesicity is proved equivalent in source to the
inclusive one-shortest-arc predicate, including ties. Positivity is only on
actual graph edges. The exact external Prove2Me root source was not retrieved;
no literal Cycle/EdgeWeight/IsPeripheral adapter or root closure is claimed.

Official discovery documentation inspected this turn:
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Walk/Decomp.html
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Paths.html
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Walk/Operations.html
Relevant operations are take_spec, takeUntil_takeUntil, takeUntil_append_of_mem_left,
rotate, append, reverse, native IsPath and IsCycle. These are moving API docs,
NOT the installed exact-package API or an observed successful elaboration.

Exact requested repository profile: Lean4.33.0 and Mathlib
db584cd6d46c92f209a44c0f1c829460d327499d.
Requested compatibility profile: Lean4.33.1 and Mathlib
0df444a360eaa60ab8c11dca51a86af692955474.
Both replay drivers stopped at missing lake. No compiler ran, no actual axioms
were observed, and the configuration names are not runtime attestations.
