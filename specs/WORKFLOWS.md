# Contributte GitHub Workflows Specification

This document describes the GitHub Actions setup in Contributte repositories: which workflow files exist, how they
call the shared reusable workflows, and how Dependabot is configured. Library and skeleton specs link here from
[LIBRARY.md](LIBRARY.md#github-workflows) and [SKELETON.md](SKELETON.md).

## Table of Contents

- [Rules](#rules)
- [Reusable Workflows](#reusable-workflows)
- [Triggers](#triggers)
- [PHP Versions](#php-versions)
- [Library Workflows](#library-workflows)
- [Skeleton Workflows](#skeleton-workflows)
- [Other Projects](#other-projects)
- [Dependabot](#dependabot)
- [Funding](#funding)
- [Checklist](#checklist)

## Rules

- Workflows live in `.github/workflows/` and use the `.yml` extension.
- Every PHP repository has one file per check: `tests.yml`, `phpstan.yml`, `codesniffer.yml`, `coverage.yml`.
  Do not combine them into a single `main.yaml`, `ci.yml` or `qa.yml`.
- Jobs call reusable workflows from `contributte/.github`. Do not copy their steps inline.
- Reusable workflows are always pinned to `@master`. The old `@v1` branch is not maintained.
- Every workflow file has the same four triggers (see [Triggers](#triggers)).
- Workflows run `make` targets. A workflow only exists when the matching target exists in the `Makefile`
  (`tests`, `phpstan`, `cs`, `coverage`), see [MAKEFILE.md](MAKEFILE.md).
- `coverage.yml` passes secrets with `secrets: inherit`, so the reusable workflow can read `CODECOV_TOKEN`.
- Inline jobs are allowed only when a reusable workflow cannot express the setup, for example a job that needs a
  database service with fixtures loaded or a repository-specific extra check. Keep the standard file names anyway.

## Reusable Workflows

The shared workflows live in [contributte/.github](https://github.com/contributte/.github/tree/master/.github/workflows).
Reference them as `contributte/.github/.github/workflows/<file>@master`.

| Workflow | Runs | Use for |
|----------|------|---------|
| `nette-tester.yml` | `make tests` | Tests |
| `nette-tester-mysql.yml` | `make tests` with a MySQL service | Tests that need MySQL |
| `nette-tester-redis.yml` | `make tests` with a Redis service | Tests that need Redis |
| `nette-tester-coverage-v2.yml` | `make coverage`, uploads to Codecov | Coverage |
| `phpstan.yml` | `make phpstan` | Static analysis |
| `codesniffer.yml` | `make cs` | Coding standard |
| `php.yml` | any command (`run` input) | Projects without the standard targets |

Common inputs:

| Input | Default | Notes |
|-------|---------|-------|
| `php` | `8.2` | Always set it explicitly |
| `make` | the workflow's target | Skeletons prefix it with `init`, e.g. `init tests` |
| `composer` | `composer install --no-interaction --no-progress --prefer-dist` | Changed for the lowest-deps job |

Older workflows (`nette-tester-coverage.yml`, `phpunit.yml`, `phpunit-coverage.yml`, `codeception.yml`) still exist
but are not used in new setups. Coverage goes through `nette-tester-coverage-v2.yml`, which runs any `make coverage`
target, so it also works for PHPUnit-based projects.

## Triggers

Every workflow file uses this block:

```yaml
on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"
```

- `pull_request` runs checks on PRs, including forks.
- `workflow_dispatch` allows a manual run from the Actions tab.
- `push` to any branch runs checks before a PR is opened.
- `schedule` runs weekly on Monday morning (UTC), so dependency breakage shows up even without commits.
  Templates use `0 8 * * 1`. Existing repositories that stagger the files to 09:00 or 10:00 are fine.

## PHP Versions

- `tests.yml` has one job for every PHP minor version from the `php` constraint in `composer.json` up to the
  newest release (currently 8.5).
- Libraries add a `testlower` job on the minimum PHP version with the lowest dependencies:
  `composer update --no-interaction --no-progress --prefer-dist --prefer-stable --prefer-lowest`.
- Job ids are `test85`, `test84`, ... and `testlower`. Each job id matches the PHP version it runs.
- The job name is the workflow name (`Nette Tester`). The reusable workflow appends the PHP version.
- `phpstan.yml`, `codesniffer.yml` and `coverage.yml` each run one job, and all three use the same PHP version.
  Libraries use their minimum supported version, skeletons use the version they require.
- When the minimum PHP version changes, update `composer.json` and all four workflow files together.

## Library Workflows

```
.github/workflows/
├── codesniffer.yml
├── coverage.yml
├── phpstan.yml
└── tests.yml
```

Libraries don't need a `dependabot.yml`: the matrix and the weekly schedule already test the newest and the lowest
allowed dependencies.

### tests.yml

```yaml
name: "Nette Tester"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  test85:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.5"

  test84:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.4"

  test83:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.3"

  test82:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.2"

  testlower:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.2"
      composer: "composer update --no-interaction --no-progress --prefer-dist --prefer-stable --prefer-lowest"
```

For MySQL or Redis tests, call `nette-tester-mysql.yml` or `nette-tester-redis.yml` in every job instead and pass
the service inputs (`mysql`, `database` or `redis`).

### phpstan.yml

```yaml
name: "Phpstan"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  phpstan:
    name: "Phpstan"
    uses: contributte/.github/.github/workflows/phpstan.yml@master
    with:
      php: "8.2"
```

### codesniffer.yml

```yaml
name: "Codesniffer"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  codesniffer:
    name: "Codesniffer"
    uses: contributte/.github/.github/workflows/codesniffer.yml@master
    with:
      php: "8.2"
```

### coverage.yml

```yaml
name: "Coverage"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  coverage:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester-coverage-v2.yml@master
    secrets: inherit
    with:
      php: "8.2"
```

## Skeleton Workflows

Skeletons use the same four files and names as libraries, with these differences:

- One test job on the PHP version the skeleton requires (currently 8.4). A job for the newest PHP may be added.
- No `testlower` job. Skeletons install from `composer.lock`.
- `tests`, `phpstan` and `coverage` run `make init <target>`, so the local config exists before the check runs.
  Skeletons without an `init` target use `setup` instead. `codesniffer.yml` needs no prefix.
- Skeletons have a `dependabot.yml` (see [Dependabot](#dependabot)).
- A skeleton without a `tests/` directory has only `phpstan.yml` and `codesniffer.yml`.

```
.github/
├── dependabot.yml
└── workflows/
    ├── codesniffer.yml
    ├── coverage.yml
    ├── phpstan.yml
    └── tests.yml
```

### tests.yml

```yaml
name: "Nette Tester"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  test84:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.4"
      make: "init tests"
```

### phpstan.yml

```yaml
name: "Phpstan"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  phpstan:
    name: "Phpstan"
    uses: contributte/.github/.github/workflows/phpstan.yml@master
    with:
      php: "8.4"
      make: "init phpstan"
```

### codesniffer.yml

Same as the [library file](#codesnifferyml) with `php: "8.4"`.

### coverage.yml

```yaml
name: "Coverage"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  coverage:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester-coverage-v2.yml@master
    secrets: inherit
    with:
      php: "8.4"
      make: "init coverage"
```

## Other Projects

Demos and other PHP projects without the standard `make` targets use one `php.yml` that calls the generic
workflow. It uses the same triggers and `@master`:

```yaml
name: "PHP"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 8 * * 1"

jobs:
  php:
    name: "PHP check"
    uses: contributte/.github/.github/workflows/php.yml@master
    with:
      name: "PHP check"
      php: "8.4"
      run: "composer validate"
```

JavaScript packages, websites and deployment repositories are not covered by this spec.

## Dependabot

Skeletons and projects with a `composer.lock` have `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: composer
    directory: "/"
    schedule:
      interval: daily
    labels:
      - "dependencies"
      - "automerge"
```

- Updates run daily for Composer.
- The `dependencies` and `automerge` labels are required. `automerge` lets passing updates merge without review.
- Projects with a `package.json` may add an `npm` entry with the same schedule and labels.
- Libraries usually have no `dependabot.yml` (see [Library Workflows](#library-workflows)).

## Funding

`FUNDING.yml` is set once for the whole organization in `contributte/.github`. Repositories don't add their own
copy unless they need different funding links.

## Checklist

- [ ] `.github/workflows/` has `tests.yml`, `phpstan.yml`, `codesniffer.yml` and `coverage.yml` (all `.yml`)
- [ ] Workflow names are `Nette Tester`, `Phpstan`, `Codesniffer` and `Coverage`
- [ ] Every job calls a `contributte/.github` reusable workflow pinned to `@master`
- [ ] Every file has `pull_request`, `workflow_dispatch`, `push` on `["*"]` and a weekly Monday `schedule`
- [ ] `tests.yml` covers every PHP version from the `composer.json` minimum to the newest, with matching job ids
- [ ] Libraries: `testlower` runs on the minimum PHP with `--prefer-stable --prefer-lowest`
- [ ] `phpstan.yml`, `codesniffer.yml` and `coverage.yml` set `php` explicitly, all to the same version
- [ ] `coverage.yml` uses `nette-tester-coverage-v2.yml` with `secrets: inherit`
- [ ] Skeletons: `make` input is prefixed with `init` (or `setup`), no `testlower` job
- [ ] Skeletons: `.github/dependabot.yml` with daily Composer updates and `dependencies` and `automerge` labels
- [ ] No per-repository `FUNDING.yml`
