# Contributte TECH.md Specification

This document describes the `TECH.md` file in Contributte projects: skeletons, applications, sites and demos. The
file is the technical design of the project: how it is put together, how a request flows through it, how it is
built and tested, and which decisions shaped it. Product intent is in [PRD.md](PRD.md), UI in
[DESIGN.md](DESIGN.md), repository conventions in [SKELETON.md](SKELETON.md), [MAKEFILE.md](MAKEFILE.md) and
[TESTS.md](TESTS.md).

## Table of Contents

- [Rules](#rules)
- [When It Is Required](#when-it-is-required)
- [Sections](#sections)
- [Decisions](#decisions)
- [Undated Decisions](#undated-decisions)
- [Writing Style](#writing-style)
- [Template](#template)
- [Checklist](#checklist)

## Rules

- `TECH.md` lives in the repository root, next to `README.md`, `PRD.md` and `AGENTS.md`.
- It is 50 to 150 lines. Detail about one subsystem goes to `.docs/` and is linked from here.
- It describes the code as it is today. It is not a proposal and not a tutorial.
- It links instead of repeating: commands are in `AGENTS.md` and the `Makefile`, install steps in the README,
  variables in `config/local.neon.example` or `.env.example`.
- Versions come from `composer.json`, `package.json` and `docker-compose.yml`. When those change, `TECH.md`
  changes in the same pull request.
- A pull request that changes architecture, adds a service or reverses a decision adds a dated entry to
  `## Decisions`.

## When It Is Required

`TECH.md` is required in the same repositories as `PRD.md`: skeletons, applications, sites and demos. Libraries
don't have one; their design notes go to `.docs/` and their decisions to the changelog or the pull request.
fxnorm checks this with `contributte/tech-md-exists` for every `composer.json` with `"type": "project"`.

## Sections

Use these `##` sections in this order:

1. `# {Name} Tech` and one sentence: what the system is, technically.
2. `## Architecture` - a text diagram of processes and services, then 2 to 4 bullets.
3. `## Stack` - runtimes, framework and key packages with versions.
4. `## Layout` - an annotated directory tree, top two levels only.
5. `## Configuration` - config files and load order, env variables, link to the example file.
6. `## Data Model` - entities or tables and their relations, migrations and fixtures location.
7. `## Services` - Docker Compose services, ports and credentials for local use only.
8. `## Request Flow` - one HTTP request and one CLI command, from entry point to response.
9. `## Build and Deploy` - what `make build` and `make deploy` do, where it runs.
10. `## Testing` - test layers, what each covers, what is not tested.
11. `## Decisions` - dated entries, newest first.
12. `## Known Limits` - things that are wrong or old today and why they are not fixed yet.

Omit `Data Model` or `Services` only when the project has none, and say so in one line.

## Decisions

Each entry is short and never rewritten after it is merged. A later decision that reverses it adds a new entry
and marks the old one `Superseded by YYYY-MM-DD`.

```markdown
### 2026-09-28 Doctrine ORM instead of nette/database

- **Context:** The skeleton must show entities, repositories and migrations.
- **Decision:** Use `nettrine/orm`, `nettrine/migrations` and `nettrine/fixtures`.
- **Consequences:** (+) one mapping for schema and code; (-) heavier boot, needs `.build/phpstan-doctrine.php`.
- **Rejected:** `nette/database` Explorer - no migrations or fixtures in the same toolset.
```

When the list passes about 10 entries or an entry needs more than 10 lines, move entries to
`.docs/decisions/YYYY-MM-DD-slug.md` with the same headings and keep a one-line index here.

### Undated Decisions

A `TECH.md` written for an existing project records decisions that were made before the file existed. Their date
is often unknown.

- Take the date from git: the commit that introduced the change (`git log --diff-filter=A --format=%as -- {file}`
  for a new file, `git log -S '{text}' --format=%as` for a line). Write it as the entry date.
- When git can't tell (a shallow clone, a squashed import), use the date the entry is written and add
  `(recorded)` after the title: `### 2026-09-28 Doctrine ORM instead of nette/database (recorded)`. The marker says
  the decision is older than the date.
- Never invent a date and never leave the heading without one. Sorting and `Superseded by` both need it.
- `(recorded)` entries keep the Context line short and say what is known: "Chosen before 2020; no discussion is
  recorded."

## Writing Style

- Facts first, reason second: "**Only `www/` is public.** `app/`, `config/` and `var/` are outside the web root."
- Code spans for every file, class, command and variable.
- Versions as ranges from the manifest (`php >=8.4`), not "latest".
- Name one config template everywhere: `config/local.neon.example` (not `.dist`), or `.env.example`.
- No emoji, no marketing words, no future tense except in `Known Limits`.

## Template

`{...}` marks a placeholder: replace it with facts from the repository; delete lines that don't apply. Text
outside braces is the fixed structure. No fact is kept because it is in the template: every version, port, folder
and command comes from `composer.json`, `docker-compose.yml`, the `Makefile` and the code.

````markdown
# {Name} Tech

{What the system is, technically, in one sentence: framework, database, how it is served.}

## Architecture

```
{entry point} -> {process or service} -> {next hop}
{CLI entry point} -> {bootstrap method} -> {command}
{process} -> {database or external service}
```

- {How web and CLI share or split the container, from app/Bootstrap.php.}
- {What does not exist, e.g. "No queue or worker; everything runs inside a request or a console command."}

## Stack

- PHP `{php constraint}`, {Nette and Latte majors from composer.json}
- {Database layer packages with their constraints}
- QA: {QA packages from require-dev, as they are}

## Layout

```
{file or folder}      # {what it holds}
{file or folder}      # {what it holds}
```

## Configuration

- Load order: {config files in the order app/Bootstrap.php loads them, and what picks the environment}.
- `config/local.neon` is created by `{make target or copy command}` from `config/local.neon.example`; it holds
  {what it holds}.
- {Environment variables the app reads, and where.}

## Data Model

- {Entity or table} (`{file}`) {with its relations or traits}.
- Schema changes only through a new file in `{migrations folder}`; never edit an applied migration.
- Fixtures in `{fixtures folder}`, loaded by `{command}`.

## Services

- {Compose service} ({host port}:{container port}), {what it runs on start}.
- Local credentials `{user}` / `{password}`; for development only.

## Request Flow

- HTTP: `{public entry}` -> {bootstrap} -> {router} -> presenter -> {template location}.
- CLI: `bin/console` -> {bootstrap} -> command service.

## Build and Deploy

- `make build` {what it does, read from the Makefile; say when it destroys data}.
- `make deploy` {what it does}. {Where the demo or production runs, if anywhere.}

## Testing

- `{test folder}` - {what it covers}.
- CI workflows: {files in .github/workflows/}.
- Not tested: {what no test covers}.

## Decisions

### {YYYY-MM-DD} {Decision title, then "(recorded)" when the date is not the decision date}

- **Context:** {Why a choice was needed.}
- **Decision:** {What was chosen.}
- **Consequences:** (+) {gain}; (-) {cost}.

## Known Limits

- {What is wrong or outdated today, with the file, and why it is not fixed yet.}
````

## Checklist

- [ ] The repository is a project, so `TECH.md` exists in the root
- [ ] Sections are in the order above
- [ ] The architecture diagram matches `docker-compose.yml` and the entry points
- [ ] Versions match `composer.json`, `package.json` and compose images
- [ ] Configuration links the committed example file (`config/local.neon.example` or `.env.example`)
- [ ] Every decision has a date, context, decision and consequences; a date that is not the real decision date is
      marked `(recorded)`
- [ ] No placeholder and no template fact is left
- [ ] Known limits are listed, not hidden
- [ ] The file is 50 to 150 lines and has no emoji
