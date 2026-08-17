# Contributte README Standards

Contributte maintains separate README standards because a reusable library, a runnable skeleton, and a deprecated repository serve different readers.

- [Library README Standard](readme-library-standard.md) for maintained reusable packages.
- [Skeleton README Standard](readme-skeleton-standard.md) for starters, reference applications, demos, and integration projects.
- [Deprecated Repository README Standard](readme-deprecated-standard.md) for archived, abandoned, superseded, or otherwise unsupported libraries.
- [Spec-Driven Docs](spec-driven-docs.md) for evidence-based evaluation, scoring, and calibration.
- [README Evaluation](readme-evaluation.md) for machine, human, and optional LLM review.
- [README Generation Evaluation](readme-generation-evaluation.md) for pinned OpenCode prompt/model benchmarks.

The keywords **MUST**, **SHOULD**, and **MAY** describe required, recommended, and optional practices. A repository uses the profile that matches its current maintenance state and intended user journey.

Select the profile by the first supported journey presented to a new reader, not by the repository name or whether it is published on Packagist:

- Use the Library profile when the README's supported first journey is installing the repository as a dependency.
- Use the Skeleton profile when the README's supported first journey is obtaining or running the repository to start or evaluate an application. Maintained demos and examples use this profile.
- Use the Deprecated profile for unsupported repositories regardless of their former type.

A repository that supports both dependency installation and a runnable application MUST select one primary profile and link to the other supported journey without duplicating its full instructions.

## Shared evidence rules

Before editing any README, verify machine facts in tracked sources:

- `composer.json`, `package.json`, and lock files for requirements and package names;
- `Makefile`, Composer scripts, and npm scripts for commands;
- configuration, routes, Docker/Compose files, and environment templates for setup;
- tests and CI for supported flows and quality commands.

The README is authoritative for the supported user journey. Executable configuration is authoritative for machine facts. Detailed documentation is authoritative for reference material. Do not let two locations make conflicting claims.

All profiles require clear technical English, typed code fences, relative repository links where possible, and no real secrets. Do not copy historical boilerplate by default: tracking images, badge walls, remote screenshot services, stale social links, author-avatar blocks, and branch-qualified links to local files are never required.

## Exceptions

The standards describe outcomes, not copy/paste templates. A rule that genuinely does not apply uses `not-applicable` with repository evidence, not an exception. A repository MAY temporarily depart from an applicable MUST only through the [Spec-Driven Docs exception format](spec-driven-docs.md#exceptions): rule ID, repository-specific reason, evidence, compensating control, owner, maintainer approval, and expiry date.

Cross-repository exceptions require an RFC and an update to the relevant standard.
