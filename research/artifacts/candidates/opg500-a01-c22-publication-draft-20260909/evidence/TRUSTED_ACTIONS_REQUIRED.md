# Trusted actions required before repository admission

**Nothing in `admission-drafts/` is signed or admitted.**

1. Freeze the Candidate bytes and have the trusted importer recompute the accepted-root, graph, ProblemContract, obligation, and statement hashes.
2. Run the exact Lean replay in an admitted verifier trust domain. Issue a `kernel_check` receipt with the actual verifier identity, time, command, output digest, toolchain fingerprint, and `verdict=accept` only if policy passes.
3. Independently run the placeholder/custom-axiom/unsafe and dependency-boundary audit. Issue `axiom_escape_audit` only after reviewing the reported standard axioms `[propext, Classical.choice, Quot.sound]`; do not translate that list into “axiom-free.”
4. Have a qualified reviewer compare the original source, canonical ProblemContract, Lean definitions, and root theorem. Resolve the `R^+` strict-positivity notation note and issue `statement_faithfulness` only if satisfied.
5. Replace the three `undetermined` template receipts with immutable accepted receipts and append three EvidenceLinks through the repository's authorized writer. Independence must be derived from the verifier registry, not from a filename or a self-declared boolean.
6. Validate and insert the `kind=counterexample`, `outcome=refuted` Result through the unique trusted store path. Check for stale/invalidated links and proof/counterexample conflict.
7. Rebuild, do not hand-edit, the Solution View; then run the repository research-space and ResearchBundle tests.
8. Separately obtain an independent human mathematical reading, author approvals, rights/licensing decisions, and publication authorization. Repository admission does not imply journal peer review or permission to publish.

No step above was performed by this publication-integration task.
