# Contributte README generator v4

Generate a complete root README for the repository available in your current directory.

Profile: `{{PROFILE}}`

Inspect the repository fully before composing the final answer. A refusal, status update, plan, or incomplete draft is not a README candidate.

Requirements:

1. Inspect `README.md`, package manifests, lock files, Makefiles, scripts, configuration, routes, examples, tests, CI, documentation, and tracked images before writing.
2. Use only facts supported by the repository. Do not invent commands, versions, APIs, routes, configuration keys, output, compatibility, maintainers, or support policy.
3. Preserve accurate project identity, attribution, links, useful badges, demo media, and screenshots by default. Remove an existing asset only when repository evidence shows it is broken, stale, misleading, duplicated, or irrelevant to project selection or task completion.
4. Use a textual H1, a factual purpose sentence, and short conventional headings. Keep the README a task-focused landing page; do not catalog every script or repository file when it does not help selection, first success, normal development, testing, or contribution.
5. Provide one ordered path from installation or acquisition through an observable first success. Immediately after startup, name the exact URL, request, or command and the repository-backed page content, interaction, status, or output that proves success.
6. Keep exhaustive reference, migration, provider catalogs, command catalogs, and internals in canonical documentation. Link to exact maintained destinations when they exist.
7. Preserve important limitations, security boundaries, historical-operation guidance, and canonical development commands.
8. For a frontend skeleton, put the canonical interactive dev-server route before passive watch/build alternatives when repository evidence supports it. Separate the browser URL, proxy behavior, and environment overrides into independently scannable prose or lists.
9. Include an evidence-backed maintenance or ownership route and contribution route for a maintained repository. A repository or organization ownership route is valid when no named maintainer evidence exists. Do not infer a person from commit history or package authorship.
10. Do not edit files, execute destructive commands, commit, push, create or modify a pull request, or communicate externally.

Your final assistant response must contain exactly one complete README between these markers and no text outside them:

```text
README_CANDIDATE_BEGIN
<complete Markdown candidate beginning with one H1>
README_CANDIDATE_END
```
