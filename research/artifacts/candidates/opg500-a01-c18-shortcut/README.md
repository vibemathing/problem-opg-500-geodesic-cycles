# C18 complementary B3 extraction and root-tail audit

Status: NONTERMINAL_CHECKPOINT. Verdict: candidate_only. best_verified_result=none.
This supplements the already-open PR27, rather than recreating it. Its sole
packet remains research/artifacts/web-inbox/opg500-a01-c18.packet.json.
Base: 3cc234eb4e4a7d065b07e705b4e10f741ba2420c.

The existing C18-b3 first-hit/Mathlib-splice implementation stays unchanged.
This second implementation constructs every consecutive visit, both actual
child words and exact integer/F2 identities. Seventy-six rational cases,
thirteen multiple-visit cases and eighteen rejected mutations were actually
run. These numbers are not added to the other implementation's counts:
input overlap has not been measured. No 5913-pattern recount was performed.

ExternalSubwalk.lean uses the SAME C16 Walk. It proves, in unelaborated source,
that a strict competitor has a minimum-edge-count violating contiguous
factor, then derives its internally-disjoint property. A metric restricted
to the circle vertices is still an explicit input. OddDescent.lean supplies
finite minimum existence and the conditional odd-child composition. No
circle-geometry adapter or root proof is silently supplied by these files.

The complete paper proof constructs the arcs and children, proves their
simplicity and minimum size, and compares the two root tails. The shorter
paper tail is B: closed domination plus forest/C4 counting shows the triangle
span is proper; a shortest simple cycle outside this span must be geodesic
by the strict split. Counts are only rank upper bounds until justified.
The fully formalized graph-to-cycle/metric/arc bridge is still missing.

No Lean executable was available in this runtime. Both reported external
compile profiles are kept as reported targets, not observed passes. The
unchanged TightWalk digest and repaired ShortcutAlgebra digest match actual
bytes. The supplied corrected FiniteRealWalk source was not retrieved.
The exact OPG500Counterexample root declaration/definitions were not retrieved;
no same-name replacement theorem is introduced. There is no new admission
request, SMT fixture invocation, EvidenceLink, Result or trusted attestation.

## Lossless storage and deterministic replay

The manifest describes twelve logical members. Eleven distinct new contents
are in the payload chunks. ShortcutAlgebra is a byte-identical alias to the
existing C18-b3 archive and is NOT uploaded again. Member paths are logical
paths, not separately expanded physical repository files.

1. Use the existing T01 unpack.py to decode C18-b3 into a new staging root.
2. Decode this directory with --repository-root set to that staging root,
   and --output set to another fresh root. The decoder checks all byte hashes
   and restores members without executing them.
3. In the restored supplement run python -I -S construct.py and
   python -I -S verify.py. The latter does not import the producer. The saved
   execution.json records actual ordinary and optimized runs and limits.
4. replay.py --probe only probes executables. Its optional exact-project
   compile requires a preinstalled project with the selected immutable locks.
   It never installs dependencies, edits the locked project, or treats a
   supplied compile report as an observed run. Stage unchanged C16 TightWalk
   by its digest. A provided repaired FiniteRealWalk must match its expected
   digest or replay stops; that file is not fabricated by this supplement.

Final transport and obligation status belongs to the latest Issue3 checkpoint.
PR/CI/merge and finite tests do not close the universal real-weight root.
