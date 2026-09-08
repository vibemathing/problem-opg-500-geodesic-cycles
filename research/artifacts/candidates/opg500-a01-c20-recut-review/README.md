# C20 native recut review and correction

Status: NONTERMINAL_CHECKPOINT. Verdict: candidate_only.
Best verified result: none. Same repository and existing PR #28 / Issue #3.
This supplement does not overwrite the earlier native-recuts archive.

## A withdrawn boundary assertion

The earlier PR/packet assertion that the C19 prefix and rotated Walk pairs
differ at x=y is false. Both definitions reverse their second component.
At every diagonal circle vertex both pairs are (nil, reverse rotated lap).
ReviewRecutAgreement.lean supplies prefix_recuts_diagonal as an explicit
proof body. The full-lap component is not IsPath; this, not pair inequality,
is the genuine diagonal limitation. The distinct-endpoint theorem and the
positive-real root candidate are not withdrawn.

The first symbolic test returned exit 1 because this supposed mutation
survived. first-failure.json retains that execution, source/output hashes
and diagnosis. The corrected normal and -O runs returned 0 with identical
word-review.json SHA256:
213d71a5cfcd802d1cab682f2a66d2ad10fc8be48d2154e43e088cbd145e7a04.
This is a generator-side fixed free-word check, not native Lean validation,
a repetition of old B3 numeric enumeration, or a different trust domain.

## Native theorem-sized source advance

Namespace OPG500C20Review keeps the earlier C20 sources distinct.
ReviewRecutAgreement proves typed triple factorization and prefix/rotation
Walk equality up to one simultaneous swap; paths, supports and costs are
transferred by that equality. Endpoint-only support intersection and edge
multiplicity partition are derived from the actual IsCycle.
ReviewB3 starts with that CycleView and a strict arbitrary competing Walk,
derives simple erasure and the intrinsic circle metric, extracts Q and
constructs both genuine >=3-edge IsCycle children. Their strict decreases,
absence of circle edges in Q, and integer/F2 cancellation are conclusions.
ReviewOutsideSpan calls this B3 construction directly, including a finite
minimum existence proof, and specializes to the actual triangle span.
No abstract split-provider parameter is inserted in the final composition.
Its outside seed remains a separate root-tail obligation.

All three sources and inherited dependencies remain UNCOMPILED. Fresh
lean/lake/elan probes failed before process launch. Neither requested
exact profile produced a compiler run, runtime fingerprint or axioms output.
Static source scanning is not an imported axiom audit. The external literal
Prove2Me root source is still not retrieved; no same-name weaker declaration,
new admission request or trusted receipt is manufactured.

## Storage and recovery

Four chunks plus manifest preserve ten new text members, 60705 member bytes.
The archive is decoded JSON63744bytes, compressed17204bytes. Existing T01
unpack.py verifies/restores without executing members. The logical paths in
manifest are archive members, not separately expanded GitHub files.
Every chunk/member roundtripped locally, and all five physical Git blob IDs
were fresh-read and matched original bytes at
1ac2a42bc87a34ea3476f6f678c196d4c601e050.

The complete, different C19-circle-metric attachment is already in the
36-member native-recuts archive. Do not re-upload it. The pre-existing
C19-circle-arcs archive still has missing payload-03/04/05 original bytes;
its exact pending paths and digests remain in native-recuts/transport-status.json.
That partial archive is not a mathematical dependency of this review.

Next: replay unchanged C16, ExternalSubwalk, the frozen C19 metric/prefix
modules and these three review modules at each exact profile; repair concrete
API errors without weakening assumptions. Then connect the literal root
Cycle/EdgeWeight/geodesic/peripheral definitions and the remaining root tail.
No forest/C4 work or 5913-pattern recount is included here.
