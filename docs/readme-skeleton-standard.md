# Contributte Skeleton README Standard

## Profiles

[Overview](readme-standard.md) | [Library](readme-library-standard.md) | [Skeleton](readme-skeleton-standard.md) | [Deprecated](readme-deprecated-standard.md) | [Evaluation](spec-driven-docs.md)

## Scope

This standard applies to starters, reference applications, demos, and integration projects. A skeleton README is a concise, complete route from obtaining the project to verifying it locally.

## Writing style

Write concise, factual developer-facing English. Prefer concrete subjects, verbs, commands, paths, versions, and observable outcomes. Preserve accurate project terminology, product names, command output, and established public wording; this standard does not require stylistic rewriting when existing language is clearer or more precise.

In this standard, "factual" means verifiable from the repository, released package, or documented support policy. "Concrete" means naming the relevant command, path, version, URL, setting, or expected result. "Clear" means a reader can identify the action and outcome without promotional or implied claims.

Prefer: `Open http://localhost:8080/health; it returns {"status":"ok"}.`

Avoid: `Open the application and enjoy.`

Examples illustrate the required information; they are not mandatory wording. Keep project-specific terminology where it is accurate and understandable.

## Required information

A skeleton README MUST state whether it is a starter, reference application, demo, or integration demonstration. It MUST give one complete, verified route to a first success:

1. Requirements.
2. The correct acquisition model.
3. Dependency installation and local configuration.
4. Required services, migrations, fixtures, or builds.
5. Application, API, CLI, or protocol startup.
6. A URL, request, command output, or client interaction that proves success.

The README MUST begin with a single H1 followed immediately by a factual sentence that identifies the repository as a starter, reference application, demo, or integration demonstration. A `Purpose` section may expand this but MUST NOT be the first declaration of project type.

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

Heading names and section boundaries MAY vary when the required information remains discoverable in the same reader order. `Quick start` MAY include the minimum local configuration and runtime commands when that is the complete recommended route; use a separate `Configuration` section when readers need it independently.

The first reader-facing onboarding path MUST preserve execution order: requirements, acquisition, dependency installation and any required local configuration, backing services/data/assets, runtime, then verification. Later operational sections MUST NOT be required to complete an earlier Quick start.

Quick start MUST end with a copyable proof immediately after startup: an exact browser route and expected interaction for a web application, a request with expected status/body for an API, a command with representative output for a CLI, a dispatched message with consumer evidence for a worker, or a client/Inspector interaction for a protocol integration.

The README MUST distinguish acquisition models:

- A consumer-ready starter uses `composer create-project`.
- A checked-out example or integration uses `composer install`.
- Document both only when both workflows are supported and their purposes are clear.

A starter's Quick start MUST use `composer create-project` or an equivalent acquisition path. A checked-out reference or demo MUST state clone/template acquisition before `composer install` or `npm ci`. A consumer-ready starter MUST NOT present `composer install` alone as its acquisition route.

## Configuration and runtime paths

The recommended route MUST have been run against the current tracked repository state and SHOULD be covered by an automated smoke or integration check when practical. Mark one route as recommended. Alternative host, Docker, or production-like routes MAY follow it and MUST identify their differing prerequisites, commands, ports, and success signal.

When the recommended route requires a database, queue, cache, broker, or other backing service, it MUST start that service with its host, port, and development-only credentials, or make a self-contained Compose path the recommended route. Docker Compose is a requirement only when the recommended route uses it; otherwise label it as an alternative.

Document `make init`, `make project`, `make build`, `composer install`, and frontend install/build commands only when they are required by the tracked targets, and preserve their required order. Do not assume `composer create-project` performs repository-defined post-install initialization unless it is verified.

Document the minimum configuration needed for the recommended path: config file/environment source, local or gitignored status, values that must change, and values that differ in containers. Label demo credentials as development-only.

Document Docker only when it is a supported or recommended onboarding path. A Docker path MUST be complete: services, hostnames, ports, follow-up migrations/builds/workers, and user-facing URLs. Do not advertise Docker merely because a Make target or maintenance file exists.

When Compose supplies only backing services, label it `Docker services` and state that the application or protocol runtime still starts separately. Put it after the local configuration needed to use those services unless it is the recommended first-success path.

Quick start may name the local configuration creation/copy command. The `Configuration` section is the single detailed source for file ownership, ignored status, required values, and container differences. Do not repeat full configuration examples for each runtime unless values materially differ.

State a canonical verification URL or request once in Quick start or the relevant variant section. Do not duplicate route or endpoint inventories across native and Docker paths; describe only host, port, or authentication differences in an alternate path. Move exhaustive routes to focused documentation.

Use `http://localhost:<port>` or `http://127.0.0.1:<port>` for browser instructions. `0.0.0.0` is a bind address, not a reader-facing URL.

## Variant-specific additions

- **API skeletons** MUST include the base URL, a health/ping endpoint, an API/OpenAPI discovery endpoint when available, and one copyable successful request. Explain authentication or development tokens.
- **Worker/DDD skeletons** MUST state backing services, startup order, and consumer/worker commands when central to the example.
- **Frontend skeletons** MUST state PHP and frontend runtime requirements, dependency installation, watch/build commands, and whether frontend and PHP processes run separately. State whether the browser uses the PHP application with watched/generated assets, a frontend dev-server URL/proxy, or a production asset build; show concurrently required terminal commands.
- **MCP/protocol skeletons** MUST describe each transport separately, including its connection URL or STDIO command and required inspector/client workflow. Show the Inspector/client connection procedure and one callable capability with its expected result.
- **CMS skeletons** MUST document install/development/build/start commands, local admin/bootstrap behavior, and configuration grouped by subsystem.
- **Security-focused integrations** MUST state secure defaults, outbound-data boundaries, and credential handling before any opt-in configuration or command that can transmit data or use credentials.

## Links, visuals, and development

A maintained demo link SHOULD appear near the purpose section when it helps users choose the project. Screenshots or GIFs MAY be included for UI and protocol workflows, but only when they have meaningful alt text/captions and support the instructions rather than replace them.

Use relative links for repository-owned files and assets. Do not use `blob/master` URLs for local files. Keep architecture, troubleshooting, and exhaustive dependency material in focused documentation when it would obscure onboarding.

Use `Commands` or `Development and quality checks` for canonical QA, tests, builds, watchers, migrations, and consumers. Reserve a final `Development` section for contribution, maintenance, and footer material. A generic footer MUST NOT displace operational documentation.

The README MUST keep only information necessary to select the project and reach first success. Put architecture, complete route catalogs, extensive package lists, screenshots, troubleshooting, and deployment detail in `docs/` or `.docs/`, and link to it from `Further documentation`.

Document canonical quality and test commands when the repository provides them. Prefer project entrypoints such as `make qa`, `make tests`, `composer test`, or `npm run test`. Describe commands accurately. A maintained repository MUST provide a contributor route: prefer a repository-local `CONTRIBUTING.md`; otherwise link to applicable maintained organization guidance.

Avoid generic encouragement such as "Open the page and enjoy" without stating the expected route, interaction, or output.

Review before merge:

- [ ] Project type, audience, and first success are clear.
- [ ] Requirements, acquisition model, commands, services, ports, and URLs match tracked sources.
- [ ] The quick-start sequence is complete and one route is clearly recommended.
- [ ] The recommended route has been run against the current tracked state; record the verification command or CI/smoke-check reference in the pull request when it is not self-evident.
- [ ] A concrete success signal is stated; alternate paths are correctly distinguished.
- [ ] API examples include a successful request and required development authentication; protocol examples include a client-facing transport proof.
- [ ] Configuration scope, development-only credentials, and security implications are clear.
- [ ] Docker is complete when documented and omitted when it is not a supported user path.
- [ ] Variant-specific API, worker, frontend, protocol, CMS, or security rules are covered.
- [ ] The contributor route and canonical development commands are accurate.
- [ ] Links and visual assets resolve; Markdown renders correctly on GitHub.
