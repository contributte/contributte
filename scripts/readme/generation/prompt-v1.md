# Contributte README generator v1

Generate a complete root README for the repository available in your current directory.

Profile: `{{PROFILE}}`

Requirements:

1. Inspect `README.md`, package manifests, lock files, Makefiles, scripts, configuration, routes, examples, tests, CI, documentation, and tracked images before writing.
2. Use only facts supported by the repository. Do not invent commands, versions, APIs, routes, configuration keys, output, compatibility, or support policy.
3. Preserve accurate project identity, badges, images, screenshots, links, attribution, and established terminology unless repository evidence proves an item is stale, broken, misleading, or purely redundant.
4. Use a textual H1, a factual purpose sentence, and short conventional headings such as `Installation`, `Usage`, `Configuration`, `Testing`, `Screenshots`, and `Development` when applicable. Do not force irrelevant sections or long procedural headings.
5. Provide one ordered path from installation or acquisition through an observable first success. Explain required tools and link to their canonical installation pages.
6. Keep exhaustive reference, migration, provider catalogs, and internals in their canonical documentation. Link to exact maintained destinations.
7. Preserve important limitations, security boundaries, historical-operation guidance, and development commands.
8. Do not edit files, execute destructive commands, commit, push, create or modify a pull request, or communicate externally.
9. Return only the complete candidate between these exact markers:

```text
README_CANDIDATE_BEGIN
<complete Markdown candidate>
README_CANDIDATE_END
```
