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
- Screenshots live in `.docs/assets/` and are replaced when the UI they show changes.

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
11. `## Screenshots` - list of files in `.docs/assets/` and how to regenerate them.
12. `## Changing the UI` - the traps: what downstream code depends on and must not break.
13. `## Checklist` - 4 to 8 items to verify before merging a UI change.

## Writing Style

- Start each bullet with the fact, then the reason: "**Markup uses Bootstrap 5 classes only.** Host apps theme
  it with their own Bootstrap build."
- Name files and classes in code spans: `src/templates/datagrid.latte`, `.datagrid-row-inline-edit`.
- Write numbers, not adjectives: "breakpoint 768 px", not "on smaller screens".
- State what is not supported: "No keyboard navigation between cells."
- No emoji, no marketing words, no future plans. Plans go to issues.

## Template

A filled example for `contributte/datagrid`. Replace the facts, keep the order.

````markdown
# Datagrid Design

Datagrid renders a data table with filters, sorting, pagination, inline editing and group actions inside a
Nette application page. Developers embed it; their users see it.

## Principles

- **Markup is Bootstrap 5, nothing else.** Host apps theme it with their own Bootstrap build; we ship no
  competing design language.
- **Server renders, JS enhances.** Every action works as a plain link or form; `naja` turns it into AJAX
  snippets.
- **Templates are an API.** Apps extend `datagrid.latte` blocks; renaming a block breaks them.
- **Icons come from one prefix.** `Datagrid::$iconPrefix` (default `fas fa-`) swaps the icon set.

## Inventory

- Grid table, toolbar, pagination, per-page select: `src/templates/datagrid.latte`
- Tree view: `src/templates/datagrid_tree.latte`
- Filters (text, select, date, date range, range): `src/templates/datagrid_filter_*.latte`
- Status column and multi-action column: `src/templates/column_status.latte`, `column_multi_action.latte`
- Client behaviour (inline edit, sortable rows, datepicker, tom-select): `assets/plugins/`

## Layout

- The grid fills its container; width is set by the host page.
- Toolbar above the table, pagination and per-page select below.
- Spacing uses Bootstrap utilities; custom rules are in `assets/css/datagrid.css`.

## Typography

- Inherits the host page font and size. The grid sets no `font-family`.

## Colors and Tokens

- Source of truth: `assets/css/datagrid.css`, bundled as `datagrid-full.css`.
- Button classes come from `Datagrid::$btnSecondaryClass`; do not hard-code `btn-secondary` in templates.
- Row flash after inline edit: green `#A6E2A9` (saved), red `#E8AAA4` (error), fading to transparent.

## States

- Empty: `{block noItems}` renders one row with the translated "no items" text.
- Loading: no spinner of our own; `naja` requests keep the old content until the snippet arrives.
- Error: failed inline edit flashes the row red; validation messages come from Nette Forms.

## Accessibility

- Dropdowns carry `aria-haspopup` and `aria-expanded` from Bootstrap.
- Sort links and filters are real links and inputs, reachable by keyboard.
- Known gap: icon-only buttons have no text label unless the app sets a title.

## Dark Mode

- Follows the host page Bootstrap theme (`data-bs-theme`). `datagrid.css` defines no dark palette.

## Responsive

- One breakpoint in `datagrid.css`: `min-width: 768px`. Below it the table scrolls horizontally.

## Screenshots

- `.docs/assets/*.gif` show inline edit, group actions, hideable columns and status.
- Record a new GIF from the demo when the matching feature changes; keep it under 2 MB.

## Changing the UI

- Block names in `datagrid.latte` are public; add blocks, never rename or remove them in a minor release.
- CSS class names are used by app stylesheets; treat renames as breaking and list them in `UPGRADE.md`.
- After changing `assets/`, run `npm run build` and check `dist/datagrid-full.js` and
  `dist/datagrid-full.css`; the CDN serves those two files.

## Checklist

- [ ] Existing template blocks keep their names
- [ ] New strings go through the translator
- [ ] Works without JS (links and forms still submit)
- [ ] Checked at 375 px and 1280 px width
- [ ] Screenshots in `.docs/assets/` updated if the UI changed
````

For a skeleton (`webapp-skeleton`), the Inventory lists modules and layouts (`app/UI/Modules/Front`,
`Admin`, `Base` layouts, `resources/mail/@layout.latte`, `resources/pdf/example.latte`, Tracy error page
`resources/tracy/500.phtml`), and Principles say what the starter UI must show a new developer.

## Checklist

- [ ] The repository renders UI, so `DESIGN.md` exists in the root
- [ ] Sections are in the order above; skipped sections say why in one line
- [ ] Every inventory item names its source file
- [ ] Colors and tokens point to the CSS or template file that defines them
- [ ] Empty, loading and error states are described
- [ ] Accessibility gaps are listed, not hidden
- [ ] Screenshots are in `.docs/assets/`
- [ ] The file is 50 to 150 lines and has no emoji
- [ ] Libraries export-ignore `DESIGN.md`
