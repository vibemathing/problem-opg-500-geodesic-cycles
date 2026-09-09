# Lessons learned from the OPG-500 package

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**

1. **Quantifier order is the central claim boundary.** The fixed graph must precede all positive weights; only the witness cycle may depend on the weighting.
2. **The picture is not the graph.** A printed edge list, independent enumeration, and formal `Finset (Sym2 Vertex)` must agree.
3. **A finite computation can establish structure without proving the weighted theorem.** Kernel `decide` and Python enumeration check the 3-connectivity/peripheral classification; the real-weight universal step needs mathematics.
4. **Tight edges turn metric information into combinatorics.** Shortest paths make the tight graph connected and let geodesicity transfer back to the ambient graph.
5. **The contradiction has a clean dimensional core.** Under the false all-peripheral hypothesis, four dominating links provide too few peripheral triangle generators for the tight graph's cycle rank.
6. **Strict positivity does real work.** It supports path simplification, positive proper subpaths, and strict descent. The result should not be advertised for nonnegative weights.
7. **Ties are not genericity failures.** The proof uses `≤` and the two-step argument explicitly includes tied shortest paths.
8. **Accepted source and replay source need separate hashes.** Canonical-name transformations and added axiom prints are benign only because their exact diff is recorded.
9. **Platform acceptance, local replay, repository admission, and peer review are different layers.** Conflating them is a larger publication risk than a missing optional tool.
10. **Draft schemas need honest pending semantics.** Here existing schemas can carry `undetermined/incomplete` receipts, but the directory-level unsigned warning remains essential because EvidenceLink itself has no pending-status field.
11. **Bibliographic disagreement must remain visible.** Crossref and cited bibliographies disagree by one page for Tutte's paper; the draft flags rather than resolves it by guesswork.
12. **Public reasoning should be theorem-sized.** Dependency graphs, proofs, and reproducible checks are appropriate; raw chats and hidden model reasoning are not.
