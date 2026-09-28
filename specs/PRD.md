# Contributte PRD.md Specification

This document describes the `PRD.md` file in Contributte projects: skeletons, applications, sites and demos. The
file says what the project is for, who uses it and what it must and must not do. How it is built is in
[TECH.md](TECH.md), how it looks in [DESIGN.md](DESIGN.md), repository conventions in [SKELETON.md](SKELETON.md).

## Table of Contents

- [Rules](#rules)
- [When It Is Required](#when-it-is-required)
- [Sections](#sections)
- [Writing Style](#writing-style)
- [Template](#template)
- [Checklist](#checklist)

## Rules

- `PRD.md` lives in the repository root, next to `README.md`, `TECH.md` and `AGENTS.md`.
- It is 50 to 150 lines. It is a short product document, not a backlog.
- It describes the current product. Plans and ideas go to issues; open questions go to its last section.
- It links instead of repeating: installation is in the README, stack and commands are in `TECH.md` and
  `AGENTS.md`.
- A pull request that adds, removes or changes a feature listed in `Scope` updates `PRD.md` in the same PR.
- Every `Non-goal` and `Out of Scope` item is a decision. Removing one needs the same review as adding a
  feature.

## When It Is Required

| Repository kind | Examples | Required |
|-----------------|----------|----------|
| Skeleton (`"type": "project"`) | `webapp-skeleton`, `doctrine-skeleton`, `messenger-skeleton` | yes |
| Application or site | `componette-site`, `contributte.org` | yes |
| Demo or playground | `playground`, `*-demo` | yes, short |
| Library (`"type": "library"`) | `datagrid`, `console` | no |

For a skeleton, the product is the starter template itself. Its users are developers who run
`composer create-project`, and its success is measured by what they get working without reading the code.

## Sections

Use these `##` sections in this order:

1. `# {Name} PRD` and one sentence: what the project is.
2. `## Problem` - 2 to 4 sentences: what hurts without this project.
3. `## Users` - who uses it and what they already know.
4. `## Goals` - 3 to 6 bullets, each checkable.
5. `## Non-goals` - what we decided not to do, each with a one-clause reason.
6. `## Scope` - features as user stories ("As a developer, I can ...") or plain bullets, grouped by area.
7. `## Success Criteria` - observable facts: commands that pass, pages that render, times, numbers.
8. `## Out of Scope` - things users ask for that belong elsewhere, with a pointer to where.
9. `## Open Questions` - dated bullets; remove each when it is decided and record the decision in `TECH.md`.

Non-goals are what the product will not try to be. Out of scope is what users expect but will find in another
repository or tool.

## Writing Style

- One sentence per bullet. Put the fact first and the reason after a dash or comma.
- Use "you" only in user stories; elsewhere name the user ("a new developer", "a maintainer").
- Numbers over adjectives: "first page in under 5 minutes", not "quick start".
- No emoji, no marketing words ("best", "powerful", "full featured"), no roadmap.

## Template

A filled example for `contributte/webapp-skeleton`. Replace the facts, keep the order.

````markdown
# Webapp Skeleton PRD

Webapp Skeleton is a Nette Framework starter project with Doctrine ORM, an admin module, console, mailing and
PDF output, all wired and tested.

## Problem

Starting a Nette application means choosing and wiring about 20 packages: DI extensions, Doctrine, console,
logging, mail, tests and QA. Each new project repeats that work and repeats the same mistakes in config.

## Users

- Developers who know PHP and basic Nette and start a new web application.
- Maintainers of Contributte packages who need a real app to test integrations against.

## Goals

- `composer create-project` plus `docker compose up` gives a running app with a database.
- Every bundled package is used at least once, so the wiring is shown, not described.
- `make qa` and `make tests` pass on a fresh copy.
- The code is small enough to read in one sitting and delete what you don't need.

## Non-goals

- Not a CMS or admin generator - the admin module is a sign-in example, not a product.
- No frontend build pipeline - plain CSS and JS in `www/assets/`, so there is nothing to compile.
- No multi-tenant or API setup - that is a different skeleton.

## Scope

- Front module: home page and error pages (4xx, 500).
- Admin module: sign-in, sign-out, secured home page.
- Users: Doctrine entity, repository, query object, create facade, fixtures.
- Console: `bin/console` with an example `HelloCommand`, migrations and fixtures commands.
- Mailing: templated e-mail from `resources/mail/`.
- PDF: example document from `resources/pdf/`.
- Events: Symfony event dispatcher with request and order log subscribers.
- QA: CodeSniffer, PHPStan and Nette Tester configured and passing in CI.

## Success Criteria

- A fresh copy reaches the sign-in page at `http://localhost:8080` with Docker in under 5 minutes.
- CI runs code style, PHPStan, tests and database workflows green on `master`.
- The demo at `examples.contributte.org/webapp-skeleton/` runs the current `master`.

## Out of Scope

- Per-package usage - see each package's `.docs/README.md`.
- Doctrine-only setup without the UI - see `contributte/doctrine-skeleton`.
- Messenger and queues - see `contributte/messenger-skeleton`.

## Open Questions

- 2026-09-28: Keep the PDF module in the default install or move it to a recipe?
````

## Checklist

- [ ] The repository is a project, so `PRD.md` exists in the root
- [ ] Sections are in the order above
- [ ] Goals and success criteria can be checked by running something or opening a page
- [ ] Every non-goal has a reason
- [ ] Out of scope items point to where the thing lives
- [ ] Open questions are dated; decided ones are removed and recorded in `TECH.md`
- [ ] Scope matches what the code does today
- [ ] The file is 50 to 150 lines and has no emoji or marketing words
