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

## Writing Style

- Facts first, reason second: "**Only `www/` is public.** `app/`, `config/` and `var/` are outside the web root."
- Code spans for every file, class, command and variable.
- Versions as ranges from the manifest (`php >=8.4`), not "latest".
- No emoji, no marketing words, no future tense except in `Known Limits`.

## Template

A filled example for `contributte/webapp-skeleton`. Replace the facts, keep the order.

````markdown
# Webapp Skeleton Tech

A Nette Framework application with Doctrine ORM on PostgreSQL, served by Nginx and PHP-FPM in Docker.

## Architecture

```
browser -> nginx (:8080) -> php-fpm -> www/index.php -> App\Bootstrap::runWeb()
                                                          -> Nette Application -> presenter -> Latte
bin/console -> App\Bootstrap::runCli() -> Symfony Console -> command
php-fpm / console -> PostgreSQL (database)
```

- One DI container for web and CLI; the static parameter `scope` is `web` or `cli`.
- No queue or worker; everything runs inside a request or a console command.

## Stack

- PHP >=8.4, Nette 3, Latte 3, `contributte/*` integrations
- Doctrine ORM via `nettrine/orm`, `nettrine/dbal`, `nettrine/migrations`, `nettrine/fixtures`
- Symfony Console and EventDispatcher via `contributte/console`, `contributte/event-dispatcher`
- QA: `contributte/qa` (CodeSniffer), `contributte/phpstan`, `contributte/tester`

## Layout

```
app/Bootstrap.php     # container setup, web and CLI entry
app/Domain/           # entities, repositories, facades, subscribers (User, Order, Http)
app/Model/            # infrastructure: database, security, router, latte, utils
app/UI/               # modules (Front, Admin, Base, Mailing, Pdf), controls, forms
config/               # app/, env/, ext/ and local.neon (not committed)
db/                   # Migrations/, Fixtures/
resources/            # mail, pdf and Tracy error templates
www/                  # public web root: index.php, assets/
```

## Configuration

- Load order: `config/env/base.neon` via `dev.neon` or `prod.neon` (`NETTE_ENV=dev` picks dev), then
  `config/local.neon`.
- `config/local.neon` is created by `make init` from `config/local.neon.example`; it holds database and SMTP.
- `NETTE_DEBUG=1` enables Tracy. Environment variables are added to `parameters` at compile time.

## Data Model

- `User` (`app/Domain/User/User.php`) with `TId`, `TCreatedAt`, `TUpdatedAt` traits.
- Schema changes only through a new file in `db/Migrations/`; never edit an applied migration.
- Fixtures in `db/Fixtures/`, loaded by `make build`.

## Services

- `nginx` (8080, 8443), `php` (FPM, runs migrations and fixtures on start), `database` (PostgreSQL).
- Local credentials `contributte` / `contributte`; for development only.

## Request Flow

- HTTP: `www/index.php` -> `Bootstrap::runWeb()` -> `RouterFactory` (Mailing, Pdf, `admin/...`, Front) ->
  presenter -> Latte template from the module `templates/` folder.
- CLI: `bin/console` -> `Bootstrap::runCli()` -> command service.

## Build and Deploy

- `make build` drops the schema, runs migrations and loads fixtures. It destroys data; local only.
- `make deploy` runs `clean`, `project`, `build`, `clean`. The demo is deployed from `master`.

## Testing

- `tests/Cases/Unit` - plain classes (`Model/Utils`).
- `tests/Cases/E2E` - booted container: Doctrine mapping is valid, every `*.latte` in `app/` compiles, entry
  points start.
- CI workflows: `codesniffer`, `phpstan`, `tests`, `coverage`, `database`.
- Not tested: rendered HTML and JS in `www/assets/`.

## Decisions

### 2026-09-28 Doctrine ORM instead of nette/database

- **Context:** The skeleton must show entities, repositories and migrations.
- **Decision:** Use `nettrine/*` for ORM, migrations and fixtures.
- **Consequences:** (+) one toolset for schema and data; (-) heavier boot.

## Known Limits

- `docker-compose.yml` uses `dockette/postgres:10`, which is out of upstream support; `make docker-postgres`
  uses 12. Align both before the next release.
- `docker-compose.yml` still has the obsolete `version:` key.
````

## Checklist

- [ ] The repository is a project, so `TECH.md` exists in the root
- [ ] Sections are in the order above
- [ ] The architecture diagram matches `docker-compose.yml` and the entry points
- [ ] Versions match `composer.json`, `package.json` and compose images
- [ ] Configuration links the committed example file (`config/local.neon.example` or `.env.example`)
- [ ] Every decision has a date, context, decision and consequences
- [ ] Known limits are listed, not hidden
- [ ] The file is 50 to 150 lines and has no emoji
