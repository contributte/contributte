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
- The README links it. `AGENTS.md` doesn't link it; it covers development only.
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

fxnorm checks this with `contributte/prd-md-exists` for every `composer.json` with `"type": "project"`.

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
9. `## Open Questions` - bullets dated with the day the question was written down; remove each when it is decided
   and record the decision in `TECH.md` (a dated entry, see [TECH.md](TECH.md#decisions)).

Non-goals are what the product will not try to be. Out of scope is what users expect but will find in another
repository or tool.

## Writing Style

- One sentence per bullet. Put the fact first and the reason after a dash or comma.
- Use "you" only in user stories; elsewhere name the user ("a new developer", "a maintainer").
- Numbers over adjectives: "first page in under 5 minutes", not "quick start".
- No emoji, no marketing words ("best", "powerful", "full featured"), no roadmap.

## Template

`{...}` marks a placeholder: replace it with facts from the repository; delete lines that don't apply. Scope and
success criteria describe what the code does today, checked by running it, not what the template or the old
README claims.

````markdown
# {Name} PRD

{Name} is {what the project is, one sentence: framework, main features, what is wired}.

## Problem

{2 to 4 sentences: what a developer has to do without this project, and what goes wrong.}

## Users

- {Who uses it and what they already know.}
- {A second group, if there is one.}

## Goals

- {A checkable goal: a command that works on a fresh copy.}
- {A checkable goal about what the project shows or keeps small.}

## Non-goals

- {What it will not try to be} - {the reason in one clause}.

## Scope

- {Area}: {features that exist today, with the module or folder}.
- {Area}: {features}.

## Success Criteria

- {Observable fact: a URL that answers after the README steps, with the real port and the time it takes.}
- {The CI workflows that pass on `master`.}

## Out of Scope

- {What users ask for} - see {the repository or document where it lives}.

## Open Questions

- {YYYY-MM-DD}: {A question that is not decided yet.}
````

## Checklist

- [ ] The repository is a project, so `PRD.md` exists in the root
- [ ] Sections are in the order above
- [ ] Goals and success criteria can be checked by running something or opening a page
- [ ] Every non-goal has a reason
- [ ] Out of scope items point to where the thing lives
- [ ] Open questions are dated; decided ones are removed and recorded in `TECH.md`
- [ ] Scope matches what the code does today
- [ ] No placeholder and no template fact is left
- [ ] The file is 50 to 150 lines and has no emoji or marketing words
