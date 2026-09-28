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
- [Placeholders](#placeholders)
- [Commands and CI](#commands-and-ci)
- [Library Template](#library-template)
- [Skeleton Template](#skeleton-template)
- [Project Documents](#project-documents)
- [What Not to Include](#what-not-to-include)
- [Checking with fxnorm](#checking-with-fxnorm)
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
- Libraries export-ignore every agent file and `fxnorm.yml` in `.gitattributes` (see [.gitattributes](#gitattributes)).
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
| `fxnorm.yml` | yes | The fxnorm preset and rule settings, written by `fxnorm init`, see [Checking with fxnorm](#checking-with-fxnorm) |

- All files are in the root. The agent and project documents use uppercase names; `fxnorm.yml` is lowercase.
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
fxnorm.yml export-ignore
fxnorm-baseline.json export-ignore
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
  (a single test file, a code generator). What to write when targets or tests are missing is in
  [Commands and CI](#commands-and-ci).
- The PHP version, package and namespace go to `## Overview` in libraries and to `## Stack` in skeletons.
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

## Placeholders

The templates below are outlines, not examples to copy. Fixed wording is written out; everything in `{...}` is a
placeholder with a hint of what goes there.

- Replace every placeholder with facts from the repository: `composer.json`, the `Makefile`, `phpstan.neon`,
  `.github/workflows/`, the code and the tests. Check each fact in the file named in the hint.
- Delete lines that don't apply. A library without a DI extension has no **Extension** line; a skeleton without
  Docker has no Docker command.
- Never keep a fact because it is in the template. A command, port, folder or version the repository doesn't have
  is a bug in `AGENTS.md`.
- The finished file has no placeholders left. Braces that belong to the content (NEON parameters, Latte tags)
  are not placeholders; a placeholder always holds a hint in plain words.

## Commands and CI

- `## Commands` lists only targets that exist in the `Makefile` today. Never write a target the repository doesn't
  have, even when the specs require it.
- When the `Makefile` deviates from [MAKEFILE.md](MAKEFILE.md) (no `help`, `test` instead of `tests`,
  `codesniffer` instead of `phpcs`), write the real names. Fixing the `Makefile` is its own change; when the same
  pull request fixes it, `AGENTS.md` uses the new names.
- A repository without a `tests/` folder has no `tests` and `coverage` targets, and the `Makefile` doesn't add
  empty ones. `## Commands` shows `make qa` and says so in one line under the block: "There are no tests; `make qa`
  (code style and PHPStan) is the only check." Skeletons need at least the container test
  ([TESTS.md](TESTS.md#skeleton-tests)), so a skeleton adds `tests/` and both targets instead.
- The single-test command is shown only when tests exist, with a real file from `tests/Cases`.
- The line under the command block says what CI runs, read from `.github/workflows/`. When a workflow runs
  something other than a `make` target, name the workflow and its command.

## Library Template

About 60 lines is typical when filled. `{...}` marks a placeholder: replace it with facts from the repository;
delete lines that don't apply (see [Placeholders](#placeholders)).

````markdown
# {Name from the README title, e.g. Contributte Console}

Instructions for AI coding agents working in this repository.

## Overview

`{package}` {what it is, one sentence: "integrates Symfony Console into Nette Framework"}. {What it does, as a
fact from the code.} It is a library with {what it registers, e.g. one DI extension}, not an application.

- **PHP**: {versions CI tests, e.g. 8.2 to 8.5} (`{php constraint}` in `composer.json`)
- **Package**: `{package}`, namespace `{Namespace}\`
- **Extension**: `{DI extension class}`
- **Integrates**: `{vendor/library}` {majors allowed in composer.json}, `nette/di` {constraint in composer.json}

## Documentation

- `.docs/README.md` is the user documentation and the page on contributte.org. Update it in the same pull request
  when configuration or behaviour changes.
- {`DESIGN.md` when the library renders a UI, with one line on when to read it.}
- Organization rules for code, tests and tooling are in
  [contributte/contributte specs](https://github.com/contributte/contributte/tree/master/specs).

## Commands

```bash
# Install dependencies
make install

# Run all checks (code style + PHPStan level {level in phpstan.neon})
make qa

# Fix code style
make csf

# Run all tests, or one file
make tests
vendor/bin/tester -s -p php --colors 1 -C tests/Cases/{path of a real test file}
```

{What CI runs, from .github/workflows/, e.g. "CI runs the tests on PHP 8.2 to 8.5 and once with `--prefer-lowest`."}

## Conventions

- {How tests are written here: framework, helpers, where fixtures live. Take it from `tests/`, not from TESTS.md.}
- {A convention that differs from the specs or needs a reminder, with the file that shows it.}

## Traps

- **{Bold claim about a non-obvious invariant, found in the code or the tests}.** {The rule that follows and the
  reason; name the file or class to read.}
- **{Bold claim}.** {Rule and reason.}
- Usage, configuration and examples for users live in `.docs/README.md`, not here.
````

Library specifics:

- `## Overview` names the integrated library and the majors `composer.json` allows. Packages without a DI extension
  drop the **Extension** line.
- `## Documentation` lists `DESIGN.md` when the library renders a UI (templates, assets, a Tracy panel).
- Namespaces follow [CODE.md](CODE.md#files-and-namespaces): `Contributte\`, `Nettrine\`, `Apitte\`.
- The traps in [Writing Bullets](#writing-bullets) show the tone. Don't copy them into another repository.

## Skeleton Template

Skeletons are applications, so they add `## Stack` and `## Ground Rules`. 70 to 100 lines is typical when filled.
`{...}` marks a placeholder: replace it with facts from the repository; delete lines that don't apply (see
[Placeholders](#placeholders)).

````markdown
# {Name from the README title, e.g. Webapp Skeleton}

Instructions for AI coding agents working in this repository.

## Overview

{What the skeleton is, one sentence: framework, main packages, database.} It is a starting point that users copy
with `composer create-project`, not a library. Every change must keep a fresh copy working.

## Documentation

- `PRD.md` says what the skeleton demonstrates and what it leaves out on purpose. Read it before adding a feature.
- `TECH.md` explains {what it covers, e.g. the bootstrap, the configuration layers and the database setup}.
- `DESIGN.md` holds the rules for {templates, layouts and assets, with their folders}.
- Organization rules are in [contributte/contributte specs](https://github.com/contributte/contributte/tree/master/specs).

## Stack

- **PHP**: {PHP version in prose} (`{php constraint}` in `composer.json`), {Nette and Latte majors from composer.json}
- **Database**: {engine and version from docker-compose.yml, and the packages that talk to it}
- **Tests**: {test framework and helpers}; PHPStan level {level in phpstan.neon}

```
{top-level folder}/   # {what it holds, only when the name doesn't say it}
├── {subfolder}/      # {what it holds}
{next top-level folder}/
```

## Commands

```bash
# {What the setup targets do, from the Makefile}
make {setup targets, e.g. project, init}

# {How to start it, with the URL and port; a raw `docker compose up -d` when there is no target}
{start command}

# Run all checks, fix code style, run tests
make qa
make csf
make tests
```

{What CI runs, from .github/workflows/.}

## Conventions

- {Where a presenter and its templates live, as in app/UI/.}
- {How schema changes are made, as in db/ or migrations/.}

## Traps

- **{Bold claim about the configuration load order, from app/Bootstrap.php}.** {What wins and which command sets it.}
- **{Bold claim about a destructive target or container start, from the Makefile or docker-compose.yml}.** {What
  it destroys and where it must never run.}
- **{Bold claim}.** {Rule and reason.}
- Features for users and screenshots are described in `README.md`; product scope is in `PRD.md`, not here.

## Ground Rules

- **Only `www/` is public.** {Folders that must never be served, e.g. `app/`, `config/`, `db/` and `var/`.}
- Secrets live in `config/local.neon` or environment variables and are never committed.
- {How debug mode is switched on, from app/Bootstrap.php, and that it is for development only.}
````

Skeleton specifics:

- The folder tree shows only the top two levels, with a comment on each line that isn't obvious.
- `## Ground Rules` holds rules whose violation is a security or data problem. Everything else is a trap.
- If the skeleton uses Docker, say which services run and on which host ports, in `## Commands` or `## Stack`.
  Two services on the same host port is a trap.
- Traps come from reading the code: what `make build` drops, what a container runs on start, which config file is
  never loaded. Don't write "fixtures are idempotent" or "runs on port 8080" without checking.

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

## Checking with fxnorm

`fxnorm` checks a repository against these specs and reports each deviation with the file, the line and the id of
the rule that found it. Set it up once per repository, then check after every change:

```bash
# Detect the kind of repository and write fxnorm.yml (preset contributte-library or contributte-skeleton)
fxnorm init

# Report deviations, or apply the safe fixes and report what is left
fxnorm check
fxnorm fix
```

- `fxnorm.yml` is committed in the root. It names the preset and, when needed, rule settings. A setting that
  turns a rule off or lowers its severity has a comment with the reason.
- `fxnorm fix` writes `CLAUDE.md` (`common/claude-md-import`) and the Makefile help block. Everything else is
  fixed by hand.
- The rules for this document are `common/agents-md-exists`, `common/agents-md-length` (50 to 100 lines),
  `common/agents-md-no-emoji`, `common/claude-md-import` and `common/tone-words` (`README.md` and `AGENTS.md`).
  `contributte/design-md-exists`, `contributte/prd-md-exists` and `contributte/tech-md-exists` check the project
  documents.
- Fix the file instead of silencing the rule. A finding you accept gets `<!-- fxnorm:ignore {rule id} -->` on the
  line above it, with the reason in the same comment.
- `fxnorm explain {rule id}` shows what a rule checks and which section of these specs it enforces. When a rule
  and these specs disagree, the specs win; report the rule.
- Libraries export-ignore `fxnorm.yml`, `AGENTS.md` and `CLAUDE.md` (see [.gitattributes](#gitattributes)).
  Skeletons commit them as they are.
- `AGENTS.md` doesn't list `fxnorm` in `## Commands`. It is the same in every repository and belongs in these
  specs.

## Checklist

- [ ] `AGENTS.md` exists in the root and has 50 to 100 lines
- [ ] `CLAUDE.md` contains only `@AGENTS.md`
- [ ] Sections in order: title and purpose line, Overview, Documentation, (Stack), Commands, Conventions, Traps,
      (Ground Rules)
- [ ] Overview (libraries) or Stack (skeletons) states the PHP version, package, namespace and, for libraries,
      the DI extension
- [ ] Every fact comes from the repository; no placeholder and no template fact is left
- [ ] Commands exist in the `Makefile` today, use the target names and show how to run a single test (when tests
      exist)
- [ ] The line under the commands says what CI runs
- [ ] Every trap opens with a bold claim and says why or where to read more
- [ ] The last trap bullet points to `.docs/README.md`, `README.md` or `PRD.md`
- [ ] No generic advice, no emoji, no tables, no tool-specific wording
- [ ] `PRD.md`, `TECH.md` and `DESIGN.md` exist where [Project Documents](#project-documents) requires them and are
      linked from `## Documentation`
- [ ] Libraries export-ignore `AGENTS.md`, `CLAUDE.md`, `.claude`, `fxnorm.yml` and the project documents
- [ ] `fxnorm check` reports no findings in `AGENTS.md` and `CLAUDE.md`
- [ ] `.claude/settings.local.json` is not committed
