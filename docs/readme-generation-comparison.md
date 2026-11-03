# README Generation Model Comparison

This report compares report-only runs of GPT 5.6 Sol, Terra, and Luna on the same pinned Webpack Skeleton input while refining prompts v2 through v4. It identifies a candidate for further calibration, not a generally best model.

## Controls

All runs use:

- repository revision `3016aea65daf27eea408e0a688ef6ab516fb9d80`;
- source README SHA-256 `c36d5b988796f4baec899070b129ad15df2da2dd6418d3d800deed1c303ca8cc`;
- Skeleton profile;
- one immutable prompt version per round;
- OpenCode `--pure`, JSON output, variant `high`, and a 600-second timeout;
- a clean detached worktree copied without Git metadata;
- identical deterministic and semantic review criteria.

## Selection order

Compare models in this non-compensable order:

1. Successful extraction and no repository mutation.
2. No factual regression or unsupported high-impact claim.
3. Complete and correctly ordered first-success path.
4. Interactive dev-server route before passive watcher/build alternatives.
5. Browser URL, proxy behavior, and overrides separated for scanning.
6. Evidence-backed maintenance/ownership and contribution route.
7. Useful source identity, links, visuals, caveats, and attribution preserved.
8. Lower latency and token use only after document outcomes are tied.

The table and findings below are populated from retained run artifacts. A single run per model is insufficient to establish repeatability.

## Prompt evolution

- **v2** added dev-server priority, scannable overrides, and ownership. Sol returned a marked refusal rather than a README. Terra exposed an extractor defect by emitting progress text before a valid final candidate. Luna produced the only accepted full candidate.
- **v3** restricted status/refusal output, accepted only the final assistant response, discouraged command catalogs, and clarified repository ownership. All models produced full candidates. Terra was the most task-focused; Luna preserved more visual identity; Sol added useful caveats but included a questionable Node lock-file requirement and excessive deployment detail.
- **v4** required preservation of useful existing visuals and an explicit repository-backed success signal. All models preserved the demo identity and described visible first success. Luna preserved all screenshots but introduced a broken link to ignored `config/local.neon`, causing a hard `CM-LK-01` failure. Sol and Terra passed all implemented machine checks; Terra remained more concise.

## Final round

| Model | Extraction | Mutation | Machine result | Semantic result | Duration | Input/output/cache-read tokens |
|---|---|---|---|---|---:|---:|
| Sol v4 | Pass | None | 7 pass, 0 fail, 7 unassessed | Accurate and useful, but broader than needed | 136,055 ms | 63,406 / 5,618 / 152,064 |
| Terra v4 | Pass | None | 7 pass, 0 fail, 7 unassessed | Best task focus; all feedback criteria addressed; screenshots removed | 133,008 ms | 71,904 / 5,240 / 143,872 |
| Luna v4 | Pass | None | 6 pass, 1 fail, 7 unassessed | Best visual preservation, but broken local link | 137,984 ms | 69,011 / 5,619 / 216,448 |

Provider-reported cost was `0` for every run. This is retained as provider output, not interpreted as proof that generation is free.

## Decision

**Provisional choice: prompt v4 with `9router/cx/gpt-5.6-terra`.**

Terra is the only final-round candidate that combines no implemented gate failure, concise task ordering, dev-server priority, scannable URL/proxy/override guidance, explicit repository ownership, preserved demo identity, and a concrete first-success signal. Sol remains a useful second reviewer for security and deployment caveats. Luna is not selected because its broken local link is non-compensable, despite superior screenshot preservation.

This choice applies only to this pinned Skeleton case. It does not satisfy the benchmark's repeatability or multi-repository acceptance requirements. Future calibration should run at least three repetitions and include Library and Deprecated profiles plus private or synthetic holdouts.
