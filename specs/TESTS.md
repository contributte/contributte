# Contributte Tests Specification

This document describes how tests in Contributte repositories are written. It extends the short Testing sections in
[LIBRARY.md](LIBRARY.md#testing) and [SKELETON.md](SKELETON.md#testing). The `make tests` and `make coverage` commands
are described in [MAKEFILE.md](MAKEFILE.md), the CI jobs in [WORKFLOWS.md](WORKFLOWS.md).

## Table of Contents

- [Rules](#rules)
- [Framework](#framework)
- [Folder Layout](#folder-layout)
- [File Names](#file-names)
- [Bootstrap](#bootstrap)
- [Toolkit Test Template](#toolkit-test-template)
- [TestCase Template](#testcase-template)
- [DI Container Tests](#di-container-tests)
- [Temporary Files](#temporary-files)
- [Fixtures and Mocks](#fixtures-and-mocks)
- [External Services](#external-services)
- [Lowest Dependencies](#lowest-dependencies)
- [Skeleton Tests](#skeleton-tests)
- [Helpers](#helpers)
- [Checklist](#checklist)

## Rules

- Tests use [Nette Tester](https://tester.nette.org/) with [contributte/tester](https://github.com/contributte/tester).
- Every PHP repository has tests. A library has at least one test per public feature and a DI test for every extension.
- Test files live in `tests/Cases` and are `.phpt` files.
- Tests are written as `Toolkit::test()` closures. A `TestCase` class is used only when tests share state or a lifecycle.
- `tests/bootstrap.php` calls `Contributte\Tester\Environment::setup(__DIR__)`.
- Temporary files go to `Environment::getTestDir()`, never to a shared folder.
- DI containers are built with `Contributte\Tester\Utils\ContainerBuilder`.
- Helpers that are useful in more than one repository belong to `contributte/tester`, not to `tests/Toolkit`.
- Tests that need a service (database, Redis, API) skip themselves when it is missing, and CI provides the service.
- Tests pass with both the newest and the lowest dependencies.

## Framework

| Package | Constraint | Purpose |
|---------|------------|---------|
| `contributte/tester` | `^0.4` | Environment, `Toolkit`, helpers; pulls in `nette/tester` |
| `mockery/mockery` | `^1.6` | Mocks, only when the tests use it |
| `nette/di`, `nette/neon` | library minimum | DI container tests |

- Put these packages in `require-dev`. Don't require `nette/tester` directly; `contributte/tester` already does.
- Don't use PHPUnit or Codeception, and don't use `ninjify/nunjuck` (replaced by `contributte/tester`).
  Packages that integrate a framework (`contributte/phpunit`, `contributte/codeception`, `contributte/qa`) may test
  with it.
- Register the `Tests\` namespace:

```json
"autoload-dev": {
  "psr-4": {
    "Tests\\": "tests"
  }
}
```

## Folder Layout

```
tests/
├── Cases/                  # Test files (*.phpt), mirror the src/ namespaces
│   ├── DI/                 # Extension tests
│   │   └── FooExtension.phpt
│   ├── E2E/                # Tests against real services or a booted application
│   └── Utils/
│       └── Helper.phpt
├── Fixtures/               # Test data and dummy classes (namespace Tests\Fixtures)
├── Mocks/                  # Hand-written mocks and stubs (namespace Tests\Mocks)
├── Toolkit/                # Repository-specific helpers (namespace Tests\Toolkit)
│   └── Tests.php
├── tmp/                    # Created by the Environment, ignored by git
├── .gitignore
└── bootstrap.php
```

- `tests/Cases` mirrors the `src/` folders. A `Unit/` + `Integration/` split (as sketched in LIBRARY.md) is also fine,
  but don't mix both styles in one repository.
- Folder names start with a capital letter: `Cases`, `Fixtures`, `Mocks`, `Toolkit`. Not `cases`, `fixtures`, `Files`.
- `Fixtures/` and `Mocks/` hold only support code. The runner never executes them.
- Don't add `php.ini` files to `tests/`. The runner uses the system ini (`-C`).
- `tests/.gitignore`:

```
# Folders - recursive
*.expected
*.actual

# Folders
/tmp

# Files
/*.log
/*.html
```

## File Names

- One file per class or feature: `Cases/Utils/Strings.phpt`.
- Split big files by feature with a dot: `OrmExtension.phpt`, `OrmExtension.cache.phpt`, `OrmExtension.errors.phpt`.
- A `Test` suffix (`StringsTest.phpt`) is allowed; keep one style per repository.
- Only `.phpt` and `*Test.php` files run. A test saved as `Foo.php` is silently skipped.

## Bootstrap

`tests/bootstrap.php`:

```php
<?php declare(strict_types = 1);

use Contributte\Tester\Environment;

if (@!include __DIR__ . '/../vendor/autoload.php') {
	echo 'Install Nette Tester using `composer update --dev`';
	exit(1);
}

Environment::setup(__DIR__);
```

`Environment::setup(__DIR__)` runs `Tester\Environment::setup()` (the minimal form in LIBRARY.md) and also:

- sets the timezone to `Europe/Prague`,
- clears `$_SERVER`, `$_ENV`, `$_GET`, `$_POST` and fixes `REQUEST_TIME`,
- creates `tests/tmp` and a per-process `tests/tmp/<pid>` folder, removed at shutdown,
- points `session.save_path` to `tests/tmp`.

Optional lines, added only when needed:

| Line | When |
|------|------|
| `Environment::setupFinals();` | Mocking `final` classes |
| `Environment::setupFunctions();` | Using Tester's global `test()` / `testException()` (prefer `Toolkit::test()`) |

Don't define constants (`TEMP_DIR`), helper functions or containers in the bootstrap. Put helpers in `tests/Toolkit`.

## Toolkit Test Template

The default test style. Each closure is one test case, and the comment above it says what it tests.

```php
<?php declare(strict_types = 1);

use Contributte\Foo\Formatter;
use Contributte\Foo\Exception\LogicalException;
use Contributte\Tester\Toolkit;
use Tester\Assert;

require_once __DIR__ . '/../../bootstrap.php';

// Formats a value
Toolkit::test(static function (): void {
	$formatter = new Formatter();

	Assert::same('1 000', $formatter->format(1000));
});

// Invalid value
Toolkit::test(static function (): void {
	Assert::exception(
		static fn () => (new Formatter())->format(-1),
		LogicalException::class,
		'Value must be positive'
	);
});
```

- `.phpt` files have no namespace.
- `Toolkit::setUp()` / `Toolkit::tearDown()` register callbacks around every following `Toolkit::test()`.
- `Toolkit::bind($object)` binds the closures to an object, so they can call its private methods.
- Use `Contributte\Tester\Utils\Notes` to record and assert call order (`Notes::add('A')`, `Notes::fetch()`).

## TestCase Template

Use a `TestCase` when tests share fixtures created in `setUp()`, or need a data provider.

```php
<?php declare(strict_types = 1);

namespace Tests\Cases\Utils;

use Contributte\Foo\Utils\Strings;
use Tester\Assert;
use Tester\TestCase;

require_once __DIR__ . '/../../bootstrap.php';

final class StringsTest extends TestCase
{

	private Strings $strings;

	protected function setUp(): void
	{
		$this->strings = new Strings();
	}

	public function testSlug(): void
	{
		Assert::same('foo-bar', $this->strings->slug('Foo Bar'));
	}

}

(new StringsTest())->run();
```

- The file ends with `(new ...)->run();`. Without it nothing is tested.
- Shared base classes (`AbstractTestCase`) go to `tests/Toolkit`.

## DI Container Tests

Every extension has a test in `tests/Cases/DI` that builds a container and checks the registered services.

```php
<?php declare(strict_types = 1);

use Contributte\Foo\DI\FooExtension;
use Contributte\Foo\FooService;
use Contributte\Tester\Toolkit;
use Contributte\Tester\Utils\ContainerBuilder;
use Contributte\Tester\Utils\Neonkit;
use Nette\DI\Compiler;
use Nette\DI\InvalidConfigurationException;
use Tester\Assert;

require_once __DIR__ . '/../../bootstrap.php';

// Default configuration
Toolkit::test(static function (): void {
	$container = ContainerBuilder::of()
		->withCompiler(static function (Compiler $compiler): void {
			$compiler->addExtension('foo', new FooExtension());
			$compiler->addConfig(Neonkit::load(<<<'NEON'
				foo:
					debug: true
				NEON));
		})
		->build();

	Assert::type(FooService::class, $container->getByType(FooService::class));
});

// Invalid configuration
Toolkit::test(static function (): void {
	Assert::exception(static function (): void {
		ContainerBuilder::of()
			->withCompiler(static function (Compiler $compiler): void {
				$compiler->addExtension('foo', new FooExtension());
				$compiler->addConfig(Neonkit::load(<<<'NEON'
					foo:
						unknown: true
					NEON));
			})
			->build();
	}, InvalidConfigurationException::class);
});
```

- `ContainerBuilder` compiles into `Environment::getTestDir()` under a unique key, so every build is fresh.
- `->buildWith(['param' => ...])` passes dynamic parameters.
- `Neonkit::load()` / `Neonkit::loadFile()` read NEON the same way as a real config (with `@service`, `::constant`).
- Use `ContainerPatcher::of($container)` to replace a service in a built container.
- Don't copy `ContainerLoader` + `Compiler` boilerplate or a private `Tests\Toolkit\Container` class.
  A repository-specific default setup is a small helper around `ContainerBuilder` in `tests/Toolkit`.

## Temporary Files

- Write only to `Environment::getTestDir()` (per process) or `Environment::getTmpDir()` (`tests/tmp`, shared).
- Prefer `getTestDir()`: tests run in parallel, and a shared folder causes random failures.
- Don't use `sys_get_temp_dir()`, a `TEMP_DIR` constant or folders outside `tests/`.
- `/tests/tmp/` is in the root `.gitignore` ([LIBRARY.md](LIBRARY.md#gitignore)) and excluded in `ruleset.xml`.

## Fixtures and Mocks

- `tests/Fixtures`: data files (`.neon`, `.json`, `.sql`, `.latte`) and dummy classes, namespace `Tests\Fixtures`.
- `tests/Mocks`: hand-written stubs of interfaces, namespace `Tests\Mocks`.
- Short one-off stubs can be anonymous classes inside the test.
- Mockery is used for expectations (`shouldReceive()->once()`). Every file that uses it closes it, otherwise the
  expectations are never checked:

```php
Toolkit::tearDown(static fn () => Mockery::close());
```

- `mockery/mockery` is in `require-dev` only if the tests use it.
- Use `Contributte\Tester\Utils\Liberator` to read private properties, instead of hand-written reflection.

## External Services

- Unit and DI tests never need a network or a running service. Use SQLite in memory (`path: ":memory:"`) for Doctrine
  and Nextras tests when a real database is not the point of the test.
- Tests against a real service go to `tests/Cases/E2E` and skip when the service or extension is missing:

```php
if (!extension_loaded('redis')) {
	Environment::skip('Requires ext-redis');
}
```

- CI runs them with the service workflows `nette-tester-mysql.yml` or `nette-tester-redis.yml`
  ([WORKFLOWS.md](WORKFLOWS.md)). A test that is always skipped in CI is not a test.
- Connection settings have defaults matching the CI service (`127.0.0.1`, user `root`, database `tests`).
- Tests against third-party APIs (payment gates, SMS) read credentials from a git-ignored fixture file and skip
  when it is missing.
- Mark tests that share one external resource with `@lock <name>`, instead of running the whole suite with `-j 1`.

## Lowest Dependencies

Libraries run the test suite with `--prefer-lowest` on the minimum PHP version ([WORKFLOWS.md](WORKFLOWS.md#php-versions)).

- Don't raise a dependency's minimum just to make a test pass. Fix the test or skip it by feature:

```php
if (!method_exists(Form::class, 'initialize')) {
	Environment::skip('Requires nette/forms >= 3.1');
}
```

- Check a feature (`method_exists`, `class_exists`) rather than a version string.
- Use `PHP_VERSION_ID` checks only for PHP features.

## Skeleton Tests

Skeletons test that the application boots. They use the same bootstrap, and the E2E tests use `Bootstrap::boot()`.

```
tests/
├── Cases/
│   ├── E2E/
│   │   ├── Container/EntrypointTest.php    # Container builds, main services resolve
│   │   ├── Latte/LatteTest.php             # All templates compile
│   │   └── Presenter/HomePresenterTest.php # Home page renders
│   └── Unit/                                # Optional
├── Toolkit/
│   └── Tests.php                            # ROOT_PATH, APP_PATH, CONFIG_DIR constants
└── bootstrap.php
```

```php
<?php declare(strict_types = 1);

namespace Tests\Cases\E2E\Container;

use App\Bootstrap;
use Contributte\Tester\Toolkit;
use Nette\Application\Application;
use Tester\Assert;

require_once __DIR__ . '/../../../bootstrap.php';

Toolkit::test(static function (): void {
	$container = Bootstrap::boot()->createContainer();

	Assert::type(Application::class, $container->getByType(Application::class));
});
```

- Skeleton test files end with `Test.php`. `make tests` is defined in [SKELETON.md](SKELETON.md#makefile).
- Every skeleton has at least the container test. `echo "NO TESTS"` is not a test target.

## Helpers

`contributte/tester` provides these helpers. Use them instead of local copies.

| Helper | Purpose |
|--------|---------|
| `Environment::setup(__DIR__)` | Tester setup, timezone, globals, tmp folders |
| `Environment::getTestDir()` / `getTmpDir()` | Per-process and shared temp folder |
| `Environment::setupFinals()` | Bypass `final` for mocking |
| `Environment::skip($message)` | Skip the current test file |
| `Toolkit::test()`, `setUp()`, `tearDown()`, `bind()` | Closure-based test cases |
| `Utils\ContainerBuilder` | Build a Nette DI container in the test dir |
| `Utils\ContainerPatcher` | Replace services in a built container |
| `Utils\Neonkit` | Load NEON config from a string or file |
| `Utils\Notes` | Record and assert call order |
| `Utils\Liberator` | Access private properties and methods |
| `Utils\Httpkit` | Run code and discard its output |
| `Utils\ClassFinder` | Find classes in a folder |
| `Utils\FileSystem` | `mkdir`, `purge`, `rmdir` |

## Checklist

- [ ] Tests use Nette Tester with `contributte/tester` in `require-dev`
- [ ] `tests/bootstrap.php` calls `Environment::setup(__DIR__)` and nothing else it doesn't need
- [ ] Test files are `.phpt` in `tests/Cases`, mirroring `src/`
- [ ] Tests use `Toolkit::test()`; `TestCase` classes end with `->run()`
- [ ] Every DI extension has a container test built with `ContainerBuilder`
- [ ] Temporary files go to `Environment::getTestDir()`
- [ ] Support code is in `Fixtures/`, `Mocks/` and `Toolkit/` (capitalised)
- [ ] Mockery is closed in `tearDown`, and required only when used
- [ ] Service tests skip without the service, and CI provides the service
- [ ] Tests pass with `--prefer-lowest`
- [ ] `tests/.gitignore` ignores `/tmp`, `*.actual`, `*.expected`
- [ ] Skeletons have an E2E container test
