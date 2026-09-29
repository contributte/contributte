# Contributte Makefile Specification

This document describes how Makefiles in Contributte repositories are written. Library and skeleton
specific targets are described in [LIBRARY.md](LIBRARY.md#makefile) and [SKELETON.md](SKELETON.md#makefile).

## Table of Contents

- [Rules](#rules)
- [Help](#help)
- [Environment](#environment)
- [Sections](#sections)
- [CI Output](#ci-output)
- [Library Template](#library-template)
- [Skeleton Template](#skeleton-template)
- [Target Names](#target-names)
- [Checking with fxnorm](#checking-with-fxnorm)
- [Checklist](#checklist)

## Rules

- Running `make` without a target prints the help, same as `make help`.
- Every public target has a `## Description` comment on its target line.
- Every target has its own `.PHONY` line directly above it.
- Targets are grouped into sections with `##@ Section` headers.
- Env files are included at the top when the Makefile uses environment variables.
- Private helper targets start with `_` and have no `##` comment, so they are hidden from the help.
- Recipes are indented with tabs.

## Help

Put this block at the top of every Makefile, after the env includes:

```makefile
.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))
```

- `.DEFAULT_GOAL := help` makes plain `make` show the help, regardless of target order.
- The awk script lists every `target: ## Description` line and prints `##@ Section` lines as headers.
- It reads `$(firstword $(MAKEFILE_LIST))`, so included `.env` files are never parsed.
- It works with GNU awk, mawk and BSD awk (macOS).

Output:

```
Usage: make <target>

Help
  help                 Show this help

QA
  qa                   Run all QA checks
  cs                   Check code style
  csf                  Fix code style
  phpstan              Run static analysis
```

## Environment

When a Makefile needs environment variables (tokens, hosts, credentials), include the env file and export it:

```makefile
-include .env
export
```

- `.env` is local and listed in `.gitignore`.
- A committed `.env.example` lists all required variables, with empty or safe default values.
- `-include` (with the dash) keeps `make help` working before `.env` exists.
- `export` passes the loaded variables to every recipe (terraform, docker, scripts).
- When committed defaults must always be loaded, include them first and let `.env` override them:

```makefile
include .env.example
-include .env
export
```

Makefiles that don't use any environment variables don't include env files.

## Sections

Use `##@` headers to group targets. The usual order is:

| Section | Targets |
|---------|---------|
| `##@ Help` | `help` |
| `##@ Project` | `project`, `init`, `install`, `setup`, `clean` |
| `##@ QA` | `qa`, `cs`, `csf`, `phpstan`, `tests`, `coverage` |
| `##@ Development` | `dev`, `build` |
| `##@ Docker` | `docker-up`, `docker-*` |
| `##@ Deployment` | `deploy` |

Libraries only use the Help, Project and QA sections.

## CI Output

Targets with different CI output switch on `GITHUB_ACTION`, which GitHub Actions always sets:

```makefile
.PHONY: cs
cs: ## Check code style
ifdef GITHUB_ACTION
	vendor/bin/phpcs ... -q --report=checkstyle src tests | cs2pr
else
	vendor/bin/phpcs ... src tests
endif
```

## Library Template

```makefile
.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))

##@ Project

.PHONY: install
install: ## Install dependencies
	composer update

##@ QA

.PHONY: qa
qa: phpstan cs ## Run all QA checks

.PHONY: cs
cs: ## Check code style
ifdef GITHUB_ACTION
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp -q --report=checkstyle src tests | cs2pr
else
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp src tests
endif

.PHONY: csf
csf: ## Fix code style
	vendor/bin/phpcbf --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp src tests

.PHONY: phpstan
phpstan: ## Run static analysis
	vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: tests
tests: ## Run tests
	vendor/bin/tester -s -p php --colors 1 -C tests/Cases

.PHONY: coverage
coverage: ## Generate code coverage
ifdef GITHUB_ACTION
	vendor/bin/tester -s -p php --colors 1 -C --coverage coverage.xml --coverage-src src tests/Cases
else
	vendor/bin/tester -s -p php --colors 1 -C --coverage coverage.html --coverage-src src tests/Cases
endif
```

## Skeleton Template

See [SKELETON.md](SKELETON.md#makefile). It uses the same help block and adds the Project, Development,
Docker and Deployment sections. Skeletons that need environment variables add the [env includes](#environment)
at the top.

## Target Names

These names are used across the organization. Use them instead of inventing new ones.

| Target | Purpose |
|--------|---------|
| `help` | Show available targets (default) |
| `install` | Install dependencies (`composer update` in libraries, `composer install` in projects) |
| `qa` | Run all QA checks |
| `cs` | Check code style |
| `csf` | Fix code style |
| `phpstan` | Run static analysis |
| `tests` | Run tests |
| `coverage` | Generate code coverage |
| `project` | Full project setup |
| `init` | Create local config from template |
| `setup` | Create runtime directories |
| `clean` | Remove temporary files and logs |
| `dev` | Start development server |
| `build` | Build the project |
| `deploy` | Build for deployment |
| `docker-up` | Start Docker services |

Avoid the older variants `coverage-clover`, `coverage-html`, `test` and `vendor/bin/codesniffer`/`codefixer`.

Required targets:

- Libraries and applications: `install`, `qa`, `cs`, `csf`, `phpstan`, `tests`, `coverage`.
- Skeletons add `project`, `setup`, `clean`, `dev`, `build` and `deploy`. `init` is needed only when there is a
  local config template (`config/local.neon.example`), `docker-up` only when there is a `docker-compose.yml`.
- A repository without a `tests/` folder has no `tests` and `coverage` targets. Don't add a target that only
  prints a message (`echo "NO TESTS"`); `AGENTS.md` says there are no tests instead (see
  [AGENTS.md](AGENTS.md#sections)). Skeletons need at least the container test
  ([TESTS.md](TESTS.md#skeleton-tests)), so they add `tests/` and both targets.
- A repository that still has `test` renames it to `tests`, and updates `AGENTS.md`, the workflows and the README
  in the same pull request.

## Checking with fxnorm

`fxnorm check` checks the Makefile against this document. `fxnorm fix` adds `.DEFAULT_GOAL := help` and the
[help block](#help) when they are missing; the other findings are fixed by hand.

```bash
# Once per repository: write fxnorm.yml with the contributte-library or contributte-skeleton preset
fxnorm init

# Check, or fix what can be fixed and check again
fxnorm check
fxnorm fix
```

| Rule | Checks |
|------|--------|
| `common/makefile-help` | `.DEFAULT_GOAL := help` and a `help` target (fixable) |
| `common/makefile-target-descriptions` | Every public target has a `## Description` comment |
| `contributte/makefile-phony` | Every target has its own `.PHONY` line directly above it |
| `contributte/makefile-required-targets` | The [required targets](#target-names) for a library or a skeleton |
| `contributte/makefile-ci-output` | `cs` and `coverage` switch on `ifdef GITHUB_ACTION` |
| `contributte/makefile-no-legacy` | No `test`, `coverage-clover`, `coverage-html`, `codesniffer` or `codefixer` |
| `contributte/makefile-tester-php` | Nette Tester runs with `-p php`, not `-p phpdbg` |

- `fxnorm.yml` is committed in the root. Libraries export-ignore it (see [COMPOSER.md](COMPOSER.md#gitattributes)),
  together with `AGENTS.md` and `CLAUDE.md`.
- The Makefile has no `fxnorm` target. fxnorm is not a Composer dependency and runs the same way in every
  repository.
- `fxnorm explain {rule id}` shows what a rule checks. When a rule and this document disagree, this document wins;
  report the rule.

## Checklist

- [ ] `make` prints the help
- [ ] Every public target has a `## Description`
- [ ] Every target has its own `.PHONY`
- [ ] Targets are grouped with `##@` sections
- [ ] `.env` is included (`-include .env` + `export`) if the Makefile needs environment variables
- [ ] `.env.example` lists the required variables and `.env` is in `.gitignore`
- [ ] The required targets exist; `tests` and `coverage` only when `tests/` exists
- [ ] `fxnorm check` reports no findings in the `Makefile`
