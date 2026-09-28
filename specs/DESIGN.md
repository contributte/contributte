# Contributte DESIGN.md Specification

This document describes the `DESIGN.md` file in Contributte repositories that render a user interface. The file
records how the UI looks and behaves, where its source of truth lives and how to change it without breaking
downstream applications. Product intent is in [PRD.md](PRD.md), technical design in [TECH.md](TECH.md), user
documentation in [DOCS.md](DOCS.md).

## Table of Contents

- [Rules](#rules)
- [When It Is Required](#when-it-is-required)
- [Sections](#sections)
- [Writing Style](#writing-style)
- [Screenshots](#screenshots)
- [Template](#template)
- [Checklist](#checklist)

## Rules

- `DESIGN.md` lives in the repository root, next to `README.md` and `AGENTS.md`.
- It is 50 to 150 lines. Longer material moves to `.docs/` and is linked.
- It is written for the next person or agent who edits the UI. It is not user documentation.
- It links instead of repeating: the README for installation, `.docs/` for usage, `AGENTS.md` for commands.
- Colors, spacing and fonts are defined in CSS or templates. `DESIGN.md` names the file that defines them and
  never becomes a second copy of the values.
- It is updated in the same pull request as the change that makes it wrong. A stale `DESIGN.md` is a bug.
- Libraries list `DESIGN.md` in `.gitattributes` as `export-ignore` (see [COMPOSER.md](COMPOSER.md)).
- Screenshots live in `.docs/assets/` (never in the `.docs` root or the repository root) and are replaced when the
  UI they show changes.
- Every screenshot is listed in `## Screenshots` with the date it was taken (see [Screenshots](#screenshots)).

## When It Is Required

A repository needs `DESIGN.md` when it renders something a human looks at:

| Repository kind | Examples | Required |
|-----------------|----------|----------|
| UI component with templates, CSS or JS | `datagrid`, `forms-bootstrap`, `forms-multiplier` | yes |
| Debugger output (Tracy panels, BlueScreen sections, error pages) | `tracy`, `nextras-orm-query-panel` | yes |
| Skeleton or app with presenters and templates | `webapp-skeleton`, `componette-site` | yes |
| Mail or PDF templates shipped to users | `mailing`, `pdf` | yes, short |
| Library without visual output | `di`, `console`, `utils` | no |

When in doubt, ask: does a change in this repository show up in someone's browser? If yes, write the file.

fxnorm checks this with `contributte/design-md-exists`: a repository renders a UI when it ships Latte or PHTML
templates or CSS in `src/`, `app/`, `resources/`, `templates/` or `www/`, or CSS or JS in `assets/`.

## Sections

Use these `##` sections in this order. Leave a section out only when it does not apply, and say so in one line
("No dark mode; the component inherits the host page theme.") instead of deleting it silently.

1. `# {Name} Design` and one sentence: what the UI is and who sees it.
2. `## Principles` - 3 to 5 bullets. Each states a constraint that decides real choices.
3. `## Inventory` - screens, components or templates, each with its source file.
4. `## Layout` - grid, containers, spacing scale, where the layout is defined.
5. `## Typography` - font stack and sizes, or "inherits from the host page".
6. `## Colors and Tokens` - the file that defines colors and the few values that carry meaning.
7. `## States` - empty, loading, error and success, and how each looks.
8. `## Accessibility` - the baseline the UI meets and known gaps.
9. `## Dark Mode` - supported or not, and how it is switched.
10. `## Responsive` - breakpoints and what changes at each.
11. `## Screenshots` - every file in `.docs/assets/`, what it shows, when it was taken, how to retake it.
12. `## Changing the UI` - the traps: what downstream code depends on and must not break.
13. `## Checklist` - 4 to 8 items to verify before merging a UI change.

## Writing Style

- Start each bullet with the fact, then the reason: "**Markup uses Bootstrap 5 classes only.** Host apps theme
  it with their own Bootstrap build."
- Name files and classes in code spans: `src/templates/datagrid.latte`, `.datagrid-row-inline-edit`.
- Write numbers, not adjectives: "breakpoint 768 px", not "on smaller screens".
- State what is not supported: "No keyboard navigation between cells."
- No emoji, no marketing words, no future plans. Plans go to issues.

## Screenshots

- One bullet per file: path, what it shows, the date it was taken and the version it shows:
  "`.docs/assets/inline-edit.gif` - inline edit of one row, 2026-09-28, `v7.1.0`."
- A screenshot whose date is unknown is listed as `undated`. Compare it with the current UI: retake it when it
  shows an old name, layout or feature, otherwise date it on the day you checked it and add `(checked)`.
- An outdated screenshot that can't be retaken now is a known gap; say what differs in one clause.
- In the README, a gallery of more than one screenshot has one line per image: a short caption, then the image.
  Screenshots of variants of the same screen (themes, sizes) may be a row of thumbnails in one `<p align=center>`.
- New images are named after what they show (`admin-sign-in.png`), not numbered (`screenshot3.png`).

## Template

`{...}` marks a placeholder: replace it with facts from the repository; delete lines that don't apply. Keep the
section order. Every claim is checked in the templates, CSS and JS, not taken from the template or the README:
whether `dist/` is committed, which breakpoints exist, whether dark mode is followed.

````markdown
# {Name} Design

{What the UI is and who sees it, in one or two sentences.}

## Principles

- **{A constraint that decides real choices, e.g. the CSS framework the markup uses}.** {Why.}
- **{How server rendering and JS split the work}.** {What works without JS.}
- **{What downstream code depends on, e.g. template blocks}.** {What breaks when it changes.}

## Inventory

- {Screen, component or template}: `{source file}`
- {Client behaviour}: `{folder or file}`

## Layout

- {What sets the width and the containers.}
- {Where custom spacing rules are defined: `{css file}`.}

## Typography

- {Font stack and sizes, with the file, or "Inherits the host page font and size."}

## Colors and Tokens

- Source of truth: `{css or template file}`, bundled as `{built file}` when there is a build step.
- {The few values that carry meaning, with the option or class that controls them.}

## States

- Empty: {how it looks, with the block or template}.
- Loading: {spinner or not, and what shows meanwhile}.
- Error: {how errors show}.

## Accessibility

- {What the markup provides.}
- Known gap: {what is missing}.

## Dark Mode

- {Supported or not, and what decides it, checked in the CSS.}

## Responsive

- {Breakpoints from the CSS and what changes at each, or what happens on a narrow screen.}

## Screenshots

- `.docs/assets/{file}` - {what it shows}, {YYYY-MM-DD or undated}, {version}.
- {How to retake them.}

## Changing the UI

- {What is public: block names, CSS classes, options; what a rename breaks.}
- {Build step after changing assets, and which files it produces; whether they are committed.}

## Checklist

- [ ] {4 to 8 checks before merging a UI change, e.g. widths to test, translations, no-JS behaviour}
- [ ] Screenshots in `.docs/assets/` updated if the UI changed
````

For a skeleton, the Inventory lists modules and layouts (`app/UI/Modules/{Module}`), mail and PDF templates, and
every error page (4xx and 500 templates, and the Tracy error page when there is one), each with its file.
Principles say what the starter UI must show a new developer.

## Checklist

- [ ] The repository renders UI, so `DESIGN.md` exists in the root
- [ ] Sections are in the order above; skipped sections say why in one line
- [ ] Every inventory item names its source file
- [ ] Colors and tokens point to the CSS or template file that defines them
- [ ] Empty, loading and error states are described
- [ ] Accessibility gaps are listed, not hidden
- [ ] Screenshots are in `.docs/assets/` and each is listed with its date (or `undated`)
- [ ] No placeholder and no template fact is left
- [ ] The file is 50 to 150 lines and has no emoji
- [ ] Libraries export-ignore `DESIGN.md`
