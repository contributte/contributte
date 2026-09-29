# Contributte AGENTS.md Specification

This document describes how `AGENTS.md` and `CLAUDE.md` are written in Contributte repositories. `AGENTS.md` is a
short development guide for AI coding agents and people: the stack, the commands and the principles. Everything
else lives in the README, `.docs/` and these specs. How to write the text is described in [TONE.md](TONE.md);
commands come from [MAKEFILE.md](MAKEFILE.md).

## Table of Contents

- [Rules](#rules)
- [Sections](#sections)
- [Library Template](#library-template)
- [Project Template](#project-template)
- [Checking with fxnorm](#checking-with-fxnorm)
- [Checklist](#checklist)

## Rules

- Every non-empty repository has an `AGENTS.md` in the root.
- `AGENTS.md` has 20 to 45 lines. Plain English, no emoji, no tables.
- Sections exactly: title and one-line purpose, `## Stack`, `## Development`, `## Principles`.
- Only facts that are true for the repository: every command must exist.
- It stays high level. It does not describe the file or folder structure, architecture internals, traps, history,
  planned changes, TODOs or "what is changing".
- `CLAUDE.md` contains exactly one line: `@AGENTS.md`.
- Don't add other agent files (`.cursorrules`, `.github/copilot-instructions.md`, `GEMINI.md`, `llms.txt`).
- `AGENTS.md` doesn't link `PRD.md`, `TECH.md` or `DESIGN.md`. The README links them when they exist.
- Libraries export-ignore the agent files in `.gitattributes`. Projects commit them as they are:

```
.claude export-ignore
AGENTS.md export-ignore
CLAUDE.md export-ignore
fxnorm.yml export-ignore
fxnorm-baseline.json export-ignore
```

## Sections

- **Title and purpose**: the name from the README (`# Contributte Console`), then one sentence saying what the
  package or project is.
- **`## Stack`**: the PHP version, the Nette version and the main integration, the test tool, the PHPStan level
  and the coding standard. Versions come from `composer.json` and `phpstan.neon`.
- **`## Development`**: one fenced `bash` block with the `make` targets that exist in the `Makefile`, and the
  command for one test file with a real file from `tests/Cases`. When the `Makefile` uses other names than
  [MAKEFILE.md](MAKEFILE.md#target-names), write the real names. A repository without tests shows `make qa` and
  says "There are no tests; `make qa` is the only check."
- **`## Principles`**: KISS, DRY and YAGNI, plus at most two bullets on code and tests from
  [CODE.md](CODE.md) and [TESTS.md](TESTS.md).

## Library Template

`{...}` marks a placeholder. Replace it with facts from the repository and delete lines that don't apply.

````markdown
# {Package name}

{One sentence: what the package is.}

## Stack

- Language: PHP {>=8.2}
- Framework: Nette {3.2}{, plus the main integration, e.g. Symfony Console 7}
- Tests: Nette Tester; static analysis: PHPStan (level {9}); code style: Contributte coding standard

## Development

```bash
make install     # install dependencies
make qa          # PHPStan and code style
make csf         # fix code style
make tests       # run all tests
vendor/bin/tester -s -p php --colors 1 -C tests/Cases/{Existing.phpt}   # run one test file
make coverage    # code coverage
```

Run `make` to list every target.

## Principles

- KISS: write the simplest code that works; no speculative abstractions.
- DRY: one source of truth; reuse existing code before adding new.
- YAGNI: build what is needed now, not what might be needed later.
- Small, final classes with typed properties and `declare(strict_types = 1)`.
- Every change comes with a test; `make qa tests` must pass before a commit.
````

## Project Template

Skeletons, applications, sites and demos use the library template and add the setup targets after the block.

````markdown
# {Project name}

{One sentence: what the project is.}

## Stack

- Language: PHP {>=8.2}
- Framework: Nette {3.2}{, plus the main packages, e.g. Nettrine ORM, Latte 3}
- Tests: Nette Tester; static analysis: PHPStan (level {9}); code style: Contributte coding standard

## Development

```bash
make install     # install dependencies
make qa          # PHPStan and code style
make csf         # fix code style
make tests       # run all tests
vendor/bin/tester -s -p php --colors 1 -C tests/Cases/{Existing.phpt}   # run one test file
make coverage    # code coverage
```

Run `make` to list every target. `make init` creates the local config, `make dev` starts the dev server on
http://localhost:{8000}.

## Principles

- KISS: write the simplest code that works; no speculative abstractions.
- DRY: one source of truth; reuse existing code before adding new.
- YAGNI: build what is needed now, not what might be needed later.
- Small, final classes with typed properties and `declare(strict_types = 1)`.
- Every change comes with a test; `make qa tests` must pass before a commit.
````

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

- `fxnorm.yml` is committed in the root. A setting that turns a rule off or lowers its severity has a comment
  with the reason.
- `fxnorm fix` writes `CLAUDE.md` (`common/claude-md-import`) and the Makefile help block. Everything else is
  fixed by hand.
- The rules for this document are `common/agents-md-exists`, `common/agents-md-length` (20 to 45 lines),
  `common/agents-md-sections`, `common/agents-md-no-structure`, `common/agents-md-no-emoji`,
  `common/claude-md-import` and `common/tone-words`.
- Fix the file instead of silencing the rule. A finding you accept gets `<!-- fxnorm:ignore {rule id} -->` on the
  line above it, with the reason in the same comment.
- `fxnorm explain {rule id}` shows what a rule checks. When a rule and these specs disagree, the specs win; report
  the rule.
- `AGENTS.md` doesn't list `fxnorm` in `## Development`. It is the same in every repository.

## Checklist

- [ ] `AGENTS.md` exists in the root and has 20 to 45 lines
- [ ] Sections in order: title and purpose, `## Stack`, `## Development`, `## Principles`
- [ ] Every command in `## Development` exists in the `Makefile` today
- [ ] No folder structure, architecture, traps, history, plans or TODOs
- [ ] No emoji, no tables, no placeholder left
- [ ] `CLAUDE.md` contains only `@AGENTS.md`
- [ ] Libraries export-ignore `AGENTS.md`, `CLAUDE.md`, `.claude` and `fxnorm.yml`
- [ ] `fxnorm check` reports no findings in `AGENTS.md` and `CLAUDE.md`
