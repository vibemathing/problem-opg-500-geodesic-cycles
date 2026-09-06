# Web Research Context Bundle

This file is generated from repository truth and bounded for the web channel. It is navigation context, not a Result, EvidenceLink, verifier receipt, or permission grant.

## Mandatory order

1. Read `AGENTS.md`, `governance/harness/PROJECT_AGENTS.md`, and `WEB_BOOTSTRAP.md`.
2. Check the exact ProblemContract and its SHA-256 below.
3. Select exactly one pre-admitted Attempt/Route/ObligationGraph/Obligation.
4. Search registered mathematical knowledge sources before inventing a new theorem.
5. After repository admission, autonomously complete Issue, candidate branch/file edits, commit, PR review, checks/rerun, merge, and checkpoint within the profile.
6. Write only candidate files under the profile allowlist and one `WEB_ATTEMPT_PACKET`; do not wait for project-added routine human approvals.
7. Never claim that Issue, PR, AI review, merge, Actions status, package build, search hit, test success, or this context closes mathematics.

## Compiled repository truth

```json
{
  "active_skills": [
    {
      "entry": ".codex/skills/math-computation/SKILL.md",
      "entry_sha256": "80c447221725ec198bee4b104d43ca28425110a7dac17afa9cad56ec69b57f48",
      "skill_id": "math-computation",
      "version": "0.6.0",
      "web_status": "constrained"
    },
    {
      "entry": ".codex/skills/math-derivation/SKILL.md",
      "entry_sha256": "3f3b567729f1e5dd24f87e832fdac702577f4add14b8cf6be12d538e1fe787c1",
      "skill_id": "math-derivation",
      "version": "0.4.0",
      "web_status": "active"
    },
    {
      "entry": ".codex/skills/math-discovery/SKILL.md",
      "entry_sha256": "ceb54d773cd970ca42d0243fb1a39b109cab3ffdbe2dd87b98b43539f988d471",
      "skill_id": "math-discovery",
      "version": "0.4.0",
      "web_status": "active"
    },
    {
      "entry": ".codex/skills/math-formalization/SKILL.md",
      "entry_sha256": "8ade921dacd277f425f424064a6002806c057f160555081dbdb4ec05c1f5ea05",
      "skill_id": "math-formalization",
      "version": "0.5.0",
      "web_status": "constrained"
    },
    {
      "entry": ".codex/skills/math-proof/SKILL.md",
      "entry_sha256": "61006c732ad69e73f56be126acb6fa9e25c866e18733ce1f0f3863c1f8eea80f",
      "skill_id": "math-proof",
      "version": "0.5.0",
      "web_status": "active"
    },
    {
      "entry": ".codex/skills/math-toolchain/SKILL.md",
      "entry_sha256": "f6514e01358aa2e40f8b7e3bb9221fd9abca6b7ff37ec6920f2c2cf537533f7b",
      "skill_id": "math-toolchain",
      "version": "0.2.0",
      "web_status": "constrained"
    },
    {
      "entry": ".codex/skills/solve/SKILL.md",
      "entry_sha256": "ff557dc3fc2fa10df4b21e8bef251a37928f5572ccf0092c79f0d9ab90a00ec0",
      "skill_id": "solve",
      "version": "0.3.0",
      "web_status": "active"
    },
    {
      "entry": ".codex/skills/vibe-mathing-router/SKILL.md",
      "entry_sha256": "65f6b25fe152a4cc2fa9ecb03626dad6e3b70473fc256ac9acbabd0ef7cb9e8e",
      "skill_id": "vibe-mathing-router",
      "version": "0.4.0",
      "web_status": "active"
    }
  ],
  "attempts": [
    {
      "artifacts": [],
      "attempt_id": "attempt:web-20260906-opg500-a01",
      "claims": [],
      "completed_at": null,
      "generator": "chatgpt-web-github",
      "inputs": [
        "problem-library/records/canonical-problems.jsonl",
        "research/records/failed-routes.jsonl"
      ],
      "lifecycle": "running",
      "method": "formalization",
      "objective": "对固定有限图 G 与圈 C，严格证明 C 为 ℓ-geodesic 的定义等价于对每对 x,y∈V(C)，两条 C-arc 中至少一条达到 dist_ℓ(x,y)，并把该条件化为对有限条 simple x-y paths 的有限布尔组合线性等式/不等式；审计 strict/weak inequality 与并取结构。",
      "obligation_graph_id": "graph:opg500-initial-v1",
      "problem_contract_sha256": "51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449",
      "problem_id": "problem:opg-500-geodesic-cycles",
      "route_id": "route:geodesic-linear-encoding-v1",
      "started_at": "2026-09-06T05:03:30Z"
    }
  ],
  "failed_routes": [],
  "knowledge_operators": [
    {
      "evidence_ceiling": "discovery_only",
      "external_effect": "none",
      "operator_id": "op:identify-mathematical-object",
      "owner_skill": "math-discovery"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "read_local",
      "operator_id": "op:search-formal-theorem",
      "owner_skill": "math-discovery"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "read_network",
      "operator_id": "op:search-mathematical-database",
      "owner_skill": "math-discovery"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "read_local",
      "operator_id": "op:resolve-formal-package",
      "owner_skill": "math-formalization"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "none",
      "operator_id": "op:compare-statements",
      "owner_skill": "math-proof"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "none",
      "operator_id": "op:compose-reuse-plan",
      "owner_skill": "math-proof"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "none",
      "operator_id": "op:prove-reuse-gap",
      "owner_skill": "math-proof"
    },
    {
      "evidence_ceiling": "candidate_only",
      "external_effect": "bounded_candidate_build",
      "operator_id": "op:build-formal-candidate",
      "owner_skill": "math-formalization"
    },
    {
      "evidence_ceiling": "verifier_receipt",
      "external_effect": "bounded_candidate_build",
      "operator_id": "op:verify-formal-candidate",
      "owner_skill": "math-formalization"
    },
    {
      "evidence_ceiling": "verifier_receipt",
      "external_effect": "none",
      "operator_id": "op:review-reuse-semantics",
      "owner_skill": "math-proof"
    }
  ],
  "knowledge_sources": [
    {
      "evidence_ceiling": "verifier_input",
      "maturity": "installed",
      "operational_status": "quarantined",
      "source_class": "formal_library_index",
      "source_id": "lean-mathlib-local"
    },
    {
      "evidence_ceiling": "candidate_only",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "formal_package_registry",
      "source_id": "lean-reservoir"
    },
    {
      "evidence_ceiling": "candidate_only",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "formal_library_index",
      "source_id": "mathlib-docs-search"
    },
    {
      "evidence_ceiling": "verifier_input",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "proof_archive",
      "source_id": "isabelle-afp"
    },
    {
      "evidence_ceiling": "verifier_input",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "formal_package_registry",
      "source_id": "rocq-mathcomp"
    },
    {
      "evidence_ceiling": "candidate_only",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "mathematical_object_database",
      "source_id": "oeis"
    },
    {
      "evidence_ceiling": "candidate_only",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "mathematical_object_database",
      "source_id": "lmfdb"
    },
    {
      "evidence_ceiling": "candidate_only",
      "maturity": "surveyed",
      "operational_status": "available",
      "source_class": "formula_reference",
      "source_id": "nist-dlmf"
    },
    {
      "evidence_ceiling": "computation_evidence",
      "maturity": "surveyed",
      "operational_status": "design_only",
      "source_class": "algorithm_distribution",
      "source_id": "sagemath"
    }
  ],
  "obligation_graphs": [
    {
      "attempt_id": "attempt:web-20260906-opg500-a01",
      "graph_id": "graph:opg500-initial-v1",
      "obligations": [
        {
          "dependencies": [
            "obligation:opg500-finite-linear-characterization"
          ],
          "kind": "root_claim",
          "obligation_id": "obligation:opg500-root",
          "statement": {
            "formal_declaration": null,
            "language": "en",
            "text": "For every finite 3-connected graph G, does there exist an assignment of positive real lengths ℓ:E(G)→R_{>0} such that every ℓ-geodesic cycle is peripheral?"
          },
          "statement_sha256": "ab6f891faac82c09c71a1cac0cad55ce0ded258d37159097c2e4488952f5066e"
        },
        {
          "dependencies": [],
          "kind": "lemma",
          "obligation_id": "obligation:opg500-finite-linear-characterization",
          "statement": {
            "formal_declaration": null,
            "language": "zh",
            "text": "对固定有限图 G 与圈 C，严格证明 C 为 ℓ-geodesic 的定义等价于对每对 x,y∈V(C)，两条 C-arc 中至少一条达到 dist_ℓ(x,y)，并把该条件化为对有限条 simple x-y paths 的有限布尔组合线性等式/不等式；审计 strict/weak inequality 与并取结构。"
          },
          "statement_sha256": "2f3ae878173cf0c4283d949014261bb9ae0072a1b283776ef47e581122993e5d"
        }
      ],
      "root_obligation_id": "obligation:opg500-root",
      "route_id": "route:geodesic-linear-encoding-v1"
    }
  ],
  "problem_contract": {
    "acceptance": {
      "policy": "solution-admission-v1"
    },
    "aliases": [
      "Open Problem Garden OPG-500"
    ],
    "allowed_axioms": [
      "finite-graph-basic",
      "real-ordered-field"
    ],
    "assumptions": [
      "All graphs and digraphs are finite and simple unless the statement explicitly says otherwise."
    ],
    "constraints": {
      "allowed_adapters": [
        "bounded-graph-enumerator-v1",
        "exact-linear-inequality-v1",
        "lean-obligation-v1"
      ],
      "allowed_methods": [
        "discovery",
        "derivation",
        "computation",
        "proof",
        "formalization"
      ],
      "max_attempts": 20,
      "runtime": {
        "max_output_bytes": 5242880,
        "max_retries": 3,
        "max_transitions": 300,
        "timeout_seconds": 1800
      }
    },
    "created_at": "2026-09-06T03:30:00Z",
    "definitions": [
      {
        "definition": "A cycle C such that for each pair of vertices on C, one of the two C-arcs between them is an ℓ-shortest path in G.",
        "term": "ℓ-geodesic cycle"
      },
      {
        "definition": "An induced non-separating cycle; deleting its vertices leaves the remaining graph connected or empty.",
        "term": "peripheral cycle"
      }
    ],
    "domain": {
      "description": "Finite simple 3-connected graphs equipped with positive real edge lengths.",
      "objects": [
        "3-connected graph",
        "positive edge-length assignment",
        "geodesic cycle",
        "peripheral cycle"
      ]
    },
    "lifecycle": "active",
    "msc": [
      "05C38"
    ],
    "problem_id": "problem:opg-500-geodesic-cycles",
    "quantifiers": [
      {
        "domain": "finite simple 3-connected graphs",
        "kind": "forall",
        "variables": [
          "G"
        ]
      },
      {
        "domain": "positive real edge-length assignments ℓ:E(G)→R_{>0}",
        "kind": "exists",
        "variables": [
          "ℓ"
        ]
      },
      {
        "domain": "ℓ-geodesic cycles of G",
        "kind": "forall",
        "variables": [
          "C"
        ]
      }
    ],
    "schema_version": "1.0.0",
    "sources": [
      {
        "retrieved_at": "2026-09-02T00:06:43Z",
        "source": "UnsolvedMath",
        "source_record_id": "unsolvedmath-opg-500-6a469c8c697d",
        "url": "https://www.unsolvedmath.com/problems/OPG-500"
      }
    ],
    "statement": {
      "language": "en",
      "text": "For every finite 3-connected graph G, does there exist an assignment of positive real lengths ℓ:E(G)→R_{>0} such that every ℓ-geodesic cycle is peripheral?",
      "version": 1
    },
    "title": "Geodesic cycles and Tutte's theorem",
    "updated_at": "2026-09-06T03:30:00Z"
  },
  "problem_contract_sha256": "51d8524b7f530bacb73ee5da132109fbd3e54dc441b9ef926fcbcc3abbf8f449"
}
```
