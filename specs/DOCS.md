# Contributte Documentation Specification

This document describes how `README.md`, the `.docs` folder and `LICENSE` are written in Contributte repositories.
It extends the short [Documentation](LIBRARY.md#documentation) section in LIBRARY.md and the
[Documentation](SKELETON.md#documentation) section in SKELETON.md. How to write the text is described in
[TONE.md](TONE.md).

## Table of Contents

- [Rules](#rules)
- [Placeholders](#placeholders)
- [Header](#header)
- [Badges](#badges)
- [Library README Template](#library-readme-template)
- [Skeleton README Template](#skeleton-readme-template)
- [.docs Folder](#docs-folder)
- [.docs/README.md Template](#docsreadmemd-template)
- [LICENSE](#license)
- [Checklist](#checklist)

## Rules

- Every repository has a `README.md` (uppercase) and a `LICENSE` file in the root.
- The root `README.md` is short: header, description, install command, link to docs, versions table, maintainers,
  footer.
- Libraries keep the full documentation in `.docs/README.md`. The root README only links to it.
- The root README links to the docs as `[documentation](.docs)`. Don't link to contributte.org instead.
- Images used in docs or READMEs live in `.docs/assets/`.
- All badges come from [badgen.net](https://badgen.net). Don't use shields.io, Travis, Scrutinizer or GitHub `badge.svg`.
- Badges, links and the header point to the repository's current home, `contributte/{repo}`, not to an old
  organization (`nettrine`, `ublaboo`, `juicyfx`, `f00b4r`, …). Packagist badges use the real composer name.
- Coverage is reported to Codecov by the shared coverage workflow, so the coverage badge is Codecov.
- Section headings use the exact names from the templates (`## Versions`, not `## Version`).

## Placeholders

| Placeholder | Meaning | Example |
|-------------|---------|---------|
| `{repo}` | GitHub repository name | `utils` |
| `{package}` | Composer package name | `contributte/utils`, `nettrine/orm` |
| `{Name}` | Human readable name | `Utils`, `Doctrine ORM` |
| `{Extension}` | DI extension class | `Contributte\Utils\DI\UtilsExtension` |
| `{name}` | Extension name in NEON | `utils` |
| `{Library}` | Integrated library, if any | `Symfony Console` |
| `{library-url}` | Link to the integrated library | `https://symfony.com/doc/current/console.html` |

## Header

The README starts with a generated heading image, not a markdown `# Title`:

```markdown
![](https://heatbadger.now.sh/github/readme/contributte/{repo}/)
```

It is followed by two centered badge rows ([Badges](#badges)) and a centered links line:

```html
<p align=center>
Website 🚀 <a href="https://contributte.org">contributte.org</a> | Contact 👨🏻‍💻 <a href="https://f3l1x.io">f3l1x.io</a> | Twitter 🐦 <a href="https://twitter.com/contributte">@contributte</a>
</p>
```

## Badges

Nine badges in two `<p align=center>` rows, always in this order. Each badge is wrapped in a link.

| Row | Badge | Image | Link |
|-----|-------|-------|------|
| 1 | Build | `badgen.net/github/checks/contributte/{repo}/master?cache=300` | `github.com/contributte/{repo}/actions` |
| 1 | Coverage | `badgen.net/codecov/c/github/contributte/{repo}` | `codecov.io/gh/contributte/{repo}` |
| 1 | Downloads | `badgen.net/packagist/dm/{package}` | `packagist.org/packages/{package}` |
| 1 | Version | `badgen.net/packagist/v/{package}` | `packagist.org/packages/{package}` |
| 2 | PHP | `badgen.net/packagist/php/{package}` | `packagist.org/packages/{package}` |
| 2 | License | `badgen.net/github/license/contributte/{repo}` | `github.com/contributte/{repo}` |
| 2 | Gitter | `badgen.net/badge/support/gitter/cyan` | `bit.ly/ctteg` |
| 2 | Forum | `badgen.net/badge/support/forum/yellow` | `bit.ly/cttfo` |
| 2 | Sponsor | `badgen.net/badge/sponsor/donations/F96854` | `contributte.org/partners.html` |

- Leave out the coverage badge only when the repository has no coverage workflow.
- The old "become a patron" badge is replaced by the sponsor badge.
- Non-PHP packages (npm) swap the Packagist badges for `badgen.net/npm/...` ones and keep the rest.

## Library README Template

````markdown
![](https://heatbadger.now.sh/github/readme/contributte/{repo}/)

<p align=center>
  <a href="https://github.com/contributte/{repo}/actions"><img src="https://badgen.net/github/checks/contributte/{repo}/master?cache=300"></a>
  <a href="https://codecov.io/gh/contributte/{repo}"><img src="https://badgen.net/codecov/c/github/contributte/{repo}"></a>
  <a href="https://packagist.org/packages/{package}"><img src="https://badgen.net/packagist/dm/{package}"></a>
  <a href="https://packagist.org/packages/{package}"><img src="https://badgen.net/packagist/v/{package}"></a>
</p>
<p align=center>
  <a href="https://packagist.org/packages/{package}"><img src="https://badgen.net/packagist/php/{package}"></a>
  <a href="https://github.com/contributte/{repo}"><img src="https://badgen.net/github/license/contributte/{repo}"></a>
  <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
  <a href="https://bit.ly/cttfo"><img src="https://badgen.net/badge/support/forum/yellow"></a>
  <a href="https://contributte.org/partners.html"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

<p align=center>
Website 🚀 <a href="https://contributte.org">contributte.org</a> | Contact 👨🏻‍💻 <a href="https://f3l1x.io">f3l1x.io</a> | Twitter 🐦 <a href="https://twitter.com/contributte">@contributte</a>
</p>

{Name} integrates [{Library}]({library-url}) into Nette Framework. {One sentence on what it gives you.}

## Usage

To install the latest version of `{package}`, use [Composer](https://getcomposer.org):

```bash
composer require {package}
```

Requires PHP 8.2 or later and Nette 3.2.

Register the extension in your `config.neon`:

```neon
extensions:
	{name}: {Extension}
```

## Documentation

For details on how to use this package, check out the [documentation](.docs).

## Versions

| State       | Version | Branch   | Nette  | PHP     |
|-------------|---------|----------|--------|---------|
| dev         | `^0.2`  | `master` | `3.2+` | `>=8.2` |
| stable      | `^0.1`  | `master` | `3.2+` | `>=8.2` |

## Development

See [how to contribute](https://contributte.org/contributing.html) to this package.

This package is currently maintained by these authors.

<a href="https://github.com/f3l1x">
  <img width="80" height="80" src="https://avatars2.githubusercontent.com/u/538058?v=3&s=80">
</a>

-----

Consider [supporting](https://contributte.org/partners.html) the **contributte** development team.
Thank you for using this package.
````

Section order is fixed: description, **Usage**, **Documentation**, **Versions**, **Development**, then the footer.

- The **description** is one to three sentences without a heading, between the links line and `## Usage`. The first
  sentence says what the package is, the second why you would want it. Packages that don't integrate another
  library start with what they are: "Contributte Utils is a set of small helpers for Nette Framework."
- **Usage** holds the install command, one requirements sentence that matches the Versions table, and the smallest
  working example (usually the extension registration). Longer examples go to `.docs/README.md`.
- **Versions** has the columns `State | Version | Branch | Nette | PHP`, newest first. Packages that don't depend on
  Nette drop the `Nette` column. An extra column (e.g. `Symfony`, `Bootstrap`) is fine when it matters.
- **Development** lists maintainers as 80×80 GitHub avatars linking to their profiles.
- The footer is a `-----` rule followed by the two support lines. Older READMEs with "currently maintaining by"
  or "Consider to support" are updated to the template text.

## Skeleton README Template

Skeletons (`"type": "project"`) use the same header, badges, Development section and footer. The body describes
the project instead of an install command, and there's no `.docs/README.md`.

````markdown
<!-- header, badge rows and links line, same as the library template -->

<p align=center>
  <img src="https://api.microlink.io?url=https%3A%2F%2Fexamples.contributte.org%2F{repo}%2F&overlay.browser=light&screenshot=true&meta=false&embed=screenshot.url"></img>
</p>

-----

## Goal

What the skeleton demonstrates and which packages it's built on.

## Demo

https://examples.contributte.org/{repo}/

## Installation

```bash
composer create-project -s dev {package} acme
```

## Startup

```bash
make dev
```

## Development

<!-- same as the library template, then the footer -->
````

- Section order: **Goal**, **Demo**, **Installation**, **Startup**, optional **Features** / **Screenshots**,
  **Development**.
- Screenshots are stored in `.docs/assets/` and linked from the README.

## .docs Folder

```
.docs/
├── README.md       # Main documentation (libraries)
└── assets/         # Images and diagrams
```

- `.docs/README.md` is the entry point. contributte.org renders it as the package page.
- Large packages may split the docs into more files next to `README.md` (e.g. `.docs/columns.md`). `README.md`
  then acts as the table of contents and links to them.
- Docs for old major versions are kept as `README-v{major}.md` and linked from `README.md`.
- File names are uppercase `README.md`; images go to `assets/`, not the `.docs` root.

## .docs/README.md Template

````markdown
# Contributte {Name}

Short description, with a link to the integrated library if there is one.

## Content

- [Setup](#setup)
- [Configuration](#configuration)
- [Usage](#usage)
- [Examples](#examples)

## Setup

Install the package with [Composer](https://getcomposer.org):

```bash
composer require {package}
```

Register the [compiler extension](https://doc.nette.org/en/dependency-injection/nette-container) in your `config.neon`:

```neon
extensions:
	{name}: {Extension}
```

## Configuration

### Minimal configuration

```neon
{name}:
	# minimal options
```

### Advanced configuration

```neon
{name}:
	# option: <type>
```

## Usage

Inject the service where you need it:

```php
use Contributte\{Name}\ExampleService;

final class HomePresenter extends Presenter
{

	public function __construct(
		private ExampleService $service,
	)
	{
	}

}
```

## Examples

> [!TIP]
> Take a look at more examples in [contributte/playground](https://github.com/contributte/playground).
````

- The heading is `# Contributte {Name}` (the `{Name}` part may be the product name, e.g. `# Contributte Doctrine ORM`).
- `## Content` is a bullet list linking every `##` section (and important `###` ones, nested). It is required
  unless the doc is only a few short sections.
- `## Setup` (or `## Installation`) always comes first and shows `composer require` plus the extension registration.
- `## Configuration`, `## Usage` and `## Examples` follow in this order when they apply. Package specific sections
  (e.g. `## Console`, `## Tracy`) go between Usage and Examples.
- `## Examples` points to [contributte/playground](https://github.com/contributte/playground), a skeleton or
  [contributte.org/examples](https://contributte.org/examples.html).
- Use NEON with tabs, `bash` for shell commands, and GitHub alerts (`> [!NOTE]`, `> [!TIP]`) for hints.
- Every code block has a lead-in sentence that ends with a colon ([TONE.md](TONE.md#formatting)).

## LICENSE

- The file is named `LICENSE`, with no extension (not `LICENSE.md`, `LICENCE` or `license.md`).
- The license is MIT, matching `"license": "MIT"` in `composer.json`.
- Packages forked from an upstream project keep the upstream license (e.g. BSD-3-Clause, GPL, LGPL). `LICENSE` and
  `composer.json` must state the same license.
- The copyright line always names a holder. New repositories use `Contributte`:

```
MIT License

Copyright (c) {year} Contributte

Permission is hereby granted, free of charge, to any person obtaining a copy
...
```

- `{year}` is the year the project was created. Don't bump it on every release.
- Projects moved in from other organizations may keep the original holder (e.g. `Nettrine`, `Apitte`).

## Checklist

- [ ] `README.md` starts with the heatbadger image for `contributte/{repo}`
- [ ] Two badge rows with the nine badgen badges in order, pointing to `contributte/{repo}` and `{package}`
- [ ] Coverage badge is Codecov
- [ ] Website / Contact / Twitter links line
- [ ] A description of one to three sentences before `## Usage` (libraries)
- [ ] Sections: Usage, Documentation, Versions, Development (skeletons: Goal, Demo, Installation, Startup, Development)
- [ ] Usage has the install command, a requirements sentence and a working example
- [ ] Documentation links to `.docs`
- [ ] Versions table with `State | Version | Branch | Nette | PHP`
- [ ] Maintainer avatars and the support footer ("Consider supporting …")
- [ ] Text follows [TONE.md](TONE.md)
- [ ] `.docs/README.md` with `# Contributte {Name}`, `## Content`, `## Setup` (libraries)
- [ ] Images in `.docs/assets/`
- [ ] `LICENSE` file (MIT, with holder and year), same license as `composer.json`
