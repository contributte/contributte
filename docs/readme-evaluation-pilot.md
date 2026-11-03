# README Evaluation Pilot

This pilot evaluates the draft `0.1` machine layer. It does not assign semantic quality scores.

The results below are a calibration snapshot from August 16, 2026. Repository revisions and evaluator changes can change later results; a production calibration manifest will pin both.

The machine command was `bun scripts/readme/evaluate.ts --profile <profile> --format json <repository>`. The evaluator was the uncommitted draft layered on PR #77 head `0baf123`; regression tests, rather than these prose tables, are the canonical machine-behavior record until the evaluator receives its first committed version.

## Corpus

| Repository | Profile | Calibration role |
|---|---|---|
| `contributte/openapi` PR #9 at `c387680` | Library | Strong first-use content with a structural gate failure. |
| `contributte/qa` at `3b8f795` | Library | Development-only package with fragmented onboarding and reference drift risk. |
| `contributte/webpack-skeleton` PR #992 at `3016aea` | Skeleton | Strong frontend onboarding aligned with tracked commands. |
| `contributte/webapp-skeleton` at `4671f54` | Skeleton | Contradictory, multi-route onboarding. |
| `contributte/thepay-api` at `f94a525` | Deprecated | Best available status/successor example with missing support boundaries. |
| `contributte/social` at `ee3e9f2` | Deprecated | Status notice without replacement or explicit no-replacement action. |

The corpus intentionally contains no fully compliant deprecated README. A synthetic fixture supplies the positive deterministic case; a real gold example is required before `1.0`.

## Results

| Repository | Machine status | Confirmed evidence | Unassessed evidence |
|---|---|---|---|
| OpenAPI | `blocked` | Missing H1; correct Composer install; local links resolve. | Public example execution and semantic sufficiency. |
| QA | `blocked` | Missing H1; package name matches and the visible command uses `--dev`; untyped fences. | Dependency-mode policy and first successful QA command/result. |
| Webpack skeleton PR #992 | `incomplete` | H1, package acquisition, local asset paths, typed fences, and Make targets pass. | Setup/startup path was not executed; internal anchor semantics are not implemented in draft `0.1`. |
| Webapp skeleton | `blocked` | Missing H1 and untyped fences; tracked Make references pass after calibration. | Runtime result and cross-route consistency. |
| ThePay API | `blocked` | Missing H1; prominent unsupported notice. | Successor compatibility, security posture, and historical boundary. |
| Social | `blocked` | Missing H1; prominent unsupported notice. | Replacement/no-replacement action and security posture. |

## Calibration findings

The first run exposed two false positives:

1. `deprecated=1` inside a Heatbadger image URL was mistaken for a reader-visible deprecation notice.
2. The phrase `make task` was mistaken for invocation of a target named `task`.

Both rules were narrowed and regression fixtures were added. These are discovered evaluator defects, not precision measurements; they demonstrate why new rules remain report-only until a labeled denominator exists.

The pilot also illustrates the non-compensable model:

- OpenAPI and QA both fail the H1 gate, but a human quality review should distinguish OpenAPI's focused public example from QA's fragmented onboarding.
- Webpack has no deterministic failures, but remains `incomplete` because finding commands and a URL does not prove that the documented journey works.
- Deprecated repositories cannot earn a safe status from a Heatbadger marker alone; support and next-action semantics require visible text and review.

## Next calibration

Before enforcement:

1. Expand to at least six to eight repositories per profile.
2. Add a real conforming deprecated README.
3. Obtain two blind human ratings per README.
4. Add command-result evidence for canonical examples.
5. Measure per-rule precision, false-block rate, review time, and reviewer agreement.
6. Keep machine and human/semantic reports separate until coverage thresholds are met.
