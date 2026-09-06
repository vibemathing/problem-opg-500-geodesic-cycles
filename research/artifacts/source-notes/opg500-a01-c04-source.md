# OPG-500 C04 source and assumption audit

Status: candidate_only. Owner: math-formalization.
Base: c2c0d1bd84bf02dd569e2508a556c60f43ea40f6
Retrieved: 2026-09-06.

## Primary references consulted

1. Michel X. Goemans, MIT 18.433, Linear Programming and Polyhedral
Combinatorics, dated 2013-02-28.
URL: https://math.mit.edu/~goemans/18433S13/polyhedral.pdf
Locators: Theorem 3.6 and Corollary 3.8, printed pages 7--8
(PDF indices 6--7). Those pages were visually inspected.
The notes describe a vertex through a full-rank active subsystem and
give a rank condition ensuring vertices in a nonempty polyhedron.
C04 does not assume nonempty polyhedra always have vertices; its
coordinate lower bounds furnish the blocking direction directly.

2. Afonso S. Bandeira, ETH Zurich, Linear Algebra Fall 2023,
lecture notes part II.
URL: https://people.math.ethz.ch/~abandeira/LA23_notes_part_II.pdf
Locators: determinant definition 5.1.6 on printed page 31, and
Cramer's Rule, Proposition 5.1.16 on printed page 34 (PDF index 33).
The Cramer page was visually inspected.
The cited formula expresses the unique solution of a nonsingular
square system by replaced-column determinants. The determinant
expansion then gives the elementary bound needed for {-1,0,1} matrices.

## Statement difference and reuse boundary

Neither reference is asserted to discuss OPG-500, to supply a length
assignment for all 3-connected graphs, or to prove this project's
graph-to-formula faithfulness. C04 supplies the sign-cell specialization,
strict-row normalization, finite active-rank construction and application
to all simple-path comparisons explicitly.

The move from real to bounded integer representatives preserves only
the signs of finitely many homogeneous forms. It is not metric equality,
a claim of integrality of the entire polyhedron, or an invocation of
total unimodularity. The determinant multiplier may exceed one.

The proof avoids topological compactness and rational density; thus it
does not require strengthening real-ordered-field to a completeness
assumption. Rank, null vectors, determinant identities and finite
minimum choices are ordinary finite algebraic operations.

## Attribution and verification

These are short paraphrases and exact source locators, not copies of
the references. No novelty claim is made for basic feasible points or
Cramer's identity. The reference PDFs are mutable URLs; no content hash
or executable proof receipt was obtained for them.
All graph-specific claims remain candidate deductions and require
statement-faithful verification.
