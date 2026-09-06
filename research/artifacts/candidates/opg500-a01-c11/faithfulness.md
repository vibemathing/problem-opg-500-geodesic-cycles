# C11: explicit proof terms and their exact remaining bridge

Verdict: candidate_only. Primary owner: math-formalization.
Target: obligation:opg500-root.
Problem: problem:opg-500-geodesic-cycles.
Attempt: attempt:web-20260906-opg500-a01.
Route: route:geodesic-linear-encoding-v1.
Graph: graph:opg500-initial-v1.
Base: 31b64fe0dadd119feb9052627ad9bfbfb6ac506f.
ProblemContract SHA-256:
51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.

## What was actually added

The existing C11 branch contained emit.py and MinimumOutside.lean.
This continuation reuses that branch. It expands C09's FROZEN certificate
into NecessaryPattern.lean, audits that text with a separate small
propositional checker, and retains the actual bounded executions.
Neither Lean source has been elaborated in this environment.

The input is ../opg500-a01-c09/unsat-tree.json, SHA-256
b7f6bb1aaa032313232be769f83f0a8e3862b852095e868f25ff82506b2d73be.
The exporter verifies all 76 clauses, 15 tree nodes, 89 unit implications,
and eight conflict leaves BEFORE writing a term. Both children of every
split are retained. The emitted theorem uses explicit lets, lambdas,
Or.elim, False.elim, applications and Classical.em; it does not ask Lean
to trust a Python success flag, import a solver answer, or execute a
native decision oracle. Seven excluded-middle cases are explicit.

## Propositional theorem versus root statement

noNecessaryPattern quantifies over eighteen propositions and assumes
76 explicit clauses. It derives False from those clauses. It does NOT
quantify over edge lengths or declare the eight-vertex graph. Its use
for the root needs C09's mathematical implication, not just compilation.

The canonical graph uses core B={0,1,2,3} and y_i=7-i, adjacent to B-{i}.
The first twelve propositions refer to the following peripheral faces,
in the exact C09 table order:
  p1=014, p2=015, p3=024, p4=026, p5=035, p6=036,
  p7=124, p8=127, p9=135, p10=137, p11=236, p12=237.
The last six refer to tight core edges:
  p13=01, p14=02, p15=03, p16=12, p17=13, p18=23.
Face digits name VERTEX sets, not edge variables or decimal integers.

Premises h0--h65 are every pairwise disjunction among the first twelve
propositions: at most one peripheral face is not geodesic. The remaining
six positive-tightness clauses are supplied by two geodesic incident
faces under UNIQUE shortest paths. The last four clauses forbid a tight
core triangle. Each sign and face-to-core incidence agrees with the
frozen certificate, rather than only with a hand-selected subset.

C09 supplies the candidate metric bridge: weighted geodesic cycles span,
strict-margin perturbation preserves absence of bad cycles and yields
unique shortest paths, and a nontight edge then lies in at most one
geodesic cycle. The all-real premise and perturbation are NOT proved by
this propositional theorem. C10 provides a separate all-ties argument;
its distinct necessary abstraction must not be silently substituted for
the 76 clauses used here.

## Small fragment checker: precise scope

audit_terms.py does not import emit.py or execute Lean. It reads the
emitted theorem envelope, parses all 76 assumptions and its proof text,
and checks the explicit propositional fragment by the introduction and
elimination rules stated in its header. It checks header-to-certificate
identity as well as term typing. Unknown hypotheses, wrong applications,
extra declarations and incomplete syntax fail rather than being skipped.

It returned exit 0 on the emitted text. The count includes 141 Or.elim
steps, 118 False.elim steps, 142 applications, 89 let bindings and seven
excluded-middle occurrences. Its three corrupted-text tests (changed
premise, unbound hypothesis and reversed negation application) were all
rejected. The exporter separately rejected four corrupted certificates.

This is a generator-side implementation check. Its parser and rules are
not the Lean parser/kernel and have not been admitted as a verifier.
Classical.em is a declared rule of this small checker, not a new axiom
added to the repository. Actual Lean axiom dependencies remain unknown
until a real #print axioms replay. The checker does not cover the
quantified/equality syntax of MinimumOutside.lean.

## Minimum-outside-span slice

MinimumOutside.lean contains three explicit proof-term candidates:
- outsideChild: closure of a predicate under combination implies a
  combination outside it has at least one child outside it.
- minimumOutside: if a nongood object splits into two strictly smaller
  objects whose codes combine to its code, a minimal object outside a
  closed predicate is good.
- existsGoodOutside: packages the preceding result given an actual
  minimum-outside witness.

For C10 the object type must be ALL simple cycles of T; code is the F2
edge vector; combine is symmetric difference; inside is membership in
the span of all T-triangles; good is T-geodesicity; smaller is strict
weighted length. The equation is code(c)=combine(code(a),code(b)).
Eq.mpr transports the closed-combination proof back in that direction.
The proof does not require cycles themselves to be closed under addition.

The signatures deliberately expose closed, split and hminimum. None is
an unproved global axiom. The graph application must supply: the linear
span closure; C10's external-shortcut two-cycle split with strict decrease;
nonemptiness outside the span from the rank count; a finite minimum;
and T's distance preservation to transfer geodesicity back to H.
No member of that list becomes true merely because this abstract
conditional theorem has been written or later compiled.

## Replay and source identity

Actual commands, from this candidate directory:
  python -S emit.py
  python -S audit_terms.py
Each was executed with a 15-second wall limit, 10-second CPU limit,
256 MiB address-space limit and a 1 MiB captured-output budget. Both
returned 0 on Python 3.13.5. execution.json contains their source/input/
output hashes and observations. Generated generation.json and
term-audit.json are reproducible; their full contents are nested in
execution.json, so they are not separate tracked duplicates.

A fresh local probe found no lean, lake or elan executable. No installation,
network package resolution or permission change was attempted. Init-only
imports remove the Mathlib dependency for these two files; they do not
invent a present or admitted Lean runtime. The repository's declared
fixture pin and quarantine controls still govern any requested replay.

Official discovery reference: Lean Language Reference,
https://lean-lang.org/doc/reference/latest/Type-Classes/Basic-Classes/ .
Its logical/basic-class documentation was consulted during this step;
mutable documentation is not exact-version compiler evidence. Candidate
source and clause pins above, not documentation freshness, freeze this
slice. The graph-metric sources remain in the C09 source audit.

Proposed authorized kernel replay: run the two Lean files using a
freshly identified and admitted Lean version, with 60 seconds per file,
one thread, 1 GiB memory and 1 MiB output; retain exact version, source
hashes, exit code and #print axioms outputs. Do not use a fixture build
or the small Python checker as a substitute. Graph/statement-faithfulness
review and root admission are separate from either compiler invocation.

## Checkpoint and next atomic objective

best_candidate: candidate:opg500-a01-c10-root-all-ties.
best_verified_candidate: none.
best_verified_result: none.
route_status: active.
open_obligations: obligation:opg500-root;
obligation:opg500-finite-linear-characterization.
failed_mutations: wrong unit; false conflict; missing tree child; changed
clause; changed theorem premise; unbound hypothesis; reversed negation.
These are rejected candidate mutations, not new admitted failed routes.
next_action: remove the supplied-minimum premise by a finite-list minimum
or explicit well-founded descent proof, then instantiate that slice for
the frozen complete T-cycle table without conflating it with root admission.
