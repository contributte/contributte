# Contributte Composer & QA Configuration Specification

This document describes how `composer.json` and the QA config files (`phpstan.neon`, `ruleset.xml`,
`.editorconfig`, `.gitattributes`, `.gitignore`) are written in Contributte repositories. It covers
libraries (`contributte/*`, `nettrine/*`, `apitte/*`, …) and skeletons. The Makefile is described in
[MAKEFILE.md](MAKEFILE.md), workflows in [WORKFLOWS.md](WORKFLOWS.md). Where this file and
[LIBRARY.md](LIBRARY.md) or [SKELETON.md](SKELETON.md) differ on these files, this file wins.

## Table of Contents

- [Rules](#rules)
- [composer.json](#composerjson)
- [Dependencies](#dependencies)
- [QA Packages](#qa-packages)
- [Library Template](#library-template)
- [Skeleton Differences](#skeleton-differences)
- [phpstan.neon](#phpstanneon)
- [ruleset.xml](#rulesetxml)
- [.editorconfig](#editorconfig)
- [.gitattributes](#gitattributes)
- [.gitignore](#gitignore)
- [Version Policy](#version-policy)
- [Checklist](#checklist)

## Rules

- `composer.json` is indented with 2 spaces and keys follow the [order below](#composerjson).
- Every constraint can be satisfied by a **released** version. Never require only a version that is not tagged yet
  (for example `contributte/qa: ^0.5.0` while the newest tag is `v0.4.0`).
- Use caret constraints with a full version: `^3.2.0`, `^0.4.0`. For `0.x` packages `~0.4.0` means the same as
  `^0.4.0`, so prefer `^`.
- The minimum PHP version is the same in `composer.json`, `phpstan.neon` (`phpVersion`), `ruleset.xml`
  (`ruleset-X.Y.xml`) and the workflows.
- QA tools come from the Contributte meta packages (`contributte/qa`, `contributte/phpstan`, `contributte/tester`),
  never from `phpstan/*`, `nette/tester`, `squizlabs/*` or `ninjify/*` directly.
- Don't depend on abandoned packages.
- Libraries have `.gitattributes`. Skeletons don't need it (they are never installed as a dependency).

## composer.json

Keys, in this order. Keys marked optional are left out when empty.

| Key | Libraries | Skeletons | Notes |
|-----|-----------|-----------|-------|
| `name` | yes | yes | `contributte/*`, `nettrine/*`, … Lowercase, dash separated |
| `description` | yes | yes | One sentence, no trailing period needed |
| `keywords` | yes | yes | 3–7 lowercase words, include `nette` |
| `type` | `library` | `project` | `contributte/qa` uses `phpcodesniffer-standard` |
| `license` | `"MIT"` | `"MIT"` | A string, not an array |
| `homepage` | yes | optional | `https://github.com/contributte/<repo>` |
| `authors` | yes | optional | See template |
| `require` | yes | yes | `php` first, then extensions, then packages (sorted) |
| `require-dev` | yes | yes | Sorted |
| `suggest` | optional | – | Optional integrations with a short reason |
| `conflict` | optional | – | Versions of dependencies known to break the library |
| `autoload` | yes | yes | PSR-4 only |
| `autoload-dev` | yes | yes | `"Tests\\": "tests"` |
| `minimum-stability` | `dev` | `dev` | |
| `prefer-stable` | `true` | `true` | |
| `config` | yes | yes | `sort-packages` + `allow-plugins` |
| `extra` | `branch-alias` | – | Skeletons have no branch alias |

Not used: `funding`, `support` (Packagist takes them from GitHub), `scripts` (use the Makefile), `repositories`,
`version`.

### Autoload

- Namespace is `{Vendor}\{Package}\` mapped to `src` (no trailing slash): `Contributte\Messenger\`,
  `Nettrine\DBAL\`, `Apitte\` for `contributte/apitte`.
- Tests are always `"Tests\\": "tests"`. Skeletons map `"App\\": "app"`.
- Use `classmap` or `files` only for legacy code that can't be PSR-4.

### Config

```json
"config": {
  "sort-packages": true,
  "allow-plugins": {
    "dealerdirect/phpcodesniffer-composer-installer": true
  }
}
```

- `dealerdirect/phpcodesniffer-composer-installer` is always allowed (it comes with `contributte/qa`).
- Add `php-http/discovery` or `phpstan/extension-installer` only when a dependency actually uses them.
- Don't allow `composer/package-versions-deprecated` or `symfony/thanks`. They are not needed anymore.
- No `platform` override.

### Branch Alias

```json
"extra": {
  "branch-alias": {
    "dev-master": "0.4.x-dev"
  }
}
```

- The format is `MAJOR.MINOR.x-dev`, without `v` and without a patch number (`3.3-dev`, `1.0-dev`, `v5.1.x-dev` are wrong).
- It is the **next** minor after the newest tag. After tagging `v0.4.0`, bump it to `0.5.x-dev`.
- It is never lower than the newest tag.

### Suggest and Conflict

```json
"suggest": {
  "symfony/cache": "To use a PSR-6 cache for metadata"
},
"conflict": {
  "nette/schema": "<1.2.0"
}
```

- Use `conflict` to block old versions of optional or transitive packages that break the library. Don't use
  it to repeat what `require` already says.

## Dependencies

- **Nette 3.x packages** (`nette/di`, `nette/application`, `nette/http`, `nette/forms`, `nette/bootstrap`,
  `nette/caching`, `nette/database`, `nette/security`, `nette/routing`): `^3.2.0` or higher. Nette 3.1 is not
  supported (for example `nette/di` 3.1 does not run on PHP 8.4+).
- `nette/utils`: `^4.0.0`. Don't allow `^3.x`.
- `latte/latte`: `^3.0.0`. Don't allow Latte 2.
- `tracy/tracy`: `^2.10.0`.
- `nette/schema`: `^1.3.0`, `nette/neon`: `^3.4.0`, `nette/php-generator`: `^4.1.0`.
- Add the next major (`^3.2.0 || ^4.0.0`) only after it is released and the library is tested with it.
- **Sibling packages** (`contributte/*`, `nettrine/*`): allow the newest released minor. Allowing the current
  branch alias as well is fine: `"contributte/di": "^0.6.0 || ^0.7.0"`.
- **Third-party packages**: allow the newest major once it is supported, keep the previous one while it is maintained:
  `"symfony/console": "^7.4.0 || ^8.0.0"`, `"guzzlehttp/guzzle": "^7.8.0 || ^8.0.0"`.
- Don't require abandoned packages: `nettrine/cache` (use `symfony/cache`), `doctrine/cache`,
  `doctrine/annotations`, `nette/tokenizer`, `nette/finder` (use `Nette\Utils\Finder`), `nette/safe`.
- Don't point to a git hash (`dev-main#…`) in a published library.

## QA Packages

| Package | Constraint | Provides |
|---------|------------|----------|
| `contributte/qa` | `^0.4.0` | PHP CodeSniffer + Slevomat rules, `ruleset-8.x.xml` |
| `contributte/phpstan` | `^0.3.1` | PHPStan 2 + strict, deprecation and Nette rules |
| `contributte/tester` | `^0.4.1` | Nette Tester 2.5+ and test helpers |
| `mockery/mockery` | `^1.6.12` | Only when tests use mocks |

- `contributte/phpstan` `^0.1` means PHPStan 1. Always upgrade to `^0.3`.
- Extra PHPStan extensions that `contributte/phpstan` does not include (`phpstan/phpstan-doctrine`,
  `phpstan/phpstan-mockery`) may be added directly, in their `^2.0` versions.
- PHPUnit-based packages (`contributte/qa`, `contributte/aop`) use `contributte/phpunit` instead of `contributte/tester`.
- When a new QA version is tagged, the whole organization moves to it together.

## Library Template

```json
{
  "name": "contributte/{package}",
  "description": "{Description} for Nette Framework",
  "keywords": [
    "nette",
    "contributte",
    "{keyword}"
  ],
  "type": "library",
  "license": "MIT",
  "homepage": "https://github.com/contributte/{package}",
  "authors": [
    {
      "name": "Milan Felix Šulc",
      "homepage": "https://f3l1x.io"
    }
  ],
  "require": {
    "php": ">=8.2",
    "nette/di": "^3.2.0",
    "nette/utils": "^4.0.0"
  },
  "require-dev": {
    "contributte/phpstan": "^0.3.1",
    "contributte/qa": "^0.4.0",
    "contributte/tester": "^0.4.1",
    "mockery/mockery": "^1.6.12",
    "tracy/tracy": "^2.10.0"
  },
  "autoload": {
    "psr-4": {
      "Contributte\\{Package}\\": "src"
    }
  },
  "autoload-dev": {
    "psr-4": {
      "Tests\\": "tests"
    }
  },
  "minimum-stability": "dev",
  "prefer-stable": true,
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
  }
}
```

## Skeleton Differences

- `"type": "project"`, `"php": ">=8.4"` (not `^8.4`), no `extra.branch-alias`, no `.gitattributes`.
- Autoload `"App\\": "app"`.
- `phpVersion: 80400` and `ruleset-8.4.xml`.
- Sibling packages use the newest released minor, same as libraries.

## phpstan.neon

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
```

- Indent with tabs.
- Include only `vendor/contributte/phpstan/phpstan.neon`, plus extra extensions (e.g. `phpstan-doctrine`) when needed.
  Don't include `phpstan-nette`, `phpstan-strict-rules` or `phpstan-deprecation-rules` by hand.
- `level: 9` (or `max`). Don't lower it to get CI green.
- `phpVersion` matches the `php` constraint: `>=8.2` → `80200`, `>=8.4` → `80400`.
- `paths` are `src` and `.docs` for libraries, `app` (and `bin`, `config` when they have PHP) for skeletons.
- No baseline files. Fix the errors or add a narrow `ignoreErrors` entry.
- `ignoreErrors` entries use `message` or `identifier`, with `path` and, when useful, `count`. Leave the key out
  when it has no entries.

```neon
	ignoreErrors:
		-
			message: "#^Dead catch \\- ReflectionException is never thrown in the try block\\.$#"
			path: src/DI/Utils/Reflector.php
			count: 1
```

## ruleset.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ruleset name="Contributte" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="vendor/squizlabs/php_codesniffer/phpcs.xsd">
	<!-- Rulesets -->
	<rule ref="./vendor/contributte/qa/ruleset-8.2.xml"/>

	<!-- Rules -->
	<rule ref="SlevomatCodingStandard.Files.TypeNameMatchesFileName">
		<properties>
			<property name="rootNamespaces" type="array">
				<element key="src" value="Contributte\{Package}"/>
				<element key="tests" value="Tests"/>
			</property>
		</properties>
	</rule>

	<!-- Excludes -->
	<exclude-pattern>/tests/tmp</exclude-pattern>
</ruleset>
```

- Always reference a versioned ruleset: `ruleset-8.2.xml` for `php >=8.2`, `ruleset-8.4.xml` for `>=8.4`.
  `contributte/qa` ships `ruleset-8.2.xml` to `ruleset-8.5.xml`. The plain `ruleset.xml` has no PHP version,
  and `ruleset-8.0.xml` no longer exists on qa master.
- `TypeNameMatchesFileName` is always present. Skeletons use `<element key="app" value="App"/>`.
- Package-specific exclusions go under `<!-- Rules -->`, each with a reason in a comment when it is not obvious.

## .editorconfig

```ini
# EditorConfig is awesome: http://EditorConfig.org

root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = tab
indent_size = tab
tab_width = 4

[*.{json,yaml,yml,md}]
indent_style = space
indent_size = 2
```

Same file in libraries and skeletons. Write the glob as `[*.{json,yaml,yml,md}]` (no spaces, no inner `*.`).

## .gitattributes

Libraries only:

```
.docs export-ignore
.editorconfig export-ignore
.gitattributes export-ignore
.github export-ignore
.gitignore export-ignore
Makefile export-ignore
README.md export-ignore
phpstan.neon export-ignore
ruleset.xml export-ignore
tests export-ignore
```

- Add every other development-only path in the root: `AGENTS.md`, `.claude`, `DESIGN.md`, `PRD.md`, `TECH.md`,
  `fxnorm.yml`, `fxnorm-baseline.json`, `phpunit.xml`, `examples`, `phpstan-*.neon`.
- `fxnorm.yml` is written by `fxnorm init` (see [AGENTS.md](AGENTS.md#checking-with-fxnorm)). It configures a
  development tool, so users who install the package don't need it.
- Remove entries for files that don't exist anymore (most often `.travis.yml`).
- Never export-ignore `src`, `composer.json` or `LICENSE`.

## .gitignore

Libraries:

```
# IDE
/.idea

# Composer
/vendor
/composer.lock

# Tests
/tests/tmp
/coverage.*
/tests/**/*.log
/tests/**/*.html
/tests/**/*.expected
/tests/**/*.actual
```

Skeletons keep `/vendor`, `/.idea`, `/var/` (or `/temp`, `/log`), `/config/local.neon` and `.env`.
Skeletons commit `composer.lock`; libraries don't.

## Version Policy

| Target | Now | Next step |
|--------|-----|-----------|
| PHP (libraries) | `>=8.2` | `>=8.3` in the next minor after PHP 8.2 security support ends (31 Dec 2026) |
| PHP (skeletons) | `>=8.4` | Follow the newest PHP minus one |
| Nette 3.x packages | `^3.2.0` | With PHP 8.3, allow the releases that need it: `nette/application`, `forms`, `bootstrap` `^3.3`, `nette/http` `^3.4` |
| `nette/utils` | `^4.0.0` | – |
| `contributte/qa` | `^0.4.0` | `^0.5.0` for everyone once `v0.5.0` is tagged |
| `contributte/phpstan` | `^0.3.1` | `^0.4.0` once tagged |
| `contributte/tester` | `^0.4.1` | `^0.5.0` once tagged |

When the minimum PHP version changes, update `composer.json`, `phpstan.neon` (`phpVersion`), `ruleset.xml`
(`ruleset-X.Y.xml`) and the workflows together, and bump the branch alias to a new minor.

## Checklist

- [ ] `composer.json` has 2-space indent, the standard key order and `"license": "MIT"` as a string
- [ ] `php` is `>=8.2` (libraries) or `>=8.4` (skeletons)
- [ ] Nette 3.x packages are `^3.2.0` or higher, `nette/utils` is `^4.0.0`
- [ ] `require-dev` has `contributte/qa ^0.4.0`, `contributte/phpstan ^0.3.1`, `contributte/tester ^0.4.1`
- [ ] No direct `nette/tester`, `phpstan/phpstan*` (except extra extensions) or `ninjify/*`
- [ ] Every constraint matches a released version; no abandoned packages; no `dev-*#hash`
- [ ] `minimum-stability: dev`, `prefer-stable: true`, `sort-packages: true`, only needed `allow-plugins`
- [ ] Branch alias is `X.Y.x-dev` and above the newest tag (libraries only)
- [ ] `phpstan.neon`: includes `contributte/phpstan`, level 9, `phpVersion` matches PHP, no baseline
- [ ] `ruleset.xml`: versioned `ruleset-X.Y.xml` matching PHP, `TypeNameMatchesFileName`, excludes `/tests/tmp`
- [ ] `.editorconfig`, `.gitignore` and (libraries) `.gitattributes` match the templates
