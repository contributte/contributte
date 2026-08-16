# Contributte Skeleton README Standard

## Scope

This standard applies to starters, reference applications, demos, and integration projects. A skeleton README is the shortest reliable route from discovery to a verified local success.

## Required information

A skeleton README MUST state whether it is a starter, reference application, demo, or integration demonstration. It MUST give one complete, verified route to a first success:

1. Requirements.
2. The correct acquisition model.
3. Dependency installation and local configuration.
4. Required services, migrations, fixtures, or builds.
5. Application, API, CLI, or protocol startup.
6. A URL, request, command output, or client interaction that proves success.

Use this order as a default, omitting irrelevant sections:

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

The README MUST distinguish acquisition models:

- A consumer-ready starter uses `composer create-project`.
- A checked-out example or integration uses `composer install`.
- Document both only when both workflows are supported and their purposes are clear.

## Configuration and runtime paths

Document the minimum configuration needed for the recommended path: config file/environment source, local or gitignored status, values that must change, and values that differ in containers. Label demo credentials as development-only.

Document Docker only when it is a supported or recommended onboarding path. A Docker path MUST be complete: services, hostnames, ports, follow-up migrations/builds/workers, and user-facing URLs. Do not advertise Docker merely because a Make target or maintenance file exists.

Use `http://localhost:<port>` or `http://127.0.0.1:<port>` for browser instructions. `0.0.0.0` is a bind address, not a reader-facing URL.

## Variant-specific additions

- **API skeletons** MUST include the base URL, a health/ping endpoint, an API/OpenAPI discovery endpoint when available, and one copyable successful request. Explain authentication or development tokens.
- **Worker/DDD skeletons** MUST state backing services, startup order, and consumer/worker commands when central to the example.
- **Frontend skeletons** MUST state PHP and frontend runtime requirements, dependency installation, watch/build commands, and whether frontend and PHP processes run separately.
- **MCP/protocol skeletons** MUST describe each transport separately, including its connection URL or STDIO command and required inspector/client workflow.
- **CMS skeletons** MUST document install/development/build/start commands, local admin/bootstrap behavior, and configuration grouped by subsystem.
- **Security-focused integrations** MUST state secure defaults and data-sharing or credential implications before opt-in instructions.

## Links, visuals, and development

A maintained demo link SHOULD appear near the purpose section when it helps users choose the project. Screenshots or GIFs MAY be included for UI and protocol workflows, but only when they have meaningful alt text/captions and support the instructions rather than replace them.

Use relative links for repository-owned files and assets. Do not use `blob/master` URLs for local files. Keep architecture, troubleshooting, and exhaustive dependency material in focused documentation when it would obscure onboarding.

Document canonical quality and test commands when the repository provides them. Prefer project entrypoints such as `make qa`, `make tests`, `composer test`, or `npm run test`. Describe commands accurately.

Avoid generic encouragement such as "Open the page and enjoy" without stating the expected route, interaction, or output.

Review before merge:

- [ ] Project type, audience, and first success are clear.
- [ ] Requirements, acquisition model, commands, services, ports, and URLs match tracked sources.
- [ ] The quick-start sequence is complete and one route is clearly recommended.
- [ ] Configuration scope, development-only credentials, and security implications are clear.
- [ ] Docker is complete when documented and omitted when it is not a supported user path.
- [ ] Variant-specific API, worker, frontend, protocol, CMS, or security rules are covered.
- [ ] Links and visual assets resolve; Markdown renders correctly on GitHub.
