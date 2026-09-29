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
├── .docs/assets/             # Screenshots used by the README
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

- **PHP Version**: PHP 8.4 or later (`"php": ">=8.4"`, see [COMPOSER.md](COMPOSER.md#version-policy))
- **Nette Framework**: 3.2 or later
- **Docker**: For local development services

## Composer Configuration

`composer.json`, version policy and development dependencies are described in [COMPOSER.md](COMPOSER.md).

## Makefile

Skeleton projects have extended Makefile with project management tasks. Running `make` without a target prints the help, see [MAKEFILE.md](MAKEFILE.md). If the project needs environment variables, add `-include .env` and `export` at the top of the Makefile (see [Environment](MAKEFILE.md#environment)).

```makefile
.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))

##@ Project

.PHONY: project
project: install setup ## Install and set up project

.PHONY: init
init: ## Create local config
	cp config/local.neon.example config/local.neon

.PHONY: install
install: ## Install dependencies
	composer install

.PHONY: setup
setup: ## Create runtime directories
	mkdir -p var/tmp var/log
	chmod -R 0777 var/tmp var/log

.PHONY: clean
clean: ## Remove temporary files and logs
	find var/tmp -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} + 2>/dev/null; true
	find var/log -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} + 2>/dev/null; true

##@ QA

.PHONY: qa
qa: phpstan cs ## Run all QA checks

.PHONY: cs
cs: ## Check code style
ifdef GITHUB_ACTION
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp -q --report=checkstyle app tests | cs2pr
else
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp app tests
endif

.PHONY: csf
csf: ## Fix code style
	vendor/bin/phpcbf --standard=ruleset.xml --encoding=utf-8 --extensions=php,phpt --colors -nsp app tests

.PHONY: phpstan
phpstan: ## Run static analysis
	vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: tests
tests: ## Run tests
	vendor/bin/tester -s -p php --colors 1 -C tests/Cases

.PHONY: coverage
coverage: ## Generate code coverage
ifdef GITHUB_ACTION
	vendor/bin/tester -s -p php --colors 1 -C --coverage coverage.xml --coverage-src app tests/Cases
else
	vendor/bin/tester -s -p php --colors 1 -C --coverage coverage.html --coverage-src app tests/Cases
endif

##@ Development

.PHONY: dev
dev: ## Start development server
	NETTE_DEBUG=1 php -S 0.0.0.0:8000 -t www

##@ Docker

.PHONY: docker-up
docker-up: ## Start Docker services
	docker compose up -d

##@ Deployment

.PHONY: build
build: ## Build project
	# Add build steps here

.PHONY: deploy
deploy: ## Build for deployment
	$(MAKE) clean
	$(MAKE) project
	$(MAKE) build
	$(MAKE) clean
```

### Available Commands

| Command | Description |
|---------|-------------|
| `make` / `make help` | Show available commands |
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

### config/local.neon.example

Template for local environment configuration. It is committed; `make init` copies it to `config/local.neon`,
which is listed in `.gitignore`. Use the `.example` suffix, not `.dist`:

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

See [phpstan.neon](COMPOSER.md#phpstanneon) in COMPOSER.md.

## Coding Standards

`ruleset.xml` is described in [COMPOSER.md](COMPOSER.md#rulesetxml). PHP code conventions are described in [CODE.md](CODE.md).

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

Test layout, bootstrap and E2E tests are described in [TESTS.md](TESTS.md).

## Documentation

### README.md Structure

Skeleton READMEs follow the [Skeleton README Template](DOCS.md#skeleton-readme-template) in DOCS.md.

### Installation and Startup Example

Installation and Startup stay short: one code block each, no numbered walkthrough and no config samples. Details
belong in `.docs/` or in the Makefile help.

````markdown
## Installation

```bash
composer create-project -s dev contributte/example-skeleton acme
```

Requires PHP 8.4 or later and PostgreSQL.

## Startup

```bash
make init docker-up dev
```

The project runs on http://localhost:8000.

## Development

```bash
make install   # install dependencies
make qa        # PHPStan and code style
make tests     # run all tests
```

Run `make` to list every target.
````

## Git Configuration

See [.gitignore](COMPOSER.md#gitignore) in COMPOSER.md.

## Checklist for New Skeletons

- [ ] Create directory structure
- [ ] Configure `composer.json` (type: project)
- [ ] Set up `Makefile` with project commands
- [ ] Configure `phpstan.neon`
- [ ] Configure `ruleset.xml`
- [ ] Add `.editorconfig`
- [ ] Add `.gitignore`
- [ ] Create `docker-compose.yml`
- [ ] Add `config/local.neon.example` template
- [ ] Create `app/Bootstrap.php`
- [ ] Create `www/index.php` entry point
- [ ] Create `bin/console` for CLI
- [ ] Add `LICENSE` (MIT)
- [ ] Create `README.md` with screenshots, one-block Installation and Startup and a short `make` Development block
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
