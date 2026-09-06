# C09 source and statement audit

Status: candidate_only. Retrieved 2026-09-06. This is a source comparison,
not a semantic-verifier receipt or a novelty claim.

## Frozen target

Repository base: 76c8b56770a0894211bccd215cf23ec60021b871.
ProblemContract: 51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449.
The contract uses cycle VERTICES, an inclusive choice of shortest arc,
positive real edge lengths, and induced vertex-nonseparating peripheral
cycles. C09 addresses the logical negation on one fixed graph.

## Primary problem source

https://www.openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem

The problem paragraph and following definition use vertices x,y and
exclude a path strictly shorter than both cycle arcs. This matches C09.
The page also states geodesic cycle-space generation and explains its
connection to Tutte's theorem. It is not being cited as a solution or as
an endorsement of C09. No claim about recent resolution or novelty follows
from this page.

## Finite weighted spanning theorem

Agelos Georgakopoulos and Philipp Spruessel, Geodetic topological cycles
in locally finite graphs, arXiv:0911.3999v1 (2009), Section 3.1,
Theorem 3.1, printed page 5; Problem 3 is on printed page 15.
https://arxiv.org/abs/0911.3999v1
https://arxiv.org/pdf/0911.3999

The finite section explicitly tests x,y in V(C). Theorem 3.1 expresses
any finite cycle as a sum of weighted geodetic cycles no longer than it,
for every positive weighting. This supports C09 M1. C09 gives its own
strict-shortcut segment proof and finite descent. The paper does not
supply C09's perturbation, tight-edge incidence, or eight-vertex argument.

The paper's topological sections use all points on a circle. Those
sections are not substituted for the finite vertex-level definition.
Problem 3 and the primary problem page are the relevant target locators.
The PDF text was retrieved, but repeated screenshot requests returned
cache errors; no successful visual inspection is claimed this round.

## Remaining audits

M2 must preserve pre-existing strict comparisons, not the entire set of
geodesic cycles. M3 requires unique shortest paths; the 3/1 mutation
exhibits why ties matter. A 76-clause Boolean contradiction becomes a
root contradiction only after M1--M4 and graph-to-clause fidelity are
validated. The earlier 5913-pattern tight-subgraph argument is a distinct
proof candidate; its counts and labeling must not be mixed with C09's
13-by-64 face/tightness abstraction.
