# README Generation Evaluation

This benchmark evaluates README generation through the OpenCode CLI. It extends [Spec-Driven Docs](spec-driven-docs.md): document gates and quality remain authoritative, while generation metrics measure whether a prompt/model workflow produces reliable improvements.

See the [exploratory GPT 5.6 pilot](readme-generation-pilot.md) for one pinned report-only run.
See the [GPT 5.6 model comparison](readme-generation-comparison.md) for the prompt-v2 Sol, Terra, and Luna experiment.

Draft `0.1` is report-only. Generated files MUST NOT be pushed or merged automatically.

## Evaluation unit

One generation run is the immutable tuple:

```text
repository + commit + source README hash + profile + prompt version
+ OpenCode version + provider/model + variant + run ID
```

Changing any element creates a new run. A benchmark report MUST retain the manifest, prompt, raw OpenCode JSON events, extracted candidate, timing, exit status, and evaluator results.

## Input manifest

The manifest identifies:

- repository path and pinned commit;
- README path and SHA-256 hash;
- Library, Skeleton, or Deprecated profile;
- prompt path and version;
- OpenCode model and variant;
- run count and timeout;
- output directory.

The runner MUST reject a commit or README hash mismatch. This prevents silent comparison against a moving repository.

## Prompt contract

The generator prompt MUST:

- identify the selected README profile and primary reader task;
- direct the model to inspect tracked repository facts before writing;
- preserve accurate project identity, badges, images, screenshots, links, attribution, and domain terminology unless evidence proves they are stale or misleading;
- use short conventional headings rather than a fixed template;
- require installation through observable first success;
- keep detailed reference material in its canonical location;
- forbid invented commands, versions, APIs, routes, configuration, support claims, and output;
- return one complete candidate between `README_CANDIDATE_BEGIN` and `README_CANDIDATE_END` markers;
- forbid repository edits, commits, pushes, comments, and pull requests.

Prompt examples MAY improve instruction clarity but MUST NOT contain the target repository's expected answer.

## Isolation

The benchmark copies the repository to an ephemeral directory without Git metadata and runs OpenCode against that copy. The original checkout MUST remain unchanged.

Generation receives no secrets, write token, deployment credentials, or privileged runner. Network access SHOULD be disabled unless repository inspection genuinely requires it. The runner MUST impose a timeout and retain redacted logs.

## Metrics

### Document outcome

Evaluate each candidate with the same profile gates and human quality dimensions as any authored README. Generator identity MUST be hidden from human and LLM judges.

Record:

- deterministic gate outcomes and unassessed gates;
- human dimension levels and assessment coverage;
- executable install/first-success result where safely available;
- factual regressions relative to repository evidence;
- content loss: accurate source facts, visual identity, attribution, or documentation routes removed without reason;
- unsupported additions: claims absent from accepted evidence.

### Relative outcome

Evaluate source and candidate independently before comparison. Then compare source/candidate in both presentation orders for:

- task completion;
- technical correctness;
- clarity and scanability;
- preservation of useful content;
- documentation boundaries.

Order disagreement is `uncertain`. Pairwise preference MUST NOT override an absolute gate failure.

The generator model MUST NOT be the sole judge of its own output. Prefer a human or a different model family; if the same family is unavoidable, disclose it and require human confirmation. Always run deterministic evaluation before semantic preference: a broken link or other gate failure rejects a polished candidate.

### System outcome

Record per run:

- OpenCode exit code and session ID;
- wall-clock duration;
- input, output, reasoning, and cache tokens when reported;
- provider-reported cost when reported;
- candidate extraction success;
- candidate hash and size;
- repository-copy mutation summary;
- evaluator duration.

Across repeated runs, report:

- gate pass/fail agreement;
- pairwise preference agreement;
- criterion score variance;
- unsupported-claim frequency;
- candidate similarity and material structural divergence;
- median and percentile latency, tokens, and cost.

Textual identity is not required. Repeated runs are reliable when they preserve facts and task outcomes.

## Acceptance

A prompt/model configuration is only a **candidate generator** when every pilot run:

- introduces no deterministic factual regression;
- introduces no new failed gate;
- preserves all source facts and assets classified as useful;
- reaches complete semantic assessment coverage;
- has no unsupported high-impact claim;
- is preferred or tied to the source by independent review.

Promotion beyond report-only additionally requires:

- at least three runs on each repository;
- at least six diverse repositories per profile;
- zero false factual passes in the pinned corpus;
- at least 95% successful candidate extraction;
- human inter-rater calibration required by Spec-Driven Docs;
- documented cost and latency budgets;
- a prompt/model version freeze.

No aggregate score can compensate for a factual regression. Report per-repository results before averages.

## Bias controls

- Randomize source/candidate order and evaluate both orders.
- Remove model, author, and prompt identity from candidates.
- Do not reward length, heading count, badges, or stylistic similarity to the judge.
- Require line-level evidence for every semantic finding.
- Include adversarial cases where polished generated prose contains one wrong command.
- Include preservation cases where the source contains valuable screenshots, compatibility caveats, or historical instructions.
- Audit a random sample of generated passes manually.

## Reproduction

Run a pinned manifest:

```bash
bun scripts/readme/generate.ts \
  --manifest scripts/readme/generation/pilot-webpack.json
```

The command prints the run directory. Evaluate its `candidate.md` separately:

```bash
bun scripts/readme/evaluate.ts \
  --profile skeleton \
  --readme README.md \
  /path/to/generated-readme-evaluation-copy
```

Create the evaluation copy from the retained `repository/` directory and replace only its `README.md` with the sibling `candidate.md`. Keep the retained benchmark artifact unchanged.

Live generation is optional in normal tests. Unit tests use recorded OpenCode events and never call a model.
