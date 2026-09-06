# C12: finite minimum supplied by a complete table

Verdict: candidate_only. Primary owner: math-formalization.
Target: obligation:opg500-root.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1.
Base: 89ce4a84d43e914c6d5e6be200580ecb8791b104.
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## Removed hypothesis and exact theorem

C11 MinimumOutside.lean assumed that a minimum object outside a closed
predicate had already been supplied. C12 replaces that premise with an
explicit finite list, its completeness, and one outside object. It does
not assume that the real numbers themselves are well ordered.

Let C be an object type with a total preorder leq (reflexive, transitive,
and total), and let P be any predicate. For any finite table xs with an
occurrence satisfying P, there is an occurrence m satisfying P with
leq(m,x) for every P-occurrence x in xs. Duplicates and ties are allowed;
no antisymmetry, distinct-cost or sorting assumption is needed.

Proof by list induction. The empty case contradicts existence of a
P-occurrence. For a::xs, if xs has no P-occurrence, the existing witness
must equal a, and a is the required minimum. Otherwise obtain a restricted
minimum m of xs. If P(a) is false retain m. If P(a) is true, compare a and
m using totality. Retain the smaller one. Reflexivity handles the head;
transitivity transfers the lower bound to every eligible tail member.
All logical cases appear explicitly in restrictedMinimum.

InTable is ordinary list occurrence defined as False on [] and
(x=a OR InTable x xs) on a::xs. Thus a table of objects is used, not a
list of arbitrary numbers allowed to introduce nonexistent cycle costs.
Completeness of the eventual cycle table is a different requirement
from nonemptiness of the predicate-restricted portion.

## Finite descent outside a span

The second declaration finiteGoodOutside has the following data:
- code:C->V and combine:V->V->V;
- inside:V->Prop closed under combine;
- good:C->Prop and a strict relation smaller;
- leq as above, compatible via leq(a,b) implies NOT smaller(b,a);
- every nongood c splits as two smaller a,b with
  code(c)=combine(code(a),code(b));
- a finite table containing EVERY object of C;
- at least one object whose code is outside inside.

Conclusion: some good object has its code outside inside.
There is no hminimum parameter in this signature.

Apply restrictedMinimum with P(c)=NOT inside(code(c)). It supplies a
weak minimum m outside inside. Completeness upgrades its table-relative
bound to all objects, and compatibility rules out any smaller outside
object. If m were nongood, split it into a,b. A smaller child cannot lie
outside, so both child codes lie inside. Closure and the code equation
put code(m) inside, a contradiction. This is the explicit finite descent
argument, not a call to an unproved minimum oracle.

## Exact C10 graph realization still needed

Take C to be ALL simple cycles of the tight spanning subgraph T for the
fixed positive length vector. V is its F2 edge-vector space; combine is
XOR; inside means membership in the span of ALL T-triangles. leq compares
weighted lengths weakly and smaller compares them strictly. A minimum
may tie other cycles. No tie-breaking or unique shortest path is needed.

A complete table for T can be obtained from the frozen complete H-cycle
table by retaining precisely cycles whose edges all belong to T. The
fact that T depends on the lengths does not make this family infinite:
for each fixed assignment it is a subset of the same finite H-table.
Soundness is encoded in the cycle-object type; completeness must still
be proved for that full type, not merely for a truncated enumerated type.

The following bridges remain separately open to trusted replay:
1. H's cycle table is complete and the edge-subset filter gives all T-cycles.
2. XOR is the genuine edge-incidence identity for strict-shortcut splitting.
3. A nongood T-cycle admits TWO strictly shorter simple T-cycles, not walks.
4. C10's rank count supplies a cycle outside the triangle span.
5. T preserves H-distances, so the resulting T-geodesic is H-geodesic.
6. In H every peripheral cycle is one of the twelve listed triangles.

The new theorem removes minimum existence only. It does not replace
any of these graph requirements by a new axiom or claim their admission.

## Actual bounded semantic checks and precise mutations

check_minimum.py tests the selection algorithm over four named objects,
all 256 assignments of costs in {0,1,2,3}, all sixteen predicates, and
all 341 lists of length at most four. There are 1,396,736 cases:
- 264,192 have no eligible occurrence and return no fabricated witness;
- 1,132,544 have a selected eligible minimum;
- 537,600 include a tied or duplicated minimum occurrence.
Every returned object is checked against all eligible table entries.
These counts describe an actual finite integer test, not universal
verification of the Lean proof or of the real-weight graph statement.

Four mutations isolate requirements that must remain in the graph map.
A. Incomplete table: costs (2,1), table [0], both objects eligible. The
selected row is locally minimal but not globally minimal. A hash alone
cannot turn this table into a complete one.
B. Missing span closure: in F2^2 let codes be 3,1,2 with costs 2,1,1;
inside={0,1,2} and good={objects with code 1 or 2}. The sole outside
object splits strictly into those two good children, but no good outside
object exists. All retained conditions hold except closure. Membership
in a set of generators cannot replace membership in their linear span.
C. Weak descent: codes 1,2,3, inside={0}, all costs 1, no good objects;
each code is the XOR of the other two. With weak decrease every split
holds, but the conclusion is false. Compatibility with strict smaller
is the missing condition. Equal lengths must not be treated as descent.
D. Empty outside restriction: one object of code 0 in inside={0}. The
object table is nonempty and complete but no outside witness exists.

The script computes these finite models rather than only listing
expected outcomes. Its explicit universal loops are bounded. No code
uses floats, network, model calls, or a claimed external verifier.

## Formalization and replay status

FiniteDescent.lean imports Init only and uses List.rec with its motive
spelled out, propositional introduction/elimination and equality
transport. This extends the C11 conditional slice without requiring a
compiled Mathlib project. It is a source candidate, NOT an elaborated
proof. The previously probed absence of Lean is not a compiler success;
there is no new kernel or axiom report in this packet.

Official source for the recursor signature used during this step:
https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/
section Recursor Types, List.rec. This is mutable discovery documentation,
not evidence for the exact fixture version. The code must be replayed
with a freshly identified and admitted Lean runtime before relying on
its formal guarantee. Classical case splits are explicit; actual axiom
closure must be audited from replay rather than guessed from source.

Actual candidate-generation command from this directory:
  python -S check_minimum.py
It returned 0 on Python 3.13.5 with an 18-second wall limit, 15-second CPU
limit, 256 MiB address-space limit and 1 MiB output budget. The inner loop
has a twelve-second cap. execution.json retains actual output and digests.
No universal claim is inferred from this finite semantic replay.

Proposed authorized command:
  lean FiniteDescent.lean
Use one thread, 60 seconds, 1 GiB memory and 1 MiB output; record exact
version, input hash, exit code, output digest and both #print axioms
reports. This command has NOT run here. A future rejection must be
recorded and repaired in a new immutable packet, not hidden by changing
an old admitted candidate or weakening the graph statement.

## Checkpoint

best_candidate: candidate:opg500-a01-c10-root-all-ties.
best_verified_candidate: none.
best_verified_result: none.
route_status: active.
open_obligations: obligation:opg500-root;
obligation:opg500-finite-linear-characterization.
failed_routes: no newly admitted record; mutation failures are local tests.
next_action: supply an exhaustive symbolic XOR/length-row certificate for
all strict external-path two-cycle splits of the canonical eight-vertex
graph, including membership inheritance to every tight subgraph T.
