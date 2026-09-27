# Contributte Code Specification

This document describes how PHP code in Contributte repositories is written: files, namespaces, classes, types,
exceptions and Nette DI extensions. It applies to `src/` in libraries and `app/` in skeletons. Package setup, QA
tools and PHP/Nette versions are described in [LIBRARY.md](LIBRARY.md) and [SKELETON.md](SKELETON.md), tests in
[TESTS.md](TESTS.md). Code style is checked by `contributte/qa` (`make cs`) and PHPStan level 9 (`make phpstan`).

## Table of Contents

- [Rules](#rules)
- [Files and Namespaces](#files-and-namespaces)
- [Folder Structure](#folder-structure)
- [Classes](#classes)
- [Types](#types)
- [Exceptions](#exceptions)
- [DI Extensions](#di-extensions)
- [Versions and Deprecated APIs](#versions-and-deprecated-apis)
- [Shared Code](#shared-code)
- [Class Template](#class-template)
- [Exception Template](#exception-template)
- [DI Extension Template](#di-extension-template)
- [Checklist](#checklist)

## Rules

- Every PHP file starts with `<?php declare(strict_types = 1);` on the first line.
- Classes are `final` unless they are built to be extended.
- Dependencies come in through the constructor, using constructor promotion.
- Everything has a native type. PHPDoc is only for what native types can't say (generics, array shapes).
- A library throws only its own exceptions, based on `LogicalException` and `RuntimeException`.
- A DI extension lives in `src/DI/{Name}Extension.php` and describes its config with `getConfigSchema()` (nette/schema).
- Metadata uses attributes (`#[Inject]`, `#[AsCommand]`, `#[ORM\Entity]`), not annotations.
- Don't use deprecated Nette, Latte or PHP APIs (see [Deprecated APIs](#deprecated-apis)).
- Don't copy helpers between repositories. Shared code belongs to `contributte/di`, `contributte/utils` or `contributte/tester`.

## Files and Namespaces

- One class, interface, trait or enum per file. The file name matches the type name.
- The first line is exactly `<?php declare(strict_types = 1);`. Not `declare(strict_types=1)` and not on a separate line.
- Namespaces follow PSR-4 from `composer.json`:

| Vendor | Namespace | Example |
|--------|-----------|---------|
| `contributte/*` | `Contributte\{Library}` | `Contributte\Messenger` |
| `contributte/doctrine-*` | `Nettrine\{Library}` | `Nettrine\ORM`, `Nettrine\Extensions\KnpLabs` |
| `contributte/apitte` | `Apitte\{Part}` | `Apitte\Core`, `Apitte\OpenApi` |
| skeletons | `App` | `App\UI\Home\HomePresenter` |

- Don't add new root namespaces. Older ones (`Dag\`, `Ublaboo\`, `Minetro\`, `JuicyFx\`) move to `Contributte\` in a major release.
- `use` statements import every class, function and constant. Don't write fully qualified names in code.

## Folder Structure

Libraries group code by feature. These folder names are shared across the organization:

```
src/
├── DI/                  # Nette DI extensions ({Name}Extension.php)
│   ├── Helpers/         # DI-only helpers (@internal)
│   └── Pass/            # Compiler passes for big extensions
├── Exception/           # LogicalException, RuntimeException
│   ├── Logical/         # Specific logical exceptions
│   └── Runtime/         # Specific runtime exceptions
├── Latte/               # Latte 3 extensions, nodes, filters
├── Tracy/               # Tracy panels and BlueScreen helpers
├── Utils/               # Small static helpers
└── {Feature}/           # Domain code (Client/, Command/, Http/, ...)
```

- Use singular names: `Exception/`, not `Exceptions/`.
- Tracy panels go to `Tracy/`, not `Diagnostics/` or `Debug/`.
- Don't use `Bridge/Nette/DI/` or `Nette/` folders for the extension. Nette is the main target, so the extension is in `src/DI/`.
- Skeletons follow [SKELETON.md](SKELETON.md): `app/Bootstrap.php`, `app/UI/`, `app/Model/` or `app/Domain/`.

## Classes

### Modifiers

- `final class` is the default. Services, value objects, commands, presenters and leaf exceptions are final.
- Use `abstract class Abstract{Name}` for base classes. Skeleton presenters use `abstract class BasePresenter`.
- Readonly data goes to `readonly` properties (or `final readonly class` for value objects).
- Use `enum` instead of groups of string or int constants.
- Mark classes and methods that are not public API with `@internal` (DI helpers, compiler passes, generated code).

### Naming

- Interfaces: a noun or adjective without the `Interface` suffix (`Transport`, `Loader`). QA checks this
  (`SuperfluousInterfaceNaming`). The `I` prefix (`IMiddleware`) is legacy; keep it in existing APIs, don't add new ones.
- Traits: no `Trait` suffix (`SuperfluousTraitNaming`). The `T` prefix is common (`TContainerAware`, `TCreatedAt`).
- Exceptions end with `Exception`.
- DI extensions end with `Extension`, Latte extensions too. The folder (`DI/` or `Latte/`) tells them apart.

### Construction

- Use constructor promotion. Use a classic assignment only when the constructor transforms the value.
- Don't use `Nette\SmartObject`. Typed properties and `final` classes replace it.
- Don't use `Nette\StaticClass` for new helpers. A `final` class with only static methods is enough.
- Inject into presenters with `#[Inject]` properties or the constructor, never `/** @inject */`.
- Console commands use `#[AsCommand(name: ..., description: ...)]`, not `static $defaultName`.

## Types

- Every parameter, property, return value and constant has a native type, including `void`, `never`, `static` and unions.
- Class constants have a type when the library requires PHP 8.3+ (`public const string FOO = 'foo';`).
- PHPDoc is added only when it says more than the native type:
  - generics and shapes: `array<string, mixed>`, `list<Foo>`, `array{host: string, port: int}`, `class-string<T>`
  - `@template` for generic classes and methods
  - `@property-read stdClass $config` on DI extensions
- Prefer `array<string, mixed>` or `list<Foo>` over `mixed[]` and `Foo[]` in new code.
- Use `mixed` only at boundaries (config, decoded JSON, user callbacks). Narrow it right away.
- Don't repeat native types in PHPDoc (`@param string $name` next to `string $name`).

## Exceptions

- Every library has `src/Exception/` with two base classes:
  - `LogicalException extends \LogicException` for programmer errors (wrong config, invalid argument, bad state)
  - `RuntimeException extends \RuntimeException` for errors at runtime (I/O, HTTP, external services)
- Specific exceptions extend a base class and live in `Exception/Logical/` or `Exception/Runtime/`.
- The base name is `LogicalException`, not `LogicException`, so it doesn't clash with the SPL class.
- Base classes are not final when other exceptions extend them. Leaf exceptions are `final`.
- A leaf exception builds its own message in the constructor or a named constructor (`::create()`, `::forPath()`).
- Don't throw SPL (`\RuntimeException`, `\InvalidArgumentException`) or Nette (`Nette\InvalidStateException`)
  exceptions from library code, and don't add a marker interface. Callers catch the two base classes.
- DI extensions throw `Nette\DI\InvalidConfigurationException` for config errors the schema can't express.

## DI Extensions

### Structure

- One extension per file in `src/DI/`, named `{Name}Extension` and extending `Nette\DI\CompilerExtension`.
- New extensions are `final`. Existing non-final extensions stay open until the next major release.
- The class has a `@property-read stdClass $config` annotation and reads config via `$this->config`.
- Use `getConfigSchema()` with `Nette\Schema\Expect`. Don't use `$defaults` + `validateConfig()` (Nette 2.4 style).
  Extensions without config don't need a schema.
- Every config key has a type and a default: `Expect::string()`, `Expect::bool(false)`, `Expect::arrayOf(...)`,
  `Expect::anyOf(...)`, nested `Expect::structure([...])`. Mark required keys with `->required()`.
- Config that accepts a service takes `Expect::anyOf(Expect::string(), Expect::type(Statement::class))`.

### Phases

| Method | Use it for |
|--------|------------|
| `getConfigSchema()` | Config schema and defaults |
| `loadConfiguration()` | Register the extension's own services |
| `beforeCompile()` | Work with other services: `findByTag()`, `findByType()`, `getDefinitionByType()`, `addSetup()` |
| `afterCompile()` | Only for changes to the generated container class |

- Runtime initialization (Tracy panels, handlers) goes through `$this->initialization->addBody(...)`, not through
  `$class->getMethod('initialize')` in `afterCompile()`.
- Big extensions split the work into compiler passes in `DI/Pass/` (see `Contributte\DI\Pass\AbstractPass`).
- An extension that needs another one checks `$this->compiler->getExtensions(Other::class)` and throws a clear error.

### Services

- Register services with `$builder->addDefinition($this->prefix('name'))->setFactory(Foo::class, [...])`.
- Add `->setType(Interface::class)` when the factory returns an interface or is a static call.
- Service names are camelCase and grouped with dots: `$this->prefix('configuration.tableStorage')`.
- Reference other services by definition object or `$this->prefix('@name')`, not by class name strings.
- Helper services that must not be autowired get `->setAutowired(false)`.
- Use `Nette\DI\Definitions\Statement`, not the old `Nette\DI\Statement`.
- Use `addFactoryDefinition()` for generated factories, not hand-written implementations.

### Tags

- Tags are public constants on the extension: `public const HANDLER_TAG = 'contributte.messenger.handler';`
- The value is `{vendor}.{library}.{name}` in lower case with dots (`nettrine.orm.manager`, `contributte.mcp.server`).
- Console commands are tagged with `console.command` and the command name, or use `#[AsCommand]`.
- Read tags in `beforeCompile()` with `$builder->findByTag(self::HANDLER_TAG)`.

## Versions and Deprecated APIs

### Versions

- PHP and Nette versions follow [LIBRARY.md](LIBRARY.md#composer-configuration): PHP 8.2+ and Nette 3.2+.
- `nette/*` constraints start at `^3.2` (`nette/utils` at `^4.0`, `latte/latte` at `^3.0`). Add `|| ^4.0` only after
  testing against the Nette 4 dev branch.
- Don't use syntax newer than the `php` constraint (typed constants need 8.3, property hooks 8.4).
- Use modern syntax the constraint allows: `readonly`, enums, `match`, `?->`, first-class callables, `str_contains()`.

### Deprecated APIs

| Don't use | Use |
|-----------|-----|
| `Nette\SmartObject` | Typed properties, `final` classes |
| `Nette\Configurator` | `Nette\Bootstrap\Configurator` |
| `Nette\Localization\ITranslator` | `Nette\Localization\Translator` |
| `Nette\Caching\IStorage` | `Nette\Caching\Storage` |
| `Nette\Bridges\ApplicationLatte\ILatteFactory` | `Nette\Bridges\ApplicationLatte\LatteFactory` |
| `Nette\Database\Context` | `Nette\Database\Explorer` |
| `Json::decode($s, Json::FORCE_ARRAY)` | `Json::decode($s, forceArrays: true)` |
| `Nette\PhpGenerator\PhpLiteral` | `Nette\PhpGenerator\Literal` |
| `$defaults` + `validateConfig()` | `getConfigSchema()` |
| `$class->getMethod('initialize')` | `$this->initialization->addBody()` |
| Latte 2 `MacroSet`, `MacroNode`, `onCompile` | Latte 3 `Latte\Extension` with tags and nodes |
| `/** @inject */`, `@ORM\...` annotations | `#[Inject]`, `#[ORM\...]` attributes |
| `static $defaultName` in commands | `#[AsCommand]` |
| Extensions for Nette 2.4 (`*Extension24`) | Remove them |

## Shared Code

Before writing a helper, check if it already exists:

| Need | Use |
|------|-----|
| Arrays, strings, validators, date time | `nette/utils`, then `contributte/utils` |
| Regular expressions | `Nette\Utils\Strings::match()` / `matchAll()` / `replace()` |
| DI helpers (compiler passes, definition lookup) | `contributte/di` |
| Test helpers | `contributte/tester` |
| HTTP client | PSR-18 `Psr\Http\Client\ClientInterface` (`contributte/guzzlette` for Guzzle) |
| Doctrine entity traits and query objects | `contributte/doctrine-extra` |

A helper that exists in two or more repositories (for example `DI/Helpers/SmartStatement` or `DI/Pass/AbstractPass`)
moves to the shared package, and the copies are removed.

## Class Template

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo;

use Contributte\Foo\Exception\Logical\InvalidNameException;
use Psr\Log\LoggerInterface;

final class FooService
{

	/** @var array<string, Item> */
	private array $items = [];

	public function __construct(
		private readonly FooClient $client,
		private readonly LoggerInterface $logger,
		private readonly bool $debug = false,
	)
	{
	}

	public function get(string $name): Item
	{
		if (!isset($this->items[$name])) {
			throw InvalidNameException::create($name);
		}

		return $this->items[$name];
	}

	/**
	 * @return list<Item>
	 */
	public function all(): array
	{
		return array_values($this->items);
	}

}
```

## Exception Template

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo\Exception;

use LogicException;

class LogicalException extends LogicException
{

}
```

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo\Exception;

class RuntimeException extends \RuntimeException
{

}
```

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo\Exception\Logical;

use Contributte\Foo\Exception\LogicalException;

final class InvalidNameException extends LogicalException
{

	public static function create(string $name): self
	{
		return new self(sprintf('Item "%s" does not exist.', $name));
	}

}
```

## DI Extension Template

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo\DI;

use Contributte\Foo\FooClient;
use Contributte\Foo\FooService;
use Contributte\Foo\Handler;
use Contributte\Foo\Tracy\FooPanel;
use Nette\DI\CompilerExtension;
use Nette\DI\Definitions\ServiceDefinition;
use Nette\DI\Definitions\Statement;
use Nette\Schema\Expect;
use Nette\Schema\Schema;
use stdClass;

/**
 * @property-read stdClass $config
 */
final class FooExtension extends CompilerExtension
{

	public const HANDLER_TAG = 'contributte.foo.handler';

	public function getConfigSchema(): Schema
	{
		return Expect::structure([
			'debug' => Expect::bool(false),
			'client' => Expect::structure([
				'url' => Expect::string()->required(),
				'timeout' => Expect::int(10),
			]),
			'logger' => Expect::anyOf(Expect::string(), Expect::type(Statement::class))->nullable(),
			'handlers' => Expect::arrayOf(Expect::string(), Expect::string()),
		]);
	}

	public function loadConfiguration(): void
	{
		$builder = $this->getContainerBuilder();
		$config = $this->config;

		$builder->addDefinition($this->prefix('client'))
			->setFactory(FooClient::class, [$config->client->url, $config->client->timeout])
			->setAutowired(false);

		$builder->addDefinition($this->prefix('service'))
			->setFactory(FooService::class, [
				'client' => $this->prefix('@client'),
				'debug' => $config->debug,
			]);

		foreach ($config->handlers as $name => $handler) {
			$builder->addDefinition($this->prefix('handler.' . $name))
				->setFactory($handler)
				->setType(Handler::class)
				->addTag(self::HANDLER_TAG, $name);
		}

		if ($config->debug) {
			$this->initialization->addBody('$this->getService(?)->addPanel(new ' . FooPanel::class . '($this->getService(?)));', [
				'tracy.bar',
				$this->prefix('service'),
			]);
		}
	}

	public function beforeCompile(): void
	{
		$builder = $this->getContainerBuilder();

		$service = $builder->getDefinition($this->prefix('service'));
		assert($service instanceof ServiceDefinition);

		foreach ($builder->findByTag(self::HANDLER_TAG) as $serviceName => $name) {
			$service->addSetup('addHandler', [$name, '@' . $serviceName]);
		}
	}

}
```

Register it in NEON:

```neon
extensions:
	foo: Contributte\Foo\DI\FooExtension

foo:
	debug: %debugMode%
	client:
		url: https://api.example.com
```

Every extension has a container test, see [TESTS.md](TESTS.md#di-container-tests).

## Checklist

- [ ] Every file starts with `<?php declare(strict_types = 1);`
- [ ] Namespace matches `composer.json` PSR-4 (`Contributte\`, `Nettrine\`, `Apitte\` or `App\`)
- [ ] Classes are `final` unless built for extension; base classes are `Abstract*`
- [ ] Constructors use promotion; immutable properties are `readonly`
- [ ] No `Nette\SmartObject`, no annotations for metadata, no deprecated APIs from the table
- [ ] Every parameter, property and return value has a native type; PHPDoc only for generics and shapes
- [ ] `src/Exception/` has `LogicalException` and `RuntimeException`; the library throws only its own exceptions
- [ ] DI extensions are in `src/DI/`, named `*Extension`, with `getConfigSchema()` and `@property-read stdClass $config`
- [ ] Tags are `*_TAG` constants with `{vendor}.{library}.{name}` values
- [ ] Runtime init uses `$this->initialization`, not `afterCompile()` + `getMethod('initialize')`
- [ ] `nette/*` constraints start at `^3.2` and `php` at `>=8.2`
- [ ] No helper copied from another repository
- [ ] PHPStan level 9 passes
