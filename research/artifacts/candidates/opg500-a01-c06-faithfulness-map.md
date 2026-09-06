# OPG-500 C06: formal-language slice and faithfulness map

Status: candidate_only. Primary owner: math-formalization.
Candidate: candidate:opg500-a01-c06-faithfulness-map
Formal-language candidate: candidate:opg500-a01-c06-order-slice
Attempt: attempt:web-20260906-opg500-a01
Route: route:geodesic-linear-encoding-v1
Graph: graph:opg500-initial-v1
Target: obligation:opg500-finite-linear-characterization
Base: 5760c72bce91f0d5e596516b584d9650d1ff63d4
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449

## Artifact and actual status

File: research/artifacts/candidates/opg500-a01-c06-order-slice.lean
SHA-256: b7c4eff87ed0283d88958bf664a1848dd950ba033aa99f90a473a369191b36f0
Namespace: OPG500CandidateC06
Import: Mathlib
Execution status: not_executed
Compiler exit code: not_available
Axiom report: not_available
Kernel or graph-verifier receipt: none

The file contains eight proposed theorem declarations with explicit proof
scripts. They have NOT been compiled or elaborated here. Text inspection
and hashing do not substitute for either operation. In particular,
possible library API, elaboration or proof errors remain to be checked.
There is no graph definition in this Lean file; its theorem names must
not be interpreted as a proof of graph geodesicity or of the root claim.

## What each declaration asks to prove

1. finite_list_minimum: every nonempty finite list of elements of a
linear order has a member no greater than every list element. The proof
is by list induction and one comparison at each nonempty step.
Duplicates and ties are permitted.

2. minimum_of_cost_table: a nonempty finite cost table that is both
complete and sound supplies a lower bound attained by an indexed object.
Completeness means every object's cost occurs; soundness means every
table entry is the cost of an object. Both are explicit hypotheses.

3. forall_weak_or_iff_uniform: for a fixed a,b, pointwise inclusive weak
choices against all costs are equivalent to one uniform choice. The
proof chooses the smaller of a and b. It does not assume a general
commutation law for a universal quantifier and disjunction.

4. separate_strict_witnesses_iff_common: two possibly different witnesses
beating a and b imply one witness beating both, by choosing the cheaper
of the two. A same-witness requirement is kept in the final encoding.

5. weak_choice_iff_no_shortcut: the inclusive weak condition is equivalent
to absence of a single strict shortcut against both a and b.

6. arc_attainment_iff_uniform: if d is an attained lower bound of all
indexed costs and ia,ib are actual indices in that family, then one
distinguished cost equals d exactly when one is a uniform lower bound.

7. arc_attainment_iff_no_shortcut: composes declarations 3,5,6.

8. finite_arc_characterization: obtains d from the complete sound finite
table before invoking declaration 7. Thus the final order-level theorem
does not postulate a minimum as an unexplained fact.

The order assumptions are weaker than real-ordered-field and suffice
for this slice. Positivity and graph finiteness are not redundant in
the graph application; their use occurs in the separate realization
map below.

## Graph realization map, not yet formalized

For one fixed distinct pair x,y on a finite simple cycle C in G:

| Lean object or hypothesis | Required graph meaning |
|---|---|
| alpha | Real edge-path lengths with their usual total order |
| iota | ALL simple x-y paths in G, not an arbitrary tested subset |
| cost p | Sum of positive real edge lengths along p |
| ia, ib | The two actual simple C-arcs with endpoints x,y |
| xs | A finite list of all simple x-y path lengths |
| hne | The list contains an arc length, so is nonempty |
| hcomplete | Every simple graph path contributes its cost |
| hsound | No invented smaller number occurs in the cost table |
| derived d | A minimum attained by a simple graph path |
| graph-distance identification | Positive-length walk simplification makes d equal graph distance |

The last row is essential. It is a candidate argument in C01, not a
theorem of this Lean file. To lift the pair theorem to C being geodesic,
take the finite conjunction over ALL distinct cycle-vertex pairs.
The diagonal is discharged by the empty walk, not invented two x-x arcs.
Linear coefficient faithfulness still requires proving the path cost
equals its incidence vector dotted with the edge-length vector.

No table completeness proof, path-to-walk reduction, incidence-map
proof, or C03 potential encoding is silently assumed to have been
machine-checked. The fixed target and root remain unclosed.

## Cheapest semantic attacks

A. Omit a graph path from iota. Then a perfect proof over that smaller
index type can falsely pass a cycle that has an omitted strict shortcut.
The map requires iota to range over all simple paths, not just that
hcomplete hold relative to an already narrowed type.

B. Omit hsound. With one object of cost 1 and a table [0,1], a minimum
of the table need not be the cost of any object. The proposed declaration
retains soundness and uses it to extract an attaining object.

C. Replace inclusive OR by AND. A triangle in unit-length K4 has arc
lengths 1 and 2 and distance 1, so only one arc attains the minimum.
Both the code and graph interpretation keep inclusive OR.

D. In a unit-edge K4 square with diagonals 2, equal shortcuts are not
strict shortcuts. The code keeps weak comparisons and exact equality.

E. Call the abstract order theorem a solution of the root. Its signature
contains neither graph 3-connectivity, peripheral cycles nor an existence
quantifier over edge assignments. Such a status upgrade is unsupported.

These are hand semantic audits, not executable test results.

## Declared source pins and discovery

Freshly read repository files at the base:
- fixtures/lean-proof/lean-toolchain:
  leanprover/lean4:v4.33.0
- fixtures/lean-proof/lake-manifest.json:
  Mathlib revision db584cd6d46c92f209a44c0f1c829460d327499d
- .codex/skills/math-formalization/references/pressure-tests.md

These are declared fixture pins, NOT observations of installed tools,
a package resolution receipt or permission to execute. The registered
Mathlib source remains quarantined and this channel has
command_execution=false. No lean, elan or lake probe was run.

Primary discovery pages consulted on 2026-09-06:
- https://leanprover-community.github.io/mathlib4_docs/Mathlib/Order/Defs/LinearOrder.html
  Locators: LinearOrder, le_total, lt_or_ge, min_le_iff.
- https://leanprover-community.github.io/mathlib4_docs/Init/Data/List/Lemmas.html
  Locator: List membership API.
- https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/
  Locators: cases/constructor, rewriting and substitution tactics.

These mutable documentation pages are discovery aids, not exact-version
declaration evidence. The latest language reference identifies a version
different from the repository's fixture pin; it must not be substituted
for the declared target environment. Exact-version resolution and replay
remain required. No external repository was modified.

## Conditional verification ToolPlan

Only a separately authorized, re-admitted environment may execute this
plan. It must freeze the candidate and dependency digests, report the
actual Lean/Mathlib versions and check the quarantine/allowlist boundary.
No installation or network package update is authorized by this plan.

Proposed compile command, from the repository's existing fixture project:
  cd fixtures/lean-proof
  lake env lean ../../research/artifacts/candidates/opg500-a01-c06-order-slice.lean

Proposed bounds: one thread, 60 seconds, 1 GiB memory, 1 MiB output;
no automatic retry on a deterministic parsing or proof error.
The runner must enforce those limits around the command. A cap excess
or unavailable import yields no mathematical success verdict.

After an actual successful compile, request an axiom/escape audit of all
eight declarations, including the generated dependency closure. Inspect
the proof terms rather than inferring their properties from source token
searches. Use a separately generated audit input with, for example,
  #print axioms OPG500CandidateC06.finite_arc_characterization
and the seven other names, without altering the frozen candidate.

A separate statement-faithfulness review must then discharge the graph
mapping obligations above. Successful compilation of only this order
slice cannot close either repository obligation by itself.

## Checkpoint

best_verified_result: none
best_verified_candidate: none
route_status: active
open_obligations:
- obligation:opg500-finite-linear-characterization
- obligation:opg500-root
next_action: close the remaining graph-to-finite-table mapping at the
candidate level by giving a complete explicit vertex-sequence enumerator,
cycle-arc construction, incidence identity and pair-index audit.
