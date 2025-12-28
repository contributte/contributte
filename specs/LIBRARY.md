# Contributte Library Development Specification

This document describes the standards and conventions for developing Contributte libraries.

## Table of Contents

- [Reference Repositories](#reference-repositories)
- [AI Development](#ai-development)
- [Git Strategy](#git-strategy)
- [Quality Assurance](#quality-assurance)
- [Directory Structure](#directory-structure)
- [Requirements](#requirements)
- [Composer Configuration](#composer-configuration)
- [Makefile](#makefile)
- [PHPStan Configuration](#phpstan-configuration)
- [Coding Standards](#coding-standards)
- [GitHub Workflows](#github-workflows)
- [Testing](#testing)
- [Editor Configuration](#editor-configuration)
- [Git Configuration](#git-configuration)
- [Documentation](#documentation)
- [Versioning](#versioning)
- [Checklist for New Libraries](#checklist-for-new-libraries)

## Reference Repositories

- [contributte/doctrine-dbal](https://github.com/contributte/doctrine-dbal)
- [contributte/doctrine-orm](https://github.com/contributte/doctrine-orm)
- [contributte/messenger](https://github.com/contributte/messenger)
- [contributte/nella](https://github.com/contributte/nella)

## AI Development

When using AI agents (Claude, GPT, etc.) to contribute to Contributte libraries:

### Git Configuration

```bash
git config user.name "Felixbot"
git config user.email "ai@f3l1x.io"
```

### Guidelines

- Always commit under the `ai@f3l1x.io` email address
- Follow all coding standards and QA requirements
- Run all checks before committing
- Write clear, descriptive commit messages

## Git Strategy

### Rebasing

- **Always use rebase** instead of merge to keep history clean
- Before starting work: `git fetch origin && git rebase origin/master`
- Keep commits atomic and focused on single logical changes

### Commit Style

- Review the **last 10 commits** in the repository to match the existing style
- Use imperative mood in commit messages (e.g., "Add feature" not "Added feature")
- Commit logical blocks of work separately
- Keep commits small and focused

### Commit Message Format

```
Short summary (max 50 chars)

Optional longer description explaining the "why" behind
the change. Wrap at 72 characters.
```

### Examples

```bash
# Check recent commit style
git log -10 --oneline

# Rebase before pushing
git fetch origin
git rebase origin/master
```

## Quality Assurance

**Always run these checks before committing:**

### 1. Code Style (CodeSniffer)

```bash
make cs
```

Fix issues automatically:

```bash
make csf
```

### 2. Static Analysis (PHPStan)

```bash
make phpstan
```

### 3. Tests (Nette Tester)

```bash
make tests
```

### Full QA Check

Run all checks at once:

```bash
make qa
```

### Requirements

- All checks **must pass** before committing
- Never commit code with failing tests or static analysis errors
- Fix code style issues before committing (use `make csf`)

## Directory Structure

```
├── .docs/                    # Documentation files
│   └── README.md             # Main documentation
├── .github/                  # GitHub workflows and templates
│   └── workflows/            # CI/CD workflow files
├── src/                      # Source code
├── tests/                    # Test suite
│   ├── Cases/                # Test cases
│   ├── Fixtures/             # Test fixtures and data
│   └── bootstrap.php         # Test bootstrap file
├── .editorconfig             # Editor configuration
├── .gitattributes            # Git export attributes
├── .gitignore                # Git ignore rules
├── composer.json             # Composer configuration
├── LICENSE                   # MIT License
├── Makefile                  # Build automation
├── phpstan.neon              # PHPStan configuration
├── README.md                 # Project readme
└── ruleset.xml               # PHP CodeSniffer rules
```

## Requirements

- **PHP Version**: 8.2+ (minimum)
- **Nette Framework**: 3.2+
- **Coding Standard**: Contributte QA ruleset

## Composer Configuration

### composer.json Structure

```json
{
  "name": "{vendor}/{package}",
  "description": "Package description",
  "license": "MIT",
  "type": "library",
  "homepage": "https://github.com/contributte/{package}",
  "authors": [
    {
      "name": "Milan Felix Sulc",
      "homepage": "https://f3l1x.io"
    }
  ],
  "require": {
    "php": ">=8.2"
  },
  "require-dev": {
    "contributte/qa": "^0.4.0",
    "contributte/phpstan": "^0.1.0",
    "mockery/mockery": "^1.6.0",
    "nette/tester": "^2.5.0"
  },
  "autoload": {
    "psr-4": {
      "{Org}\\{Library}\\": "src"
    }
  },
  "autoload-dev": {
    "psr-4": {
      "Tests\\": "tests"
    }
  },
  "config": {
    "sort-packages": true,
    "allow-plugins": {
      "dealerdirect/phpcodesniffer-composer-installer": true
    }
  },
  "extra": {
    "branch-alias": {
      "dev-master": "0.1.x-dev"
    }
  },
  "minimum-stability": "dev",
  "prefer-stable": true
}
```

### Development Dependencies

| Package | Purpose | When to Use |
|---------|---------|-------------|
| `contributte/qa` | Coding standards ruleset | Always required for code style checks |
| `contributte/phpstan` | PHPStan configuration | Always required for static analysis |
| `nette/tester` | Testing framework | Always required for running tests |
| `mockery/mockery` | Mocking library | When tests need to mock dependencies |

## Makefile

The Makefile provides standardized development commands:

```makefile
.PHONY: install
install:
	composer update

.PHONY: qa
qa: phpstan cs

.PHONY: cs
cs:
ifdef GITHUB_ACTION
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp -q --report=checkstyle src tests | cs2pr
else
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp src tests
endif

.PHONY: csf
csf:
	vendor/bin/phpcbf --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp src tests

.PHONY: phpstan
phpstan:
	vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: tests
tests:
	vendor/bin/tester -s -p php --colors 1 -C tests/Cases

.PHONY: coverage
coverage:
ifdef GITHUB_ACTION
	vendor/bin/tester -s -p phpdbg --colors 1 -C --coverage coverage.xml --coverage-src src tests/Cases
else
	vendor/bin/tester -s -p phpdbg --colors 1 -C --coverage coverage.html --coverage-src src tests/Cases
endif
```

### Available Commands

| Command | Description |
|---------|-------------|
| `make install` | Install/update Composer dependencies |
| `make qa` | Run all quality assurance checks (phpstan + cs) |
| `make cs` | Run code style checks |
| `make csf` | Fix code style issues automatically |
| `make phpstan` | Run static analysis |
| `make tests` | Execute test suite |
| `make coverage` | Generate code coverage report |

## PHPStan Configuration

### phpstan.neon

```neon
includes:
    - vendor/contributte/phpstan/phpstan.neon

parameters:
    level: 9
    phpVersion: 80200

    scanDirectories:
        - src

    fileExtensions:
        - php

    paths:
        - src
        - .docs

    ignoreErrors:
```

### Configuration Details

- **Level**: 9 (strictest)
- **PHP Version**: Matches minimum required version
- **Scan paths**: `src` and `.docs` directories

## Coding Standards

### ruleset.xml

```xml
<?xml version="1.0"?>
<ruleset>
    <rule ref="./vendor/contributte/qa/ruleset-8.2.xml"/>

    <rule ref="SlevomatCodingStandard.Files.TypeNameMatchesFileName">
        <properties>
            <property name="rootNamespaces" type="array">
                <element key="src" value="{Org}\{Library}"/>
                <element key="tests" value="Tests"/>
            </property>
        </properties>
    </rule>

    <exclude-pattern>/tests/tmp</exclude-pattern>
</ruleset>
```

### Key Points

- Uses `contributte/qa` base ruleset
- Requires PHP 8.2 compatible ruleset
- Enforces file/class name matching
- Excludes temporary test directories
- Replace `{Org}\{Library}` with actual namespace (e.g., `Nettrine\DBAL`, `Contributte\Messenger`)

## GitHub Workflows

Libraries use reusable workflows from `contributte/.github` repository.

### Required Workflow Files

```
.github/workflows/
├── codesniffer.yml
├── coverage.yml
├── phpstan.yml
└── tests.yml
```

### Workflow Templates

#### tests.yml

Tests must run from the minimum supported PHP version (with `--prefer-lowest` flag) up to the latest PHP version.

```yaml
name: "Nette Tester"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: [ "*" ]

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
      php: "8.4"

  test82:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.2"

  testlowest:
    name: "Nette Tester Lowest"
    uses: contributte/.github/.github/workflows/nette-tester.yml@master
    with:
      php: "8.2"
      composer: "composer update --no-interaction --no-progress --prefer-dist --prefer-lowest --prefer-stable"
```

#### phpstan.yml

```yaml
name: "Phpstan"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 9 * * 1"

jobs:
  phpstan:
    name: "Phpstan"
    uses: contributte/.github/.github/workflows/phpstan.yml@master
    with:
      php: "8.4"
```

#### codesniffer.yml

```yaml
name: "Codesniffer"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 10 * * 1"

jobs:
  codesniffer:
    name: "Codesniffer"
    uses: contributte/.github/.github/workflows/codesniffer.yml@master
    with:
      php: "8.4"
```

#### coverage.yml

```yaml
name: "Coverage"

on:
  pull_request:
  workflow_dispatch:

  push:
    branches: ["*"]

  schedule:
    - cron: "0 11 * * 1"

jobs:
  coverage:
    name: "Nette Tester"
    uses: contributte/.github/.github/workflows/nette-tester-coverage-v2.yml@master
    with:
      php: "8.4"
    secrets: inherit
```

### Workflow Triggers

All workflows are triggered by:
- Pull requests
- Manual dispatch (`workflow_dispatch`)
- Push to any branch
- Weekly schedule (Monday 8:00 UTC)

## Testing

### Test Structure

```
tests/
├── Cases/              # Test cases organized by feature
│   ├── Unit/           # Unit tests
│   └── Integration/    # Integration tests
├── Fixtures/           # Test fixtures and data
└── bootstrap.php       # Test bootstrap file
```

### Test Bootstrap

```php
<?php declare(strict_types = 1);

require __DIR__ . '/../vendor/autoload.php';

Tester\Environment::setup();
```

### Writing Tests

Contributte libraries use [Nette Tester](https://tester.nette.org/). There are two approaches to writing tests:

#### PHPT Tests (Preferred)

PHPT tests are simple, self-contained test files. This is the **preferred approach** for most tests.

```php
<?php declare(strict_types = 1);

use Tester\Assert;

require_once __DIR__ . '/../../bootstrap.php';

// Test code
$result = someFunction();

Assert::same('expected', $result);
Assert::true(true);
Assert::count(3, $array);
```

#### TestCase Class

Use `TestCase` when you need setup/teardown methods or when grouping related tests makes sense.

```php
<?php declare(strict_types = 1);

namespace Tests\Cases\Unit;

use Tester\Assert;
use Tester\TestCase;

require_once __DIR__ . '/../../bootstrap.php';

final class ExampleTest extends TestCase
{
    private $service;

    protected function setUp(): void
    {
        $this->service = new Service();
    }

    public function testFeatureA(): void
    {
        Assert::same('expected', $this->service->methodA());
    }

    public function testFeatureB(): void
    {
        Assert::true($this->service->methodB());
    }
}

(new ExampleTest())->run();
```

### When to Use Each Approach

| Approach | Use When |
|----------|----------|
| **PHPT** (preferred) | Simple tests, single assertions, no shared setup needed |
| **TestCase** | Multiple related tests sharing setup, need setUp/tearDown lifecycle |

## Editor Configuration

### .editorconfig

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = tab
indent_size = 4

[*.{yml,yaml}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[*.neon]
indent_style = tab
indent_size = 4
```

## Git Configuration

### .gitattributes

```
/.build         export-ignore
/.docs          export-ignore
/.github        export-ignore
/tests          export-ignore
.editorconfig   export-ignore
.gitattributes  export-ignore
.gitignore      export-ignore
Makefile        export-ignore
phpstan.neon    export-ignore
ruleset.xml     export-ignore
```

### .gitignore

```
/vendor/
/tests/tmp/
composer.lock
coverage.html
coverage.xml
```

## Documentation

### .docs Structure

Documentation is stored in the `.docs` directory:

```
.docs/
├── README.md           # Main documentation
└── assets/             # Images and diagrams
```

### README.md Template

The main README.md should include:

1. Package name and badges
2. Brief description
3. Documentation link
4. Installation instructions
5. Quick usage example
6. Version compatibility matrix
7. Development section
8. License information

## Versioning

- Follow [Semantic Versioning](https://semver.org/)
- Use branch aliases in composer.json
- Tag releases appropriately

### Version Matrix Example

| State | Version | Branch | Nette | PHP |
|-------|---------|--------|-------|-----|
| dev | `^0.11` | `master` | 3.2+ | >=8.2 |
| stable | `^0.10` | `master` | 3.2+ | >=8.2 |
| stable | `^0.9` | `master` | 3.1+ | >=8.1 |

## Checklist for New Libraries

- [ ] Create directory structure
- [ ] Configure `composer.json`
- [ ] Set up `Makefile`
- [ ] Configure `phpstan.neon`
- [ ] Configure `ruleset.xml`
- [ ] Add `.editorconfig`
- [ ] Add `.gitattributes`
- [ ] Add `.gitignore`
- [ ] Create GitHub workflows
- [ ] Add `LICENSE` (MIT)
- [ ] Create `README.md`
- [ ] Add documentation in `.docs`
- [ ] Write initial tests
- [ ] Verify all CI checks pass
