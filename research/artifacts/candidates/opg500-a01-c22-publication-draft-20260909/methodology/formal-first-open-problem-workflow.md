# A formal-first workflow for open-problem counterexamples

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**

## Scope

This document abstracts the OPG-500 publication process. It is a workflow report, not evidence that an AI system autonomously solved a problem.

## 1. Normalize before searching

Freeze the source wording in a ProblemContract: object domain, quantifiers, definitions, assumptions, permitted axioms, source identity, and bounded execution policy. Preserve source status separately from mathematical Result status. For OPG-500 the decisive quantifier distinction was

```text
question:  forall G, exists weight, forall cycles ...
refuter:   exists H, forall weights, exists cycle ... not ...
```

A candidate that gets this order wrong is not repairable by stronger computation.

## 2. Separate attempts, candidates, evidence, and Results

An Attempt records activity. A Candidate freezes proposed bytes. Evidence records verifier capabilities and binds to one Candidate. A Result expresses mathematical outcome only after policy-qualified evidence. The Solution View is derived. This prevents a successful run, platform label, or attractive PDF from silently becoming a governed theorem.

## 3. Decompose theorem obligations

Build a DAG with explicit statements. For this case the stable spine was: graph structure; shortest-path/tight-edge bridge; finite geodesic generation; four-core rank gap; peripheral generator span; cycle-rank obstruction; root assembly. Keep local helper declarations in the machine DAG, while the paper groups them into mathematically natural lemmas.

## 4. Use computation only where its quantifiers permit

Finite kernel evaluation can certify the fixed edge list, deletion connectivity, and small graph cases. It cannot sample its way through all positive real edge weights. The universal weighted claim was discharged symbolically by the tight-graph and dimension argument.

## 5. Replay exact bytes

Pin the accepted source, theorem identity, Lean version/commit, dependency lock, and Mathlib commit. Replay in a clean source directory under resource bounds. Record every command, exit code, bounded log, input digest, and output digest. Distinguish source scanning, successful elaboration, platform acceptance, and trusted repository verification.

## 6. Audit escape routes and foundations

Scan comments-aware source for placeholders and custom escape declarations; inspect imports; run `#print axioms`; report the exact axiom list. “No `sorry` found” is weaker than kernel elaboration, and a standard axiom list is not “axiom-free.”

## 7. Reconstruct a human proof from the DAG

Do not translate tactics line by line. State definitions first; identify the conceptual invariant; isolate finite checks; prove boundary cases (strict positivity, reversal, support, simplicity, ties, diagonal pairs); and map each paper item back to declarations. A proof narrative is public reasoning, not hidden chain-of-thought.

## 8. Control outward claims

Create a claim ledger before press copy. Each sentence has evidence, allowed wording, and forbidden extensions. Keep formal acceptance, repository admission, external peer review, minimality, novelty, and publication authorization as separate fields.

## 9. Prepare admission without self-admitting

Schema-valid drafts are useful, but pending receipts must remain `undetermined/incomplete`; verifier identity and independence cannot be invented. Trusted writers recompute hashes, issue receipts, append links, insert the Result, and rebuild the derived Solution View.

## 10. Release only after independent gates

A publication candidate should pass source identity, statement faithfulness, mathematical reading, exact replay, bibliography, privacy, author approval, and explicit release authorization. Version the final manifest rather than rewriting historical evidence.
