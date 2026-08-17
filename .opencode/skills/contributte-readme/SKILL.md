---
name: contributte-readme
description: Use this skill when creating, rewriting, or substantially reviewing a Contributte repository README. Select the Library, Skeleton, or Deprecated profile, ground every claim in repository evidence, preserve useful identity and assets, and evaluate generated output before proposing it.
compatibility: opencode
metadata:
  owner: contributte
---

# Contributte README

Create or review a README as an evidence-backed reader journey, not a fixed template.

## Required Procedure

1. Select exactly one profile from `docs/readme-library-standard.md`, `docs/readme-skeleton-standard.md`, or `docs/readme-deprecated-standard.md`.
2. Read the existing README before changing it. Inventory accurate identity, links, badges, screenshots, attribution, caveats, and canonical documentation routes that should be preserved.
3. Inspect authoritative repository facts: package manifests and locks, Makefiles/scripts, configuration, routes, examples, tests, CI, tracked docs, assets, support policy, and lifecycle state.
4. Identify the primary reader and task. Build one ordered path to installation/use, first success, or a safe deprecation decision.
5. Write only supported claims. Do not infer maintainers from commit history or package authorship. Use a repository or organization ownership route when no named maintainer evidence exists.
6. Keep the README task-focused. Do not add exhaustive command, API, route, provider, or dependency catalogs when canonical focused documentation is more useful.
7. Preserve useful existing identity and assets unless evidence shows they are stale, broken, misleading, duplicated, or irrelevant.
8. Run the deterministic evaluator and resolve every failure. Treat unassessed gates as review work, not passes.
9. Review semantic criteria with line-level evidence, especially first success, route priority, scanability, ownership, preservation, and factual consistency.
10. Never merge generated output directly. Apply the smallest reviewed synthesis and report unexecuted success paths as unassessed.

## Skeleton Focus

- Prefer the canonical interactive dev server before passive watcher/build alternatives when supported.
- Show concurrently required processes in execution order.
- Put browser URL, proxy behavior, and environment overrides in separate sentences or lists.
- State a repository-backed visible page, interaction, response, or output immediately after startup.
- Distinguish development, watcher, container, and production-like routes.

## Evaluation Command

From the standards repository, run:

```bash
bun scripts/readme/evaluate.ts \
  --profile <library|skeleton|deprecated> \
  --readme README.md \
  /path/to/repository
```

Use `scripts/readme/generation/prompt-v4.md` only for report-only generation experiments. The current single-repository calibration provisionally favors GPT 5.6 Terra, but model selection MUST be revalidated for other profiles and repositories.
