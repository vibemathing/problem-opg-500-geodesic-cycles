# Citation and novelty audit

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**  
Access date for web sources: 2026-09-09.

## Verified sources and passages

### Open Problem Garden source

* URL: https://openproblemgarden.org/op/geodesic_cycles_and_tuttes_theorem
* Page title: “Geodesic cycles and Tutte's Theorem.”
* Listed authors: Agelos Georgakopoulos and Philipp Sprüssel.
* Posted: 4 August 2007.
* Exact problem: “If G is a 3-connected finite graph, is there an assignment of lengths ℓ:E(G)→R+ to the edges of G, such that every ℓ-geodesic cycle is peripheral?”
* Exact definition: “A cycle C is ℓ-geodesic if for every two vertices x,y on C there is no x-y path in G shorter, with respect to ℓ, than both x-y arcs on C.”
* Supported claims: source wording, terminology, problem provenance, motivation through cycle-space generation.
* Frozen readback: `inputs/literature/opg-page.html`.

### Georgakopoulos–Sprüssel

* Agelos Georgakopoulos and Philipp Sprüssel, “Geodetic Topological Cycles in Locally Finite Graphs,” *Electronic Journal of Combinatorics* 16(1) (2009), R144. DOI: https://doi.org/10.37236/233.
* Journal metadata verified on the journal page; publication date shown as 30 November 2009.
* Introduction: “A finite cycle C in a graph G is called geodetic if, for any two vertices x,y∈C, the length of at least one of the two x–y arcs on C equals the distance between x and y in G.”
* Theorem 3.1: “For every finite graph G and every metric representation (|G|,ℓ) of G, every cycle C of G can be written as a sum of ℓ-geodetic cycles of length at most ℓ(C).”
* Supported claims: geodetic/geodesic definition and finite weighted cycle-space generation used in the proof architecture.
* Note: the final title uses **Geodetic**; the earlier OPG bibliography says **Geodesic**. The paper cites the final journal title.

### Tutte

* W. T. Tutte, “How to Draw a Graph,” *Proceedings of the London Mathematical Society*, series 3, volume 13, issue 1 (1963), 743–767. DOI: https://doi.org/10.1112/plms/s3-13.1.743.
* Metadata verified through Crossref's DOI record at `inputs/literature/tutte-crossref.json`.
* Supported claim (through the OPG page and later expositions): peripheral cycles generate the cycle space of a finite 3-connected graph.
* Pagination discrepancy: the OPG bibliography and Georgakopoulos–Sprüssel reference list print 743–768; Crossref prints 743–767. The BibTeX follows Crossref and this discrepancy remains flagged for a human bibliographic check against the version of record.

### Kelmans secondary proof source

* Alexander Kelmans, “On the Cycle Space of a 3-Connected Graph,” arXiv:math/0609219 (2006), https://arxiv.org/abs/math/0609219.
* Exact Theorem 1.3 passage: “The set of non-separating circuits of a 3-connected graph generates the cycle space of the graph.”
* Its introduction describes undirected graphs with no loops or parallel edges and defines the mod-2 cycle space.
* Supported claim: modern accessible statement of Tutte's cycle-space theorem. This is used as exposition, not as evidence of novelty for the counterexample.

## Novelty controls

No claim of “first,” priority, fame, age, or smallest counterexample is approved. The bundle only says that it presents a fixed eight-vertex counterexample and its accepted/replayed formal proof. A broader prior-art search and conventional peer review have not been completed. `prior_art_review` therefore remains unresolved and is not a required substitute for the three repository capabilities specified by the current root obligation.

## MSC

`05C38` (paths and cycles) is inherited from the canonical ProblemContract and is used provisionally. Independent confirmation against the official MSC 2020 table was not completed in this run; the manuscript visibly marks it provisional.
