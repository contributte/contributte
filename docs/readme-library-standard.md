# Contributte Library README Standard

## Profiles

[Overview](readme-standard.md) | [Library](readme-library-standard.md) | [Skeleton](readme-skeleton-standard.md) | [Deprecated](readme-deprecated-standard.md) | [Evaluation](spec-driven-docs.md)

## Scope

This standard applies to maintained reusable Composer packages. A library README is a concise landing page: it identifies the package, gives a safe installation and first-use path, states relevant compatibility, and directs readers to maintained detailed documentation.

## Writing style

Write concise, factual developer-facing English. Prefer concrete subjects, verbs, commands, paths, versions, and observable outcomes. Preserve accurate project terminology, product names, command output, and established public wording; this standard does not require stylistic rewriting when existing language is clearer or more precise.

In this standard, "factual" means verifiable from the repository, released package, or documented support policy. "Concrete" means naming the relevant command, path, version, URL, setting, or expected result. "Clear" means a reader can identify the action and outcome without promotional or implied claims.

Prefer: `Run composer require contributte/foo to install the package.`

Avoid: `This package makes integration effortless.`

Examples illustrate the required information; they are not mandatory wording. Keep project-specific terminology where it is accurate and understandable.

## Required information

A library README MUST provide:

1. A visible H1 and one factual sentence describing the package and its primary integration.
2. The published Composer package name and a copyable installation command.
3. The required framework, DI, runtime, or configuration entry point.
4. A minimal supported path through required wiring, configuration, first public use, and its observable result.
5. Compatibility information when consumers must choose between maintained PHP, framework, package, or integration lines.
6. A development or contribution route when the repository is maintained.

Use this order as a default, omitting sections that are not useful:

```md
# Package Name

One factual sentence describing the package and its primary integration.

## Installation

## Quick start

## Documentation (when separate detailed documentation exists)

## Supported versions

## Development
```

Heading names and section boundaries MAY vary when the required information remains discoverable in the same reader order. A combined `Installation` section MAY contain the minimal first-use configuration; do not create an empty `Quick start` or `Documentation` section solely to match this outline.

Use `Installation` for `composer require`; do not call installation-only content `Usage`. A development-only package MAY use `composer require --dev`, but it MUST say why.

The README MUST contain the complete minimal path through installation, the first required wiring step, the smallest valid configuration, one public use, and its observable result. For Nette integrations, this includes required extension registration or NEON configuration when installation alone does not make the package usable. Configuration alone is not a successful use: show a public service, Latte extension, command, response, rendered output, or other effect. When additional configuration is required for variants, link directly to the exact maintained documentation section; a link only to a documentation directory is insufficient. Do not show internal service IDs as normal configuration unless they are documented public extension points.

`Quick start` is one vertical slice: required activation/configuration plus the smallest public use that demonstrates successful integration. It MUST NOT become an option reference, provider inventory, migration guide, or collection of unrelated tutorials. A library with independently useful settings MAY add `## Configuration` before `## Documentation`.

## Documentation boundary

The root README and repository-local detailed documentation are complementary:

- Keep purpose, installation, compatibility, the minimal integration path, and development entrypoints in `README.md`.
- Keep exhaustive schemas, API inventories, provider lists, migration history, and long tutorials in focused documentation.
- Use relative links, for example `[Documentation](.docs/)` or a direct topic link.

If detailed repository documentation exists, the README MUST contain a `## Documentation` section naming one canonical landing page or exact first-use page. A README topic list is not a substitute unless the README itself is intentionally the canonical detailed manual.

A small library MAY keep its full manual in the README when it is the maintained primary documentation and its sections are easy to locate.

When `.docs/README.md` is the established detailed-documentation index, retain it and link to it from the root README. Do not delete the index or move its full reference content into the root README merely to consolidate files.

## Compatibility and examples

Put minimum PHP, framework, and runtime requirements with Installation. Put `## Supported versions` after `## Documentation` by default. Add a compatibility section only when users must select among multiple maintained release or integration lines; a maintained line still receives releases, compatibility fixes, or security fixes. Do not repeat the same support data in both places. Matrix values MUST match package constraints, tested CI, and release policy.

Each primary example MUST be syntactically valid, focused on one outcome, and introduced with where it belongs. Use typed code fences. Prefer constructor injection and current project conventions over legacy public-property injection or PHPDoc-heavy pseudo-code.

Dev-only packages MUST state that they belong in development/test/static-analysis dependencies, use `composer require --dev`, show the command to run after installation, and state the expected successful result. Visual or multi-provider libraries MUST show one canonical provider or data source and a visible result; provider matrices and advanced modes belong in detailed documentation.

## Links, badges, and images

Use relative links for repository-owned documentation and assets. Do not use `blob/master` URLs for files in the same repository. Use absolute HTTPS URLs for external resources, Packagist, canonical hosted documentation, and maintained public demos.

Badges are optional. If used, keep them compact and actionable: CI, package version, PHP support, license, or live coverage. Use the actual Packagist package name, which may differ from the repository name. Every image needs useful alternative text.

Images are optional. Include a repository-owned image only when it shows an output or interaction that the written example cannot show clearly. Headless integrations generally need a clear example more than a screenshot.

Do not add a manual table of contents to a short landing page. It MAY be useful for a long README with several independently useful areas; keep it shallow and maintained.

## Development and review

Document canonical quality and test commands when the repository provides them. Prefer project entrypoints such as `make qa`, `make tests`, or Composer scripts. Describe commands accurately. A maintained repository MUST provide a contributor route: prefer a repository-local `CONTRIBUTING.md`; otherwise link to applicable maintained organization guidance.

Place `## Development` after consumer documentation. Optional maintainer attribution, sponsorship, community, or support material MAY follow as a short footer; it MUST NOT interrupt installation, quick start, documentation, or compatibility information. A `## License` section or a clear link to the tracked license SHOULD appear near the end when the license is not otherwise evident.

When a change affects installation, configuration, supported versions, commands, public endpoints, or images, update the README and detailed documentation in the same pull request.

Review before merge:

- [ ] H1, purpose, package name, and install command are correct.
- [ ] The first usable path includes required wiring and has an exact next-step link when more configuration is needed.
- [ ] The primary example is checked against the current public API and states an observable successful result.
- [ ] Requirements and support data match package metadata, CI, and release policy.
- [ ] Examples are valid, typed, current, and use public supported interfaces.
- [ ] The README remains onboarding material and has one canonical detailed-docs location.
- [ ] The contributor route and canonical development commands are accurate.
- [ ] Links, assets, badges, and images resolve and are maintained.
- [ ] Markdown renders correctly on GitHub.
