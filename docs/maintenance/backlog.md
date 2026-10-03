# Maintenance backlog

## UH-01: factual honesty of examples

- Problem/evidence: README and skill rewrites added technologies, dates, metrics,
  actors, and causes absent from inputs; README promised local-only execution
  and guaranteed preservation without enforcement.
- Scope: 47 published source pairs plus generated copies; source-claim audit in
  `evals/published-examples.json`, offline regression tests, host-privacy limits.
- Dependency: none; baseline b6ee94b4929c574f06ed8c64242eb17474aa2094.
- Acceptance: reviewed source/output claims and modality; synchronized derivatives;
  no unsupported README guarantees; offline checks pass.
- Risk: prompt behavior still requires review; fixture equality is not a semantic
  or live-model evaluation. No installer, CI, dependency, or release changes.
- Status: prepared for review on `maint/UH-01-factual-examples`.

## UH-03: reproduce one installer safety flaw

- Problem/evidence: static review suggests repeated `.bak` overwrites or truncated
  destination after a failed download; not yet reproduced in this cycle.
- Dependency: use temporary HOME and fixture project only.
- Acceptance: reproduce one failure, implement a minimal fix, preserve unrelated
  files, test repeat install and failure paths.
- Risk: filesystem/install changes require manual review.
- Status: queued; no implementation or runtime verification in UH-01.
