# Contributte README Standard

## Purpose and scope

This standard applies to root `README.md` files in maintained Contributte repositories.

The README is the reliable entry point for a new user or contributor. It explains what a repository is, how to reach a first successful result, and where to find maintained detail. It is not a copy of every configuration reference, changelog, or implementation guide.

Choose the profile that matches the repository:

- **Library**: a reusable Composer package.
- **Skeleton**: a starter, reference application, demo, or integration project.
- **Demo or example**: use the closest profile and document only the runnable surface it actually provides.

The keywords **MUST**, **SHOULD**, and **MAY** describe required, recommended, and optional practices.

## Sources of truth

Before editing a README, verify machine facts in tracked executable sources:

- `composer.json`, `package.json`, and lock files for runtime and package requirements;
- `Makefile`, Composer scripts, and npm scripts for commands;
- framework configuration and `.env.example` / `config/local.neon.example` for setup;
- Docker and Compose files for services, ports, hostnames, and credentials;
- routes, CLI commands, tests, and CI for documented outcomes and quality commands.

The README is authoritative for the supported user journey. Executable configuration is authoritative for machine facts. Detailed local documentation is authoritative for reference material. Do not let two locations make conflicting claims.

## Universal rules

Every README:

- MUST begin with a visible H1 that identifies the project.
- MUST open with a concise, factual explanation of what it provides and who should use it.
- MUST use only verified commands, versions, URLs, ports, credentials, service names, and feature claims.
- MUST keep repository-owned links and assets relative where possible.
- MUST use typed fenced code blocks such as `bash`, `php`, `neon`, `json`, or `yaml`.
- MUST clearly mark local/demo credentials and MUST NOT publish real secrets or imply that example credentials are safe in production.
- SHOULD use direct, concise technical English: "Install", "Create", "Configure", "Run", and "Use".
- SHOULD keep a first useful action near the top.
- SHOULD link to focused documentation instead of duplicating exhaustive reference material.
- MAY include badges, screenshots, demos, support links, maintainers, version matrices, and a table of contents only when they are accurate and maintained.

Do not copy historical boilerplate by default. In particular, tracking images, badge walls, remote screenshot services, stale social links, author-avatar blocks, uncaptioned galleries, and branch-qualified links to local files are not standard requirements.

## Libraries

### Required information

A library README MUST provide:

1. The Composer package name and a copyable installation command.
2. The primary framework, DI, or runtime integration point when relevant.
3. A minimal valid use/configuration path, or a direct link to the exact maintained documentation page that contains it.
4. Compatibility information when consumers must choose between maintained package, PHP, framework, or integration lines.
5. A contribution or development route when the repository is maintained.

Use the following order as a default, omitting sections that are not useful:

```md
# Package Name

One factual sentence describing the package and its primary integration.

## Installation

## Quick start

## Documentation

## Supported versions

## Development
```

Use `Installation` for `composer require`; do not call installation-only content `Usage`. For a development-only package, use `composer require --dev` and say why.

For Nette integrations, the first-use path MUST include the required extension registration or NEON configuration when installation alone does not make the package usable. Do not expose internal service IDs as normal configuration unless they are a documented public extension point.

### Documentation boundary

The concise Contributte library landing page and repository-local `.docs` material are complementary:

- Keep purpose, installation, compatibility, the minimal integration path, and development entrypoints in the root README.
- Keep exhaustive schemas, API inventories, provider lists, migration history, and long tutorials in focused documentation.
- Link with a relative path, for example `[Documentation](.docs/)` or a direct topic link.

A small library MAY keep its full manual in the README when that remains the practical canonical documentation and is still navigable.

### Compatibility and examples

State requirements near installation when a support decision is non-obvious. Use a compact matrix only when multiple maintained lines or integrations require it. Matrix values MUST match package constraints, tested CI, and actual release policy.

Each primary example MUST be syntactically valid, focused on one outcome, and introduced with where it belongs. Prefer constructor injection and current project conventions over legacy public-property injection or PHPDoc-heavy pseudo-code.

### Library visuals and badges

Badges are optional. If used, keep them compact and actionable: CI, package version, PHP support, license, or live coverage. Use the actual Packagist package name, which may differ from the repository name. Every image needs useful alternative text.

Images are optional. Include a repository-owned image only when it demonstrates a meaningful UI, CLI, or result. Headless integrations generally need a clear example more than a screenshot.

## Skeletons

### Required information

A skeleton README MUST state whether it is a starter, reference application, demo, or integration demonstration. It MUST give one complete, verified route to a first success:

1. Requirements.
2. Correct acquisition model.
3. Dependency installation and local configuration.
4. Required services, migrations, fixtures, or builds.
5. Application, API, CLI, or protocol startup.
6. The browser URL, request, command output, or client interaction that proves success.

Use this default order, omitting irrelevant sections:

```md
# Project Name

One factual sentence describing the intended use and defining integrations.

## Purpose

## Requirements

## Quick start

## Configuration

## Docker

## Development and quality checks

## Further documentation
```

The README MUST distinguish the acquisition models:

- A consumer-ready starter uses `composer create-project`.
- A checked-out example or integration uses `composer install`.
- Document both only when both workflows are supported and their different purposes are clear.

### Configuration and runtime paths

Document the minimum configuration needed for the recommended path: config file/environment source, local or gitignored status, values that must change, and values that differ in containers. Label demo credentials as development-only.

Document Docker only when it is a supported or recommended onboarding path. A Docker path MUST be complete: services, hostnames, ports, follow-up migrations/builds/workers, and user-facing URLs. Do not advertise Docker merely because a Make target or maintenance file exists.

Use `http://localhost:<port>` or `http://127.0.0.1:<port>` for browser instructions. `0.0.0.0` is a bind address, not a reader-facing URL.

### Variant-specific additions

- **API skeletons** MUST include the base URL, a health/ping endpoint, an API/OpenAPI discovery endpoint when available, and one copyable successful request. Explain authentication or development tokens.
- **Worker/DDD skeletons** MUST state backing services, startup order, and consumer/worker commands when central to the example.
- **Frontend skeletons** MUST state PHP and frontend runtime requirements, dependency installation, watch/build commands, and whether frontend and PHP processes run separately.
- **MCP/protocol skeletons** MUST describe each transport separately, including its connection URL or STDIO command and required inspector/client workflow.
- **CMS skeletons** MUST document install/development/build/start commands, local admin/bootstrap behavior, and configuration grouped by subsystem.
- **Security-focused integrations** MUST state secure defaults and data-sharing or credential implications before opt-in instructions.

### Skeleton visuals and tone

A maintained demo link SHOULD appear near the purpose section when it helps users choose the project. Screenshots or GIFs MAY be included for UI and protocol workflows, but only when they have meaningful alt text/captions and support the instructions rather than replace them.

Avoid generic encouragement such as "Open the page and enjoy" without saying what should work. State the expected route, interaction, or output.

## Links, images, and navigation

Use relative links for repository-owned files and assets. Do not use `blob/master` URLs for files in the same repository. Use absolute HTTPS URLs for external resources, canonical hosted documentation, Packagist, and maintained public demos.

Use images only when they communicate information more effectively than text. Store durable assets in the repository, provide useful alt text, and prefer Markdown over complex HTML. Minimal HTML is acceptable for a real rendering need such as image width.

Do not add a manual table of contents to a short README. It MAY be useful when a long README has several independently useful areas and GitHub's outline is insufficient. Keep it shallow and maintain it with the headings.

## Development and maintenance

Document canonical quality and test commands when the repository provides them. Prefer project entrypoints such as `make qa`, `make tests`, `composer test`, or `npm run test` to unverified implementation details. Describe commands accurately; a QA target is not a test target unless it runs tests.

Link to repository-specific contribution guidance when available. Keep maintainer and sponsor information factual, current, and secondary to onboarding.

When a change affects documented installation, configuration, a runtime version, a command, a port, a credential, an endpoint, or an image, update the relevant README and detailed documentation in the same pull request.

## Review checklist

- [ ] The repository profile is correct: library, skeleton, demo, or example.
- [ ] The opening identifies the project, intended user, and primary outcome.
- [ ] Commands, requirements, versions, URLs, ports, services, and configuration match tracked sources.
- [ ] The first-success path is complete for the selected profile.
- [ ] Configuration scope, local-only values, and secret safety are clear.
- [ ] README content is onboarding material; detailed documentation has one canonical location.
- [ ] Local links and images are relative, resolve, and have useful text alternatives where needed.
- [ ] Badges, visuals, and contact links are relevant, live, and not inherited decoration.
- [ ] Examples are valid, typed, current, and show public supported interfaces.
- [ ] Markdown renders correctly on GitHub.

## Exceptions

This standard deliberately avoids a fixed copy/paste template. A repository MAY depart from a MUST when its runtime model makes the rule inapplicable. State the rule, the repository-specific reason, the alternate documentation location, and a review date for temporary exceptions in the pull request description. A maintainer must approve the exception.

Cross-repository exceptions belong in an RFC and require an update to this standard.
