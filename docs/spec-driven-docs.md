# Spec-Driven Docs

Spec-Driven Docs is Contributte's versioned method for specifying, generating, and evaluating repository READMEs. It complements the [Library](readme-library-standard.md), [Skeleton](readme-skeleton-standard.md), and [Deprecated](readme-deprecated-standard.md) profiles.

The framework measures whether documentation is supported by evidence and helps its intended reader complete a task. It does not reward a README for matching a template, containing expected keywords, or being long.

This document defines draft version `0.1`. The draft is report-only until the [calibration requirements](#calibration) are met.

## Normative language

The keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are normative. A criterion that cannot be decided from available evidence MUST be `unassessed`; an evaluator MUST NOT guess.

## Quality model

Documentation quality has separate layers:

1. **Gates** protect readers from objectively harmful failures such as the wrong package name, a broken critical local link, or hidden deprecation.
2. **Quality dimensions** measure usefulness, clarity, flow, and maintainability with anchored review criteria.
3. **Assessment coverage** states how much applicable quality weight was actually reviewed.
4. **Maturity** describes the process used to keep documentation correct over time.

A quality score MUST NOT compensate for a failed gate. Maturity MUST NOT increase a README's quality score.

This separation follows Diátaxis's distinction between measurable functional quality and judged deep quality. Accuracy is a prerequisite for flow, not one interchangeable part of it.

## Evaluation outcomes

Every applicable rule has one outcome:

| Outcome | Meaning |
|---|---|
| `pass` | Accepted evidence proves the criterion. |
| `fail` | Accepted evidence proves a violation. |
| `unassessed` | Evidence or evaluator capability is insufficient. |
| `not-applicable` | Evidence proves the criterion does not apply. |

Absence of a finding is not a pass. `not-applicable` and exceptions require evidence.

## Evidence

Every decided gate, score, applicability decision, and exception MUST cite evidence. An `unassessed` result MUST instead identify the missing evidence or unsupported evaluator capability. Accepted evidence types are:

- `readme-span`: path, line range, excerpt, and content hash;
- `repository-fact`: path and JSON pointer, symbol, target, route, or configuration value;
- `command-result`: command, isolated environment, exit code, and redacted output hash;
- `link-check`: source, target, method, result, and evaluation time;
- `human-observation`: criterion, observed task, evidence span, reviewer, and rationale;
- `llm-observation`: criterion, evidence spans, model and prompt version, and confidence;
- `exception-record`: rule, owner, approval, rationale, compensating control, and expiry.

Repository metadata, executable configuration, source, tests, and command results override prose or model judgment for machine facts. Secrets and sensitive output MUST be redacted before evidence is stored.

## Evaluator authority

Use the narrowest evaluator capable of deciding a criterion:

1. Deterministic repository or command evidence is authoritative for machine facts.
2. Human review is authoritative for audience fit, sufficiency, ambiguity, flow, and visual meaning.
3. An optional large language model (LLM) MAY assist with qualitative review but MUST NOT pass a gate, override repository evidence, or create criteria.

A deterministic rule is repeatable, not automatically valid. New blocking rules MUST run in observation mode until their precision is measured.

## Common gates

| ID | Requirement | Primary evidence |
|---|---|---|
| `CM-ID-01` | README has one visible textual H1. | Rendered/source structure |
| `CM-OR-01` | Project purpose, audience, and primary supported task are discoverable near the beginning. | Semantic review |
| `CM-LK-01` | Critical repository-local links and images resolve without escaping the repository. | Filesystem and rendered anchors |
| `CM-SF-01` | Instructions do not expose real secrets or prescribe an incontrovertibly dangerous default. | Source plus security review |
| `CM-CL-01` | Material factual claims do not contradict authoritative repository facts. | Metadata, source, tests, CI |

Heading labels are not gates. `Installation`, `Usage`, and `Configuration` are useful conventions, not keywords required to earn points.

## Profile gates

### Library

| ID | Requirement |
|---|---|
| `LB-IN-01` | Composer installation uses the package from `composer.json`. |
| `LB-DM-01` | Runtime or development dependency mode matches package policy. |
| `LB-CP-01` | Compatibility claims do not contradict Composer constraints, CI, or maintained release policy. |
| `LB-EN-01` | Required framework, DI, runtime, or configuration entry point is present. |
| `LB-FS-01` | One path from installation through public use reaches an observable, verified result. |

### Skeleton

| ID | Requirement |
|---|---|
| `SK-IN-01` | Acquisition uses the actual supported starter, template, clone, or install model. |
| `SK-RQ-01` | Required runtimes, tools, and backing services are stated before use. |
| `SK-CM-01` | Required commands correspond to tracked scripts, targets, or entry points. |
| `SK-FS-01` | One ordered setup and startup path reaches an observable, verified result. |
| `SK-RT-01` | Development, container, and production-like routes are not misleadingly conflated. |

### Deprecated

| ID | Requirement |
|---|---|
| `DP-ST-01` | Unsupported status is unambiguous and appears before normal installation or use. |
| `DP-SP-01` | Release, compatibility, and security support posture is explicit. |
| `DP-NX-01` | The reader has a verified migration/replacement action or an explicit no-replacement decision. |
| `DP-HS-01` | Historical instructions are visibly limited to existing installations. |

## Quality dimensions

Applicable criteria are scored from `0` to `4`. The catalog below defines `0`, `2`, and `4`; use `1` or `3` only when evidence lies materially between adjacent anchors.

| Level | Anchor |
|---|---|
| `0` | Missing, false, harmful, or prevents the intended task. |
| `1` | Material gaps require source inspection or expert inference. |
| `2` | Usable with noncritical friction or omissions. |
| `3` | Clear, accurate, direct, and complete for the stated scope. |
| `4` | Verified and exemplary; anticipates likely reader needs without adding noise. |

| Dimension | Weight | Review question |
|---|---:|---|
| Technical correctness and currency | 30 | Do claims, commands, examples, versions, and links match the supported repository state? |
| Task completeness and relevance | 20 | Can the intended reader identify fit and complete the primary task without undocumented knowledge? |
| Examples and applicability | 15 | Is there one realistic, focused, copyable example with context and an observable result? |
| Information architecture and findability | 15 | Does content follow the reader journey and route reference, explanation, migration, and internals appropriately? |
| Clarity, consistency, and accessibility | 10 | Is the rendered content precise, scannable, consistent, and usable with assistive technology? |
| Maintenance and governance | 10 | Are source ownership, testing, support, security, contribution, and update paths maintainable? |

No points are awarded for word count, badge count, image count, exact heading names, or number of examples. Correlated criteria SHOULD share a capped dimension to limit score gaming.

### Criterion catalog

| ID | Dimension | Profiles | Weight | `0` | `2` | `4` |
|---|---|---|---:|---|---|---|
| `Q-TC-01` | Technical correctness | All | 60 | A material claim is false or unsafe. | Checked claims are usable with noncritical uncertainty. | All critical-path claims are verified against authoritative evidence. |
| `Q-TC-02` | Technical correctness | All | 40 | Compatibility or lifecycle guidance misleads. | Current path is correct; edge/version coverage is incomplete. | Current and maintained version boundaries are verified and explicit. |
| `Q-TS-01` | Task completeness | Library, Skeleton | 70 | Primary task cannot be completed. | Task completes with minor friction or one noncritical omission. | Clean-room reader completes it without undocumented knowledge. |
| `Q-TS-02` | Task completeness | Deprecated | 70 | Reader cannot make a safe adoption/migration decision. | Decision is possible with minor uncertainty. | Status and next action are immediate, bounded, and verified. |
| `Q-TS-03` | Task completeness | All | 30 | Audience or intended use is absent. | Audience and common use are inferable. | Fit, non-fit, and primary task are immediately clear. |
| `Q-EX-01` | Examples | Library, Skeleton | 70 | No applicable example or it fails. | Focused example works with minor omitted context. | Canonical example is executable, realistic, and tested. |
| `Q-EX-02` | Examples | All | 30 | Success cannot be observed. | Result is stated but not independently verified. | Expected result is explicit and verified. |
| `Q-IA-01` | Information architecture | All | 70 | Reader journey is blocked or mixed with unrelated reference. | Main path is discoverable with some duplication. | Content follows task order and cleanly delegates other modes. |
| `Q-IA-02` | Information architecture | All | 30 | Canonical next documentation is missing or contradictory. | Useful destinations exist but boundaries are imperfect. | Guide, reference, migration, API, and internals have explicit ownership. |
| `Q-CA-01` | Clarity and accessibility | All | 60 | Language or structure materially obscures action/meaning. | Understandable with minor ambiguity or accessibility debt. | Precise, consistent, rendered, and contextually accessibility-reviewed. |
| `Q-CA-02` | Clarity and accessibility | All | 40 | Essential visual/link/code meaning is inaccessible. | Alternatives exist with minor contextual gaps. | All essential content has verified equivalent text and clear link purpose. |
| `Q-MG-01` | Maintenance and governance | All | 60 | No reliable update, support, or ownership route. | Basic contributor/support route exists. | Docs ownership and change acceptance are integrated with releases. |
| `Q-MG-02` | Maintenance and governance | All | 40 | Examples and links have no repeatable checks. | Some deterministic checks exist. | Canonical examples, links, compatibility, and generated output are continuously verified. |

Criterion weights are relative within their dimension. A criterion is applicable only to the listed profile and current repository capabilities. Capability-based exclusion requires evidence.

## Scoring

For applicable criterion `c`:

```text
criterion score = rubric level / 4

dimension score =
  100 * sum(criterion weight * criterion score)
      / sum(applicable criterion weight)

quality score =
  sum(dimension weight * dimension score)
      / sum(applicable dimension weight)

assessment coverage =
  assessed applicable criterion weight
      / all applicable criterion weight
```

`unassessed` criteria remain in the coverage denominator and are excluded from the score numerator and assessed-weight denominator. A dimension with no assessed applicable criterion has no score and forces final status `incomplete`. `not-applicable` criteria are excluded from both score and coverage only with evidence. A report MUST show gates, dimension scores, coverage, and exceptions beside the aggregate score.

## Status

| Status | Conditions |
|---|---|
| `certified` | All gates pass, score at least 80, every dimension at least 60, coverage at least 90%, and no active gate waiver. |
| `conformant` | Gates pass or are formally waived, score at least 70, every dimension at least 50, and coverage at least 75%. |
| `needs-improvement` | Gates pass but quality conditions for `conformant` are not met. |
| `blocked` | One or more unwaived gates fail. |
| `incomplete` | No gate is known to fail, but gate coverage is below 100%, a dimension has no score, or quality coverage is below 75%. |

Status precedence is `blocked`, `incomplete`, `certified`, `conformant`, then `needs-improvement`: evaluate the first matching condition in that order. A waived gate is not a pass; record its original outcome and exception ID. An active gate waiver caps the status at `conformant`. Numeric scores MUST NOT be used for cross-repository leaderboards.

During report-only mode, evaluators MUST NOT publish `certified`, `conformant`, or `needs-improvement` as official repository labels. They MAY calculate hypothetical statuses for calibration when clearly marked non-normative.

## Language evaluation

English evaluation has three layers:

### Deterministic policy

High-precision custom rules MAY block incorrect product names, conflicting governed terminology, adjacent duplicate words, known deprecated terms, or an exact package/namespace mismatch. [Vale](https://vale.sh/) is the recommended policy engine because its rules and scopes are project-controlled.

An error-level prose rule MUST first demonstrate at least 95% precision on reviewed Contributte findings. Broader Google, Microsoft, grammar, and inclusive-language rule packs start as advisory.

### Heuristic signals

Grammar candidates, passive-voice detection, bare demonstratives, long sentences, readability formulas, and inclusive-language scanners are review signals. They MUST NOT independently fail a README or contribute points.

Technical identifiers distort readability formulas. Strip code, commands, URLs, badges, and generated tables before measurement. Prefer changes against a repository baseline over universal grade-level targets.

### Semantic review

A semantic reviewer checks:

- whether purpose and audience are identifiable;
- whether prerequisites precede dependent steps;
- whether ordered procedures use one principal action per step;
- whether configuration leads to a public behavior;
- whether the result is observable;
- whether terminology is accurate and consistent;
- whether claims are unambiguous and evidence-backed;
- whether detail is in the correct README, guide, reference, migration, API, or internal layer.

The reviewer MUST cite the affected span and state the reader action or conclusion affected by a defect.

## Accessibility

Published content MUST satisfy applicable WCAG 2.2 Level A and AA requirements within the author's control. Evaluation covers the rendered GitHub surface, not only Markdown source.

Automated checks include title/heading structure, local references, typed and closed code fences, simple table headers, and image alt-text presence. Human review decides heading meaning, link purpose in context, whether alt text is equivalent, whether visuals rely on color, and whether complex diagrams have a complete text equivalent.

A report MAY state only which selected accessibility checks and contextual reviews passed, with their mapped WCAG success criteria. It MUST NOT claim WCAG conformance or broad WCAG alignment from source lint alone.

| Selected check | WCAG 2.2 mapping | Authority |
|---|---|---|
| Informative images and linked badges have equivalent text alternatives. | 1.1.1 Non-text Content | Machine presence plus human equivalence review |
| Heading structure and labels communicate document relationships and purpose. | 1.3.1 Info and Relationships; 2.4.6 Headings and Labels | Machine structure plus human meaning review |
| Link purpose is understandable in context. | 2.4.4 Link Purpose (In Context) | Human review; machine candidates only |
| Visual content does not use color as its only cue. | 1.4.1 Use of Color | Human rendered review |
| Author-controlled visual text and meaningful graphics meet applicable contrast. | 1.4.3 Contrast (Minimum); 1.4.11 Non-text Contrast | Rendered/image review |
| Source order and procedures preserve a meaningful sequence. | 1.3.2 Meaningful Sequence | Human task review |

## Executable documentation

Validation is layered:

1. Parse/lint Markdown and validate local links and images.
2. Parse PHP, NEON, JSON, YAML, and shell examples where their mode is known.
3. Test canonical examples through the package's normal test and static-analysis tools.
4. Test library installation from a clean consumer and skeleton setup from a clean directory.
5. Check external links and fresh ecosystem resolution on a scheduled job with retries.

README code is untrusted repository code. An evaluator MUST NOT execute arbitrary fences. Executable blocks require an explicit profile, ephemeral sandbox, no secrets or write token, bounded resources and time, redacted output, and network disabled unless the task requires it.

## LLM review

LLM review is optional and restricted to qualitative criteria.

- Use one criterion and its anchors at a time.
- Supply relevant README spans and repository facts.
- Require structured output and exact evidence locations.
- Record model, prompt/spec version, content hashes, and evaluation time.
- Permit `unassessed` and uncertainty.
- Reject unsupported findings.
- Never let an LLM pass a gate or override command/repository evidence.

For revision comparison, evaluate old/new and new/old order. Position disagreement becomes `uncertain`. Pairwise preference cannot rescue an absolute factual failure. Human review resolves material conflicts.

## Exceptions

An exception targets one rule and records:

- repository-specific rationale;
- evidence and compensating control;
- owner and approving maintainer;
- approval and expiry dates.

Expired exceptions fail closed. Permanent cross-repository differences belong in a new specification version, not an evergreen waiver.

## Maturity

Maturity is reported separately:

| Level | Description |
|---|---|
| `L0 Present` | README and license exist; project identity is recognizable. |
| `L1 Usable` | Identify, evaluate, install/use, and help paths are manually reviewed. |
| `L2 Verified` | Deterministic checks and canonical examples run in CI. |
| `L3 Maintained` | Compatibility, ownership, support/security, and docs lifecycle are release-governed. |
| `L4 Evidence-led` | User task tests, friction logs, feedback, or support data drive revisions. |

`L2` is the intended release baseline; `L3` is the target for maintained Contributte packages. Small repositories are not penalized for omitting process that does not improve their users' tasks.

## Calibration

Before draft `0.1` can become an enforced `1.0`:

1. Select at least six to eight diverse repositories per profile.
2. Obtain two blind human reviews per README and adjudicate material disagreements.
3. Record raw labels and evidence, not only aggregate scores.
4. Run machine-only, machine-plus-human, and optional machine-plus-LLM modes.
5. Re-run the complete corpus after every rule, weight, threshold, parser, prompt, or model change.

Initial targets are:

- hard-gate false-pass rate: `0%` in adversarial fixtures;
- hard-gate false-block rate: below `5%`;
- machine rule precision before blocking: at least `95%`;
- ordinal human agreement: Krippendorff's alpha at least `0.67` for exploration and target `0.80` for merge decisions;
- LLM unsupported-evidence rate: below `2%`;
- assessment coverage for certification: at least `90%`;
- median machine evaluation: below 60 seconds, excluding sandbox execution;
- median full human review: below 15 minutes.

Measure false pass/block rates against adjudicated gate labels across the pinned corpus. Measure rule precision as confirmed findings divided by reviewed findings, counting `unassessed` separately. Measure unsupported LLM evidence as judge claims without an accepted cited source divided by all judge claims. Report sample size, profile mix, evaluator version, reviewer agreement method, and confidence intervals where practical. These thresholds are Contributte rollout policy, not universal documentation constants.

The rollout is report-only, then deterministic gates on changed READMEs, then optional conformance enforcement. `certified` SHOULD NOT be required as an initial merge gate.

## References

This framework is informed by, but does not claim conformance with, these sources:

- [ISO/IEC/IEEE 26514:2022](https://www.iso.org/standard/77451.html), user information needs, structure, content, format, and lifecycle;
- [Diátaxis quality model](https://diataxis.fr/quality/) and documentation modes;
- [GitHub README guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes) and [GitHub Flavored Markdown](https://github.github.com/gfm/);
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/) and WAI tutorials;
- [Google developer documentation style guide](https://developers.google.com/style) and [procedures](https://developers.google.com/style/procedures);
- [Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/);
- [Vale](https://vale.sh/) and [Write the Docs testing guidance](https://www.writethedocs.org/guide/tools/testing/);
- [Google Open Docs maturity checklist](https://github.com/google/opendocs/blob/main/audit/checklist.md);
- [The Good Docs Project README guide](https://www.thegooddocsproject.dev/template/readme);
- [Learning to Judge: LLMs Designing and Applying Evaluation Rubrics](https://aclanthology.org/2026.findings-eacl.335/), especially reduced reliability in factual settings.

ISO 26514 is a broader, partly paywalled standard. Contributte uses its public lifecycle principles as an influence and MUST NOT represent this lightweight framework as ISO certification.
