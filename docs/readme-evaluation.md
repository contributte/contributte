# README Evaluation

Use this protocol with [Spec-Driven Docs](spec-driven-docs.md). Draft `0.1` is report-only.

## Machine evaluation

Run the dependency-free Bun evaluator from this repository:

```bash
bun scripts/readme/evaluate.ts --profile skeleton ../webpack-skeleton
```

Use JSON for automation:

```bash
bun scripts/readme/evaluate.ts \
  --profile library \
  --format json \
  ../package
```

JSON output follows [`scripts/readme/result.schema.json`](../scripts/readme/result.schema.json). This schema covers the draft machine layer, whose local evidence does not yet include the hashes, command results, human observations, or LLM provenance required by the final normative report. Draft `0.1` intentionally keeps the quality score `null`; a later reviewer-input schema will add evidenced dimension scores after calibration.

The evaluator returns:

- exit `0` when no deterministic gate fails, including incomplete reports;
- exit `1` when a deterministic gate fails;
- exit `2` for invalid input or unreadable repository data.

An `incomplete` report is not a pass. It means a command, semantic criterion, or contextual review still needs evidence.

The first implementation supports a documented Markdown subset. Complex GFM anchors, reference links, multiline HTML, dynamic Make targets, and arbitrary shell syntax may require a future parser or return `unassessed`.

## Human review

Review one criterion at a time. Select evidence before assigning a level.

1. Choose the explicit Library, Skeleton, or Deprecated profile.
2. Confirm the target reader and primary supported task.
3. Resolve every failed or unassessed gate.
4. Execute or observe the primary task in a clean environment.
5. Score each applicable quality criterion from `0` to `4` using its anchors.
6. Record `not-applicable` only with repository evidence.
7. Review rendered GitHub content, images, links, tables, and code.
8. Record assessment coverage and unresolved uncertainty.

Two task questions anchor review:

- Can a new reader decide whether this repository fits their need?
- Can that reader reach the stated first success without source-code archaeology or undocumented knowledge?

## English and semantics

Check deterministic terminology first. Then review:

- direct verbs and one principal action per ordered step;
- prerequisites before dependent actions;
- explicit command location when context is not obvious;
- expected output or behavior after setup;
- stable names for package, extension, service, tool, and runtime concepts;
- pronouns with clear antecedents;
- versioned terms instead of ambiguous `latest`, `current`, or `recent`;
- concrete claims instead of unsupported adjectives;
- separate sentences, paragraphs, or list items for URLs, runtime behavior, and configuration overrides that readers use independently;
- recommended runtime or development mode before secondary watcher, build, container, or production variants;
- an evidence-backed maintainer, team, repository-owner, or organization ownership route plus contribution guidance for maintained repositories;
- preserved upstream and public terminology where rewriting would reduce accuracy.

Readability, passive voice, long sentences, grammar tools, and inclusive-language scanners are advisory. Confirm each finding in context.

## LLM-assisted review

An LLM prompt MUST include:

- one criterion ID and its `0` to `4` anchors;
- the intended reader and task;
- relevant README spans;
- relevant repository facts or command evidence;
- instruction to return `unassessed` when evidence is insufficient;
- instruction that length and polish are not quality evidence.

Required response fields are criterion ID, outcome/level, README evidence, repository evidence, rationale, uncertainty, model, and prompt version. Reject output that lacks citations or conflicts with deterministic evidence.

## Pull request report

Report sections separately:

```text
Gates
- 6 passed
- 1 failed: LB-IN-01 package differs from composer.json
- 1 unassessed: LB-FS-01 example was not executed

Quality
- score: not calculated
- assessment coverage: 0%

Advisory
- 2 images need alt-text review
- 1 untyped code fence

Status: blocked
```

Do not publish an aggregate quality score before semantic review coverage is sufficient.

## Safe execution

Never execute arbitrary README fences in a privileged workflow. Use an ephemeral environment, no secrets, read-only token, non-root user, temporary home, bounded time/resources, no host Docker socket, and network disabled by default. Treat Composer plugins/scripts and shell commands as executable untrusted code.

External links belong in a retried scheduled check. Local links, images, package metadata, and tracked command names are deterministic pull-request checks.
