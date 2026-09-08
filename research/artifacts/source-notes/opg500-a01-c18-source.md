# C18 source and statement map

verdict=candidate_only. Read date:2026-09-08. Only repository:
vibemathing/problem-opg-500-geodesic-cycles.
Base:3cc234eb4e4a7d065b07e705b4e10f741ba2420c.
Contract SHA256:51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

Fresh OPG reference:
https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
It quantifies cycle VERTICES and rules out a path strictly shorter than both
arcs. Inclusive shortest-arc semantics matches the repository contract.
The contract defines peripheral as induced AND connected-or-empty deletion
of cycle VERTICES. Chorded but deletion-connected cycles remain nonperipheral.
No complete external source is copied; the page is not a verifier receipt.

Official Mathlib discovery reference:
https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Paths.html
Relevant names:Walk.IsPath.isCycle_append, IsPath.support_nodup, Walk.IsCycle,
Walk.edges_append/edges_reverse. The moving docs are discovery only, not an
inspection or replay of either exact pinned installed package.

Repository lock:Lean4.33.0/Mathlib db584cd6d46c92f209a44c0f1c829460d327499d.
User-reported compatibility:Lean4.33.1/Mathlib 0df444a360eaa60ab8c11dca51a86af692955474.
No matching runtime exists here. Source digest equality is not compilation.
The generic locality and child-splicing slices have explicitly different
premises from the full root. The intrinsic circle/arc adapter remains open;
no same-name weaker eight_vertex_counterexample declaration is created.
