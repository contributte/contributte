# Contributte Library README Standard

## Scope

This standard applies to maintained reusable Composer packages. A library README is a concise landing page: it identifies the package, gives a safe installation and first-use path, states relevant compatibility, and directs readers to maintained detailed documentation.

## Required information

A library README MUST provide:

1. A visible H1 and one factual sentence describing the package and its primary integration.
2. The published Composer package name and a copyable installation command.
3. The required framework, DI, runtime, or configuration entry point.
4. A minimal valid use/configuration path, or a direct link to the exact maintained documentation page containing it.
5. Compatibility information when consumers must choose between maintained PHP, framework, package, or integration lines.
6. A development or contribution route when the repository is maintained.

Use this order as a default, omitting sections that are not useful:

```md
# Package Name

One factual sentence describing the package and its primary integration.

## Installation

## Quick start

## Documentation

## Supported versions

## Development
```

Use `Installation` for `composer require`; do not call installation-only content `Usage`. A development-only package MAY use `composer require --dev`, but it MUST say why.

For Nette integrations, the first-use path MUST include required extension registration or NEON configuration when installation alone does not make the package usable. Do not show internal service IDs as normal configuration unless they are documented public extension points.

## Documentation boundary

The root README and repository-local detailed documentation are complementary:

- Keep purpose, installation, compatibility, the minimal integration path, and development entrypoints in `README.md`.
- Keep exhaustive schemas, API inventories, provider lists, migration history, and long tutorials in focused documentation.
- Use relative links, for example `[Documentation](.docs/)` or a direct topic link.

A small library MAY keep its full manual in the README when it remains the practical canonical documentation and is navigable.

## Compatibility and examples

State requirements near installation when a support decision is non-obvious. Use a compact support matrix only when multiple maintained lines or integrations require it. Matrix values MUST match package constraints, tested CI, and release policy.

Each primary example MUST be syntactically valid, focused on one outcome, and introduced with where it belongs. Use typed code fences. Prefer constructor injection and current project conventions over legacy public-property injection or PHPDoc-heavy pseudo-code.

## Links, badges, and images

Use relative links for repository-owned documentation and assets. Do not use `blob/master` URLs for files in the same repository. Use absolute HTTPS URLs for external resources, Packagist, canonical hosted documentation, and maintained public demos.

Badges are optional. If used, keep them compact and actionable: CI, package version, PHP support, license, or live coverage. Use the actual Packagist package name, which may differ from the repository name. Every image needs useful alternative text.

Images are optional. Include a repository-owned image only when it demonstrates a meaningful UI, CLI, or result. Headless integrations generally need a clear example more than a screenshot.

Do not add a manual table of contents to a short landing page. It MAY be useful for a long README with several independently useful areas; keep it shallow and maintained.

## Development and review

Document canonical quality and test commands when the repository provides them. Prefer project entrypoints such as `make qa`, `make tests`, or Composer scripts. Describe commands accurately.

When a change affects installation, configuration, supported versions, commands, public endpoints, or images, update the README and detailed documentation in the same pull request.

Review before merge:

- [ ] H1, purpose, package name, and install command are correct.
- [ ] Required Nette/framework wiring is shown or directly linked.
- [ ] Requirements and support data match package metadata, CI, and release policy.
- [ ] Examples are valid, typed, current, and use public supported interfaces.
- [ ] The README remains onboarding material and has one canonical detailed-docs location.
- [ ] Links, assets, badges, and images resolve and are maintained.
- [ ] Markdown renders correctly on GitHub.
