# C13 local statement-faithfulness note

Verdict: candidate_only. Retrieved 2026-09-07.
Frozen repository: vibemathing/problem-opg-500-geodesic-cycles at
7ae092f383ae891be51dd21fd423eeecec54fa66.

Canonical source: problem-library/records/canonical-problems.jsonl.
Earliest reduction: research/artifacts/candidates/opg500-a01-c01-linear.md.
Original public problem:
https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
Definition paragraph following the problem statement.

The original tests cycle vertices and excludes a path strictly shorter
than both cycle arcs. The canonical contract instead says one of the arcs
is a shortest graph path. Under finite graphs and positive lengths, an
attained simple-path minimum proves these equivalent. OR is inclusive,
weak comparisons allow ties, and no induced-cycle assumption is imposed.
The diagonal is treated as the distance identity 0=0; two nonempty simple
x-x arcs are not defined. No source mismatch is found on distinct pairs.

Scope audit: C10 has a root counterexample argument; C11 contains source
proof terms and limited fragment checks, not a local-geodesicity kernel
replay; C12 removes a supplied abstract minimum but explicitly retains six
graph requirements. This packet uses none of those six bridges and makes
no claim about their closure. No source full text is reproduced here.
