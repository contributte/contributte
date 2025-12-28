# Contributte Skeleton Development Specification

This document describes the standards and conventions for developing Contributte skeleton projects.

## Table of Contents

- [Reference Repositories](#reference-repositories)
- [AI Development](#ai-development)
- [Git Strategy](#git-strategy)
- [Quality Assurance](#quality-assurance)
- [Purpose](#purpose)
- [Directory Structure](#directory-structure)
- [Requirements](#requirements)
- [Composer Configuration](#composer-configuration)
- [Makefile](#makefile)
- [Docker Configuration](#docker-configuration)
- [Configuration](#configuration)
- [PHPStan Configuration](#phpstan-configuration)
- [Coding Standards](#coding-standards)
- [Application Entry Point](#application-entry-point)
- [Console Commands](#console-commands)
- [Testing](#testing)
- [Documentation](#documentation)
- [Git Configuration](#git-configuration)
- [Checklist for New Skeletons](#checklist-for-new-skeletons)
- [Differences: Library vs Skeleton](#differences-library-vs-skeleton)

## Reference Repositories

- [contributte/doctrine-skeleton](https://github.com/contributte/doctrine-skeleton)
- [contributte/messenger-skeleton](https://github.com/contributte/messenger-skeleton)

## AI Development

When using AI agents (Claude, GPT, etc.) to contribute to Contributte skeleton projects:

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

## Purpose

Skeleton projects serve as:
- **Starting templates** for new applications
- **Reference implementations** showing best practices
- **Demo applications** for Contributte libraries
- **Learning resources** for developers

## Directory Structure

Each skeleton project is different based on its purpose. The following is a high-level overview of common directories:

```
├── .docs/                    # Documentation and screenshots
├── .github/                  # GitHub workflows
├── app/                      # Application source code
├── bin/                      # Console scripts
├── config/                   # Configuration files
├── tests/                    # Test suite
├── var/                      # Runtime data (logs, cache)
├── www/                      # Public web root
├── .editorconfig             # Editor configuration
├── .gitignore                # Git ignore rules
├── composer.json             # Composer configuration
├── docker-compose.yml        # Docker services
├── LICENSE                   # MIT License
├── Makefile                  # Build automation
├── phpstan.neon              # PHPStan configuration
├── README.md                 # Project readme
└── ruleset.xml               # PHP CodeSniffer rules
```

Additional directories may be present depending on the skeleton's purpose (e.g., `db/` for database migrations, `.data/` for persistent Docker data).

## Requirements

- **PHP Version**: 8.2+ (minimum 8.3 recommended)
- **Nette Framework**: 3.2+
- **Docker**: For local development services

## Composer Configuration

### composer.json Structure

```json
{
  "name": "contributte/{name}-skeleton",
  "description": "Skeleton project description",
  "license": "MIT",
  "type": "project",
  "authors": [
    {
      "name": "Milan Felix Sulc",
      "homepage": "https://f3l1x.io"
    }
  ],
  "require": {
    "php": ">=8.2",
    "nette/application": "^3.2",
    "nette/bootstrap": "^3.2",
    "nette/di": "^3.2",
    "tracy/tracy": "^2.10",
    "latte/latte": "^3.0"
  },
  "require-dev": {
    "contributte/qa": "^0.4",
    "contributte/phpstan": "^0.1",
    "nette/tester": "^2.5",
    "mockery/mockery": "^1.6"
  },
  "autoload": {
    "psr-4": {
      "App\\": "app"
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
  "minimum-stability": "dev",
  "prefer-stable": true
}
```

## Makefile

Skeleton projects have extended Makefile with project management tasks:

```makefile
#
# Project
#

.PHONY: project
project: install setup

.PHONY: init
init:
	cp config/local.neon.dist config/local.neon

.PHONY: install
install:
	composer install

.PHONY: setup
setup:
	mkdir -p var/tmp var/log
	chmod -R 0777 var/tmp var/log

.PHONY: clean
clean:
	find var/tmp -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} + 2>/dev/null; true
	find var/log -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} + 2>/dev/null; true

#
# QA
#

.PHONY: qa
qa: phpstan cs

.PHONY: cs
cs:
ifdef GITHUB_ACTION
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp -q --report=checkstyle app tests | cs2pr
else
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp app tests
endif

.PHONY: csf
csf:
	vendor/bin/phpcbf --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp app tests

.PHONY: phpstan
phpstan:
	vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: tests
tests:
	vendor/bin/tester -s -p php --colors 1 -C tests/Cases

.PHONY: coverage
coverage:
ifdef GITHUB_ACTION
	vendor/bin/tester -s -p phpdbg --colors 1 -C --coverage coverage.xml --coverage-src app tests/Cases
else
	vendor/bin/tester -s -p phpdbg --colors 1 -C --coverage coverage.html --coverage-src app tests/Cases
endif

#
# Dev
#

.PHONY: dev
dev:
	NETTE_DEBUG=1 php -S 0.0.0.0:8000 -t www

#
# Docker
#

.PHONY: docker-up
docker-up:
	docker compose up -d

#
# Deploy
#

.PHONY: build
build:
	# Add build steps here

.PHONY: deploy
deploy: clean project build clean
```

### Available Commands

| Command | Description |
|---------|-------------|
| `make project` | Full project setup (install + setup) |
| `make init` | Copy local config template |
| `make install` | Install Composer dependencies |
| `make setup` | Create required directories |
| `make clean` | Clean temporary and log files |
| `make qa` | Run all quality checks |
| `make cs` | Check coding standards |
| `make csf` | Fix coding standards |
| `make phpstan` | Run static analysis |
| `make tests` | Run test suite |
| `make coverage` | Generate coverage report |
| `make dev` | Start development server |
| `make docker-up` | Start Docker services |
| `make deploy` | Build for deployment |

## Docker Configuration

### docker-compose.yml

Skeleton projects typically include Docker setup for required services. Examples:

#### Database Services

```yaml
services:
  postgres:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_PASSWORD: contributte
      POSTGRES_USER: contributte
      POSTGRES_DB: contributte
    ports:
      - "5432:5432"
    volumes:
      - ./.data/postgres/data/:/var/lib/postgresql/data/

  mariadb:
    image: mariadb:10.10
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: contributte
      MARIADB_USER: contributte
      MARIADB_PASSWORD: contributte
      MARIADB_DATABASE: contributte
    ports:
      - "3306:3306"
    volumes:
      - ./.data/mariadb/data/:/var/lib/mysql/
```

#### Queue/Cache Services

```yaml
services:
  redis:
    image: redis:7
    command: redis-server --requirepass contributte
    ports:
      - "6379:6379"

  adminer:
    image: adminer
    ports:
      - "8081:8080"
```

### Default Credentials

| Service | Default Credentials |
|---------|---------------------|
| PostgreSQL | user: `contributte`, password: `contributte` |
| MariaDB | user: `contributte`, password: `contributte` |
| Redis | password: `contributte` |

## Configuration

### config/local.neon.dist

Template for local environment configuration:

```neon
parameters:
    database:
        host: 127.0.0.1
        port: 5432
        user: contributte
        password: contributte
        database: contributte
```

## PHPStan Configuration

### phpstan.neon

```neon
includes:
    - vendor/contributte/phpstan/phpstan.neon

parameters:
    level: 9
    phpVersion: 80200

    scanDirectories:
        - app

    fileExtensions:
        - php

    paths:
        - app
        - .docs

    ignoreErrors:
```

## Coding Standards

### ruleset.xml

```xml
<?xml version="1.0"?>
<ruleset>
    <rule ref="./vendor/contributte/qa/ruleset-8.2.xml"/>

    <rule ref="SlevomatCodingStandard.Files.TypeNameMatchesFileName">
        <properties>
            <property name="rootNamespaces" type="array">
                <element key="app" value="App"/>
                <element key="tests" value="Tests"/>
            </property>
        </properties>
    </rule>

    <exclude-pattern>/tests/tmp</exclude-pattern>
</ruleset>
```

## Application Entry Point

### www/index.php

```php
<?php declare(strict_types = 1);

require __DIR__ . '/../vendor/autoload.php';

App\Bootstrap::boot()
    ->createContainer()
    ->getByType(Nette\Application\Application::class)
    ->run();
```

### app/Bootstrap.php

```php
<?php declare(strict_types = 1);

namespace App;

use Nette\Bootstrap\Configurator;

final class Bootstrap
{
    public static function boot(): Configurator
    {
        $configurator = new Configurator();
        $appDir = dirname(__DIR__);

        $configurator->setDebugMode(true);
        $configurator->enableTracy($appDir . '/var/log');
        $configurator->setTempDirectory($appDir . '/var/tmp');

        $configurator->createRobotLoader()
            ->addDirectory(__DIR__)
            ->register();

        $configurator->addConfig($appDir . '/config/common.neon');
        $configurator->addConfig($appDir . '/config/local.neon');

        return $configurator;
    }
}
```

## Console Commands

### bin/console

```php
#!/usr/bin/env php
<?php declare(strict_types = 1);

require __DIR__ . '/../vendor/autoload.php';

exit(App\Bootstrap::boot()
    ->createContainer()
    ->getByType(Contributte\Console\Application::class)
    ->run());
```

## Testing

### tests/bootstrap.php

```php
<?php declare(strict_types = 1);

require __DIR__ . '/../vendor/autoload.php';

Tester\Environment::setup();
```

### Test Organization

```
tests/
├── Cases/
│   ├── E2E/              # End-to-end tests
│   ├── Integration/      # Integration tests
│   └── Unit/             # Unit tests
├── Fixtures/             # Test data and fixtures
└── bootstrap.php         # Test bootstrap
```

## Documentation

### README.md Structure

Skeleton READMEs should include:

1. **Title and badges** - Name, build status, coverage
2. **Description** - What the skeleton demonstrates
3. **Screenshots** - Visual preview (in `.docs/assets/`)
4. **Requirements** - PHP, Docker, etc.
5. **Installation** - Step-by-step guide
6. **Configuration** - Environment setup
7. **Usage** - How to run the application
8. **Development** - How to contribute
9. **License** - MIT

### Installation Section Example

```markdown
## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/contributte/example-skeleton.git
   cd example-skeleton
   ```

2. Copy configuration template:
   ```bash
   make init
   # or: cp config/local.neon.dist config/local.neon
   ```

3. Start Docker services:
   ```bash
   make docker-up
   ```

4. Install dependencies:
   ```bash
   make install
   ```

5. Start development server:
   ```bash
   make dev
   ```

6. Open in browser: http://localhost:8000
```

## Git Configuration

### .gitignore

```
# Composer
/vendor/
composer.lock

# Local configuration
/config/local.neon

# Runtime
/var/log/*
!/var/log/.gitignore
/var/tmp/*
!/var/tmp/.gitignore

# Data
/.data/

# Coverage
coverage.html
coverage.xml

# IDE
.idea/
.vscode/
*.swp
```

## Checklist for New Skeletons

- [ ] Create directory structure
- [ ] Configure `composer.json` (type: project)
- [ ] Set up `Makefile` with project commands
- [ ] Configure `phpstan.neon`
- [ ] Configure `ruleset.xml`
- [ ] Add `.editorconfig`
- [ ] Add `.gitignore`
- [ ] Create `docker-compose.yml`
- [ ] Add `config/local.neon.dist` template
- [ ] Create `app/Bootstrap.php`
- [ ] Create `www/index.php` entry point
- [ ] Create `bin/console` for CLI
- [ ] Add `LICENSE` (MIT)
- [ ] Create `README.md` with screenshots
- [ ] Add documentation in `.docs`
- [ ] Write tests
- [ ] Verify all CI checks pass
- [ ] Test Docker setup works

## Differences: Library vs Skeleton

| Aspect | Library | Skeleton |
|--------|---------|----------|
| Type | `library` | `project` |
| Source directory | `src/` | `app/` |
| Entry point | N/A | `www/index.php` |
| Docker | Not included | Required |
| Local config | N/A | `config/local.neon` |
| Runtime data | N/A | `var/` directory |
| Console | N/A | `bin/console` |
| Web server | N/A | Built-in or Docker |
| Dependencies | Minimal | Full application |
