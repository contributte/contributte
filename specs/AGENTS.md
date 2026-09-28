# Contributte AGENTS.md Specification

This document describes how `AGENTS.md`, `CLAUDE.md` and the optional `PRD.md`, `TECH.md` and `DESIGN.md` files are
written in Contributte repositories. `AGENTS.md` tells an AI coding agent what it can't learn quickly from the code:
how to run the checks, which conventions differ from the defaults and where the traps are. How to write the text is
described in [TONE.md](TONE.md). Commands come from [MAKEFILE.md](MAKEFILE.md), tests from [TESTS.md](TESTS.md) and
code rules from [CODE.md](CODE.md).

## Table of Contents

- [Rules](#rules)
- [Files](#files)
- [Sections](#sections)
- [Writing Bullets](#writing-bullets)
- [Library Template](#library-template)
- [Skeleton Template](#skeleton-template)
- [Project Documents](#project-documents)
- [What Not to Include](#what-not-to-include)
- [Checklist](#checklist)

## Rules

- Every non-empty repository has an `AGENTS.md` in the root.
- `CLAUDE.md` contains exactly one line: `@AGENTS.md`. All instructions live in `AGENTS.md`.
- `AGENTS.md` is 50 to 100 lines. It is a signpost, not a manual. Longer content moves to `TECH.md` in projects
  and to `.docs/` in libraries.
- Every line is specific to the repository. If a line would be true in every Contributte library, it belongs in
  these specs, not in `AGENTS.md`.
- Bullets state a fact first, then the rule that follows from it, then the reason or the file to read.
- Link, don't repeat. User documentation stays in `.docs/`, organization rules stay in these specs.
- The text is vendor neutral: "AI coding agent", not the name of one tool. No tool-specific syntax in shared text.
- Plain Markdown: `##` sections, bullets, one fenced command block, inline code for every identifier, file and
  command. No tables, no emoji, no headings below `###`.
- Libraries export-ignore every agent file in `.gitattributes` (see [.gitattributes](#gitattributes)).
- A pull request that changes a command, the PHP version, the folder layout or a documented trap updates
  `AGENTS.md` in the same pull request.

## Files

| File | Required | Content |
|------|----------|---------|
| `AGENTS.md` | yes | Overview, commands, conventions, traps |
| `CLAUDE.md` | yes | The single line `@AGENTS.md` |
| `PRD.md` | skeletons, applications, sites, demos | What it is for and what is out of scope, see [PRD.md](PRD.md) |
| `TECH.md` | skeletons, applications, sites, demos | How it is built and why, see [TECH.md](TECH.md) |
| `DESIGN.md` | repositories that render a UI | How the UI looks and behaves, see [DESIGN.md](DESIGN.md) |
| `.claude/` | no | Shared agent settings and subagents. `settings.local.json` is never committed |

- All files are in the root and use uppercase names.
- Don't add other agent files (`.cursorrules`, `.github/copilot-instructions.md`, `GEMINI.md`, `llms.txt`). If a
  tool needs its own file, it imports or links `AGENTS.md`.

### .gitattributes

Libraries add these lines to the [.gitattributes template](COMPOSER.md#gitattributes), for the files that exist:

```
.claude export-ignore
AGENTS.md export-ignore
CLAUDE.md export-ignore
DESIGN.md export-ignore
PRD.md export-ignore
TECH.md export-ignore
```

Skeletons have no `.gitattributes` and commit the files as they are.

## Sections

Sections, in this order. Headings use the exact names below.

| Section | Library | Skeleton | Content |
|---------|---------|----------|---------|
| `# {Title}` + purpose line | yes | yes | Repository name, then one fixed sentence |
| `## Overview` | yes | yes | One paragraph: what it is and what it is not. Key facts as bullets |
| `## Documentation` | yes | yes | Where to read before which change |
| `## Stack` | – | yes | Versions and an annotated folder tree |
| `## Commands` | yes | yes | One `bash` block with the `make` targets |
| `## Conventions` | yes | yes | 2 to 5 bullets, only what differs from the specs or needs a reminder |
| `## Traps` | yes | yes | 3 to 10 bullets with non-obvious invariants. The last bullet sets the scope |
| `## Ground Rules` | – | yes | Security and deployment invariants |

- The title is the name from the README: `# Contributte Console`, `# Nettrine ORM`, `# Webapp Skeleton`.
- The purpose line is always: `Instructions for AI coding agents working in this repository.`
- `## Commands` uses the [target names](MAKEFILE.md#target-names). Add a raw command only when there is no target
  (a single test file, a code generator).
- `## Traps` is the most useful section. When a repository has nothing surprising, keep it short, but don't fill it
  with general advice.
- The last bullet of `## Traps` says what is not in the file and where it is: "Usage, configuration and examples
  for users live in `.docs/README.md`, not here."

## Writing Bullets

Each trap opens with a **bold claim** in one sentence. The rule and the reason follow in one or two sentences.

Good:

```markdown
- **Command names are resolved at compile time.** The extension reads the `console.command` tag, then
  `#[AsCommand]`; a command with neither fails the container build, not the first run.
```

Bad:

```markdown
- Be careful with command names.
- Always write tests for your changes.
```

- Correct likely wrong assumptions directly: "`console.url` is only used in CLI mode, not in HTTP requests."
- Name the file or class to read: "See `src/DI/Pass/` before changing the pass order."
- Mark generated files and give the command that regenerates them.
- Use imperatives only as the consequence of a fact: "Don't edit `tests/tmp`; it is recreated on every run."

## Library Template

A filled example for `contributte/console`. Replace every fact with the repository's own. About 60 lines is typical.

````markdown
# Contributte Console

Instructions for AI coding agents working in this repository.

## Overview

`contributte/console` integrates Symfony Console into Nette Framework. Every service that extends
`Symfony\Component\Console\Command\Command` becomes a lazy-loaded command. It is a library with one DI
extension, not an application.

- **PHP**: 8.2 to 8.5 (`>=8.2` in `composer.json`)
- **Package**: `contributte/console`, namespace `Contributte\Console\`
- **Extension**: `Contributte\Console\DI\ConsoleExtension`
- **Integrates**: `symfony/console` 7.x and 8.x, `nette/di` 3.1+

## Documentation

- `.docs/README.md` is the user documentation and the page on contributte.org. Update it in the same pull request
  when configuration or behaviour changes.
- Organization rules for code, tests and tooling are in
  [contributte/contributte specs](https://github.com/contributte/contributte/tree/master/specs).

## Commands

```bash
# Install dependencies
make install

# Run all checks (code style + PHPStan level 9)
make qa

# Fix code style
make csf

# Run all tests, or one file
make tests
vendor/bin/tester -s -p php --colors 1 -C tests/Cases/DI/ConsoleExtension.phpt
```

CI runs the tests on PHP 8.2 to 8.5 and once with `--prefer-lowest`.

## Conventions

- Tests are Nette Tester `.phpt` files in `tests/Cases`, with `Toolkit::test()` and containers built by
  `ContainerBuilder` from `contributte/tester`. Test commands live in `tests/Fixtures`.
- Extension tests are split by feature: `ConsoleExtension.lazy.phpt`, `ConsoleExtension.tags.phpt`.
- Exception messages are asserted in tests. Changing a message means changing its test.

## Traps

- **The extension does nothing outside CLI mode.** It is registered as
  `ConsoleExtension(%consoleMode%)`; with `false` no service is added, so tests must pass `true`.
- **Command names are resolved at compile time.** The extension reads the `console.command` tag, then
  `#[AsCommand]`; a command with neither fails the container build, not the first run.
- **Commands are lazy.** `ContainerCommandLoader` creates a command only when it runs. Don't add code that needs
  every command instance at boot.
- **`console.url` replaces `http.requestFactory` only when it is the default `RequestFactory`.** With a custom
  factory the build fails on purpose; keep that error.
- Usage, configuration and examples for users live in `.docs/README.md`, not here.
````

Library specifics:

- `## Overview` names the integrated library and its supported majors. Packages without a DI extension drop the
  **Extension** bullet.
- `## Documentation` lists `DESIGN.md` when the library renders a UI (templates, assets, a Tracy panel).
- Namespaces follow [CODE.md](CODE.md#files-and-namespaces): `Contributte\`, `Nettrine\`, `Apitte\`.

## Skeleton Template

A filled example for `contributte/webapp-skeleton`. Skeletons are applications, so they add `## Stack` and
`## Ground Rules`. 70 to 100 lines is typical.

````markdown
# Webapp Skeleton

Instructions for AI coding agents working in this repository.

## Overview

A Nette application skeleton with a front module, an admin module, Doctrine ORM and a PostgreSQL database in
Docker Compose. It is a starting point that users copy with `composer create-project`, not a library. Every
change must keep a fresh copy working.

## Documentation

- `PRD.md` says what the skeleton demonstrates and what it leaves out on purpose. Read it before adding a feature.
- `TECH.md` explains the bootstrap, the configuration layers and the database setup.
- `DESIGN.md` holds the rules for templates, layouts and assets in `app/UI` and `www/`.
- Organization rules are in [contributte/contributte specs](https://github.com/contributte/contributte/tree/master/specs).

## Stack

- **PHP**: 8.4 and later (`>=8.4`), Nette 3.2, Latte 3
- **Database**: PostgreSQL via `nettrine/orm` and `nettrine/migrations`
- **Tests**: Nette Tester with `contributte/tester`; PHPStan level 9

```
app/
├── Bootstrap.php     # container setup, picks config/env/{dev,prod}.neon
├── Domain/           # entities and repositories, by domain (Order/, User/)
├── Model/            # infrastructure: database, router, security, Latte
└── UI/Modules/       # presenters and templates, by module (Admin/, Front/)
config/               # app/, ext/, env/; local.neon is created by make init
db/                   # Migrations/ and Fixtures/
www/                  # the only public directory
```

## Commands

```bash
# Install dependencies, create var/ folders and config/local.neon
make project
make init

# Start nginx, PHP and PostgreSQL in Docker (http://localhost:8080)
make docker-up

# Or run the built-in server on http://localhost:8000
make dev

# Run all checks, fix code style, run tests
make qa
make csf
make tests
```

## Conventions

- A presenter lives in `app/UI/Modules/{Module}/{Name}/{Name}Presenter.php`, its templates in `templates/` next
  to it. Layouts are `templates/@layout.latte` in the module folder.
- Schema changes go through a new file in `db/Migrations`. Never edit a migration that has been released.
- `composer.lock` is committed; update it together with `composer.json`.

## Traps

- **`NETTE_ENV=dev` loads `config/env/dev.neon`; any other value loads `prod.neon`.** `config/local.neon` is
  loaded last and wins. `make dev` sets `NETTE_ENV=dev`, a plain `php -S` does not.
- **`make build` drops the whole database** (`orm:schema-tool:drop --full-database`), then migrates and loads
  fixtures. Never point it at a database with real data.
- **The Docker `php` container runs migrations and loads fixtures on every start.** Fixtures must stay
  idempotent.
- **`var/` is created by `make setup`.** Don't commit anything from it and don't hard-code its path.
- Features for users and screenshots are described in `README.md`; product scope is in `PRD.md`, not here.

## Ground Rules

- **Only `www/` is public.** `app/`, `config/`, `db/` and `var/` must never be served.
- Secrets live in `config/local.neon` or environment variables and are never committed.
- Tracy debug mode is on only through `NETTE_DEBUG=1` in development.
````

Skeleton specifics:

- The folder tree shows only the top two levels, with a comment on each line that isn't obvious.
- `## Ground Rules` holds rules whose violation is a security or data problem. Everything else is a trap.
- If the skeleton uses Docker, say which services run and on which ports, in `## Commands` or `## Stack`.

## Project Documents

`PRD.md`, `TECH.md` and `DESIGN.md` hold knowledge that is too long for `AGENTS.md`. Their content is described in
[PRD.md](PRD.md), [TECH.md](TECH.md) and [DESIGN.md](DESIGN.md). In short:

- `PRD.md` and `TECH.md`: skeletons, applications, sites and demos
  ([when required](PRD.md#when-it-is-required)).
- `DESIGN.md`: repositories that render a UI, including Tracy panels and skeletons
  ([when required](DESIGN.md#when-it-is-required)).
- Libraries have no `TECH.md`. Design notes that don't fit in `## Traps` go to `.docs/`.

`AGENTS.md` links each existing document from `## Documentation`, with one line that says when to read it:

```markdown
- `TECH.md` explains the bootstrap, the configuration layers and the database setup. Read it before changing
  `app/Bootstrap.php` or `config/`.
```

Don't repeat their content in `AGENTS.md`. A trap that is explained in `TECH.md` gets one bullet with a link.

## What Not to Include

- Generic advice: "write clean code", "add tests", "follow best practices".
- Rules already in these specs, beyond one bullet with a link.
- An API reference, configuration reference or usage tutorial. Those live in `.docs/README.md`.
- A copy of the folder tree for libraries. [CODE.md](CODE.md#folder-structure) already describes it.
- Machine-local paths, personal preferences, tokens or credentials.
- Text addressed to one tool ("This file provides guidance to …").
- Plans, TODO lists, status notes and references to work in progress. Describe the current state.
- Links to documents outside the repository, other than these specs and upstream documentation.

## Checklist

- [ ] `AGENTS.md` exists in the root and has 50 to 100 lines
- [ ] `CLAUDE.md` contains only `@AGENTS.md`
- [ ] Sections in order: title and purpose line, Overview, Documentation, (Stack), Commands, Conventions, Traps,
      (Ground Rules)
- [ ] Overview states the PHP version, package, namespace and, for libraries, the DI extension
- [ ] Commands use the Makefile target names and show how to run a single test
- [ ] Every trap opens with a bold claim and says why or where to read more
- [ ] The last trap bullet points to `.docs/README.md`, `README.md` or `PRD.md`
- [ ] No generic advice, no emoji, no tables, no tool-specific wording
- [ ] `PRD.md`, `TECH.md` and `DESIGN.md` exist where [Project Documents](#project-documents) requires them and are
      linked from `## Documentation`
- [ ] Libraries export-ignore `AGENTS.md`, `CLAUDE.md`, `.claude` and the project documents
- [ ] `.claude/settings.local.json` is not committed
