# Reproducibility checklist

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**

- [x] Fixed public commit recorded.
- [x] Accepted root, C21 manifest, packet, and prior replay receipt hashes recomputed.
- [x] Every C21 manifest payload hash and byte count checked.
- [x] Canonical ProblemContract and root obligation hashes recorded.
- [x] Accepted-to-replay source diff bounded to names and axiom prints.
- [x] Seven exact replay source modules copied into the publication workspace.
- [x] Lean 4.33.1 and Mathlib commit checked.
- [x] Five target modules built with exit code 0 and 240-second per-command bound.
- [x] Wall time, maximum RSS, logs, and log hashes recorded.
- [x] `#print axioms` output retained exactly.
- [x] Placeholder/custom-escape source scan run.
- [x] Machine declaration DAG extracted from the elaborated environment.
- [x] Independent finite graph audit run without using the figure.
- [x] English and Chinese PDFs built by real TeX processes.
- [ ] Trusted independent kernel receipt issued.
- [ ] Trusted escape-audit receipt issued.
- [ ] Trusted statement-faithfulness receipt issued.
- [ ] Independent human mathematical review completed.
- [ ] Author/rights/disclosure fields supplied.
- [ ] Explicit public-release authorization supplied.

Resume formal replay with `bash formal/replay.sh`; inspect logs and hashes before changing any status.
