# SYNTAX.md — How to write PHP like f3l1x (Contributte) and dg (Nette)

> Extracted from every PHP file in 164 Contributte repositories and 34 Nette repositories (8,581 files) on 2026-09-28,
> then extended with dg's personal repositories, phpsyntax/phpsyntax, nette/agent-plugins, nette/latte-tools,
> f3l1x/codestyler-site and f3l1x/forge (about 1,750 more files; the section 3 header lists them).
> Every rule below was measured, not guessed. Percentages are over `src/` of current-era repositories unless stated.

## 0. How to use this document

There are two authors and two dialects. They share a philosophy (tabs, strict types, native types everywhere, small
classes, Nette Tester) but disagree on nearly every layout detail. **Pick one dialect per repository and never mix.**

| You are writing in… | Dialect | Enforced by |
|---|---|---|
| any `contributte/*`, `nettrine/*`, `apitte/*` repository whose `ruleset.xml` extends `contributte/qa` (123 of 163), or a project built on Contributte skeletons | **A — f3l1x** | `contributte/qa` (phpcs + Slevomat), `contributte/phpstan` (level 9 in most, 8 in apitte/openapi; strict rules). Check the repo's `<exclude>`s and phpstan level before applying a rule. |
| any `nette/*`, `latte/*`, `tracy/*` repository, dg's personal repositories (`dg/*`, dibi, texy, DressCode, PhpSyntax), or a project built on `nette/web-project` | **B — dg** | Nette Coding Standard: released `nette/coding-standard ^3` (`ecs`) in 16 of 18 nette/* CI workflows, DressCode `nette` preset (stricter superset) in tester/command-line and in dg's newest personal repositories; `nette/code-checker`; PHPStan level 8 |

If nothing tells you which, default to **A** for Contributte work and **B** for Nette work. Section 1 is the cheat
sheet of the differences; sections 2 and 3 are the complete dialect descriptions; section 4 is the checklist.

**Local convention wins.** When the file or repository you edit already has a convention for the same construct, copy
it even where this guide shows another variant: the exception class and message template for the same condition,
`addSetup` argument shape, static vs non-static closures, `Assert::same` vs `Assert::equal`, `NEON` / `));` layout,
`Exception/` vs `Exceptions/`, `$this->config` vs `$this->getConfig()`, private helper naming, trailing commas,
constructor promotion. The guide decides only when the repository is silent.

## 1. The two dialects side by side

| Topic | A — f3l1x (Contributte) | B — dg (Nette) |
|---|---|---|
| First line | `<?php declare(strict_types = 1);` (spaces around `=`), 99.8% | `<?php declare(strict_types=1);` (no spaces), 100% |
| File docblock | none | `/** This file is part of the X (url) / Copyright (c) YEAR David Grudl (https://davidgrudl.com) */` in framework packages, DressCode, PhpSyntax, ai-access, dibi, texy; none in apps, tests and dg's other 2025–26 libraries (imap, fio-mcp, google-services, …) |
| Blank lines: `use` block → class | 1 | 2 |
| Blank line after class `{` and before class `}` | yes, always (99.4%) | never |
| Blank lines between methods | exactly 1 (99.7%) | exactly 2 (97.7%) |
| Blank lines between properties | exactly 1 | 0 or 1 (1 before a documented member) |
| Class docblock | rare (17%), tags only (`@property-read stdClass $config`, `@template`) | on every class, one-sentence description ending with a period (84%); dg's 2026 tools add explanatory paragraphs (61% multi-sentence in DressCode) |
| Global classes | imported: `use stdClass;`, `use Throwable;`, `use LogicException;` | fully qualified: `\stdClass`, `\Throwable`, `\LogicException` |
| Global functions | bare (`count($a)`), no `use function` | the calls PHP compiles specially imported once per file (`use function count, is_array, sprintf;`), others bare; nette/utils lists every function a file calls |
| Sibling namespace | full import per class | `use Nette;` then `Nette\Utils\Strings::...` in older code; per-class import in 2026 code, grouped `use A\{B, C};` from two imports in DressCode, PhpSyntax and the rule packages |
| Constants | `UPPER_SNAKE` (enforced) | `PascalCase` (`Strings::TrimCharacters`); `UPPER` only as deprecated aliases |
| `new Foo` without args | `new Foo()` (enforced) | `new Foo` (enforced, no parentheses); chained `(new Foo)->bar()`, with arguments `new Foo($x)->bar()` on PHP 8.4 |
| Arrow function | `fn ($x) => …` (space, enforced) | `fn($x) => …` (no space, enforced) |
| Trailing comma, multi-line array | required | required |
| Trailing comma, multi-line call / parameter list | optional, mostly absent in old code, present in 2025+ code | required |
| Multi-line ctor with promoted params | `)` newline `{` | `) {` on the same line |
| Multi-line method signature | `)` newline `{` | `): type` newline `{` |
| Nullable | `?T` (93%) | `?T` for one type, `A\|B\|null` for unions, null last |
| Exception messages | `sprintf('Service "%s" not found', $name)`; no interpolation (enforced) | `"Service '$name' not found."` interpolation for plain variables; `sprintf("… '%s'.", expr)` for expressions and throughout nette/di; dg's 2026 tools put identifiers in backticks (`` "Invalid version `$version`." ``) |
| Exception base classes | own `LogicalException` / `RuntimeException` per library in `Exception/` | `Nette\InvalidStateException`, `Nette\InvalidArgumentException`, … from `exceptions.php`; dg's personal code: SPL plus its own root (`FioException`, `DG\Imap\Exception`), never the Nette set |
| `match` | practically unused (about a dozen in 1,935 files); `switch`/`if` | used freely (205 in 779 files), `match (true)` for dispatch |
| Enums | none in libraries (0) | rare in nette/* (15), constants in a `final class` preferred; the default for closed sets in dg's 2026 tools (18, one `enums.php` per namespace, a few with methods) |
| `readonly class` | none | `final readonly class` for value objects (nette/*, DressCode 29); dg's libraries use `final class` with `public readonly` promoted properties (0 `readonly class`) |
| `final` | not the default (25%) | ~38% in nette/* (follow the package); 95–98% in dg's 2026 tools, 72% in his 2025–26 libraries |
| `static fn` | on closures without `$this` in 2024+ code | never in nette/* (7), DressCode, PhpSyntax; every `$this`-free closure in fio-mcp and google-services; follow the file |
| Named arguments | flag literals only (`forceArrays: true`) | flag literals, skipped optional parameters, constructors with many optional parameters (`new Usage(inputTokens: …)`); attributes always named |
| Numeric separators | forbidden (`1000000`) | used from 7 digits (`1_000_000`) |
| Method docblock layout | description, blank ` *` line, tags | description, no blank line, `@param  type  $x` with two spaces |
| PHPStan | level 9 in most libraries (8 in apitte/openapi) + strict rules; inline `// @phpstan-ignore-*` or `ignoreErrors` in `phpstan.neon` (44% of repos) | level 8; `ignoreErrors` in `phpstan.neon` with a reason comment; no inline ignores |
| Member order | consts → props → ctor → public → protected → private → magic (enforced) | traits → consts → props → ctor → methods grouped by subject, general before special, helpers after their caller |
| Tests | `Toolkit::test(function (): void { … });` in `tests/Cases/*.phpt` | `test('title', function () { … });` in `tests/<Dir>/Class.aspect.phpt` for new files (30% of the nette/* suite, 72–87% in dg's 2025–26 code; the rest are flat `Assert::` scripts) |
| Commit subject | `Area: imperative lowercase phrase` (`Composer: require PHP 8.2`) | `Class: present-tense sentence` (`Finder: exclude() uses the same mask grammar as find()`) or lowercase past tense (`added Type::fromValue()`, `requires PHP 8.2`); dg's agent skill teaches past tense only |
| Dev entry point | `Makefile` (`make qa cs csf phpstan tests`) | `composer phpstan`, `composer tester`; CI style job `ecs` in nette/*, `dresscode check` in dg's newest repositories |

---

## 2. Dialect A — f3l1x / Contributte

### 2.1 Toolchain (what enforces the style)

- `ruleset.xml` in the repository root extends `./vendor/contributte/qa/ruleset-8.2.xml` (or `-8.4.xml` for skeletons)
  and adds `SlevomatCodingStandard.Files.TypeNameMatchesFileName` with `src => Vendor\Package`, `tests => Tests`.
  `ruleset-8.x.xml` files differ only in `php_version`; all 185 sniffs live in `ruleset.xml`.
- `phpstan.neon` includes `vendor/contributte/phpstan/phpstan.neon` (phpstan-strict-rules, phpstan-nette,
  deprecation rules), `level: 9` (79 of 100 repos; 8 in apitte/openapi), `phpVersion` = the repo's minimum PHP
  (80200 for libraries, 80400 for skeletons), paths `src` and (in 78 of 140 repos) `.docs`, which contains no PHP
  files and so adds nothing; 8 repos also analyse `tests`. 44% of repos carry `ignoreErrors` entries.
- `make qa` = `make phpstan` + `make cs`; `make csf` auto-fixes; `make tests` runs Nette Tester over `tests/Cases`.
  phpcs runs over `src tests` with `--extensions="php,phpt"` and `-n` (errors only; warnings do not fail CI):
  **test files obey every rule below too.**
- Consequences of strict rules at level 9 that shape the code: only real booleans in conditions (`if ($x !== null)`,
  never `if ($x)` on a nullable object, never `if (count($a))`), no `empty()`, no `==`, no short ternary `?:`,
  `in_array(..., true)`, no implicit array creation, no dynamic property or method names. `empty()` has no phpcs
  sniff: only the strict rules reject it, so a repository without `phpstan.neon` can contain it (codestyler-site, 6
  uses); do not copy it. The `contributte` preset in codestyler-site's `resources/presets.json` is not an authority
  (class braces 0/0, `DisallowReference` missing): `contributte/qa/ruleset.xml` is.

### 2.2 File anatomy

Golden file (0 phpcs errors under `contributte/qa`):

```php
<?php declare(strict_types = 1);

namespace Contributte\Messenger\Bus;

use Contributte\Messenger\Exception\Logical\BusException;
use Psr\Container\ContainerInterface;
use Symfony\Component\Messenger\MessageBusInterface;

class BusRegistry
{

	private ContainerInterface $container;

	public function __construct(ContainerInterface $container)
	{
		$this->container = $container;
	}

	public function get(string $name): MessageBusInterface
	{
		if (!$this->container->has($name)) {
			throw BusException::busNotFound($name);
		}

		$bus = $this->container->get($name);
		assert($bus instanceof MessageBusInterface);

		return $bus;
	}

}
```

Rules:

1. Line 1 is exactly `<?php declare(strict_types = 1);` — one line, spaces around `=`. No BOM, LF endings, one
   trailing newline, never a closing `?>`. No file-level docblock, no license header, no `@author`.
2. One blank line, `namespace Vendor\Package\Sub;`, one blank line, the `use` block, one blank line, the type.
3. `use` block: one import per line, **alphabetical by full name, case-insensitive**; class imports first, then
   `use function …;`, then `use const …;` (each group alphabetical, no blank lines between groups), no blank lines inside, no grouping by vendor, no `use A\{B, C}`, no leading backslash, no
   unused imports (annotations count as usage). Global classes are **imported** (`use stdClass;`, `use Throwable;`,
   `use ReflectionClass;`, `use LogicException;`); phpcs also accepts `\Foo`, but the habit is to import (fully
   qualified globals occur mainly in imported code such as rabbitmq/jsonrpc). When a class collides with its own
   name the parent is fully qualified or aliased: `class RuntimeException extends \RuntimeException`.
4. Aliases only to disambiguate, named vendor-prefix + name or role suffix: `use Nette\Http\IRequest as HttpRequest;`,
   `use Tracy\ILogger as TracyLogger;`, `use Nette\Utils\Arrays as NetteArrays;`,
   `use Doctrine\DBAL\Driver as DriverInterface;`.
5. Global functions are called bare (`sprintf(...)`, `count(...)`); `use function` appears in 18 of 1,935 files (57
   statements) and is not the style. Never `\count(`.
6. One type per file; file name equals type name; `src/` mirrors the namespace 1:1 (PSR-4 root `src`, dev root
   `tests` => `Tests`).
7. Indentation is one tab per level everywhere (PHP, NEON, Latte, Makefile); JSON, YAML and Markdown use 2 spaces.
   Docblock continuation lines are tab + ` * `.
8. No line-length limit. Long `sprintf` messages, `Expect::` chains and regexes stay on one line (lines up to 300
   columns exist). Wrap by structure (one argument per line) when a call has 3+ arguments that do not fit, not by width.

### 2.3 Class layout

```php
final class Foo extends Bar implements Baz
{

	use SomeTrait;

	public const TYPE_A = 'a';
	public const TYPE_B = 'b';

	/** @var array<string, string> */
	private array $map = [];

	private ?LoggerInterface $logger = null;

	public function __construct(private readonly Container $container)
	{
	}

	public static function create(): self
	{
		return new self(new Container());
	}

	public function run(): void
	{
		$this->prepare();
		$this->finish();
	}

	protected function prepare(): void
	{
		// Override in child
	}

	private function finish(): void
	{
		$this->logger?->info('done');
	}

	public function __toString(): string
	{
		return 'foo';
	}

}
```

1. Class/interface/trait/enum `{` on its own line; **one blank line after it and one blank line before the closing
   `}`** (99.4% of 1,953 types; enforced). Empty bodies are `{`, blank line, `}`:

   ```php
   final class LogicalException extends LogicException
   {

   }
   ```

2. Method `{` on its own line (Allman), also after a multi-line signature. Control structures, closures, `match` use
   `) {` on the same line.
3. Member order (enforced by `SlevomatCodingStandard.Classes.ClassStructure`): trait `use` → enum cases → public,
   protected, private constants → public static props, public props, protected static, protected, private static,
   private props → `__construct` → `__destruct` → static constructors (`create()`, `of()`, `from()`) → public static,
   public → protected static, protected → private static, private → **magic methods last** (`__toString`, `__invoke`,
   `__get`; only `__construct`/`__destruct` are exempt).
4. Exactly one blank line between any two members (constants, properties, methods). Constants may be stacked without
   blank lines only inside one visibility group (`public const A = 1;` directly followed by `public const B = 2;` is
   what the reference repos do). Trait `use` lines are stacked, followed by one blank line.
5. One property per declaration, one constant per declaration, visibility on every constant, property and method.
   No `var`, no underscore-prefixed names.
6. Never a `//` comment directly above a method or property (enforced: it must be a `/** */` docblock or be separated
   by a blank line). Section separator comments (`/** API ****/`) do not exist in current code.

### 2.4 Declarations and naming

- **`final` is not the default.** 25% of classes are `final`. Use `final` for: static utility
  classes (`Helpers`, `Regex`, `Caster`, `Uuid`, `BuilderMan`), DI helpers, decorators/value leaves, and code in the
  newest repositories (console-extra, logging, crafter, jsonrpc). Leave services, DI extensions, passes, presenters,
  mailers, panels and anything users may extend as plain `class`. Never `final` on Doctrine entities (proxies need to
  extend them) or on skeleton scaffold classes. API-client entities and value objects are `final` (gosms, czech-post,
  reCAPTCHA), unless they extend a shared base (comgate `AbstractEntity`). In documentation examples, follow the
  `.docs` file you are editing: plain `class` is the majority (108 vs 72 `final class`; presenters 16 vs 8). Never
  mix both forms in one file.
- Abstract classes: `Abstract*` (34%: `AbstractPass`, `AbstractEntity`, `AbstractHandler`, `AbstractRepository`) or
  `Base*` (13%: `BasePresenter`, `BaseModule`, `BaseResponse`, `BaseControl`); the rest carry a plain role name
  (`Command`, `Event`, `Plugin`, `JsonController`). Rule of thumb from the code: presenters, controllers, controls,
  modules → `Base*`; entities, repositories, passes, handlers, transformers → `Abstract*`. Never a trailing
  `Abstract`.
- Interfaces: **`I` prefix is the majority in libraries** (56%: `IHandler`, `IMiddleware`, `IRouter`, `IDispatcher`,
  `ILogger`, `IMailer`, `ICacheFactory`, `IController`). No prefix/suffix in some newer or Nette-adjacent code
  (`ConnectionAccessor`, `FiltersProvider`, `Firewall`, `Serializer`) and in application code (`Queryable`). The
  `Interface` suffix is a phpcs error under the default ruleset (`SuperfluousInterfaceNaming`); 21% of interfaces use
  it in the 8 repos that opt out (`contributte/api` — `FirewallInterface`, `MiddlewareInterface` —, crafter, imagist,
  doctrine-fixtures, doctrine-migrations, messenger, translation, webpack). Follow the repository. Constant-bag
  interfaces have no prefix (`RequestAttributes`).
  Interfaces are small, often a single method (`IRouter::match`, `IHandler::handle`, `ISerializer::serialize`).
- Traits: `T` prefix in application code and DI (`TId`, `TCreatedAt`, `TContainerAware`, `TReflectionProperties`) or a
  plain descriptive noun (`StructuredTemplates`, `ExceptionExtra`). The `Trait` suffix is a phpcs error
  (`SuperfluousTraitNaming`); only psr7-http-message, forms-bootstrap, newrelic opt out.
- Exceptions: suffix `Exception`; roots named `LogicalException` (with "-al", to avoid the SPL name) and
  `RuntimeException` (see 2.10).
- Class-name vocabulary (measured suffix frequency): `*Extension`, `*Pass`, `*Exception`, `*Factory`, `*Command`,
  `*Middleware`, `*Resolver`, `*Panel`, `*Config`, `*Filter`, `*Event`, `*Client`, `*Logger`, `*Renderer`,
  `*Provider`, `*Builder`, `*Registry`, `*Locator`, `*Manager`, `*Handler`, `*Decorator`, `*Transformer`, `*Mapper`,
  `*Serializer`, `*Validator`, `*Plugin`, `*Response`, `*Request`. Prefixes: `Container<Thing>` for Nette-DI-backed
  adapters (`ContainerCommandLoader`, `ContainerEventManager`), `Null<Thing>` / `DevNull<Thing>` for no-op
  implementations, `Debug<Thing>` / `Traceable<Thing>` / `Loggable<Thing>` for decorators, `Smart<Thing>` for
  normalisers (`SmartStatement`).
- Whimsical helper names are idiomatic: `BuilderMan`, `Expecto`, `Liberator`, `Neonkit`, `Httpkit`, `Toolkit`,
  `Replacus`, `Nella`, `Crafter`, `Framex`.
- Methods: camelCase; prefixes by frequency `get` (31%), `set` (13%), `add`, `create`, `load`, `is`, `has`, `with`,
  `from`, `to`, `build`, `resolve`, `parse`, `format`, `validate`, `process`, `run`, `execute`, `register`,
  `configure`. Booleans are `isX()` / `hasX()`, never `getIsX()`. A list owned by an object is `get<Plural>()`
  (268 methods in 53 repos: `getTags()`, `getHeaders()`, `getItems()`, `getColumns()`; `get()` alone is for a class's
  single natural value, never a by-id lookup, see 2.13.3). `all()` exists only on keyed
  bags that also expose `get($key)` / `has($key)` (`AppParams`, `Changeset`; 3 uses in total). Never use `all()` on a
  component or entity. DI hook names are fixed (see 2.11). Nette-side hooks: `createComponent*`, `action*`,
  `render*`, `handle*`, `startup`, `beforeRender`, `checkRequirements`.
- Static constructors: `of(...)` wraps given collaborators (`BuilderMan::of($pass)`, `ContainerBuilder::of()`,
  `Kernel::of($configurator)`), `create()` is a no-argument blank instance (`Bootloader::create()`,
  `EntityResponse::create()`), `from(...)` / `fromArray()` / `fromString()` / `fromNette()` convert from another
  representation. A private constructor pairs with `of`/`create`; its empty body carries `// Use self::create()`.
- Constants `UPPER_SNAKE`, always with visibility (`public const`, 91%). Enumerations are constant groups plus a
  plural list constant: `IN_COOKIE`, `IN_HEADER`, … and `INS = [self::IN_COOKIE, …]` checked with
  `in_array($x, self::INS, true)`. DI tag constants end with `_TAG` and hold reverse-DNS strings
  (`public const BUS_TAG = 'contributte.messenger.bus';`).
- Variables camelCase; short names are fine (`$def`, `$rc`, `$em`, `$qb`, `$e`). Conventional locals inside DI
  code: `$builder`, `$config`, `$def`, `$definitions`.
- Namespace layout inside `src/`: entry classes in the root (`ConnectionFactory`, `CommandBus`); sub-namespaces `DI`
  (with `DI/Pass`, `DI/Helpers` or `DI/Utils`), `Exception` (singular, 44 of the 100 qa repos) or `Exceptions` (13, including
  doctrine-dbal and event-dispatcher; keep the one the repository uses; 43 repos have no own exceptions) with
  `Exception/Logical` and `Exception/Runtime`, `Utils`, `Tracy` (panels, with `templates/*.phtml` beside them),
  `Http`, `UI`, `Middleware`, `Mailer`, `Handler`, `Event`, `Command`, `Cache`, `Bridge`/`Bridges` for optional
  integrations.

### 2.5 Properties, constructors, promotion

Two generations coexist; both pass QA. Choose by repository age:

```php
	// Classic (71% of constructors; messenger, nella, bus, di, application, openapi)
	private ContainerInterface $container;

	public function __construct(ContainerInterface $container)
	{
		$this->container = $container;
	}

	// Promoted (29%; console-extra, doctrine-dbal, crafter, apitte 2025+) — trailing comma, ")" then "{" on new lines
	// doctrine-*/framex write plain `private`; console-extra/apitte/console write `private readonly`
	public function __construct(
		private Container $container,
		private array $commandMap,
	)
	{
	}
```

1. Properties are always natively typed; `@var` docblocks only add generics (`/** @var AbstractPass[] */`,
   `/** @var array<string, string> */`) and are **one line** (enforced).
2. Visibility: `private` for state (60–72%), `protected` only in classes designed for subclassing (`CoreDispatcher`,
   `ServiceHandler`, `BasePresenter`), `public` only for Nette Schema config DTOs, request/response entities and
   mapping entities the library reflects (`public int $userId;`).
3. Promoted parameters are plain `private` (152: doctrine-dbal, doctrine-orm, framex) or `private readonly` (141:
   console-extra, apitte, console) — follow the repository; `protected` (no `readonly`) in classes meant to be
   extended, `public` in DTO/command objects (crafter). Never `protected readonly`.
4. Multi-line parameter lists: one parameter per line, one tab deeper, `)` alone on its line at method indent, `{`
   on the next line. Promoted lists in 2025+ code end with a trailing comma; classic lists usually do not. Promoted
   constructors are written vertically even with one parameter (97 vs 52 one-line; doctrine-dbal:
   `public function __construct(` / `private ?bool $debugMode = null` / `)` / `{`).
5. An empty constructor body is `{` newline `}`; a private constructor with no work carries `// Use self::create()`;
   other intentionally empty methods carry `// Nothing to register`, `// No-op`, `// Override in child`,
   `// Nothing` (an empty body without a comment is a phpcs error).
6. Nullable optional dependencies come last with `= null` and are resolved with `??`:
   `$this->serializer = $serializer ?? new DefaultSerializer();`.
7. `readonly class` is never used; `readonly` is per property, on promoted params only, never on classic
   declarations.
8. When writing `new static()`, add the class docblock `@phpstan-consistent-constructor` (otherwise level 9 reports
   `new.static`; older repos ignore the error in `phpstan.neon` instead);
   `final public function __construct()` with `// Secured constructor` guards response objects that expose `create()`.

### 2.6 Types

- Every parameter, property and return has a native type (97% of methods declare a return type; the 3% are
  legacy). `: void` is always written. `mixed` is used freely for genuinely untyped input (`Caster::toInt(mixed
  $value)`, `SmartStatement::from(mixed $service)`).
- Nullable: `?T` (93%). `T|null` only when the type is already a union (`string|int|null`, `Schema|Reference|null`)
  and in a few newest files. Null last in unions. Nullable properties default to `= null` on declaration.
- Unions are written without spaces: `string|int`, `array|string $methods` then normalised with
  `if (!is_array($methods)) { $methods = [$methods]; }`.
- Fluent methods return `self` (`: self`, 447 uses) in most libraries; `: static` (145) only where a parent already
  returns `static` (PSR-7 `with*`, exceptions' `ExceptionExtra`, framex responses, Nette `DateTime`). Older code
  adds a redundant `@return static` docblock above `: self`; do not add it to new code.
- Not used in current libraries: enums (0), `readonly class` (0), `never` (0), `#[Override]`, property hooks, typed
  constants, `final const`, intersection types, first-class callable syntax (5 uses). Named arguments only for
  boolean/flag parameters of Nette/PHP helpers (`Json::decode($s, forceArrays: true)`, `Neon::encode($c, blockMode:
  true)`, `mkdir($d, $m, recursive: true)`) and in attributes. Use constants for fixed sets and `switch`/`if` for dispatch. (Skeleton apps contain one enum; treat enums
  as allowed but exceptional.)
- Attributes used: `#[AsCommand(name: 'nette:cache:purge', description: 'Clear temp folders')]` (usually broken
  one argument per line with a trailing comma when it has 2+ args; 30 multi-line vs 19 one-line), `#[Inject]` on public presenter properties, `#[Attribute(...)]`
  on attribute classes, `#[ORM\Column(type: 'string', length: 255, nullable: false)]` on entities (one attribute per
  line, string type names, explicit `nullable`), `#[AsMessageHandler]`, apitte `#[Path('/users')]`,
  `#[Method('GET')]`, `#[RequestParameter(name: 'id', type: 'int', in: 'path')]` (named args beyond the first).

### 2.7 Docblocks and comments

Docblocks exist only for what native types cannot say. 64% of methods have none.

```php
	/**
	 * Register services
	 */
	public function loadConfiguration(): void

	/**
	 * @param array<string, string> $connectionsMap
	 * @return list<array{class: string, method: string}>
	 */
	public function map(array $connectionsMap): array

	/** @var ServiceDefinition[] */
	private array $definitions = [];

	/** @var ServiceDefinition $def */
	$def = $builder->getDefinition($this->prefix('bus'));
```

1. `@param`/`@return` only for array element types, generics, callables, `class-string`, shapes (89% of `@param`
   lines carry such a type). A docblock repeating the native type is an error (enforced). Bare `array`/`iterable`
   params and returns **must** have a docblock with the element type (enforced).
2. Array notation: `T[]` and `mixed[]` for simple lists (default; `mixed[]` beats `array<mixed>`), `array<K, V>` for
   maps, `array{key: type}` for shapes, `list<T>` only where the list-ness matters (apitte, messenger). Callable
   signatures `callable(ApiRequest): ResponseInterface`.
3. Layout: description (optional, one line, imperative, no trailing period: `Register services`, `Decorate
   services`, `Update PHP code`, `Log error and generate response`), **one blank ` *` line**, then tags in the order
   `@see`, `@template`, `@param`…, `@return`, `@throws`. A property `@var` with a single tag is one line
   (`/** @var Foo[] */`, enforced). A method docblock with a single `@param`/`@return` stays multi-line (917 vs 7
   one-line). Class-level single tags (`/** @internal */`, `/** @phpstan-consistent-constructor */`) are one line.
4. Class docblocks (17%): tags only — `@property-read stdClass $config` or `@method stdClass getConfig()` on DI
   extensions, `@template`/`@implements`/`@extends`, `@phpstan-type`/`@phpstan-import-type`,
   `@phpstan-consistent-constructor`, `@internal`, `@see <upstream url>`, `@method` (Doctrine repositories),
   `@mixin BasePresenter` on presenter traits. One-line prose summaries are rare (`File download response from PSR7
   stream.`). Never `@author`, `@copyright`, `@created`, `@license`, `@package`, `@since`, `@subpackage`, `@version`,
   `@todo` (forbidden by the ruleset); credit ported code with `@see <upstream url>`.
5. `/** {@inheritDoc} */` (doctrine-*, bus, console; 64 uses) or `/** @inheritDoc */` (apitte, api; 28) as the whole
   docblock when an override narrows a return type or implements a framework interface with generics; follow the
   repository.
6. `@throws` is rare (2.4%); used on interface contracts to describe control-flow exceptions.
7. Inline narrowing: prefer `assert($def instanceof ServiceDefinition);` (doctrine-*, event-dispatcher, apitte);
   `/** @var ServiceDefinition $def */` above the assignment is the older equivalent (messenger, console-extra).
   `assert()` is only ever a type narrowing tool, never input validation.
8. Suppressions are inline and specific: `// @phpstan-ignore-line` at the end of the statement,
   `// @phpstan-ignore-next-line` above it, `// @phpstan-ignore <identifier>` in the newest code,
   `// phpcs:ignore <Sniff>` / `// phpcs:disable` … `// phpcs:enable` around `require` of `.phtml` and superglobal
   access. Never a baseline file in libraries.
9. Line comments: `//` only (never `#`, never `/* */`), on their own line **above** the block they label, capitalised,
   imperative or noun phrase, no trailing period: `// Register message bus`, `// Skip if isn't CLI`, `// Trigger
   passes`, `// Only default logger is autowired`, `// priority 10`. One comment per logical step, steps separated
   by blank lines. AGENTS.md rule: "Avoid comments unless the logic is genuinely non-obvious."

### 2.8 Control flow and expressions

```php
	public function getConnection(string $name): Connection
	{
		// Skip if isn't CLI
		if ($this->cliMode !== true) {
			throw new LogicalException(sprintf('Connection "%s" is available only in CLI', $name));
		}

		if (!isset($this->connections[$name])) {
			return $this->createConnection($name);
		}

		$connection = $this->connections[$name];
		assert($connection instanceof Connection);

		return $connection;
	}
```

1. Guard clauses first (42% of top-level `if`s are guards), happy path last; `else` after a `return`/`throw` is
   avoided (16 occurrences in 1,935 files). `elseif` (never `else if`); `else` is used for genuine two-way
   branches.
2. **Blank line before `return`, `throw`, `continue`** (enforced `JumpStatementsSpacing`) unless it is the first
   statement in the block; a `//` comment may sit directly above the jump statement, but the blank line then goes
   above the comment. Blank line after every block (`if`, `foreach`, `try`) before the next statement (enforced). No
   blank line as the first or last line of a method body. `parent::…()` calls need a blank line before and after
   unless first/last in the body (enforced).
3. Strict comparisons only: `=== null`, `!== null`, `=== []`, `!== []`, `=== ''`, `=== true` on booleans from config
   (`if ($busConfig->defaultMiddlewares === true)`), `count($x) === 0`, `in_array($x, $list, true)`. Never `==`,
   Yoda, `empty()`, `is_null()` (forbidden functions: `is_null`, `sizeof`, `join`, `chop`, `key_exists`, `pos`,
   `compact`, `extract`, `settype`, `is_integer`, `is_double`, `fputs`, …). `isset()` for key/property presence,
   `array_key_exists()` when null values matter.
4. `??` (485) and `??=` (`$config ??= new Configuration();`) instead of ternaries on null checks (enforced);
   `?? throw new RuntimeException('Cannot get rootDir')` for lookups that must exist. Long ternary `? :` is fine
   (516); **short ternary `?:` is not used** (phpstan strict forbids it although phpcs would prefer it). Multi-line
   ternary puts `?` and `:` at the start of the continuation lines.
5. Multi-line boolean conditions: allowed only when the single-line form exceeds 70 characters (enforced); the
   operator **leads** the continuation line and `) {` closes on its own line:

   ```php
			if (
				$builder->getByType(ConnectionRegistry::class, false) !== null
				&& !$builder->hasDefinition($this->prefix('transportFactory.doctrine'))
			) {
   ```

6. `match` is essentially unused; `switch` (37 uses): `break;` is usually glued to the last statement of the case
   (about 70%); a blank line before it also passes. A two-way `if/else` whose branches are a single `return` or a
   single assignment to the same variable must be a ternary (enforced `RequireTernaryOperator`); do not assign a
   variable only to return it (`UselessVariable`); `if (c) { return true; } return false;` is rejected.
7. Loops: `foreach` (1,012) far above `array_map`/`array_filter` (used only for one-line transforms). Never `for`
   where `foreach` works; `while ($middleware = array_pop($middlewares))` assignment-in-condition is accepted in
   chain builders.
8. Closures: `function (Type $x) use ($y): void {` (space after `function`, `use` before the return type, return type
   always present); `fn (Type $x): Type => …` (space after `fn`, enforced); `static` on closures/arrow functions that
   do not use `$this` in 2024+ code (`static fn (mixed $input): bool => is_string($input)`). Single-`return` closures
   must be arrow functions (enforced). Callables as `[$this, 'processForm']` in presenters; first-class callable
   syntax is rare.
9. `try`/`catch`: catch specific classes; `catch (Throwable $e)` as the last resort (never `catch (Exception)`,
   enforced `ReferenceThrowableOnly`); PHP 8 `catch (ReflectionException) {` without a variable when unused; an
   empty catch needs a comment (`// Skip`, `// No need to handle`); re-throw wrapped with the previous exception as
   third argument.
10. Casts with a space: `(string) $x`, `(int) $y`, `(array) $values` (enforced); canonical `(int)`/`(bool)`;
    `intval()`/`strval()` only rarely.
11. Increment/decrement by one is `++$i` / `$i++` / `--$i` (both `$i += 1` and `$i = $i + 1` are phpcs errors on
    local variables); other steps use combined assignment `$i += 2` (enforced). `self::CONST`, never `static::CONST`
    (enforced); `$x::class`, never `get_class()` (enforced); strict flag on `in_array`, `array_search`,
    `array_keys($a, $v, true)`, `base64_decode` (enforced).
12. Destructuring `[$a, $b] = …` (never `list()`); by-reference parameters and `use (&$x)` are forbidden by the
    ruleset (repositories that need them exclude `DisallowReference`).

### 2.9 Strings, arrays, formatting

1. Single quotes (97%). Double quotes only for escape sequences (`"\n"`) or to contain an apostrophe
   (`"Bus '%s' not found"`, `"I'm info command"`). **Never interpolation** (`"Hello $x"` is a phpcs error: use
   `sprintf`). Values in messages go through `sprintf` with `"%s"` (double quotes inside the single-quoted PHP
   string) — see 2.10. Concatenation ` . ` with one space each side; string literals are never concatenated to each
   other on one line (enforced). Heredoc is not used in practice (a nowdoc is required when nothing is interpolated);
   nowdoc `<<<'NEON'` is used in tests and `Expect` helpers.
2. Arrays: `[]` only; single-quoted keys; ` => ` single-spaced, never column-aligned; multi-line arrays have **one
   element per line, the first element on a new line, a trailing comma, and `]` at the parent indent** (enforced,
   100%). Nested arrays follow the same shape.
3. Multi-line calls: `(` ends the line, one argument per line one tab deeper, `)` on its own line at statement indent
   (enforced when broken at all). Trailing comma after the last argument: absent in older code (81% of calls),
   present in 2025+ code (console-extra, apitte attribute ctors, framex) — either passes; be consistent within a
   file. A long `sprintf` inside `throw` is broken as `throw new X(sprintf(` … `));` with the message on its own
   line.
4. Method chains: first call on the statement line, every further `->call()` on its own line indented one tab from
   the statement start, `;` glued to the last call; `->build();` may stand alone or be glued as `})->build();`:

   ```php
		$builder->addDefinition($this->prefix('managerRegistry'))
			->setFactory(ManagerRegistry::class, [
				'@container',
				[],
				[],
			])
			->setAutowired(false);
   ```

5. `sprintf` formats with `%s` and `%d`; never positional `%1$s`, never `printf`/`vsprintf`.
   `str_contains`/`str_starts_with`/`str_ends_with` instead of `strpos(...) !== false`.
6. Numeric literals without separators (enforced): `1000000`.
7. Constants and functions in lowercase (`true`, `false`, `null`; enforced).

### 2.10 Exceptions

```
src/Exception/LogicalException.php           class LogicalException extends LogicException {}
src/Exception/RuntimeException.php           class RuntimeException extends \RuntimeException {}
src/Exception/Logical/InvalidStateException.php   final class InvalidStateException extends LogicalException {}
src/Exception/Runtime/LocatorFailedException.php  final class LocatorFailedException extends RuntimeException {}
```

1. Libraries that need their own exceptions (57 of 100) put them in `Exception/` (44 repos) or `Exceptions/` (13:
   doctrine-dbal, event-dispatcher, event-dispatcher-extra, logging, scheduler, fio, comgate, … — keep whatever the
   repository already uses). The usual roots are `LogicalException` (40 repos; extends SPL `LogicException`, imported
   with `use LogicException;` or written `\LogicException`, both pass) and `RuntimeException` (extends
   `\RuntimeException`, fully qualified because the short names collide); some repos use `LogicException` (bus, fio,
   mailing) or a single domain root (`ApiException`, `MiddlewareException`). Small libraries throw the two roots
   directly and may make them `final` (doctrine-dbal, doctrine-orm, event-dispatcher have no leaves); libraries with
   leaves keep the roots plain (messenger, console, di, nella) or `abstract` (apitte, logging). Leaves live in
   `Exception/Logical/` and `Exception/Runtime/` (or `Exception/Logic/`); about two thirds have empty bodies, the rest
   carry static factories; they are plain `class` in most repos and `final` in newer ones (messenger, apitte, di,
   psr7-http-message). Never add a leaf under a `final` root; reuse the root.
   Small API clients keep a flat `Exception/` with one abstract root and final leaves (gosms
   `Exception/{RuntimeException,ClientException}.php`).
2. Programmer/config errors → `LogicalException` (or `InvalidStateException`, `InvalidArgumentException` leaves);
   environment/IO/runtime failures → `RuntimeException` leaves. Inside DI extensions, invalid configuration and
   wiring problems throw the library `LogicalException` by default (messenger, doctrine-orm, latte); Nette's
   `ServiceCreationException` / `MissingServiceException` are used when the extension already throws them
   (event-dispatcher, console) or when the problem is a missing/invalid service definition. Match the file you are
   editing. Attribute classes throw the SPL `InvalidArgumentException` imported with `use InvalidArgumentException;`.
   So do entities and value objects that reject input, including in libraries that have a `LogicalException`
   (czech-post `Entity/Cheque.php:86-88`).
3. Messages: capitalised complete phrase, values interpolated via `sprintf` — quoted `"%s"` (151: doctrine-*, apitte,
   bus), bare `%s` (188) or `'%s'` inside a double-quoted string (messenger) —, class names via `::class`, trailing
   period optional (40% have one; be consistent inside a file):

   ```php
   throw new LogicalException(sprintf('Connection "%s" not found', $connectionName));
   throw new InvalidStateException(sprintf('Cannot get undefined logger "%s".', $name));
   throw new LogicalException(sprintf('Service of type "%s" is needed. Please register it.', Foo::class));
   throw new LogicalException('Second level cache is enabled but no cache is set.');
   throw new InvalidArgumentException('Empty #[Path] given');
   ```

   AGENTS.md rule: "Exception messages must be explicit — tests assert on them." Quote style of values (`"%s"` vs
   bare `%s`) follows the other messages in the same file. Integers are bare `%d` (26 vs 2 quoted).
4. Static factories (messenger, bus, api) when an exception carries data: named after the situation, `sprintf` the
   message, set public typed properties, `return $exception;` after a blank line. Call site: `throw
   BusException::busNotFound($name);`.

   ```php
   final class ContainerException extends LogicalException
   {

   	public ?string $service = null;

   	public static function serviceNotFound(string $id): self
   	{
   		$exception = new self(sprintf("Service '%s' not found", $id));
   		$exception->service = $id;

   		return $exception;
   	}

   }
   ```

   Make the data property safe to read: default it (`public ?string $service = null;`) or give the class a private
   constructor as doctrine-extra `EntityNotFoundException.php:14` does. When a factory wraps another exception, take it
   typed (`ClientException $previous`) and copy `$previous->getCode()` instead of hardcoding a code.

5. Alternatively the message is built in a constructor that takes the offending value:
   `public function __construct(string $type) { parent::__construct(sprintf('Class "%s" does not exist', $type)); }`.
6. API exceptions (apitte/api) use a fluent trait: `ClientErrorException::create()->withMessage('User not
   found')->withCode(404)`; constructor order `(string $message = '', int $code = 400, ?Throwable $previous = null,
   mixed $context = null)`; HTTP status constants from Nette (`IResponse::S404_NotFound`).
7. Wrapping: `throw new CacheException($e->getMessage(), $e->getCode(), $e);`. PSR adapter exceptions take only
   `Throwable $previous` and copy message and code from it.
8. No `@throws` on ordinary methods.

### 2.11 DI extension (the core Contributte artefact)

Canonical skeleton (phpcs-clean under `contributte/qa` and phpstan level 9 clean):

```php
<?php declare(strict_types = 1);

namespace Contributte\Foo\DI;

use Contributte\Foo\Bar;
use Contributte\Foo\BarFactory;
use Contributte\Foo\Exception\LogicalException;
use Contributte\Foo\Tracy\FooPanel;
use Nette\DI\CompilerExtension;
use Nette\DI\Definitions\ServiceDefinition;
use Nette\DI\Definitions\Statement;
use Nette\PhpGenerator\ClassType;
use Nette\Schema\Expect;
use Nette\Schema\Schema;
use stdClass;
use Tracy\Debugger;

/**
 * @property-read stdClass $config
 */
class FooExtension extends CompilerExtension
{

	public const BAR_TAG = 'contributte.foo.bar';

	public function __construct(private ?bool $debugMode = null)
	{
		if ($this->debugMode === null) {
			$this->debugMode = class_exists(Debugger::class) && Debugger::$productionMode === false;
		}
	}

	public function getConfigSchema(): Schema
	{
		$expectService = Expect::anyOf(
			Expect::string()->required()->assert(static fn (mixed $input): bool => is_string($input) && (str_starts_with($input, '@') || class_exists($input) || interface_exists($input))),
			Expect::type(Statement::class)->required(),
		);

		return Expect::structure([
			'debug' => Expect::structure([
				'panel' => Expect::bool($this->debugMode),
			]),
			'bars' => Expect::arrayOf(Expect::structure([
				'factory' => (clone $expectService)->required(),
				'options' => Expect::array(),
				'timeout' => Expect::int()->nullable(),
			])),
		]);
	}

	/**
	 * Register services
	 */
	public function loadConfiguration(): void
	{
		$builder = $this->getContainerBuilder();
		$config = $this->config;

		// Register bars
		foreach ($config->bars as $name => $barConfig) {
			$builder->addDefinition($this->prefix(sprintf('bars.%s', $name)))
				->setFactory(Bar::class, [$barConfig->options, $barConfig->timeout])
				->setAutowired($name === 'default')
				->addTag(self::BAR_TAG, $name);
		}

		// Register factory
		$builder->addDefinition($this->prefix('factory'))
			->setFactory(BarFactory::class, [[]]);

		// Debug panel
		if ($config->debug->panel) {
			$builder->addDefinition($this->prefix('panel'))
				->setFactory(FooPanel::class)
				->setAutowired(false);
		}
	}

	/**
	 * Decorate services
	 */
	public function beforeCompile(): void
	{
		$builder = $this->getContainerBuilder();
		$config = $this->config;

		// Skip if nothing registered
		if ($config->bars === []) {
			throw new LogicalException('At least one bar must be configured');
		}

		// Replace placeholder argument with tagged services map
		$factoryDef = $builder->getDefinition($this->prefix('factory'));
		assert($factoryDef instanceof ServiceDefinition);
		$factoryDef->setArgument(0, $this->getBarsMap());
	}

	public function afterCompile(ClassType $class): void
	{
		$config = $this->config;

		if ($config->debug->panel) {
			$initialize = $class->getMethod('initialize');
			$initialize->addBody('$this->getService(?)->addPanel($this->getService(?));', ['tracy.bar', $this->prefix('panel')]);
		}
	}

	/**
	 * @return array<string, string>
	 */
	private function getBarsMap(): array
	{
		$builder = $this->getContainerBuilder();
		$map = [];

		foreach ($builder->findByTag(self::BAR_TAG) as $serviceName => $tagValue) {
			assert(is_string($tagValue));
			$map[$tagValue] = $serviceName;
		}

		return $map;
	}

}
```

Rules and idioms:

1. Name `<Concern>Extension`, in namespace `<Root>\DI`, extending `Nette\DI\CompilerExtension`. Not `final` by default
   (30 of 105 are; the reference `DbalExtension`, `OrmExtension`, `MessengerExtension` are not). Config is typed
   through the class docblock: `@property-read stdClass $config` and read as `$this->config` (majority,
   doctrine-dbal/orm/mail/http/latte/cache) or `@method stdClass getConfig()` with `$this->getConfig()` (console,
   event-dispatcher); messenger writes `@property-write`. `stdClass` is imported. Large configs get a
   `@phpstan-type TConnectionConfig object{…}` shape on the extension, imported in passes with
   `@phpstan-import-type` and used in `@phpstan-param` (doctrine-dbal `ConnectionPass`) — that is how level 9 stays
   clean with `stdClass` config.
2. Hook order in the file is fixed: `getConfigSchema()`, `loadConfiguration()`, `beforeCompile()`,
   `afterCompile(ClassType $class)`, then private helpers (79 of 79 extensions). In the pass-based reference
   extensions (doctrine-*, messenger) each hook carries the docblock `Register services` / `Decorate services` and
   only forwards to the passes under `// Trigger passes`; extensions that do the work inline usually have no hook
   docblock. `afterCompile` has none. Extensions without options omit `getConfigSchema()`.
3. First lines of a hook body: `$builder = $this->getContainerBuilder();`, then `$config = $this->config;` (or
   `$this->getConfig()` where the class declares `@method stdClass getConfig()`). Declare only the locals the hook
   uses; a dispatching hook that only reads `$config` starts with it.
4. Schema is `Expect::structure([...])` returned inline; defaults as the scalar argument (`Expect::bool(false)`,
   `Expect::int(20)`), `->required()`, `->nullable()`, `->dynamic()` for values that may be `%parameters%`,
   `->castTo('array')` on nested structures consumed as arrays, `->assert(fn, 'message')` for inline validation.
   Keys are camelCase (`failureTransport`, `defaultMiddlewares`) unless mirroring an upstream option name.
   Reusable fragments live in local variables and are reused with `(clone $expectService)`; the recurring
   "service or class" type is `string|Statement`. Environment-dependent defaults come from a constructor argument
   (`bool $debugMode`, `bool $cliMode`) passed from NEON as `%debugMode%` / `%consoleMode%`.
5. Service definitions: `$builder->addDefinition($this->prefix('name'))` followed by chained calls one per line.
   Prefer `setFactory(X::class, [args])` over `setType()`; `setType()` only when there is no factory. Internal
   services get `->setAutowired(false)` (86 of 94 calls in extensions); only the `default` instance of a
   multi-instance service is autowired (`->setAutowired($name === 'default')`). Ids are literal dotted camelCase
   (`'bus.container'`, `'transportFactory.inMemory'`); dynamic ids use `sprintf('managers.%s.entityManager', $name)`
   in the pass-based reference repos (doctrine-*, messenger) and `'x.' . $name` concatenation in older ones
   (console, console-extra, apitte); follow the repository. References to other services are `$this->prefix('@bus.container')` (the `@` inside `prefix`),
   or `'@container'`, `'@self'`; `Reference` objects are not used. Setup calls with placeholders:
   `->addSetup('?->addEventListener(?, ?)', ['@self', $event, $listener])`.
6. Tags are `*_TAG` constants (22 vs 3 `TAG_*`); the payload is a scalar (usually the instance name), narrowed on read
   with `assert(is_string($tagValue));` because `findByTag()` returns `array<string, mixed>` (messenger's
   `(string) $tagValue` cast now fails level 9 with `cast.string`); array payloads exist (24 calls) but must be
   narrowed (`assert(is_array($tag))`) before offset access. Consumers use
   `$builder->findByTag(self::BAR_TAG)`. Console commands get the literal tag `'console.command'` with the
   command name.
7. **Two-phase wiring**: register a service with an empty placeholder argument in `loadConfiguration`
   (`->setFactory(TransportFactory::class, [[]])`), then in `beforeCompile` fetch the definition,
   `assert($def instanceof ServiceDefinition)`, and `->setArgument(0, $map)` once all extensions registered their
   services. Larger extensions delegate to `DI/Pass/<Concern>Pass` classes (`AbstractPass` with
   `loadPassConfiguration()`, `beforePassCompile()`, `afterPassCompile(ClassType)`, `prefix()`,
   `getContainerBuilder()`, `getConfig(): stdClass`), instantiated in the extension constructor under
   `// priority 10` comments; a `BuilderMan::of($pass)` helper collects tagged definitions into
   `array<string, string>` maps. `contributte/di` ships this as `PassCompilerExtension`.
8. **"Service or class" config values are passed through, not re-implemented.** The schema validates the shape
   (`Expect::string()->assert(static fn (mixed $input): bool => is_string($input) && (str_starts_with($input, '@')
   || class_exists($input) || interface_exists($input)))` or `Expect::anyOf(Expect::string(), Expect::type(Statement::class))`)
   and the value is handed to Nette DI as `new Statement($value)` — the doctrine/messenger helper
   `SmartStatement::from(mixed $service): Statement` (string → `new Statement($string)`, `Statement` → itself, else
   `throw new LogicalException('Unsupported type of service')`) — or as a factory/setup argument; Nette DI resolves
   `@name` references and autowires class names itself. Exception: when the consumer needs a **service name** (lazy
   wiring such as `LazyListener`, service locators), resolve `@name` with `substr($value, 1)` and let
   `$builder->getDefinition()` throw Nette's `MissingServiceException`; resolve a class or interface with
   `$builder->getByType($class)` after the schema assertion proved it exists, narrowed with `/** @var class-string
   $class */` (messenger `HandlerPass`), failing with `sprintf('Service of type "%s" is needed. Please register it.',
   $class)`. A `Statement` with arguments becomes the extension's own definition
   (`$builder->addDefinition($this->prefix(sprintf('listener.%d', $i)))->setFactory($value)->setAutowired(false)`,
   middlewares). Never unwrap `Statement::getEntity()` of a config value; never guard `getByType()` with
   `class_exists() ? … : null`. PHPStan level 9: `getByType()`/`getDefinitionByType()` take `class-string`.
   Validate *shape* in the schema (required keys, `@`-or-class assertions, enums; tests assert the exact
   `InvalidConfigurationException` message) and *existence/wiring* in `beforeCompile()` (service registered, method
   exists, tag present). Do not drop a schema assertion to get a library exception instead.
9. Narrow `Definition` to `ServiceDefinition` with `assert($def instanceof ServiceDefinition);` (current) or
   `/** @var ServiceDefinition $def */` (older). Requirement checks throw Nette's `ServiceCreationException` /
   `MissingServiceException` or the library `LogicalException` with `sprintf('Service of type "%s" is needed.
   Please register it.', X::class)`.
10. Generated code in `afterCompile`: `$class->getMethod('initialize')->addBody('$this->getService(?)->addPanel(...);',
   [...])` with `?` placeholders. Guards at the top of hooks: `if ($this->cliMode !== true) { return; }` under
   `// Skip if isn't CLI`; `if (!$config->enabled) { return; }`.
11. Sub-extension composition ("bridges"): the parent instantiates children, calls `setCompiler($this->compiler,
    $this->prefix($name))` and `setConfig()`, then forwards the three hooks; each bridge can be disabled with
    `false` via `Expect::anyOf(false, $schema)->default($schema)`.
12. Section comments inside hooks label logical blocks: `// Register bus wrapper`, `// EntityManager: enable
    filters`, `// Only default logger is autowired`.
13. Helpers that hooks delegate to are `private`, placed after the hooks, named after the file's existing scheme
    (`doBeforeCompile<Thing>()` in event-dispatcher, `compile<Thing>()` in middlewares, `get<Thing>Map()`); a one-line
    imperative docblock only if the sibling helpers have one; lookup helpers return the `Definition`, not its name.
14. `addSetup('method', [...])` arguments are a positional list (doctrine-orm `EventPass`); string keys
    (`'eventName' => …`) appear only in legacy code.

### 2.12 Library architecture and design habits

- **Composition over inheritance**: decorators wrap an interface and delegate (`TraceableMailer`, `DebugDispatcher`,
  `LoggableStorage`, `DebugMiddleware`); inheritance is used to extend framework bases (`extends Command`,
  `extends CompilerExtension`, `extends AbstractManagerRegistry`, `extends NetteDateTime`).
- **"Collect + run" managers**: a class holds `/** @var IValidation[] */ private array $validators = [];`, exposes
  `add(IValidation $validator): void` and iterates in `validate()`; DI wires it with `->addSetup('add', [$def])` in
  a loop. Pipelines reduce with `foreach ($this->decorators as $decorator) { $request = $decorator->decorate($request); }`.
- **Static utility classes**: `final class Helpers` / `Regex` / `Caster` / `Uuid`, all `public static`, stateless, no
  private constructor, in namespace `Utils`. `Regex::match()` wraps `preg_match` and returns `null` instead of
  `false`. Name triples in `Caster`: `xOrNull()`, `ensureX()`, `forceX()`. Keyed bags: `get($key)` +
  `has($key)` + `all()`. Everything else uses `get<Plural>()`.
- **Value objects**: getter-only classes with promoted private props;
  `fromArray(array $data): self` (typed `@param mixed[] $data`, reads the source keys as they arrive) on objects built
  *from* external data, `toArray(): array` with null-skipping on objects sent *out*. Add the other direction only when
  something calls it (cache, persistence). Never assemble an intermediate array just to call your own `fromArray()`.
  `__toString()` via `sprintf`. Setters on DTO/entity/
  API-client classes return `void`; fluent `return $this` (with `: self`) is reserved for builders and UI components
  (`Datagrid`, `CurlBuilder`, `ChainBuilder::add()`, `Bootloader::use()`); `with*()` means an immutable clone only in
  PSR-7 wrappers (`$new = clone $this; … return $new;`), a mutating fluent setter in response/exception DSLs.
- **PSR interop**: wrap, do not reimplement (`ProxyRequest implements ServerRequestInterface` holding `protected
  ServerRequestInterface $inner`); the implementation carries the PSR noun (`Container implements
  ContainerInterface`, `CachePool implements CacheItemPoolInterface`); PSR interfaces are imported with their
  `Interface` suffix and never aliased. JSON through `Nette\Utils\Json::decode(..., forceArrays: true)`.
- **Middlewares**: double-pass contract `__invoke(ServerRequestInterface $request, ResponseInterface $response,
  callable $next): ResponseInterface`, `return $next($request, $response);` to continue, return a modified
  `$response` to short-circuit; attribute names namespaced (`'contributte.original.path'`, `'apitte.core.endpoint'`);
  chain built by `while ($middleware = array_pop($middlewares)) { $next = fn (...) => $middleware($request,
  $response, $next); }`. The newest generation (`contributte/api`) uses single-pass `process(ApiRequest $request,
  callable $next)`.
- **Attributes (apitte)**: non-final classes under `Annotation\Controller`, `#[Attribute(Attribute::TARGET_CLASS |
  Attribute::TARGET_METHOD)]` directly above the class, promoted `private readonly` params validated in the
  constructor (`if ($path === '') { throw new InvalidArgumentException('Empty #[Path] given'); }`), getters only.
  Consumers stack one attribute per line, class-level first, named arguments beyond the first.
- **Type mappers / strategies** registered in a map keyed by a string, each implementing a one-method interface and
  narrowing the return type; `/** @inheritDoc */` as the only docblock.
- **Tracy panels** in `Tracy/` implement `IBarPanel`, keep `templates/*.phtml` next to the class and render with
  `ob_start(); require __DIR__ . '/templates/panel.phtml'; return ob_get_clean();` wrapped in `// phpcs:disable`.
- **Nette UI components** (`Control` subclasses in 8 libraries: ui, paginator-control, menu-control, datagrid, social,
  application, oauth2-client, newrelic). `createComponent*()` methods are protected, `handle*()` are signals. Recipe,
  from `ui/src/Paginator`:

  ```
  src/<Feature>/<Feature>Control.php          class, extends Nette\Application\UI\Control (plain `class`;
                                              menu-control's MenuComponent is the only `final` one)
  src/<Feature>/<Feature>ControlFactory.php   interface <Feature>ControlFactory { public function create(…): <Feature>Control; }
  src/<Feature>/Template/bootstrap5.latte     default template; more files named after the CSS framework (bootstrap4, tailwind2)
  ```

  - Template directory: follow the repository. Measured: `templates/` (datagrid ×2 controls, menu-control),
    `Template/` (ui), `Examples/` (paginator-control), file next to the class (oauth2-client `GenericAuthControl.latte`,
    social `Script/script.latte`). In a new repository use `templates/`.
  - The default template path is a property, `private string $templateFile = __DIR__ . '/Template/bootstrap5.latte';`,
    with `public function setTemplateFile(string $file): void` (ui, paginator-control, DatagridPaginator). Only
    `Datagrid` returns `self`.
  - `render(): void` is `$template = $this->getTemplate(); $template->setFile($this->templateFile);
    $template->foo = …;`, blank line, `$template->render();`. Data is passed as dynamic template properties. No typed
    `*Template` classes.
  - Links are generated by the caller (`$this->link()` in the presenter) and passed in as strings, or with `n:href` for
    the control's own signals (`handle*()`), which then needs a presenter.
  - Factories: 0 of 4 Control factories use the `I` prefix. Two are **interfaces without prefix**
    (`ui/src/Paginator/PaginatorControlFactory.php`, `paginator-control/src/PaginatorControlFactory.php`) that the user
    registers as `- Vendor\Pkg\<Feature>ControlFactory` in NEON (or the library's extension loads a
    `config/common.neon` that does). Two are **hand-written `final class`** factories with injected services
    (`menu-control` `MenuComponentFactory::create(string $name)`, `newrelic` `RUMControlFactory::createHeader()`). Use
    an interface when all arguments come from the caller, and a class when the factory needs container services.
    `addFactoryDefinition()->setImplement()` is used for form and message factories (`forms` `IApplicationFormFactory`,
    `mail` `IMessageFactory`, `utils` `IDateTimeFactory`), never for Controls.
  - Accessors on the control follow 2.4 (`get<Plural>()` for its list), and `add<Thing>(): self` when the control is
    configured in `createComponent*()`.
  - Latte templates in libraries: tabs, n:attributes (`n:if`, `n:foreach`, `n:class`, `n:href`), Bootstrap class names
    verbatim from the Bootstrap docs, the root element guarded with `n:if` so an empty control renders nothing, and a
    conditional attribute written inside the tag as `{if $cond}aria-current="page"{/if}` (ui, paginator-control ×2; no
    `n:attr` for single attributes). Auto-escaping is relied on; no `|noescape`. `{varType}` only when the repository
    already uses it (menu-control).
- **Whimsy and terseness**: short class names (`Nella`, `Expecto`, `BuilderMan`), short variable names, methods of
  4–10 lines (median 6), files of 30–60 lines (median 35).

#### 2.12.1 API clients (gosms, comgate, czech-post, fio)

- Layout: one transport class in `Http/` over PSR-18 `ClientInterface` + `RequestFactoryInterface` (gosms
  `Http/Client.php:18-23`) or Guzzle (comgate `Http/HttpClient.php:15`); an endpoint mapper (`Api/`, `Gateway/`,
  `Requestor/`); a user-facing facade in `Client/` or `*Service`; data classes in `Entity/` (comgate adds
  `Entity/Response/`, `Entity/Codes/` for status constants).
- One method per endpoint named after it (`messageDetail()` → facade `detail()`); path ids stay scalar
  (`string $id`, `sprintf('%s/%d', self::BASE_MESSAGE_URL, $id)`). A request object only for a request body
  (gosms `Message implements JsonSerializable`, comgate `Payment::toArray()`).
- Entities are `final`, getter-only (gosms `Entity/AccessToken.php:8`, czech-post `Entity/State.php:7`); open only
  when they extend a base (comgate `AbstractEntity`). Outgoing ones serialise (`toArray()`/`jsonSerialize()`);
  incoming ones are built from the decoded payload with `new Entity($data->a, …)` (gosms
  `Auth/AccessTokenProvider.php:24-30`) or `fromArray(array $data)` reading the *wire* keys, `@param mixed[] $data`
  (czech-post `Entity/State.php:22-39`; 55 of 57 `fromArray` in the corpus). No `toArray()` nobody calls; a shape
  alias mirrors the wire (`reCAPTCHA/src/ReCaptchaResponse.php:5-13`).
- Response shape is checked before use; a missing field throws the library runtime exception with an explicit
  message (czech-post `ParcelHistoryRequestor.php:82-88`, comgate `AbstractResponseEntity.php:55-60`). Never let a
  warning or `TypeError` escape from a mapped `stdClass` (phpstan level 9 does not see implicit mixed).
- HTTP errors: one transport exception for every unexpected status, status as the exception code (gosms
  `Http/Client.php:72-74`, czech-post `Runtime/ResponseException.php`, fio `HttpStatusException::fromStatusCode()`).
  No per-resource `*NotFoundException` for 404 and no `null` returns; callers branch on `$e->getCode()`. Invalid
  input in an entity throws SPL `InvalidArgumentException` (czech-post `Entity/Cheque.php:86-88`).
- Tests never hit the network except an `E2E/` test skipped without credentials (gosms `E2E/SendSmsTest.phpt:25-29`).
  Stub the transport with Guzzle `MockHandler` + `Middleware::history()` (comgate `Gateway/PaymentService.phpt:30-50`),
  a spy fake (fio `tests/Toolkit/SpyHttpClient.php`) or `Mockery::mock(ClientInterface::class)` returning
  `new Response(…)` (gosms `Auth/AccessTokenClient.phpt:16-18`); assert method, URI and headers with `Assert::same`
  one per line, never through a boolean `withArgs` chain.
- Docs: under `## Usage` list facade methods as `` - `name(args)` - [Title](upstream anchor) `` (gosms
  `.docs/README.md:85-91`, fio `:143-147`); a new method gets a `### <Name>` with a one-line intro and one example
  (comgate `### Status`); failure modes stay in one sentence or one `### Errors` section (czech-post `:50-53`).

### 2.13 Application code (skeletons)

```
app/
  Bootstrap.php                     final class App\Bootstrap  (boot(): ExtraConfigurator, run(): void / runWeb() / runCli())
  Domain/<Aggregate>/               entities, facades, commands, handlers, subscribers (App\Domain\User\CreateUserFacade)
  Model/<Infra>/                    Database/, Exception/, Utils/, Latte/, Router/, Security/, Bus/
  UI/BasePresenter.php              abstract class BasePresenter extends NellaPresenter (often empty)
  UI/@Templates/@layout.latte
  UI/<Name>/<Name>Presenter.php     + UI/<Name>/Templates/<action>.latte
config/config.neon + config/local.neon (from local.neon.example)      var/tmp, var/log      www/index.php      bin/console
```

1. Bootstrap (current): `final class Bootstrap` with `public static function boot(): ExtraConfigurator { return
   Bootloader::create()->use(NellaPreset::create(__DIR__))->boot(); }` and `run(): void` chaining
   `self::boot()->createContainer()->getByType(Application::class)->run();`. Hand-wired variant uses
   `ExtraConfigurator`, `setEnvDebugMode()` (from `NETTE_DEBUG`), `enableTracy(__DIR__ . '/../var/log')`,
   `addStaticParameters(['rootDir' => …, 'appDir' => …, 'wwwDir' => …])`, `getenv('NETTE_ENV', true) === 'dev'`
   to pick `config/env/dev.neon` vs `prod.neon`, then `config/local.neon`.
2. Presenters: `abstract class BasePresenter` (traits, `@property-read TemplateProperty $template` docblock) →
   `SecuredPresenter` / `UnsecuredPresenter` → `class HomePresenter` (plain, as in 2.4: 26 presenters in 17 skeleton
   repos, including every Nella `UI/<Name>/` skeleton except datagrid; `final` only in datagrid-skeleton, gui, vite,
   micro and webapp's Front/Admin modules). Copy the sibling presenter. A presenter with a constructor calls
   `parent::__construct();` first. Dependencies via `#[Inject] public
   Foo $foo;` (one blank line between injected props) or constructor injection; older skeletons (webapp,
   doctrine-extra, payments) still use `/** @var Foo @inject */`; prefer `#[Inject]` in new code. webapp-skeleton
   nests modules as `UI/Modules/<Module>/<Name>/`.
   Methods `action*`, `render*`, `handle*` (signals), `protected function createComponent*()`, `process*Form`
   callbacks; flash + redirect idiom `$this->flashMessage('Saved'); $this->redirect('this');`; template variables
   assigned dynamically (`$this->template->users = $users;`). No typed `*Template` classes, no `I*Factory`
   component factories in skeletons.
3. Doctrine entities: plain `class` (never final), `#[ORM\Entity(repositoryClass: UserRepository::class)]`,
   `#[ORM\Table(name: '`user`')]`, one attribute per line, `#[ORM\Column(type: 'string')]` terse in doctrine-skeleton,
   doctrine-project, doctrine-extra-skeleton and demo-typesense; verbose `type, length: 255, nullable: false` in apitte-,
   ddd- and webapp-skeleton (follow the repo's existing entity). `private` typed properties with `?T = null`. Ids and
   timestamps are either plain properties set in the constructor (doctrine-skeleton `User`), or traits with the entity
   extending `AbstractEntity`. The traits are app-defined `App\Model\Database\Entity\{TId,TCreatedAt,TUpdatedAt}` +
   `AbstractEntity` (apitte, webapp), or `Nettrine\Extra\Entity\{TGeneratedId,TCreatedAt}` + `AbstractEntity` (ddd);
   `TId` exists only as an app-defined trait. Never traits without `AbstractEntity`. `TCreatedAt`/`TUpdatedAt` use
   `#[ORM\PrePersist]`/`#[ORM\PreUpdate]`, so the entity **must** carry `#[ORM\HasLifecycleCallbacks]` (3 of 3 entities
   with such callbacks do). Do not use `nettrine/extra`'s `TUpdatedAt` (^0.2 declares `nullable: false` on a null
   default). The constructor takes required fields and sets defaults, domain mutators named by intent
   (`activate()`, `block()`, `changeUsername()`, `rename()`), simple `getX()`/`setX(): void`, `isActivated(): bool`.
   Repositories `final class UserRepository extends AbstractRepository` with `/** @extends AbstractRepository<User> */`,
   custom finders `findOneByEmail()`; `EntityManagerDecorator` extends Doctrine's decorator.
   Lookup vocabulary: `find($id)` / `findOneBy()` return `?Entity` (Doctrine). `fetch($id)` / `fetchBy($criteria)` throw
   `EntityNotFoundException` (inherited from `Nettrine\Extra\Repository\AbstractRepository`; doctrine-extra-skeleton
   `TRepositoryExtra`). Use them instead of writing a throwing `get()` and a per-entity not-found exception. `get(int
   $id)` does not occur.
4. Facades: `<Plural>Facade` for a facade with several operations on one aggregate (`UsersFacade`, apitte-skeleton);
   `<Verb><Noun>Facade` for a single use case (`CreateUserFacade`, webapp-skeleton). Singular `UserFacade` appears only
   in library README examples. They hold only `$em` (or `EntityManagerDecorator`) and reach repositories via
   `getRepository()`; by-id lookups that must succeed use `fetch()` (item 3). API facades return response DTOs for reads
   (`UserResDto::from($entity)`); Latte apps, and `create()` everywhere, return entities. Commands and handlers live
   under `App\Domain\<Aggregate>` (`#[AsMessageHandler] final class CreateUserHandler`, `__invoke`).
5. Console commands: `#[AsCommand(name: self::NAME)] final class InfoCommand extends Command` with `public const NAME
   = 'app:info';`, `configure()` (`setName`, `setDescription`), `execute(InputInterface $input, OutputInterface
   $output): int` returning `0`.
6. Security: `UserAuthenticator implements Authenticator` with an `if/elseif` throw ladder and Nette 3.2
   PascalCase constants (`self::IdentityNotFound`); `SecurityUser extends Nette\Security\User` registered as
   `security.user`; `Identity extends SimpleIdentity`.
7. Exceptions in apps mirror libraries: `App\Model\Exception\{LogicException,RuntimeException}` roots →
   `Logic\*`, `Runtime\*` final leaves (apitte-skeleton, webapp-skeleton: 2 of 2 apps with leaves). Libraries use
   `Exception/Logical/` (12 repos vs 5 with `Logic/`, see 2.10). doctrine-skeleton names the root `LogicalException` (no
   leaves). Keep the repo's root name, and put leaves in `Logic/` (apps) next to `Runtime/`. Entity-not-found is a
   Runtime leaf; prefer nettrine/extra's `Runtime\EntityNotFoundException` via `fetch()` over a new class.
8. NEON (tabs; `# ====` banner comments in Nella-era configs; section order `php` → `parameters` → `extensions` →
   extension blocks → `services`): services as anonymous list entries `- App\Domain\User\CreateUserFacade`, named only
   when overriding framework services (`security.user: App\Model\Security\SecurityUser`, `router: … factory:
   @App\Model\Router\RouterFactory::create`); extension keys dotted with vendor (`nettrine.dbal`, `contributte.console`)
   in new skeletons, short (`console`, `monolog`) in older ones; parameters `%appDir%`, `%tempDir%`, `%debugMode%`,
   `%consoleMode%`; constants via `::constant(Foo::BAR)`. ORM mapping: one `attributes` block covering the whole domain
   (`App\Domain: { type: attributes, directories: [%appDir%/Domain], namespace: App\Domain }`: apitte, ddd, messenger).
   Widen the existing block for a new aggregate instead of adding one per folder, and map an entity only into the
   managers that use it (never a second manager by default). Migrations are part of an entity PR: a new entity ships
   with a migration for every manager it is mapped into.
9. Latte: `@layout.latte`, `{block #content}` in f3l1x scaffolds (`{block content}` in community demos),
   `{include #content}`, `{block #title|striptags}…{/}`, n:attributes over tag pairs (`n:if`, `n:href`, `n:class`,
   `n:inner-foreach`, `n:name`), `{=date(Y)}`, `{$basePath}`, loop variable `$_user`; tabs.
10. Root files: `Makefile` with `#####` banner sections (`PROJECT`, `DEVELOPMENT`, `DOCKER`, `DEPLOYMENT`) and
    targets `project init install setup clean qa cs csf phpstan tests coverage dev build docker-up deploy`
    (`qa: cs phpstan`, `dev: NETTE_DEBUG=1 NETTE_ENV=dev php -S 0.0.0.0:8000 -t www`; port 8000 in 20 of 21
    skeletons with a `dev` target); `ruleset.xml` extending
    `ruleset-8.4.xml` with `app => App`, `tests => Tests`; `phpstan.neon` level 9, paths `app`, `bin`, `tmpDir:
    %currentWorkingDirectory%/var/tmp/phpstan`; `docker-compose.yml` with `dockette/web:php-84`, `postgres:15`,
    credentials `contributte/contributte`; workflows call `contributte/.github` with `make: "init tests"`.

### 2.14 Tests (Nette Tester)

Layout:

```
tests/
  bootstrap.php
  Cases/DI/FooExtension.phpt            # <Extension>.{feature}.phpt for feature files
  Cases/Unit/…  Cases/E2E/…             # only in the newest repos; most mirror src/ (Cases/Bus, Cases/Utils)
  Fixtures/ (or Mocks/)                 # Tests\Fixtures\DummyCommand, Tests\Mocks\Handler\SimpleHandler
  Toolkit/Tests.php                     # final class Tests { public const TEMP_PATH = __DIR__ . '/../tmp'; }
  tmp/                                  # gitignored, created by Environment::setup()
```

`tests/bootstrap.php` is byte-identical in 97 repositories:

```php
<?php declare(strict_types = 1);

use Contributte\Tester\Environment;

if (@!include __DIR__ . '/../vendor/autoload.php') {
	echo 'Install Nette Tester using `composer update --dev`';
	exit(1);
}

Environment::setup(__DIR__);
```

Canonical test file (`contributte/tester` Toolkit style, 78 repositories exclusively, 96 in total):

```php
<?php declare(strict_types = 1);

namespace Tests\Cases\DI;

use Contributte\Foo\Bar;
use Contributte\Foo\DI\FooExtension;
use Contributte\Tester\Toolkit;
use Contributte\Tester\Utils\ContainerBuilder;
use Contributte\Tester\Utils\Neonkit;
use Nette\DI\Compiler;
use Nette\DI\InvalidConfigurationException;
use Tester\Assert;

require_once __DIR__ . '/../../bootstrap.php';

// Minimal config
Toolkit::test(function (): void {
	$container = ContainerBuilder::of()
		->withCompiler(function (Compiler $compiler): void {
			$compiler->addExtension('foo', new FooExtension());
			$compiler->addConfig(Neonkit::load(<<<'NEON'
				foo:
					bars:
						default:
							factory: Contributte\Foo\Bar
			NEON
			));
		})->build();

	Assert::type(Bar::class, $container->getByType(Bar::class));
	Assert::count(1, $container->findByTag(FooExtension::BAR_TAG));
});

// Invalid config
Toolkit::test(function (): void {
	Assert::exception(function (): void {
		ContainerBuilder::of()
			->withCompiler(function (Compiler $compiler): void {
				$compiler->addExtension('foo', new FooExtension());
				$compiler->addConfig(Neonkit::load(<<<'NEON'
					foo:
						unknown: 1
				NEON
				));
			})->build();
	}, InvalidConfigurationException::class, "Unexpected item 'foo › unknown'.");
});
```

1. Header identical to `src` files; `namespace Tests\Cases\<Dir>;` mirrors the path (present in 63% of test files; the
   rest are global; be consistent inside a repository). `use` block alphabetical, then
   `require_once __DIR__ . '/../../bootstrap.php';` **after** the imports, then tests. Test files are phpcs-checked.
2. Each test is `Toolkit::test(function (): void { … });` preceded by a one-line `// Description` comment (74% of
   calls) and separated by a blank line. Closures are non-static in most repositories (1,371 non-static vs 323 static
   `Toolkit::test`; 254 vs 113 for `withCompiler`); bus, di, monolog and nella use `static` everywhere, doctrine-dbal
   only for the inner `withCompiler`. Copy the existing tests of the repository; never mix the two styles in one file.
   No test names, no docblocks, no `@testCase`.
   Shared setup inside one `.phpt` is a top-level named `function` (20 files in 11 repos: application, messenger,
   validator, mail, imap, image-storage, forms-multiplier, apitte, apitte-core, fio, nusoap), not a closure in a
   variable (1 file, redis). It is named `create<Thing>()` (17 of 40), `get<Thing>()`, `initialize<Thing>()`, typed,
   and placed after `require_once` and before the first `Toolkit::test()` (13 of 20; the rest put it at the end of the
   file). A helper needed by more than one file moves to `tests/Toolkit/` or `tests/Fixtures/` as a class.
3. Assertions: expected first. `Assert::same` / `Assert::equal` split by repository (`equal` for arrays and objects
   in doctrine/bus/middlewares, `same` in messenger/apitte/mail); `Assert::type(Foo::class, $x)` for services;
   `Assert::count`, `Assert::true`/`false`, `Assert::null`, `Assert::contains`;
   `Assert::exception(callable, Class::class, 'exact message')` (messages asserted verbatim; Nette Schema
   paths are joined with NBSP`›`NBSP — U+00A0 U+203A U+00A0, not plain spaces — so copy the message from a real
   failure or use a pattern `'Unexpected item %a%unknown%a%'`; `sprintf` or `~regex~` when parts vary); `Assert::true(true)` as "did not
   throw". Comments between asserts explain intent. Look up the repository's existing tests first: event-dispatcher
   and doctrine use `equal` for arrays of events and objects. In `equal` repos, `same` is still the choice for instance
   identity (`Assert::same($listener, $resolved)` doctrine-orm; `Assert::same($em->getRepository(…), …)`
   doctrine-extra-skeleton) and `equal` for scalars and arrays.
4. Containers are built with `ContainerBuilder::of()->withCompiler(fn)->build()` from `contributte/tester` and
   inline nowdoc NEON via `Neonkit::load(<<<'NEON' … NEON)`; the terminator `NEON` and the closing `));` go on separate
   lines (250 vs 40 glued `NEON));`, the glued form only in console and fileupload). NEON lists of maps: a bare `-` line
   with the keys nested one tab deeper, or `- key: value` with the first key inline; service references stay unquoted
   (`service: @foo`). A `// comment` goes above a `/** @var */` narrowing line, never between the two; messenger uses a per-repo `Tests\Toolkit\Container::of()
   ->withDefaults()->withCompiler(…)->build()` with `Helpers::neon()`. Legacy raw `ContainerLoader` + `FileMock`
   with numeric keys is not written anymore. Typical DI assertions: service type, laziness (`isCreated`), counts of
   `findByType`, tags, parameters, exact `InvalidConfigurationException` message.
5. Narrowing in tests uses `/** @var Foo $x */` above `$container->getByType()` (438 uses) rather than `assert()`.
6. Fixtures: `final class Dummy*` / `Fake*` / `Foo*` / `Simple*` / `Invalid*` with public properties, `// Nothing`
   or `// For tests` bodies, attributes as in real code; autoloaded via `autoload-dev` `"Tests\\": "tests"`.
   New fixtures copy the shape of the nearest sibling fixture (same property name and type, same recorded value).
   Fakes and Mockery are both common (95 test files mock with Mockery; fio and thepay also keep spies and stubs). Copy
   what the repository uses. With Mockery: `use Mockery;`, `Mockery::mock(Foo::class)` chained one expectation per line
   (`->once()->with(...)->andReturn(...)`), variables named after the role (`$dispatcher`, not `$mock`).
   `Mockery::close()` is what verifies `once()`/`times()`, so write it as the last statement of every test that sets a
   count expectation and nowhere else (gosms, mailing omit it when no count is set). To inspect an argument, use
   `->andReturnUsing(function (Foo $x): Bar { Assert::same(…); return …; })` so a failure names the field. A
   `withArgs` predicate stays single-line (mailing `MailBuilder.phpt:30`). `Assert::exception()` returns the
   exception; inspect its properties directly. In `TestCase` classes: `protected function tearDown(): void {
   Mockery::close(); }` (datagrid, menu-control, paginator-control: 5 of 5; paginator-control calls `parent::tearDown();`
   first). Skeleton suites use no Mockery; prefer a real in-memory EM (item 8) over mocking `EntityManagerInterface`.
7. `Toolkit::test()` closures are the default (1,657 calls in 489 files). openapi, apitte, psr7-http-message and
   datagrid write `Tester\TestCase` classes for plain unit tests too (138 files, `final` in about half):
   `class XTest extends TestCase`, `public function testX(): void`, `public function setUp(): void {
   parent::setUp(); }`, `/** @dataProvider provideCases */` + `public function provideCases(): iterable` (12 files),
   file ends with `(new XTest())->run();`; scenario data in `__files__/*.neon`. Files may be `.php` (`*Test.php`) or
   `.phpt`. Follow the repository.
   Skeletons: `E2E/Container/EntrypointTest` is the one boilerplate `TestCase` class (16 skeletons). Other tests are
   `Toolkit::test` (messenger-skeleton, webapp-skeleton `Unit/`), except doctrine-skeleton `Unit/`, which uses `TestCase`
   classes. Follow the directory.
8. Temp files go to `Environment::getTestDir()` from **`Contributte\Tester\Environment`**
   (`use Contributte\Tester\Environment;`, imported in all 86 test files that call it). It is `tests/tmp/<pid>`,
   created by `Environment::setup()` in `tests/bootstrap.php`. `Tester\Environment` (nette/tester) has no
   `getTestDir()`. In a global-namespace `.phpt` an unimported `Environment::` passes phpcs and fails only at runtime.
   `Environment::skip('MySQL is not running')` exists on both classes; import the Contributte one.
   DBAL/ORM E2E tests use in-memory SQLite (shape from doctrine-orm `tests/Cases/E2E/QueryTest.phpt`):

   ```php
   // Facade against in-memory SQLite
   Toolkit::test(function (): void {
   	$container = ContainerBuilder::of()
   		->withCompiler(function (Compiler $compiler): void {
   			$compiler->addExtension('nettrine.dbal', new DbalExtension());
   			$compiler->addExtension('nettrine.orm', new OrmExtension());
   			$compiler->addConfig(Neonkit::load(<<<'NEON'
   				nettrine.dbal:
   					connections:
   						default:
   							driver: pdo_sqlite
   							path: ":memory:"
   				nettrine.orm:
   					managers:
   						default:
   							connection: default
   							lazyNativeObjects: true
   							mapping:
   								App:
   									type: attributes
   									directories: [%appDir%/Domain]
   									namespace: App\Domain
   				services:
   					- App\Domain\Article\ArticlesFacade
   			NEON
   			));
   			$compiler->addConfig([
   				'parameters' => [
   					'tempDir' => Environment::getTestDir(),
   					'appDir' => Tests::APP_PATH,
   				],
   			]);
   		})
   		->build();

   	/** @var EntityManagerInterface $em */
   	$em = $container->getByType(EntityManagerInterface::class);
   	(new SchemaTool($em))->createSchema($em->getMetadataFactory()->getAllMetadata());

   	/** @var ArticlesFacade $facade */
   	$facade = $container->getByType(ArticlesFacade::class);
   	…
   });
   ```

   `lazyNativeObjects: true` is required on PHP 8.4 without symfony/var-exporter (otherwise "Symfony LazyGhost is not
   available"). Do not hand-build `Doctrine\ORM\Configuration` / `ORMSetup` (the latter needs symfony/cache). Skeleton
   `Bootstrap::boot()->addConfig()` cannot swap the connection to SQLite (merged `port`/`host` keys fail the pdo_sqlite
   schema), so build a dedicated container.
9. Tests for a feature: one happy-path test per supported config form and one exception test per `throw`; do not add
   config forms whose only tests prove they are rejected. `make tests` =
   `vendor/bin/tester -s -p php --colors 1 -C tests/Cases` (skeletons run `-C tests`: 17 of 18); coverage with
   `--coverage coverage.xml --coverage-src src`. `tests/.gitignore` ignores `*.expected`, `*.actual`, `/tmp`, `/*.log`,
   `/*.html`. No
   `tests/php.ini`.
10. PHPUnit appears only in `qa`, `aop`, `forms-bootstrap`, `codeception`: `class XTest extends TestCase`,
    `testX(): void`, static `self::assertSame()`, `#[DataProvider('provideX')]` + `public static function
    provideX(): Generator`.
11. Rendering a `Control` in a test without a presenter. `Control::getTemplate()` needs a `TemplateFactory`. Give it
    the real `Nette\Bridges\ApplicationLatte\TemplateFactory` backed by a trivial `LatteFactory` fixture
    (`forms-wizard/tests/Fixtures/DummyLatteFactory.php`, `ui/tests/Fixtures/FakeLatteFactory.php`), then capture
    output with `ob_start()` (`application/tests/Cases/UI/NullControl.phpt`, `ui/tests/Cases/Bundler/Vite.phpt`):

    ```php
    // tests/Fixtures/FakeLatteFactory.php
    final class FakeLatteFactory implements LatteFactory
    {

    	public function create(?Control $control = null): Engine
    	{
    		return new Engine();
    	}

    }

    // tests/Cases/<Feature>/<Feature>.phpt
    function renderControl(Control $control): string
    {
    	$control->setTemplateFactory(new TemplateFactory(new FakeLatteFactory()));

    	ob_start();
    	$control->render();

    	return (string) ob_get_clean();
    }
    ```

    Assert with `Assert::contains()` / `Assert::match()` on the HTML. Every assertion must be able to fail. Templates
    that use `n:href`/`{link}` need a presenter: build one as in `forms-wizard/tests/Fixtures/WizardPresenterFactory.php`
    (`injectPrimary(…, $templateFactory)`). Do not mock `Template` with Mockery to check only which variables were
    assigned (the older `paginator-control` / `datagrid` style); render real HTML. Custom-template fixtures are
    committed files under `tests/Fixtures/Files/`, not written at runtime.

### 2.15 Repository conventions

- **composer.json** (2-space JSON): key order `name, description, keywords, type, license, homepage, authors,
  require, require-dev, [conflict], [suggest], autoload, autoload-dev, minimum-stability, prefer-stable, config,
  extra`. `"license": "MIT"`, `"homepage": "https://github.com/contributte/<repo>"`, one author
  `{"name": "Milan Felix Šulc", "homepage": "https://f3l1x.io"}` (no email), `"php": ">=8.2"` (never a range),
  full three-part caret versions (`"nette/di": "^3.1.8"`); Contributte 0.x tooling as `"contributte/qa": "^0.4.0"`
  (42 repos; `^0.4` 23, `~0.4.0` 29 — messenger/bus switched to `~`), `"contributte/tester": "^0.4.0"`,
  `"contributte/phpstan": "^0.2.0"`,
  `"mockery/mockery": "^1.6.0"` when needed, `psr-4` only (`"Contributte\\Foo\\": "src"`, dev `"Tests\\": "tests"`),
  `"minimum-stability": "dev"`, `"prefer-stable": true`, `config.sort-packages` and
  `allow-plugins.dealerdirect/phpcodesniffer-composer-installer`, `extra.branch-alias.dev-master: "0.N.x-dev"`.
  No `scripts` (Makefile instead), no classmap. Doctrine packages are named `nettrine/*` with namespace
  `Nettrine\*`; apitte packages `apitte/*`.
- **Makefile** (tabs; `.PHONY:` above each target): `install` (`composer update`), `qa: phpstan cs`, `cs`, `csf`,
  `phpstan`, `tests`, `coverage`; CI branches on `ifdef GITHUB_ACTION` to pipe phpcs through `cs2pr`.
- **ruleset.xml** (tabs): `<!-- Rulesets -->`, `<!-- Rules -->`, `<!-- Excludes -->` comment headers; excludes
  `/tests/tmp`; local relaxations only via `<exclude name="…"/>`.
- **phpstan.neon** (tabs): as in 2.1; ignores written as `- message: '#^…$#'`, `count: 1`, `path: src/…` after a
  `# reason` comment.
- **.editorconfig**: `[*] charset = utf-8, end_of_line = lf, insert_final_newline = true,
  trim_trailing_whitespace = true, indent_style = tab, indent_size = tab, tab_width = 4`;
  `[{*.json,*.yml,*.yaml,*.md}] indent_style = space, indent_size = 2`.
- **.gitattributes**: `export-ignore` for `.docs`, `.editorconfig`, `.gitattributes`, `.gitignore`, `Makefile`,
  `README.md`, `phpstan.neon`, `ruleset.xml`, `tests` (single space, plain list). **.gitignore**: `# IDE /.idea`,
  `# Composer /vendor /composer.lock`, `# Tests /coverage.xml` (+ `/tests/tmp`, `/tests/**/*.actual|expected`).
- **LICENSE** file (no extension), MIT, `Copyright (c) <year> Contributte` (`Nettrine` in the doctrine-* repos).
- **README.md** is a fixed template: heatbadger banner, two `<p align=center>` rows of badgen badges (GitHub checks,
  codecov, packagist dm/v; php, license, gitter, forum, sponsor), the `Website 🚀 … | Contact 👨🏻‍💻 … | Twitter 🐦 …`
  line, `## Usage` (`composer require contributte/foo`), `## Documentation` ("For details on how to use this
  package, check out our [documentation](.docs)."), `## Versions` table `| State | Version | Branch | Nette | PHP |`
  with `dev` / `stable` rows (`` `^0.7` `` / `` `master` `` / `3.2+` / `` `>=8.2` ``), `## Development` ("See [how
  to contribute](https://contributte.org/contributing.html) to this package." + maintainer avatar), `-----`, and the
  support footer.
- **.docs/README.md**: `# Contributte <Name>`, one-sentence intro, `## Content` TOC of `##` sections, optionally with
  their `###` children indented (gosms, czech-post); a new `###` is added to the TOC only if its siblings are listed,
  `## Setup`
  (`composer require` in ```` ```bash ```` + `extensions:` registration in ```` ```neon ````), `## Configuration`
  (`### Minimal configuration`, `### Advanced configuration` = annotated NEON tree with `<type>` placeholders and
  `# optional` comments; one `### Option` subsection per option with a one-sentence intro, a ```` ```neon ```` block
  and optional `` - `key` - Description (default: `x`) `` bullets; a new option also extends the `**Default**` block),
  `## Usage`, `## Examples`; GitHub alerts `> [!NOTE]` / `> [!TIP]`; user-land PHP examples
  follow the `.docs` file being edited (see `final` in 2.4); client-method sections follow the Docs bullet in 2.12.1.
  `phpstan.neon` lists `.docs` under `paths` in 78 of 140 repos, but `fileExtensions` is `php` (90), `php, phpt` (21)
  or unset (29, which defaults to `php`), and no repository keeps `.php` files in `.docs`. **No tool checks Markdown
  fences**, and the `.docs` path is a no-op kept for symmetry. Keep PHP fences syntactically valid by hand. For a
  library without a DI extension (UI controls, Latte helpers), use per-feature sections `### <Feature>` under
  `## Usage` with "Register the factory" (NEON) / "Use in presenter" (PHP) / "Render in template" (Latte) /
  "Custom template" instead of `## Setup` + `## Configuration` (`ui/.docs/README.md`).
- **CI**: four thin callers in `.github/workflows/{tests,phpstan,codesniffer,coverage}.yml` (2-space YAML,
  double-quoted strings): `codesniffer.yml`/`phpstan.yml` call the same-named reusable workflows in
  `contributte/.github/.github/workflows/…@master` with `php:` = the repo's minimum (usually `"8.2"`), `tests.yml`
  calls `nette-tester.yml` with jobs `test85`, `test84`, `test83`, `test82`, `testlower` (`--prefer-lowest`),
  `coverage.yml` calls `nette-tester-coverage-v2.yml` with `secrets: inherit`; weekly Monday cron (`"0 8 * * 1"`,
  staggered per repo), `workflow_dispatch`. The reusable workflows run `make <target>`.
- **Versioning**: single `master` branch; tags `vMAJOR.MINOR.PATCH`; after a release, commit `Composer: open v0.N.x`
  bumping `branch-alias` and the README `dev`/`stable` rows. 0.x minor = BC break.
- **Commits**: `Area: imperative lowercase phrase`, no period, no body, no emoji, no conventional-commit type.
  Areas: `Composer`, `Tests`, `Readme`, `Docs`, `CI`, `QA`, `Makefile`, `DI`, `Refactor`, `Feature`, `Code`,
  `Extension`, `Phpstan`, `Codesniffer`, `Versions`, `AI`, or the class/feature name (`Bus:`, `Transports:`,
  `ManagerRegistry:`). Examples: `Composer: require PHP 8.2`, `Tests: cover more handlers usecases`, `DI: introduce
  passes (no more multiple extensions)`, `Readme: clarify autoconfiguration [#99]`, `Annotations: unlock
  doctrine/annotations v2 [closes #196]`, `Composer: open v0.3.x`, `AI: init`. Issue refs `[#N]` / `[closes #N]` at
  the end. Milan's own subjects follow this form about 75% of the time; bot and AI commits in the same repos
  (`Oh My Felix` with conventional `chore:`, `Contributte AI <ai@f3l1x.io>` with capitalised verbs) are less uniform
  and are not the model.
- **AGENTS.md** (messenger, qa; `CLAUDE.md` containing `@AGENTS.md`): sections Stack, Codebase, Architecture, Code
  Style, Testing, Conventions; "Always run `make cs phpstan tests` and fix all errors."

### 2.16 Do not (f3l1x)

- No `declare(strict_types=1)` without spaces; no `declare` on its own line; no closing tag.
- No `match`, enums, `readonly class`, `never`, `#[Override]`, typed constants, named arguments for ordinary data,
  first-class callable syntax as a habit.
- No `\Foo` for global classes by habit (phpcs allows it); no `\count()`; no `use function` as a habit; no `use Nette;`
  root import.
- No interpolated strings, no `printf`, no positional `%1$s`, no heredoc in practice, no numeric separators, no
  aligned `=>`.
- No `==`, `!=`, Yoda, `empty()`, `is_null()`, `else if`, `?:`, `list()`, `array()`, brace-less `if`, `$i += 1`,
  `static::CONST`, `get_class()`, `$x = …; return $x;`, two-way `if/else` that should be a ternary.
- No `//` comment glued above a member; no `#` or `/* */` comments; no `@author`, `@copyright`, `@package`, `@since`,
  `@version`, `@todo`; no `@return void`; no docblock repeating native types; no multi-line `@var` on properties;
  no `@throws` on ordinary methods; no baseline files.
- No `final` on Doctrine entities, skeleton DTOs, presenters, extensions/passes/services by default; no `Interface`/`Trait`
  suffix unless the repo opts out of the sniff; no `protected readonly`; no `readonly` on classic property
  declarations.
- No `assert()` for input validation; no `else` after `return`/`throw`; no blank line as first/last line of a body;
  no missing blank line before `return`.
- No test names/docblocks on `Toolkit::test`; no `tests/php.ini`; no committed `expected` outputs; no `$mock`
  variable names; no PHPUnit in libraries; no plain spaces around `›` in Nette Schema messages.
- No `Felixbot`, no trailers, no `Co-Authored-By`, no commit bodies, no `feat:`/`fix:` prefixes.

---

## 3. Dialect B — dg / Nette

Corpus. Built first from the 34 `nette/*` (with `latte/*`, `tracy/*`) repositories, then extended with dg's own code:
his 2026 tools `dg/dresscode` and `phpsyntax/phpsyntax` (~640 authored files, ~100k lines); his 2025–26 libraries
`dg/{ai-access, google-services, fio-mcp, pohoda-mcp, imap, bypass-finals, php-extensions-finder}`, the Adminer
plugins and `dg/dresscode-rules-{nette, deegee, symfony, laravel}` (149 library and 182 test files); his long-lived
libraries `dg/{dibi, texy, ftp-deployment, composer-cleaner, MySQL-dump, twitter-php, rss-php}` (227 PHP and 151
`.phpt` files); the agent skills and hook scripts of `nette/agent-plugins` (dg's prose for models plus 20 PHP files);
and `nette/latte-tools` (154 files, 143 of them a Twig port). `f3l1x/codestyler-site` (21 files, bot-committed) and
`f3l1x/forge` (173 files in six eras) were read for section 2 and 3.19. Below, "nette/* packages" means the framework
repositories, "dg's 2026 tools" DressCode and PhpSyntax, "dg's libraries" the personal repositories. Where they
disagree a rule names both with counts; write what the repository you are in does, and its `dresscode.neon`, when
present, decides.

### 3.1 Toolchain

- Nette Coding Standard: CI in 16 of 18 repositories runs the released `nette/coding-standard ^3` (`ecs`,
  php-cs-fixer + Slevomat, created with `composer create-project` into `temp/coding-standard`, `php
  temp/coding-standard/ecs check`) plus `nette/code-checker --strict-types` over `src` and `tests`; tester and
  command-line already run DressCode (`dresscode.neon` with `presets: [nette]`, which the unreleased
  `nette/coding-standard` 4.0-dev wraps). dg's newest personal repositories run a DressCode job instead of `ecs`
  (dresscode, fio-mcp, google-services, pohoda-mcp, bypass-finals, the `dresscode-rules-*` packages: `composer
  create-project dresscode/dresscode temp/dresscode dev-master`, then `php temp/dresscode/bin/dresscode check` on PHP
  8.4); dibi, texy, ftp-deployment, twitter-php, rss-php, ai-access and imap still run `ecs ^3`. Write code that passes
  DressCode's `nette` preset — it is the stricter superset — and run whichever tool the repository's workflow names.
  Also enforced and easy to trip: a closure whose body is a single `return expr;` must be `fn(...) => expr` (both
  tools); an unused catch variable is an error (`catch (\Throwable)`); `self::` for the class's own name; parentheses
  when `&&`/`||` are mixed (`explicitOperatorPrecedence`); `==` is reported unless its line carries `// intentionally
  ==` (`strictComparison`); an `@` is reported unless its line carries `// @ reason` (`noErrorSuppression`, in the
  current build); a chain link that returns a different object steps one indentation level deeper; with `php: 8.4`
  `(new Foo($x))->bar()` is rewritten to `new Foo($x)->bar()` (`uselessParenthesesAroundNew`), while the argument-less
  `(new Foo)->bar()` is accepted and is what dg writes (365 vs 30 `new Foo()->bar()` in his 2026 tools).
- Lineage: the standard "corresponds to PSR-12 Extended Coding Style with two main exceptions", tabs and PascalCase
  constants (`nette/agent-plugins` `plugins/nette-dev/docs/contributing/coding-standard.md`); the current `nette`
  preset is PER Coding Style plus the Nette layout (`src/Presets/Nette.php`). What this guide does not settle is
  PSR-12 / PER. `Nette\PhpGenerator\Printer` encodes it as defaults (tab, `$wrapLength = 120`, two blank lines
  between methods) except `$declareOnOpenTag = false`: set it to `true` when generating dialect B files.
- There is no `deegee` preset: the built-in presets are `perCs`, `psr12`, `nette` and `symfony`, and
  `dresscode-rules-deegee` is upgrade data for Dibi and Texy. Rule names here follow the current DressCode
  (camelCase: `orderedMembers`, `uselessElse`); earlier 2026 builds and some `dresscode.neon` files spell them
  kebab-case (`ordered-members`). Repositories add project rules on top of the preset (`groupImport: {minImports:
  2}`, the `optimizedCalls` group, `overrideAttributeRequired: keep`, `modernization`): read `dresscode.neon` first.
- The `nette` preset also enforces, beyond what this section names: `yoda: forbidden`, `notEqualsNotation`,
  `incrementForAddOne`, `symbolicLogicalOperators` (`and` → `&&`), `noShortBoolCasts` (`!!$x`), `combinedIssets`,
  `combinedUnsets`, `combinedAssignmentForRepeatedTarget`, `nullCoalescingForNullTernary`, `noIsNull`, `noSettype`,
  `noDirnameOfFile`, `noAliasFunctions`, `noConversionFunctions`, `noDeprecatedFunctions`, `noDirectInvokeCalls`,
  `noCallUserFunc`, `noGlobalStatements`, `noInnerFunctions`, `noAlternativeSyntax`, `noContinueInSwitch`,
  `noBacktickOperators`, `noHashComments`, `noImplicitBackslashes`, `complexStringVariable`,
  `noTrailingWhitespaceInString`, `noInvisibleCharacters`, `nativeNameCasing`, `getClassNotation` (`$x::class`),
  `kindInClassName`, `visibilityRequired {interfaceMethod: forbidden}`, `propertyPhpdocRequired` (a comment above a
  property is a `/** */`), `propertyPhpdocSingleline`, `promotedPropertyAnnotationPosition`, `forbiddenPhpdocLines`
  (`Constructor.`, `X getter.`), `annotationCasing`, `phpdocTypeNotation {arrayNotation: keep}` (both `T[]` and
  `array<T>` stay), `explicitAssertion` (`assert($x instanceof Y)`, not an inline `@var`), `uselessFunctionPhpdoc`,
  `uselessStringConcat`, `noManualEmptyStringTests`, `uselessSameNamespaceImport`, `unusedImports`, `strictCall`,
  `noDuplicateAssignments`, `noStaticThis`, `nowdocWithoutInterpolation`, `heredocIndentation`, `attributeAfterPhpdoc`,
  `neverForThrowingFunction`, `commaSpacing {alignment: tabs}`.
- It does **not** enforce, although this guide states them as dg's habits: a line length (there is no `lineLength`
  rule; 140 is only the width at which `multilineArray` (130), `multilineCondition` and `multilineSignature` break), a
  trailing comma after the last `match` arm (`trailingComma {matchArm: keep}`), `use function` imports
  (`importNotation` only merges them into one statement; the set comes from the project's `optimizedCalls` group),
  docblock layout (`@param` spacing, no blank line before tags), group use, `static fn`, `#[\Override]`, typed
  constants, `empty()`, `switch` where `match` fits, test file naming.
- PHPStan level 8 (never 9; dg's skill: "Levels higher than 8 are not worth pursuing"), no strict-rules package,
  `nette/phpstan-rules` for Nette-aware precision; `phpstan.neon` analyses `src` in nette/* (dg's 2026 tools add
  `tests` and `bin/` or `docs/reference`, fio-mcp `server.php`, ai-access `examples`), every `ignoreErrors` entry
  carries a `# reason` comment and an `identifier` (dibi and texy still have entries without a reason: legacy).
  Resolution ladder (`nette/agent-plugins` `phpstan-analysis` skill): refactor, then phpDoc, then `assert()`
  (sparingly), then a commented `ignoreErrors` entry, then the baseline (`includes: - phpstan-baseline.neon`, last
  resort, kept minimal); never `@phpstan-ignore`. One entry is one phenomenon (`identifier:` + `message:` + `count:`,
  which needs `path:`, not `paths:`); never suppress `phpDoc.parseError`, `argument.templateType` or anything under
  `tests/types/`; no `positive-int`/`non-empty-string`-style types. Judge the run by its exit code.
- `composer phpstan` = `phpstan analyse`, `composer tester` = `tester tests -s`. No Makefile.
- Tests are style-checked with the same standard as `src`.

### 3.2 File anatomy

Golden file:

```php
<?php declare(strict_types=1);

/**
 * This file is part of the Nette Framework (https://nette.org)
 * Copyright (c) 2004 David Grudl (https://davidgrudl.com)
 */

namespace Nette\Utils;

use Nette;
use function json_decode, json_encode, json_last_error, json_last_error_msg;
use const JSON_BIGINT_AS_STRING, JSON_PRETTY_PRINT, JSON_UNESCAPED_UNICODE;


/**
 * JSON encoder and decoder.
 */
final class Json
{
	use Nette\StaticClass;

	public const
		Pretty = 'pretty',
		ForceArray = 'forceArray';


	/**
	 * Converts value to JSON format.
	 * @throws JsonException
	 */
	public static function encode(mixed $value, bool $pretty = false, bool $asciiSafe = false): string
	{
		$flags = ($asciiSafe ? 0 : JSON_UNESCAPED_UNICODE) | ($pretty ? JSON_PRETTY_PRINT : 0);

		$json = json_encode($value, $flags);
		if ($error = json_last_error()) {
			throw new JsonException(json_last_error_msg(), $error);
		}

		return $json;
	}


	/**
	 * Parses JSON to PHP value.
	 * @throws JsonException
	 */
	public static function decode(string $json, bool $forceArrays = false): mixed
	{
		$value = json_decode($json, $forceArrays, 512, JSON_BIGINT_AS_STRING);
		if ($error = json_last_error()) {
			throw new JsonException(json_last_error_msg(), $error);
		}

		return $value;
	}
}
```

1. Line 1 is exactly `<?php declare(strict_types=1);` — one line, **no spaces** around `=`. The old three-line form
   (`<?php`, blank, docblock, `declare(...)` on its own line) survives only in discontinued packages and generated
   migrations; do not write it.
2. Framework packages carry the license docblock on lines 3–6 (text per project: `This file is part of the Nette
   Framework (https://nette.org)`, `… the Latte (https://latte.nette.org)`, `… the Tracy (https://tracy.nette.org)`,
   `… the Nette Tester.`; second line `Copyright (c) YEAR David Grudl (https://davidgrudl.com)`, YEAR being the
   project's birth year in every file). dg's 2026 tools carry it too, as `<Name>, <descriptor> (<url>)`: `This file
   is part of the PhpSyntax, a lossless syntax tree for PHP (https://phpsyntax.deegee.dev)` (155 of 158 `src` files,
   the rest generated) and `… the DressCode, a coding style and upgrade tool for PHP (https://dresscode.run)` (325 of
   327); so do ai-access (68 of 68), dibi (54 of 54) and texy (90 of 91). Applications, skeletons, mcp-inspector, xray,
   web-project, assets and dg's other 2025–26 libraries (imap, bypass-finals, google-services, fio-mcp, pohoda-mcp,
   `dresscode-rules-*`) have none, nor do tests, examples and generated data files. Copy the header of the repository
   you are in.
3. Blank lines: one between `declare` and the docblock, one before and after `namespace`, none inside the `use`
   block, **two** between the `use` block (or `namespace`) and the class docblock.
4. `use` block, in this order with no blank lines between kinds: class imports alphabetically (case-insensitive,
   `use Nette;` first because shortest), then **one** `use function a, b, c;` line (alphabetical, comma-separated,
   however long; 400-character lines are normal), then one `use const A, B;` line. Import with `use function` only
   the calls PHP compiles specially (`count`, `strlen`, `in_array`, `is_*`, `array_key_exists`, `sprintf`,
   `array_slice`, `ord`/`chr`, `defined`, `dirname`, `strval`); every other native call stays bare (`substr`,
   `preg_match`, `implode`, `array_map`, `strtolower`, `str_contains`, `array_any`). That is the set DressCode's
   `optimizedCalls` group imports (`nameFallback {optimizedFunction: qualified}`, set per project in `dresscode.neon`,
   not by the `nette` preset): DressCode imports 29 distinct functions and leaves 2,004 native calls bare, texy's whole
   `src` imports 10, fio-mcp imports none. nette/utils files list every function they call (the golden `Json` above
   imports `json_*`): in such a file add new calls to the existing line; never extend a file to every call. In the
   global namespace nothing is imported (`nette/agent-plugins` hooks: 0 of 17 files).
   Group use: nette/* writes one class per line (`use Foo\{A, B};` only where a repository already does it);
   DressCode, PhpSyntax and the `dresscode-rules-*` packages group two or more imports of one namespace (`use
   PhpSyntax\{Node, Token};`, a lone class `use PhpSyntax\Token;`; 823 group statements in 275 of 327 DressCode
   files, 0 namespaces with two single imports) through `groupImport: {minImports: 2}` in their `dresscode.neon`.
5. Global classes are **not** imported: write `\stdClass`, `\Closure`, `\Throwable`, `\LogicException`,
   `\ReflectionClass`, `\Generator`, `\DateTimeInterface` in code (582 vs about 40 imports: `use Attribute;` in
   attribute classes, `use Stringable;` throughout nette/forms — follow the package). Sibling packages are reached
   through the root import `use Nette;` and written `Nette\Utils\Strings::…`, `Nette\InvalidStateException` (99 of
   203 core files); partial imports `use Nette\DI;` → `new DI\Compiler` are common. 2026 tools import each class
   individually instead; both are accepted, follow the file. dg's libraries apply the same root import to their own
   package (`use Dibi;` in 30 of 54 dibi files, `use Texy;` 33 of 91, `use AIAccess;` 22). Aliases are rare and only
   shorten long namespaces (`use Nette\PhpGenerator as Php;`, `use Latte\Runtime as LR;`). Exceptions to `\Foo`: a
   namespaced CLI script imports its global classes (`phpsyntax/bin/phpsyntax:11-23`), a file without a namespace
   writes them bare, and composer-cleaner and twitter-php import `stdClass` (follow the file); google-services writes
   `#[\Attribute(\Attribute::TARGET_METHOD)]` without importing.
6. Global functions are bare (never `\count()`).
7. Several declarations per file are allowed for exception families (`src/<Pkg>/exceptions.php`), enums
   (`enums.php`), compatibility shims (`compatibility.php`, `compatibility-intf.php`) and namespaced functions
   (`functions.php`), each declaration separated by two blank lines (DressCode accepts one or two,
   `betweenDeclarations: [1, 2]`; ai-access's `exceptions.php` uses one); composer autoload is `classmap: ["src/"]`
   plus `psr-4`. dg's 2026 tools put each namespace's enums in its own `enums.php` and exceptions in its own
   `exceptions.php` (`src/Console/exceptions.php`, `src/Analyses/enums.php`); ftp-deployment and google-services keep
   one exception per file.
8. Tabs everywhere (PHP, Latte, NEON, PHTML; the agent skill adds JS, HTML, CSS). Markdown code samples use 4 spaces
   only in docs. Line length: no hard limit and no check (DressCode's 140 only decides where arrays, conditions and
   signatures break); 92% of lines are ≤ 80 in nette/* and dg's classic libraries, 83–85% in his 2026 code; long
   `throw` lines of 130–180 columns are normal; wrap chains and ternaries by feel at 100–120. Docblock and comment
   prose wraps at about 120 columns (1–3% of DressCode/PhpSyntax docblock lines exceed it).

### 3.3 Class layout

```php
/**
 * Paginating math.
 */
class Paginator
{
	public const
		Priority = 'priority',
		Expire = 'expire';

	#[\Deprecated('use Paginator::Priority')]
	public const PRIORITY = self::Priority;

	private int $page = 1;
	private int $itemsPerPage = 1;

	/** @var array<string, int>  service name => index */
	private array $index = [];


	public function __construct(
		private readonly Storage $storage,
		private readonly ?string $namespace = null,
	) {
	}


	/**
	 * Sets current page number.
	 */
	public function setPage(int $page): static
	{
		$this->page = $page;
		return $this;
	}


	private function checkRange(int $page): bool
	{
		return $page >= 1 && $page <= $this->getPageCount();
	}
}
```

1. Class `{` on its own line; **no blank line after it and none before the closing `}`** (0 of 955 types). Empty
   body is `{` newline `}`.
2. Member order (DressCode `orderedMembers`): trait `use` lines (then one blank line) → constants (public,
   protected, private) → properties (public, protected, private) → **two blank lines** → constructor → methods.
   Methods are **not** sorted by visibility. dg's rules for their order (`php-coding-standards` skill), earlier wins:
   keep methods on one subject together and never split such a group; general before special (a variant right after
   the plain form); a helper after the method that needs it, after the whole group when several do, or at the end.
   `getIterator()` last in iterable classes. When editing, leave existing methods where they are: reordering buries
   the real change in the diff.
3. **Exactly two blank lines between methods** (97.7%; one blank line only inside interfaces). Between constants
   or properties of one group: 0 blank lines; one blank line before a member that has a docblock or attribute, and
   between visibility groups.
4. Constants: a standalone or documented constant is its own `public const Name = …;` (190); a set of related
   values without per-item docs (status codes, flags) is one `public const` followed by one `Name = value,` per line,
   `;` after the last (65 groups: `public const\n\tAssocLeft = -1,\n\tAssocNone = 0;`); PascalCase names (`TrimCharacters`, `S404_NotFound`,
   `Token::Latte_TagOpen` with an underscore for category prefixes); UPPER_SNAKE survives only as deprecated aliases
   directly below (`#[\Deprecated('use Cache::Priority')] public const PRIORITY = self::Priority;`). Never typed
   constants, never `final const`.
5. Modifier order `final public function`, `public static function`, `abstract public function`. `final` on
   individual methods freezes invariants in extensible base classes (`final public function getRequest()`).
6. Interface methods carry **no `public`** and one blank line between them: 33 of 38 core interfaces, 26 of 26
   methods in ai-access, all of PhpSyntax's; dg's standard states it as a rule ("The visibility of methods is not
   specified for interfaces because they are always public", `coding-standard.md`; repeated in `php-coding-standards`)
   and the current `nette` preset reports it (`visibilityRequired {interfaceMethod: forbidden}`). DressCode's own
   interfaces still write `public function` (`src/Reporter.php`): drop it when the file is next touched.
7. Section banners in long classes (≥ 400 lines in nette/*; dibi puts them in classes from ~100 lines, pohoda-mcp
   in its 640-line files, texy in its 600+ line renderers), lowercase, with dg's signature, two blank lines before and
   after:

   ```php
	/********************* interface IPresenter ****************d*g**/
   ```

8. Properties are typed, defaults inline, `public` for configuration and DTO/AST data (`public ?string $directory =
   null;`, `Debugger::$maxDepth`, Latte nodes), `private` for state, `protected` only on explicit extension points.
   No `SmartObject` in new classes (11 of 261 files, all old magic-property classes); dg's `nette-utils` skill
   says "For new code prefer PHP 8.4 property hooks". Measured use of the PHP 8.4 property features: 0 in nette/* and
   in dg's libraries (even the four packages requiring PHP 8.4); heavy in PhpSyntax's parser nodes (80 hand-written
   `get =>` hooks such as `public string $text { get => Printer::printText($this); }`, 510 generated `set =>` hooks,
   interface properties `public ?Token $openParen { get; }`, 4 asymmetric `public private(set)` /
   `public protected(set)`). Write a hook where a read computes or a write has a consequence, otherwise a plain
   typed property. `use Nette\StaticClass;` as the first line of a static utility class (packages depending on
   nette/utils).

### 3.4 Declarations and naming

- **`final`**: ~38% of classes overall, varying by package (schema, neon, command-line, mcp-inspector, php-generator
  ≥ 75%; mail, http, caching, security, tester, assets ≤ 30%). New internal classes, value objects, responses,
  attributes, helpers and most DI extensions (11 of 18) are `final`; follow the package for the rest. Public building
  blocks meant to be
  extended stay open: `Presenter`, `Control`, `Component`, `Form`, `Route`, `Engine`, `Logger`, `Debugger`,
  `Assert`, `TestCase`, `Strings`, `Arrays`, `Container`, `Compiler`, every Latte tag/expression node. dg's 2026 tools
  make every concrete class `final` (PhpSyntax 140 of 148, DressCode 311 of 318; open are abstract bases documented as
  the extension point and the exceptions callers extend), his 2025–26 libraries 72% (ai-access 83%, `dresscode-rules-*`
  10 of 10; open: exceptions, MCP tool classes, mutable DTOs), his classic libraries much less (dibi 2 of 60,
  ftp-deployment 0 of 17, texy 37 of 90). The ~38% describes nette/* only; in a new tool make concrete classes
  `final`.
- **No kind in the name** (enforced by the standard): no `I` prefix, no `Abstract` prefix, no `Interface`/`Trait`
  suffix. Interfaces are capability nouns/adjectives: `Response`, `Renderable`, `Authenticator`, `Storage`,
  `Mailer`, `Router`, `Loader`, `Policy`, `Schema`, `Adapter`, `HtmlStringable`. Implementations use a concrete
  adjective: `SessionStorage`, `SimpleAuthenticator`, `FileStorage`, `SendmailMailer`. Abstract classes are plain
  nouns (`Definition`, `Node`, `Component`, `CompilerExtension`). Traits: `StaticClass`, `SmartObject`,
  `TagParserData`, `*Aware` (`NameAware`, `CommentAware`). Kept deliberately with `I`: `IPresenter`,
  `IPresenterFactory`, `IRequest`, `IResponse`, `IIdentity`, `IComponent`, `IContainer`, `IBarPanel`, `ILogger`;
  reference them as they are. dg's libraries accept `Base` on an `@internal` shared abstract (`BaseChat` in ai-access),
  never `Abstract`. Class names are nouns or noun phrases carrying specificity and generality (`ArrayIterator`); PHP
  attributes are exempt (`php-coding-standards`). An interface or base class sits one namespace above its
  implementations (`Foo\Network` next to `Foo\Networks\*`), not inside it.
- Renames keep BC with `interface_exists(IOld::class);` two blank lines after the new interface and a
  `compatibility-intf.php` block: `if (false) { /** @deprecated use X */ interface IOld extends New {} } elseif
  (!interface_exists(IOld::class)) { class_alias(New::class, IOld::class); }`.
- `@internal` marks "public for technical reasons": `/** @internal */` above `final class Helpers`, or as the last
  tag of a method docblock. Never `#[Internal]`.
- Enums: nette/* packages: rare (15 in 779 files), string-backed for wire values (`enum SameSite: string`), pure for
  flags, may live in `enums.php`; a fixed set is otherwise a constant group in a final class (`ContentType`, `Token`
  types). dg's 2026 tools: the default form of a closed set (18 enums against 6 constant groups), pure for states and
  choices (`Tristate::Yes/No/Maybe`, `Stage`, `Space`), `string`-backed only where configuration or the wire spells
  the value (`enum Group: string`); all in one `enums.php` per namespace with the license docblock, two blank lines
  between enums, a sentence docblock per enum and a lowercase fragment per case where the name is not enough. In
  both, PascalCase cases (keyword-like names are fine: `SymbolKind::Function`, `Default`), and an enum may carry a few
  small methods derived from `$this` (3 of 18 in the 2026 tools: `Risk::describeRefused()` with `match ($this)`; texy
  `ListType::isOrdered()`; google-services `AccessLevel::includes()`). A wire enum in an API client gets a catch-all
  case (`FinishReason::Unknown`). `final readonly class` for immutable value objects in nette/* (`Type`, `Token`,
  `Position`, `IPAddress`) and DressCode (29); dg's libraries write `final class` with `public readonly` promoted
  properties instead (0 `readonly class`).
- Static utility classes are named plural: `Helpers`, `PhpHelpers`, `NodeHelpers`, `HtmlHelpers`, `Filters`,
  `Passes`, `Tasks`, `Validators`, `Strings`, `Arrays`, `Callback`, `Json` (with `use Nette\StaticClass;` or a
  `final public function __construct() { throw new \LogicException; }` guard). Packages without nette/utils write
  `final class Helpers` with public static methods and no guard (DressCode, PhpSyntax, `NodeHelpers` in texy).
- Abbreviations: two letters uppercase (`IO`, `DI`, `IP`, `OK`: `IOException`, `DIExtension`, `IPAddress`), three or
  more PascalCase/camelCase (`Json`, `Html`, `Url`, `Http`, `getHtml()`).
- Methods camelCase; `get`/`set`/`is`/`has`/`add`/`remove`/`create`/`parse`/`print`/`render`/`format`/`validate`/
  `resolve`/`generate`/`find`/`fetch`/`try*`/`with*`. `try*` returns `null` instead of throwing (`tryPeek`,
  `tryConsume`, `tryGetAsset`). Booleans `isX()`/`hasX()`. Toggles take `bool $state = true`
  (`setVariadic(bool $state = true)`, `required(bool $state = true)`). DSL-style fluent methods without `set`
  prefix in Schema/DI (`->default()`, `->required()`, `->castTo()`, `->tag()`, `->lazy()`). Internal DI hook methods
  prefixed `do` (`doRegisterExcludedClasses`). Static constructors: `from()`, `fromString()`, `fromReflection()`,
  `fromParts()`, `create()`, `parse()`, `el()`; never `of()`. dg's rules for agents (`php-coding-standards`): a
  method is an action, never a bare noun (`getProvider()`, not `provider()`); exceptions are static factories
  (`fromFile()`), conversions (`toArray()`), interface methods (`jsonSerialize()`) and domain-echoing fluent APIs.
  Boolean queries are `is*`/`has*`/`can*`; a boolean property is named by the state (`$active`), never `$isActive`.
  The 2026 tools add: `get*` returns what belongs to the object (may be `null`), `find*` searches and returns `null`
  for not found, `check*` returns `void` and throws, never answers; `try*` is rare there (1 in DressCode); immutable
  data has no `set*`.
- Identifiers, comments and messages are English, whatever language the conversation is in (`php-coding-standards`);
  declared names (classes, methods, properties, parameters) avoid abbreviations "unless the full name is too long".
  Local variables in nette/* are short and idiomatic: `$res`, `$tmp`, `$s`, `$m` (regex matches), `$e`,
  `$rc`/`$rm`/`$rp` (reflection), `$dolly` (the clone in `with*()`), `$def`, `$pos`, `$k => $v`, `$i`. dg's 2026
  tools spell them out (`$result`, `$expression`, `$parameter`, `$openParen`; `$res`, `$tmp`, `$s`, `$rc`, `$def`,
  `$dolly` 0 each) and keep only `$i`, `$m`, `$e`, `$k`/`$v`, `$stmts`, `$args`: follow the file.
- Events are public arrays `onXxx` documented `/** @var array<callable(static): void>  Occurs when … */`.
- Namespaces mirror directories under `src/`: `Nette\Utils`, `Nette\DI\{Compiler,Config,Definitions,Extensions}`,
  integration code in `Nette\Bridges\<Package><Target>` (`ApplicationDI`, `FormsLatte`, `HttpTracy`, `SecurityHttp`,
  `DIPsr`); Latte AST in `Latte\Compiler\Nodes\{Php\Expression,Php\Scalar,Html}` and tags in `Latte\Essential\Nodes`.

### 3.5 Properties, constructors, promotion

```php
	public function __construct(
		private readonly IPresenterFactory $presenterFactory,
		private readonly Router $router,
		/** @var array<string, mixed> */
		private readonly array $defaults = [],
	) {
	}


	public static function fromReflection(
		\ReflectionFunctionAbstract|\ReflectionParameter|\ReflectionProperty $reflection,
	): ?self
	{
```

1. Services with dependencies use promoted `private readonly` parameters (66% of constructors, ~100% in rewritten
   code); `protected readonly` where subclasses need them; `public` (mutable) for AST nodes and command objects;
   `public readonly` for value objects. A promoted list is **always multi-line** with a trailing comma, even for
   one parameter, and the constructor closes `) {` on the same line; the empty body is `{` newline `}`.
2. A multi-line constructor without promotion closes `) {` as well (ftp-deployment, twitter-php). Every other
   multi-line signature ends `): Type` on its own line and puts `{` on the next line. Single-line
   signatures (≤ ~117 columns) keep `{` on the next line too. `#[\SensitiveParameter]` on its own line before the
   parameter forces the multi-line form.
3. Classic assignment constructors remain in classes with initialisation logic (`Cache`, `Selection`, `Route`,
   `Bootstrap`, Tracy `Value`).
4. Docblocks on promoted parameters go inline above the parameter (`/** @var list<Message> */` or a one-line
   description), never as `@param` on the constructor.
5. Configuration that callers tweak is a public property with a default, set directly (`$logger->directory = …`),
   not a constructor argument.
6. The base `Presenter`/`Control` have no constructor (removed in 2023 for exactly this reason), so an application
   presenter receives its dependencies through its own constructor with promoted parameters
   (`public function __construct(private ArticleFacade $facade,) {}`, as in the Nette manual); `inject*()` methods
   or `#[Inject]` properties are for abstract base presenters that must leave the constructor free.
   `injectPrimary()` is internal to nette/application.

### 3.6 Types

- Everything is typed; `mixed` is used freely (`mixed $value`, `: mixed`); untyped only where a contract forbids
  (`offsetSet($index, $value)`, `__call`).
- Nullable: `?T` for one type (never `T|null` for a single type: 0 hits); `A|B|null` with `null` **last** for
  unions (`string|Stringable|null $label = null`, `string|int|\DateTimeInterface|null`); `false` also last
  (`static|false`). Defaults `?T $x = null`; implicit nullable never.
- Return types always, including `: void` (magic `__clone`/`__destruct` carry none); **fluent setters and withers
  return `static`** in nette/* (`: static` 526 vs `: self` 77); `: self` only for named constructors on
  final/readonly value objects; `: never` for methods that always throw or exit (`terminate()`, `redirectUrl()`,
  `error()`, `throwUnexpectedException()`). dg's 2026 tools and libraries: a chaining setter returns `static`
  (`Token::setText(): static`), a `with*()` of a final immutable class returns `self` (`Style::withIndent(): self`),
  as do named constructors (27 `static function … : self`, 0 `: static` in DressCode) and own-type navigation
  (`getNext(): ?self`).
- Immutable objects: `with*()` cloning into `$dolly` in nette/* (`$dolly = clone $this; $dolly->url = $url; return
  $dolly;`; `$dolly` 0 times in dg's personal code, which clones into `$clone`); mutable counterparts have setters.
- Named arguments label flag literals: `in_array($x, $list, strict: true)`, `getComponent($name, throw: false)`,
  `microtime(as_float: true)`, `class_exists($c, autoload: false)`, `var_export($x, return: true)`, `previous: $e`;
  not when the method name says it already (`setReadonly(true)`, `php-coding-standards`). They also skip optional
  parameters in front (`limit: 2`, `offset: $offset`, `range: $node->range` in texy; `report($token, $message,
  trivia: $comment, fixable: false)` in DressCode, where 78% of 615 named arguments are not booleans) and carry the
  values of constructors with several optional or same-typed parameters (`new Usage(inputTokens: …, outputTokens:
  …)`, `new Config(presets: [...], rules: $rules)`); ai-access prefers typed named parameters to option arrays
  (`setOptions(?int $maxOutputTokens = null, ?float $temperature = null): static`). Required leading arguments stay
  positional; a call with one obvious argument is never named. Attribute arguments beyond the first are always
  named.
- First-class callables `foo(...)` are preferred over `[$this, 'foo']`: `'n:href' => LinkNode::create(...)`,
  `$this->factory = $factory(...)`, `array_map(strval(...), $x)`.
- Conditional return docs for `bool $throw` parameters: `@return ($throw is true ? T : ?T)`.
- Regex delimiters `#…#` (or `~…~`), `D` modifier when anchoring with `$`, `x` mode with inline `#` comments for
  long patterns; native `preg_*` in libraries (`Nette\Utils\Strings::match` is for user code).
- Attributes: `#[\Deprecated('use X')]` (PHP 8.4, used unguarded in nette/*; dg's personal code has none: his 2026
  tools have deprecated nothing yet, bypass-finals, supporting PHP < 8.4, writes `@deprecated use X`),
  `#[Attribute(Attribute::TARGET_METHOD)]` with `use Attribute;` imported in attribute classes, `#[Requires(methods:
  'POST')]`, `#[Persistent]`, `#[Language('SQL')]` on parameters, `#[\SensitiveParameter]`,
  `#[\AllowDynamicProperties]`; `#[\Override]` never (0 everywhere; repositories that enable DressCode's `modernization`
  group switch it off with `overrideAttributeRequired: keep`). Project attributes read by a registry go between the
  docblock and the class, one argument per line with a trailing comma once they do not fit (`#[RuleInfo(` /
  `'dresscode/arraySpacing',` / `Stage::Formatting,` / `description: '…',` / `)]`).

### 3.7 Docblocks and comments

```php
	/**
	 * Returns item from array. If it does not exist, it throws an exception, unless a default value is set.
	 * @template T
	 * @param  array<T>  $array
	 * @param  array-key|array-key[]  $key
	 * @param  ?T  $default
	 * @return ?T
	 * @throws Nette\InvalidArgumentException if item does not exist and default value is not provided
	 */
	public static function get(array $array, string|int|array $key, mixed $default = null): mixed
```

1. **Every library class has a docblock** (application classes in web-project carry none unless the name is not
   self-explanatory): one sentence, third person, present tense, ends with a period (`JSON encoder and decoder.`,
   `Token produced by lexers.`, `Failed to send the email.` for exceptions); for Latte tags the docblock shows the
   tag syntax. When `@property*`/`@method` tags follow, one blank ` *` line separates them from the description
   (official standard; 39 vs 9); `@internal`, `@deprecated`, `@template`, `@implements` follow the description
   directly. Tag order: `@property*`, `@method`,
   `@template`, `@extends`/`@implements`, `@internal`/`@deprecated`. Usage examples in `<code>` blocks, never
   fences. A class docblock does not repeat the method list or implementation details, and never opens "Class that …"
   (`php-doc` skill). dg's 2026 tools differ: 99% of declarations documented, the first sentence says what the class
   is and further sentences give the contract, invariant or what it deliberately does not do (61% of DressCode class
   docblocks have several sentences, 70 run six lines or more); docblocks are Markdown, every call, variable, keyword
   and literal in backticks, `<code>` 0 times; `@method`/`@property` tags follow the description directly (38 of 38 in
   PhpSyntax). Follow the file.
2. ~60% of public methods have a docblock: a one-line summary starting with a verb (`Returns`, `Adds`, `Checks`,
   `Creates`, `Sets`, `Converts`, `Removes`, `Finds`, `Parses`), ending with a period; trivial getters, `print()`,
   `getIterator()`, `__construct` and overrides usually have none. **No blank line between the description and the
   tags.** Tag order: `@template`, `@param`, `@return`, `@throws`, then `@internal`/`@deprecated`. dg's `php-doc`
   skill adds: skip the docblock when the signature says it all ("getters, setters, simple delegations"; old setters
   such as `Paginator::setPage()` keep their `Sets …` line, a new setter is documented only for what the signature
   does not say); American English (`color`, `behavior`); stock phrases `Returns X, or null if …`, `Checks whether …`,
   `Converts X to Y.`, `Finds …`, `Parses …`; a predicate states the condition it tests, never "Returns true when …".
   dg's 2026 tools open half their method docblocks with a noun phrase or `Whether …` (`Whether the token is the first
   on its line.`; 66% in DressCode) and document non-obvious private helpers too (44% of DressCode's private methods).
3. `@param` uses **two spaces** after the tag and two spaces between type and name (`@param  string[]  $options`),
   an optional description after two more spaces (81%; routing/tester/mcp-inspector partly use one space); every
   other tag uses one space (`@return`, `@throws`, `@var`, `@deprecated`); a description after the type of `@return`
   or `@var` follows two spaces (`@return string[]  language codes`, `php-doc`). dg's 2026 tools write
   `@throws X  description` with two spaces too (25 of 26) and a one-line `/** @param T $x */` with one. Only
   `@param`/`@return` that add information (arrays, generics, callables, shapes, conditional types); a docblock
   repeating the native type is never written, but a `@param` that needs a description repeats the scalar type so the
   description keeps its column (`@param  string  $as  column alias`, 24 lines in dibi, texy, ftp-deployment).
4. Property docblocks are one line: `/** @var array<string, int>  service name => index */` (description after two
   spaces), or a plain description `/** minute in seconds */`. Constants may carry a one-line description docblock.
   In DressCode a docblock on a property, constant, case or promoted parameter is a lowercase fragment without a
   period (129 of 131); PhpSyntax documents public properties as sentences. Follow the file.
5. Type notation: `list<T>` for lists, `array<K, V>` for maps, `T[]` in older code (both kept, also by the preset),
   `array{file: string, line: int}` shapes, `callable(Node): bool`, `\Closure(mixed): mixed`, `class-string<T>`,
   `literal-string`, `int<0, max>`, `array-key`; `?T` in docs for single nullable, `X|Y|null` for unions. dg's
   `phpstan-analysis` skill teaches `T[]` for simple element types ("shortest notation"), `array<A|B>` for union
   elements, `list<T>`/`array<K, T>` when keys matter; the measured newer code leans to `list<T>`: both pass, follow
   the file. `list<T>` fits a `@return` that always has keys 0..n-1; for a `@param` it is too strict unless the body
   reads `$arr[0]` (`php-doc`).
6. `@throws Nette\IOException if the file cannot be read` documents public contracts (interfaces, public API),
   description lowercase after one space. `@deprecated use X` (lowercase "use", no period; 91 vs 28 `Use`). `@internal` on helpers.
   `@phpstan-*` tags: essentially never (2 `@phpstan-type` in the whole framework; dg's 2026 tools write
   `@phpstan-assert-if-true` on a boolean query whose truth fills a nullable property, 8 times); `@inheritDoc`: never;
   `@author`/`@package`/`@since`: never (forbidden).
7. Line comments: `//` only, **lowercase start, no trailing period**, terse, explaining why: `// removes xD800-xDFFF,
   x110000 and higher`, `// back compatibility`, `// intentionally ==`. Trailing comments after code are normal
   (`$name = '0' . $i; // prevents converting to integer in array key`). Every `@` suppression carries a same-line
   reason: `@mkdir($dir); // @ - directory may already exist`, `@fopen(...); // @ is escalated to exception`.
   Phase comments in lifecycle code are UPPERCASE (`// STARTUP`, `// SIGNAL HANDLING`). Fall-through in `switch`
   is marked `// break omitted`. Commented-out code has no space (`//$this->configurator->setDebugMode(...)`).
   The `@` reason is now checked: DressCode's `noErrorSuppression` accepts only a same-line comment starting `// @`
   (dibi's `// intentionally @` does not count), and `strictComparison` accepts `// intentionally ==` (dg's standard
   page words it `// == to accept null`). A comment never cites a bug, issue or PR ("fixes #123", "workaround for bug
   X"); it states a general reason (`php-coding-standards`). A deliberate departure from a DressCode rule is `//
   dresscode:ignore <rule> -- <reason>` on its own line (7 in the 2026 tools: `// dresscode:ignore
   arrayFunctionForForeach -- a loop is faster than array_any() on this hot path`); PHPStan inline ignores stay
   forbidden. Library code keeps comments lowercase; texy (46% uppercase), ftp-deployment and the agent-plugins hook
   scripts write sentence-case rationale comments, some with a period: follow the file.

### 3.8 Control flow and expressions

```php
		if (!$this->directory) {
			throw new \LogicException('Logging directory is not specified.');
		} elseif (!is_dir($this->directory)) {
			throw new \RuntimeException("Logging directory '$this->directory' is not found or is not directory.");
		}

		$json = json_encode($value, $flags);
		if ($error = json_last_error()) {
			throw new JsonException(json_last_error_msg(), $error);
		}

		return $this->name instanceof ExpressionNode
			? '${' . $this->name->print($context) . '}'
			: '$' . $this->name;
```

1. Braces always; `elseif` (never `else if`); `else`/`elseif` after `return`/`throw` is **kept** (DressCode
   `uselessElse: keep`): validation ladders are `if … throw; elseif … throw;`. Early `return`/`continue` guards
   coexist. When any branch of an `if`/`elseif`/`else` or `try`/`catch` chain is split into paragraphs by a blank
   line, nette/* puts one blank line before **every** closing `}` of that chain (DressCode `betweenBranches:
   paragraphed` in the build measured here; 525 such lines in `src`, 353 added by dg since mid-2025); otherwise no
   blank line. The same applies to `switch` cases (`betweenCases: paragraphed`). The current `nette` preset narrows the
   requirement to `lastSetApart`: a blank line before the `}` of a branch whose last statement is itself set apart by
   a blank line (typically `return`/`throw` after a paragraph), other branches as they are; the paragraphed form passes
   it too. dg's `ecs` libraries follow neither (dibi, texy, ftp-deployment: 0 of 59 such chains; at most a blank before
   `} elseif`/`} else` after a `return`). Write what the repository's DressCode asks; in nette/* default to the
   paragraphed form; in an `ecs` repository do not reformat existing chains.
2. Blank lines inside methods: after a closing `}` of a block before the next statement (87%); **no blank line
   before `return` after a plain statement** (`$x = …;` directly followed by `return $x;` in 95%); blank line
   before `return` after a block (85% in nette/*, dibi 105 of 105, `dresscode-rules-*` 14 of 14; but ftp-deployment 1 of
   18, google-services 4 of 55: not enforced, follow the file); none after `{` or before `}`; none between `match`
   arms.
3. Assignment inside conditions is idiomatic: `if ($error = json_last_error())`, `while ($token = $this->next())`,
   `elseif ($prop = …)`.
4. Strict comparisons; `==` only with `// intentionally ==`; `!$x instanceof Y` without parentheses; `isset()` and
   `??` over `array_key_exists()`; `is_array($response['data'] ?? null)` over `isset(…) && is_array(…)`; `empty()`
   sparingly (dibi, texy keep more); `in_array(..., strict: true)`; never Yoda, never `is_null`. `str_starts_with()`,
   `str_ends_with()`, `str_contains()` replace the retired `Strings::startsWith()`/`endsWith()`/`contains()`;
   `array_any()`/`array_find()`/`array_all()` replace a searching `foreach` in PHP 8.4 code (131 calls in the 2026
   tools; a profiled hot loop stays, marked with `// dresscode:ignore arrayFunctionForForeach -- …`).
5. `??`, `??=` (`$this->engine ??= $this->createEngine();`), `?->`, short ternary `?:` (allowed and used),
   `?? throw new Nette\InvalidStateException('Request is not set.')` for nullable getters,
   `?: throw`, `default => throw` in `match`, `fn() => throw …`. Short-circuit statements as control flow:
   `$item['nullable'] && $schema->nullable();`.
6. `match` is used freely (205), including `match (true) { is_int($x) => …, default => … }` for type dispatch with
   trailing comma; `switch` almost never (8).
7. Multi-line conditions, ternaries, concatenations and chains put the **operator at the start of the continuation
   line**, indented one tab from the statement; `) {` closes on its own line:

   ```php
		if (
			$expr instanceof AssignNode
			&& $expr->var instanceof VariableNode
			&& is_string($expr->var->name)
		) {
   ```

8. Closures: a closure whose body is a single `return expr;` **must** be an arrow function `fn($x) => expr`
   (enforced by both `ecs` and DressCode; `fn(` with no space, also enforced); `function (int $x) use ($y): bool {`
   (space after `function`) only for closures with statements, by-reference `use (&$x)` or `void` side effects.
   `static fn`/`static function`: not in nette/* (7 in the whole framework), DressCode, PhpSyntax (0, although 1,955 of
   their closures do not use `$this`), ai-access, pohoda-mcp or the rule packages; texy uses it for a returned or
   stored closure (4); fio-mcp and google-services make every closure that does not touch `$this` `static` (24 of 24).
   No preset enforces it (`staticClosure` is outside them): in nette/* do not add it, elsewhere follow the file.
   Closure parameters are often untyped in short callbacks.
9. Casts with a space `(string) $x`, `(int)` not `intval()`; `!$x` without space; `new Foo` **without parentheses**
   when there are no arguments (`new static`, `(new NodeTraverser)->traverse(...)`, `throw new
   Nette\ShouldNotHappenException;`, also as a parameter default: `Http\Client $http = new Http\CurlClient`); `new
   class ($x) extends Foo {` with a space after `class`. Chaining on a fresh object: `(new Foo)->bar()` without
   arguments (365 in the 2026 tools; dg's libraries wrap all 375 of theirs, most below PHP 8.4); with arguments the
   PHP 8.4 form `new Foo($x)->bar()` (68 in the 2026 tools; DressCode rewrites `(new Foo($x))->bar()` at `php: 8.4`);
   `new Foo()->bar()` with empty parentheses appears mostly in readme and examples (30). Below PHP 8.4 keep `(new
   Foo($x))->bar()`.
10. Destructuring `[$a, $b] = …`, `foreach ($x as [$k, $v])`; by-reference APIs where PHP needs them
    (`&getIterator()`, `foreach ($items as &$item)`); `static $fn;` function-local statics for lazy state;
    `false && yield;` for an empty generator; `(function (Node ...$args) {})(...$items);` to type-check array items.
    Narrow a type with `assert($x instanceof Y)`, not an inline `/** @var Y $x */` (`explicitAssertion`; 67 in
    DressCode `src`); inline `@var` stays for generic and array-shape types.
11. `try`/`catch (\Throwable $e)` (never `\Exception`), `catch (\ReflectionException)` without variable when
    unused, `try { … } catch (\Throwable $e) { cleanup; throw $e; }`, `try`/`finally` for locks; an intentionally
    empty catch omits the variable: `catch (\Throwable) {` newline `}` (DressCode reports an unused `$e`).
12. PHP-version and extension gates: `PHP_VERSION_ID >= 80400`, `extension_loaded('iconv')`,
    `function_exists('ini_set')`, throwing `Nette\NotSupportedException(__METHOD__ . '() requires ICONV extension
    that is not loaded.')`.
13. Deprecation: `#[\Deprecated('use setHtmlType()')]` + `trigger_error(__METHOD__ . '() was renamed to
    setHtmlType()', E_USER_DEPRECATED);` + delegate; removed behaviour throws `Nette\DeprecatedException`;
    moved classes get `class_alias(New::class, Old::class);` after the class.

### 3.9 Strings, arrays, formatting

1. Single quotes by default; double quotes for interpolation, escapes and apostrophes. **Interpolation is the
   normal way to build messages**, unbraced: `"Unable to read file '$file'."`, `"Component '$this->name' is not
   attached."`, `"$error[message] in $error[file]"`; braces only for calls and deep access
   (`"{$this->getName()}"`). `sprintf("… '%s' …", expr)` — format in double quotes so the single-quoted identifier
   needs no escaping — when an argument is a call or expression, for number formats, and throughout nette/di whose
   messages are sprintf-based (107 vs 10 interpolated; 152 `throw new X(sprintf(` in the framework). Follow the
   package. dg's personal code interpolates even more (libraries 76 interpolated vs 7 `sprintf` throws, DressCode 115
   vs 3). Concatenation
   ` . ` with spaces, `.` leading continuation lines.
2. Multi-line text is nowdoc `<<<'XX'` (dg's delimiter), indented, closing marker at code level and immediately
   followed by `,` or `;` when it is an argument. Text for humans or models gets `<<<'TEXT'` (MCP instructions, CLI
   help in `phpsyntax/bin/phpsyntax`).
3. Arrays `[]`; one item per line when the array does not fit in ~130 columns, otherwise inline; **trailing comma in
   every multi-line array, argument list, parameter list and `match`** (~100%; 281 of 281 multi-line `match` in the
   2026 tools; the preset requires it for arrays, arguments and parameters only, `match` is habit), never in a one-line
   list; no `=>` alignment (only trailing
   `//` comments in lookup tables are column-aligned); "tables" of short strings may pack several items per line.
4. Numeric literals with separators from 7 digits (`1_000_000`, `31_557_600`, `10_000`); octal `0o600`; binary
   `0b0001`.
5. Chains: first call on the statement line, following `->calls()` indented one tab, leading `->`.
6. Multi-line calls: `(` ends the line, one argument per line, trailing comma, `);` on its own line at statement
   indent.

### 3.10 Exceptions

1. Throw the Nette base set from `nette/utils` (`src/exceptions.php`): `Nette\InvalidStateException` (runtime state,
   extends `\RuntimeException`), `Nette\InvalidArgumentException`, `Nette\NotSupportedException`,
   `Nette\NotImplementedException`, `Nette\DeprecatedException`, `Nette\IOException`, `Nette\FileNotFoundException`,
   `Nette\ShouldNotHappenException` ("Houston, we have a problem."), `Nette\OutOfRangeException`,
   `Nette\UnexpectedValueException`, `Nette\MemberAccessException` (extends `\Error`). Standalone packages (Latte,
   Tracy, Tester, command-line) throw SPL `\LogicException` / `\RuntimeException` / `\InvalidArgumentException` /
   `\Exception` fully qualified. dg's personal code never throws the Nette set, even where it depends on nette/utils:
   SPL for programmer errors (`\InvalidArgumentException`, `\LogicException`, `\OutOfRangeException`; `throw new
   \LogicException;` for an impossible branch) and its own root for conditions the caller handles (`FioException`,
   `DG\Imap\Exception`, `Gmail\Exception`, DressCode's `ConfigurationException`); an API client splits its tree by
   recovery strategy (3.16). MySQL-dump throws bare `\Exception` by design.
2. Package exceptions are collected in one `exceptions.php`: a marker `interface Exception` (Latte), then classes
   with one-sentence docblocks and empty bodies (`class ServiceCreationException extends
   Nette\InvalidStateException`, `class CompileException extends \Exception implements Exception`), two blank lines
   between them. Never `final` in nette/* (dg's 2026 tools make internal exceptions `final`: `UsageException`,
   `ParseException`; the ones callers catch stay open), no `Error` suffix, no static factories (except
   `SmtpException::fromReply()`, `DriverException::from()`), data as promoted `readonly` params (`private readonly
   ?string $sqlState`, `readonly ?Position $position`; `public readonly int $status` plus a predicate such as
   `isRefused()` in dg's libraries), HTTP semantics via `protected $code = Http\IResponse::S404_NotFound;`. The
   class docblock is one natural sentence about the problem, never "Exception that is thrown when …"; stock phrasing
   `does not exist`, `failed to`, `cannot`, `is not supported` (`The file does not exist.`, `php-doc` skill).
3. Messages: English sentence, **ends with a period** (81% in nette/*; 89–94% in DressCode, PhpSyntax, dibi, texy;
   71% in dg's 2025–26 libraries with imap at 0 of 17; 39% in ftp-deployment), identifiers in single quotes,
   interpolated for plain variables and properties, `sprintf` when an argument is an expression (see 3.9). Write the
   period; a message ending in a forwarded value (`": $value"`, `"SQLSTATE[...]: ..."`) has none, nor do DressCode
   rule diagnostics. dg's 2026 tools put identifiers in Markdown backticks instead of quotes (155 of 261 messages,
   single quotes 2), e.g. `` "Invalid version `$version` of package `$package`." ``, and pass code values through
   `Helpers::formatCode()`. Examples: `"Service '$name' already exists."`, `"Invalid filter name '$name'."`, `"Cannot
   add cases '$name', because it already exists."`, `'Logging directory is not specified.'`; wrong types report
   `get_debug_type($x) . ' given'`; arity checks use `__METHOD__ . "() expects 2 parameters, $count given."`; config
   paths use `"\u{a0}›\u{a0}"` separators. Multi-value messages use `sprintf(` with one argument per line and a trailing
   comma. Previous exceptions: `, 0, $e)` or `previous: $e`.
4. `throw` as an expression (`?? throw`, `?: throw`, `default => throw`, `fn() => throw`) and `throw new X;` without
   parentheses when there are no arguments.
5. `@throws` on public API and interface methods, with a lowercase description.

### 3.11 Architecture and design habits

- **Static utility classes** (`final class Strings { use Nette\StaticClass; public static function …`) with `self::`
  calls (2,320 `self::` vs 104 `static::`); `static::` mostly where subclass override is intended (and in a few
  final classes such as `FileSystem`). In dg's 2026 tools a private helper that does not use `$this` is `private
  static` and called through `self::` (63% of DressCode's private methods, 51% of PhpSyntax's; not enforced).
- **Tiny interfaces** (1–5 methods) only where several implementations exist; capability discovery by `instanceof`
  (`BulkReader`, `BulkWriter`).
- **Public typed properties instead of getters** on data holders: Latte nodes, Tracy `Value`, `Logger` config,
  `Printer::$wrapLength`, event arrays `onSuccess`. Getters protect state that must stay consistent.
- **Fluent mutable builders** returning `static` (`Message::setSubject()`, `Selection::where()`, php-generator
  `ClassType::addMethod()->setReturnType()`); immutability through `final readonly class` or `with*()` + `$dolly`.
- **DI extension (Nette style)**: `final class FooExtension extends Nette\DI\CompilerExtension` (11 of 18 are
  final; http, mail, security, forms, database extensions are open) in `Nette\Bridges\<Package>DI`, class
  docblock with a description, a blank ` *` line, then the multi-line shape
  `@property object{` / `debugger: bool|null,` / `timeout: int,` / `} $config` (`T|null`, not `?T`), constructor
  `private readonly bool $debugMode = false` (from `%debugMode%`), `getConfigSchema(): Nette\Schema\Schema`
  returning `Expect::structure([...])` (keys usually uncommented; a trailing `// comment` only where the meaning is
  not obvious) and a tri-state `'debugger' => Expect::bool()`, `loadConfiguration()` (`$config = $this->config; $builder = $this->getContainerBuilder();`),
  `beforeCompile()` for cross-wiring (Tracy panel when `$this->config->debugger ?? $builder->getByType(Tracy\Bar::class)`),
  `afterCompile(ClassType $class)` only for generated code; service ids short camelCase (`presenterFactory`,
  `latteFactory`, `userStorage`), BC aliases `nette.*` added only when `$this->name === 'canonical'`;
  `->setType(Interface::class)->setFactory(Impl::class, [new Definitions\Statement(...)])`, `->addSetup('$prop',
  [$v])`, `$builder::literal('…')`. nette/di 4-dev adds `#[Hook(Phase::Register)] public function doXxx(ContainerBuilder
  $builder): void` phase hooks in place of the old triple.
- **Latte extensions**: `final class UIExtension extends Latte\Extension` with `getTags()`, `getFilters()`,
  `getFunctions()`, `getProviders()`, `getPasses()` returning arrays of first-class callables; tag nodes extend
  `StatementNode`, expose public typed props, build via `public static function create(Tag $tag): static` (or a
  `\Generator` for paired tags), implement `print(PrintContext $context): string` with `$context->format('… %node
  %line', …)` and nowdoc templates, and `&getIterator(): \Generator` yielding children by reference. Generated
  temporaries use the `$ʟ_` prefix.
- **Compilers/lexers**: state methods `state<Name>()` holding one named-group PCRE, `TokenStream` verbs
  `is/peek/tryPeek/consume/tryConsume`, closures-based `NodeTraverser` (no visitor hierarchy), positions as a
  `final readonly class Position`.
- **Tracy-style defensive code**: idempotent `enable()`, handlers registered as first-class callables, all classes
  `require_once`d eagerly before error handling, `try { … } catch (\Throwable $e) { self::tryLog($e); }`,
  atomic file writes via `rename()` of a `.tmp`, `flock` with `try/finally`, `exit(255)`.
- **Tester-style assertions**: `Assert::same(mixed $expected, mixed $actual, ?string $description = null): void`
  with `self::$counter++` and `self::fail(self::describe('%1 should be %2', $description), $actual, $expected)`.
- **No autoloader in Tracy/Tester bootstrap files**: explicit `require __DIR__ . '/Framework/Xyz.php';` lists.
- **Bridges** ship `.latte` panel sources compiled to committed `dist/*.phtml`, required inside
  `Nette\Utils\Helpers::capture(function () { require __DIR__ . '/dist/panel.phtml'; })`.
- Methods are short (median 4–7 body lines); long ones exist only in parsers, lexers and regex engines.

### 3.12 Application code (`nette/web-project`)

```
app/
  Bootstrap.php                      class App\Bootstrap (bootWebApplication(): Nette\DI\Container)
  Core/RouterFactory.php             final class, use Nette\StaticClass, public static function createRouter(): RouteList
  Presentation/@layout.latte
  Presentation/Accessory/LatteExtension.php
  Presentation/Home/HomePresenter.php + default.latte     (template next to the presenter)
  Presentation/Error/Error4xx/{Error4xxPresenter.php, 4xx.latte, 404.latte}
  Presentation/Error/Error5xx/{Error5xxPresenter.php, 500.phtml}
config/common.neon (parameters, application, database, latte, assets, di)   config/services.neon
www/index.php   bin/   log/   temp/   tests/bootstrap.php
```

1. `final class HomePresenter extends Nette\Application\UI\Presenter` (empty body on two lines, `use Nette;` root
   import); presenter mapping `App\Presentation\*\**Presenter`; error presenters with `#[Requires(methods: '*',
   forward: true)]`; template variables assigned dynamically (`$this->template->httpCode = $code;`); no `*Template`
   classes, no `Model/` in the skeleton.
2. `Bootstrap` is a plain class with `private readonly Configurator $configurator;` assigned in the constructor,
   `bootWebApplication()`, `initializeEnvironment()` (`enableTracy($this->rootDir . '/log')`, RobotLoader for
   `app/`), private `setupContainer()`. `www/index.php` is eight lines: `require` autoload, `$bootstrap = new
   App\Bootstrap;`, `$container = $bootstrap->bootWebApplication();`, `$application =
   $container->getByType(Nette\Application\Application::class);`, `$application->run();`.
3. `services.neon`: `services:` list plus `search:` auto-registration by suffix (`*Facade`, `*Factory`,
   `*Repository`, `*Service`), tabs, two blank lines between top-level sections, booleans `yes`/`no`
   (`strictParsing: yes`, `export: parameters: no`).
4. Latte: `{block content}`, `{include content}`, `{include title|stripHtml}`, `n:foreach`, `n:class`,
   `<h1 n:block=title>` (unquoted simple attribute values), `{asset? 'main.js'}`.
5. `composer.json` for apps: `"php": ">= 8.2"` (with a space), `^` constraints, scripts `phpstan` and `tester`;
   `phpstan.neon` level 8 for `app` and `bin`; the skeleton ships no `bin/` scripts. Library CLI tools
   (`latte/bin/latte-lint`, `neon/bin/neon-lint`) start `#!/usr/bin/env php` + `<?php declare(strict_types=1);`,
   probe both `vendor/autoload.php` locations and fail with `fwrite(STDERR, "Install packages using Composer.\n");
   exit(1);`. dg's own CLI tools: 3.20.

### 3.13 Tests (Nette Tester, dg style)

`tests/bootstrap.php`:

```php
<?php declare(strict_types=1);

// The Nette Tester command-line runner can be
// invoked through the command: ../vendor/bin/tester .

if (@!include __DIR__ . '/../vendor/autoload.php') { // @ - the autoloader is missing before composer install
	echo 'Install Nette Tester using `composer install`';
	exit(1);
}


// configure environment
Tester\Environment::setup();
Tester\Environment::setupFunctions();
date_default_timezone_set('Europe/Prague');


function getTempDir(): string
{
	$dir = __DIR__ . '/tmp/' . getmypid();
	// garbage collector with shared/exclusive lock, then @mkdir($dir)
	return $dir;
}
```

Canonical test file `tests/Utils/Arrays.get().phpt`:

```php
<?php declare(strict_types=1);

/**
 * Test: Nette\Utils\Arrays::get()
 */

use Nette\Utils\Arrays;
use Tester\Assert;

require __DIR__ . '/../bootstrap.php';


$arr = ['' => 'first', 1 => 'second'];

test('basic retrieval by key', function () use ($arr) {
	Assert::same('first', Arrays::get($arr, ''));
	Assert::same('second', Arrays::get($arr, 1));
});


test('missing key throws', function () use ($arr) {
	Assert::exception(
		fn() => Arrays::get($arr, 'undefined'),
		Nette\InvalidArgumentException::class,
		"Missing item 'undefined'.",
	);
});
```

1. Files are `.phpt`, named `Subject.aspect.phpt` (63%: `Arrays.isList.phpt`, `Debugger.enable().error.phpt`,
   `Connection.exceptions.postgre.phpt`), `Subject.phpt`, or `Class.method().phpt` when the file tests one method;
   directories mirror `src/` (`tests/Utils/`, `tests/Compiler/`, dotted `Bridges.DI/`, `Forms.Latte/`). No namespace
   in test files (96%; ai-access's `tests/Support/` helper classes use `namespace Tests\Support;`). dg's 2026 tools
   name files after the subject (`Token.phpt`, `.aspect` only when one subject has several files) under a directory
   named after the root namespace (`tests/PhpSyntax/…`, `tests/DressCode/Rules/…`); texy uses kebab-case feature
   names (`block-code.phpt`, 71 of 77), the agent-plugins hook tests are named after their scripts (`lint-php.phpt`).
   Test-local classes (`class Foo`, `interface Iface`, `class TestPresenter`) are declared in the file, loosely typed,
   separated by two blank lines.
2. Header: `<?php declare(strict_types=1);`, blank, optional `/** * Test: Nette\Utils\Strings::match() */` docblock
   (1,413 nette/* files, texy 76 of 77; newest repositories omit it: schema, assets, tester, dg's 2026 tools and
   2025–26 libraries 0 of 257; the `nette-tester` skill spells it `TEST:`, which no measured file does: write
   `Test:`; DressCode-era files may open with a prose docblock saying what the file covers), blank, `use` lines (`use
   Tester\Assert;` sorted among them), one blank line (DressCode; older files have two), `require __DIR__ .
   '/../bootstrap.php';` (plain `require`, never `require_once`), **two blank lines**, body. Annotations in the
   docblock: `@phpExtension mbstring`, `@phpVersion 8.4`, `@dataProvider? ../databases.ini`, `@exitCode   255`,
   `@httpCode   500`, `@outputMatch`, `@outputMatchFile expected/x.expect`.
3. `test()` is provided by Tester (`Environment::setupFunctions()`), never redefined in a new bootstrap (dibi and
   texy still define `function test(string $title, Closure $function): void { $function(); }`: leave it there, do not
   copy it): `test('lowercase description', function () use ($x) { … });` — title required, lowercase, no period, may
   embed `method()` names; no comment above a `test()` call, the title is the comment (`nette-tester` skill); **two
   blank lines between `test()` blocks**; companions `testException('title', function () { … }, X::class, 'msg')`,
   `setUp(function () { … })`, `tearDown(...)` (0 in dg's 2026 tools, which assert exceptions inside `test()`). Older
   files are flat top-level `Assert::` scripts with `// section` comments after two blank lines; `Tester\TestCase`
   classes are practically extinct (run as `$test = new XTest; $test->run();`, `new X` without parentheses).
4. Assertions expected-first: `Assert::same`, `Assert::null($x)` (not `same(null, …)`), `Assert::true/false`,
   `Assert::type(Foo::class, $x)`, `Assert::count`, `Assert::equal` for object graphs (`(object) [...]`),
   `Assert::match('%a%:%d% %A%', $s)` with Tester patterns, `Assert::matchFile(__DIR__ . '/expected/x.php', $out)`
   for snapshots (never `Assert::contains()` for generated output, which passes on broken output: `nette-tester`
   skill), `Assert::error(fn() => …, E_USER_DEPRECATED, 'msg')`, `Assert::noError`, `Assert::with(Class::class,
   function () { … })` for private access. `Assert::exception(fn() => …, Class::class, 'message',)` multi-line with
   trailing comma; closure with statements uses `function () { … }` and puts the remaining arguments on the closing
   line. Expected multi-line text is nowdoc `<<<'XX'`.
5. DI tests: the `createContainer($compiler, $neon)` helper from `di/tests/bootstrap.php`, NEON as a single-quoted
   string that opens with a **real** line break (not `\n`, which single quotes would not expand), top-level keys at
   column 0, tabs for nesting:

   ```php
   $container = createContainer($compiler, '
   foo:
   	timeout: 30
   ');
   ```

   Config files via
   `Tester\FileMock::create($s, 'neon')` (always fully qualified); temp dirs via `getTempDir()`; skipping via
   `Tester\Environment::skip('Requires CGI mode')`; `Tester\Environment::lock()` for DB tests.
6. Data sets: `$dataSet = [...]` + `foreach` with asserts, or one `test()` per case; `@dataProvider` methods only in
   the rare TestCase classes. Mockery only in application/database/security with `Mockery::close()` in a global
   `tearDown()`.
7. Formatting inside tests equals production: tabs, trailing commas, single quotes, `new X` without parentheses,
   long expectation lines unwrapped.
8. CI `tests.yml`: matrix over PHP versions (`fail-fast: false`), `composer install --no-progress --prefer-dist`,
   `composer tester`, upload `tests/**/output` on failure, `lowest_dependencies` and `code_coverage` (phpdbg +
   coveralls) jobs; 4-space YAML.

### 3.14 Repository conventions

- **composer.json** (tabs): `name, description, keywords, homepage, license, authors, require, [suggest],
  require-dev, [conflict], autoload, minimum-stability, scripts, extra, config`; description starts with an emoji
  (`🛠  Nette Utils: …`, `💎 Nette Dependency Injection Container: …`); `"homepage": "https://nette.org"`;
  `"license": ["BSD-3-Clause", "GPL-2.0-only", "GPL-3.0-only"]`; authors `David Grudl` (`https://davidgrudl.com`) and
  `Nette Community` (`https://nette.org/contributors`); `"php": "X.Y - 8.5"` (range with spaces; lower bound per package: 8.3 on the 4.0-dev line, 8.1–8.2 elsewhere;
  upper bound bumped per PHP release); `^x.y` constraints, `@stable` on phpstan tooling; `"autoload": {"classmap": ["src/"], "psr-4":
  {"Nette\\": "src"}}` (+ `"files"` for `functions.php`); no `autoload-dev`, no `prefer-stable`, no `sort-packages`;
  `"scripts": {"phpstan": "phpstan analyse", "tester": "tester tests -s"}`; `extra.branch-alias.dev-master:
  "4.1-dev"` (no `.x`); `extra.nette.di-extensions` for auto-discovered extensions.
  dg's personal repositories differ: one author (`David Grudl`, `https://davidgrudl.com`), no emoji except the
  2026 tools and rule packages (`🌳 PhpSyntax: …`, `👔 DressCode: …`), `homepage` only on an own domain
  (`https://dresscode.run`), license `MIT` (2026 tools, fio-mcp, pohoda-mcp), `["BSD-3-Clause"]` or the Nette triple;
  `"php"` as `"8.4 - 8.6"` (2026 tools), `"8.2 - 8.5"` (dibi, texy) or `">=8.2"`; `classmap: ["src/"]` (run `composer
  dump-autoload` after adding a class); dibi and texy add `replace` for the old `dg/` name.
- **readme.md** (lowercase): banner image link, five shields.io/poser badges each on its own line, Setext-underlined
  sections `Introduction`, `Installation` ("The recommended way to install is via Composer:" + compatibility
  sentence "Nette Utils 4.1 is compatible with PHP 8.2 to 8.5."), `Usage`, `[Support Me](https://github.com/sponsors/dg)`
  with the "Buy me a coffee" image; sections separated by ` <!---->`; feature lists as `✅ [Arrays](…)<br>`; docs live
  on doc.nette.org, not in the repo. **license.md** (lowercase) with the BSD/GPL dual text. No Makefile, no
  `.editorconfig`, no CHANGELOG, no `.docs/`. dg's personal libraries keep their documentation in the repository
  (readme usage sections, `docs/`, runnable `examples/`), use 2–5 badges and no ` <!---->` except twitter-php,
  ai-access and bypass-finals; the 2026 tools add long keyword-style section titles and a "Limits" section; fio-mcp and
  pohoda-mcp are documented in Czech; google-services uses `README.md` with ATX headings.
- **AGENTS.md** in most repos (`# To My Agents!`), stating conventions ("Every file starts with
  `declare(strict_types=1);`; everything typed; `readonly` for immutable properties; tabs; two blank lines between
  methods; Nette Coding Standard; document the shut-up operator"); agent-facing `docs/internals/*.md`. dg's 2026
  tools and libraries use fixed sections (Documentation, Project overview, Essential commands, Conventions, Working
  rules, Traps or Deliberate decisions) and point to `docs/internals.md` as "the source of truth"; quotations in 3.21.
- **.gitattributes** column-aligned with `export-ignore` for `.github/`, `AGENTS.md`, `docs/`, `tests/`, `ncs.*`,
  `phpstan*.neon`, plus `*.php* diff=php`, `*.sh text eol=lf`. **.gitignore**: `/vendor`, `/composer.lock`,
  `tests/lock`, `/tests/output`, `/tests/tmp`.
- **phpstan.neon** (tabs): `level: 8`, `paths: - src` (2026 tools add `tests`), `excludePaths` for compatibility
  files, `bootstrapFiles`, `ignoreErrors` entries as `- # reason` + `identifier:` (+ `message:`, `path:`, `count:`).
- **Workflows**: `.github/workflows/{tests,coding-style,static-analysis}.yml`, self-contained, 4-space YAML,
  `on: [push, pull_request]`, snake_case job ids (`nette_cc`, `nette_cs`, `code_coverage`, `lowest_dependencies`),
  `actions/checkout@v6`, `shivammathur/setup-php@v2`. In dg's newest repositories `coding-style.yml` holds a
  `dresscode` job instead of `nette_cs`, and the 2026 tools diff generated docs in CI (`composer reference` +
  `git diff --exit-code docs/reference`) and run `composer verify-examples`.
- **Versioning**: `master` tracks the next version (`4.1-dev`); one long-lived branch per released minor (`v4.0`,
  `v3.2`); tags `vX.Y.Z` (+ `v3.3.0-RC`); release commit `Released version 3.1.6` (only the version constant), then
  `opened 4.1-dev` (composer alias). BC breaks are flagged in the commit subject, not in a changelog.
- **Commits**: lowercase past tense for changes (`added Type::fromValue()`, `removed support for Latte 2`,
  `improved tests`, `used native PHP 8 functions`, `requires PHP 8.2`, `uses PascalCase constants`, `opened
  4.1-dev`) or `Class: behaviour sentence` / `Class::method() sentence` (`Finder: exclude() uses the same mask
  grammar as find()`, `Arrays::renameKey() fixed incorrect replacement for existing new keys [Closes #230]`,
  `Html: added fragment() and add()`); tool prefixes lowercase (`tests:`, `composer:`, `readme:`, `phpstan.neon:`,
  `coding style:`, bare `cs`) except `CI:`; markers `(BC break)`, `[Closes #N]` (capital C, one bracket per issue), `[security]`,
  `WIP`; no trailing period, no emoji, no body except long prose bodies in 2026 work. dg's `commit-messages` skill
  teaches models a narrower form: lowercase **past tense** only ("the commit describes what happened, so the git log
  reads as a chronological history"), `Subject: description` where it clarifies the area (`Filters: added
  escapeHtml()`), under 70 characters, English, `wip` in lower case, routine subjects `vendor`, `cs`, `typos`,
  deprecations as `[method] deprecated`, a body only when the "why" is not obvious. The measured log also has the
  present-tense `Class: sentence` form and `WIP`/`[WIP]`; both pass, the past tense is the safer choice.

### 3.15 Do not (dg)

- No spaces in `declare(strict_types = 1)`; no `declare` on its own line; no blank line after class `{`; no single
  blank line between methods; no blank lines between `use` groups.
- No `use stdClass;`/`use Throwable;` (write `\stdClass`); no `\count()`; no per-line `use function`; no `use
  function` for calls PHP does not compile specially in a new file.
- No `I`/`Abstract`/`Interface`/`Trait` in names; no bare-noun method names; no `$isActive` properties; no
  `UPPER_SNAKE` constants in new code; no typed constants; no `#[\Override]`; no `public` on interface methods; no
  `static fn`/`static function` in nette/*; no `new Foo()` with empty parentheses; no `(new Foo($x))->bar()` on PHP
  8.4; no `fn ($x)` with a space; no `(int)$x` without a space.
- No `sprintf` for plain variables (outside nette/di); no braced `{$var}` where `$var` suffices; no new messages
  without a period (except a forwarded `: $value`); no `Foo::bar():` prefixes in messages; no exception static
  factories; no Nette exceptions in dg's personal packages.
- No `@param string $x` restating a native type; no blank line between a method description and its tags (class
  docblocks keep one before `@property`/`@method`); no `@author`,
  `@since`, `@package`, `@inheritDoc`, `@phpstan-*`, `@return $this`/`@return static` docblocks; no "Class that …"
  summaries; no docblocks on trivial getters or setters; no uppercase-starting or period-terminated `//` comments in
  library code; no `@` without a same-line `// @ reason`; no comments citing bugs, issues or PRs; no non-English
  identifiers or comments.
- No `else` removal for its own sake; no Yoda; no `is_null`; no `else if`; no `switch` where `match` fits; no
  `list()`, `array()`, `goto` (one commented exception); no aligned `=>`/`=`.
- No `SmartObject`/`@property` on new classes; no `inject*()`/`#[Inject]` in concrete app presenters (constructor
  injection); no docblock annotations (`@persistent`); no `array_map(function ($x) { return …; })` (must be `fn`);
  no captured `$e` in an empty catch;
  no `private` on subclass hooks (`protected`); no `final` on the main extension points.
- No PHPStan inline ignores; no strict-rules; no Makefile, `.editorconfig`, `ruleset.xml`, CHANGELOG, `.docs/`.
- No test namespaces; no `require_once` for bootstrap; no test docblocks in new repos; no redefined `test()` in a
  new bootstrap; no comment above a `test()` call; no `TEST:`; no `Test`-suffixed `.phpt` names; no PHPUnit.
- No imperative capitalised commit subjects (`Add feature`); no conventional-commit types; no `Co-Authored-By`.

### 3.16 API clients (dialect B)

dg's 2025–26 clients (ai-access, google-services, fio-mcp, imap, pohoda-mcp) share none of 2.12.1's shape.

- Layout: capability interfaces and shared value classes at the top (`ai-access/src/{Chat,Batch,Embedding,Http}/`),
  one directory per provider with the same file set (`src/Provider/<Name>/{Client,Chat,ChatResponse,Batch}.php`);
  single-service libraries stay flat (`fio-mcp/src/{FioClient,Transaction,Statement}.php`, `imap/src/{Mailbox,
  Message,Connection}.php`); google-services `src/<Service>/{Manager,McpTools,<Dto>}.php`. The role is the last word
  of the name (`Client`, `Manager`, `Response`).
- Transport is one injected seam with a default: an `Http\Client` interface with a single `fetch(...)` method
  (`ai-access/src/Http/Client.php`), `private readonly Http\Client $httpClient = new Http\CurlClient,` in every
  provider constructor (`Provider/Claude/Client.php:29`), retries, caching and logging as decorators of the same
  interface (`RetryClient`, `CachingClient`, `ObservableClient`). A small library injects a `?\Closure $http`
  returning `[status, body]` (`FioClient::__construct()`). No PSR-18, no Guzzle.
- Options are typed nullable named parameters on the provider's own class, merged into the wire array with the wire
  names mapped inline (`Claude\Chat::setOptions(?int $maxOutputTokens = null, …): static`,
  `Provider/Claude/Chat.php:42-62`); no options arrays. Default models are constructor arguments and per-call
  arguments win: `$model ??= $this->chatModel ?? throw new AIAccess\LogicException('No chat model given and the
  client has no default one.');`.
- Responses wrap the decoded array and parse lazily (`final class ChatResponse implements Chat\Response`,
  `getFinishReason(): FinishReason` through `match` with `default => FinishReason::Unknown`). Entities are `final
  class` with `public readonly` promoted properties, the payload kept in `public readonly array $raw = []`, built by
  `: self` constructors named for the source (`fromJson()`, `fromXml()`, `fromArray()`, `parse()`, `connect()`) with
  named arguments (`fio-mcp/src/Transaction.php`, 19 properties). Objects a caller fills (google-services
  `Calendar\Event`) have `public` properties, not setters.
- Lists are generators (`listBatches(): \Generator`, `iterable` in the interface); a stream is `?\Closure $onChunk`
  on the same `fetch()`. JSON passes one helper (`Helpers::decodeJson()` with `JSON_THROW_ON_ERROR`).
- Exceptions follow what the caller can do: ai-access `ServiceException` with `ApiException`,
  `CommunicationException`, `UnexpectedResponseException`, `TooManyRoundsException`, plus `LogicException extends
  \LogicException` for caller mistakes (`ai-access/src/exceptions.php`); fio-mcp `FioException`, `TransportException`
  (outcome unknown) and `HttpException` with `public readonly int $status` and `isRefused()`.
- Tests never touch the network: `FakeHttpClient implements Http\Client, \Countable` (`ai-access/tests/Support/`),
  JSON fixtures captured from the real services (`fixture('claude/chat')`), an injected closure (`createClient()` in
  `fio-mcp/tests/FioClient.phpt`), a scripted socket dialogue (`imap/tests/bootstrap.php`); `final` classes are
  mocked after `DG\BypassFinals::enable()`.

### 3.17 MCP servers

fio-mcp, google-services and pohoda-mcp (`mcp/sdk ^0.8`; 51 `#[McpTool]` methods).

1. `server.php` at the root: the header, `// stdout carries the JSON-RPC stream, a PHP warning printed there would
   break it`, `ini_set('display_errors', 'stderr');`, an autoload that works standalone and as a dependency (`require
   is_file(__DIR__ . '/vendor/autoload.php') ? __DIR__ . '/vendor/autoload.php' : __DIR__ . '/../../autoload.php';`,
   `fio-mcp/server.php:6-9`), then `use` (a script imports after `require`), `getenv()` settings and one chain
   `Server::builder()->setServerInfo(…)->setInstructions($instructions)->setContainer($container)
   ->setReferenceHandler(new McpToolCallGuard(new ReferenceHandler($container)))->setDiscovery(__DIR__ . '/src',
   ['.'], namePatterns: ['*Tools.php'])->build()`, ending `$server->run(new StdioTransport);`. A fatal misconfiguration
   goes to STDERR and `exit(1)` from a `static function (string $message): never` (`google-services/server.php:27-30`).
2. Tools are public methods of a plain (not `final`) `McpTools` class per service, which takes a factory closure and
   resolves credentials on the first call (`$this->manager ??= …`). Between docblock and signature: `#[McpTool(name:
   'fio_list_transactions', title: '…', annotations: new ToolAnnotations(readOnlyHint: true, openWorldHint: true))]`;
   parameters carry `#[Schema(minimum: 1, maximum: 1000)]`, `format: 'date'`, `enum: […]`. Names are `snake_case`,
   prefixed with the service when a server has several (`gmail_create_draft`); google-services adds
   `#[Access(AccessLevel::Write)]`.
3. The docblock is the description sent to the model: an imperative summary (`List movements on the Fio account`),
   one `@param ?string $dateFrom  First day, YYYY-MM-DD` per parameter (one space after the tag, type restated: 244
   of 244 lines), `@return array{…}`; a blank ` *` before the tags is allowed. "Tool names, descriptions, and JSON
   schemas all consume the agent's context - keep them tight" (`google-services/AGENTS.md`).
4. Tool bodies do not catch: `McpToolCallGuard implements ReferenceHandlerInterface` converts in a documented
   first-match-wins order (`ToolCallException` rethrown, domain and `\InvalidArgumentException` messages forwarded,
   any other `\Throwable` wrapped with class, file and line). Messages for the model are long and name the remedy.
5. Tests pin names, titles, annotations and schemas (`tests/McpTools.phpt`, "Update it after adding a tool."), cover
   every guard branch and call tools as plain methods with a fake factory. Extras: `.mcp.json.example`, `.mcp.json`
   ignored, instructions in `<<<'TEXT'`, pohoda-mcp's `nameCasing {variable: keep}` override for tool parameters.

### 3.18 DressCode rule packages

`dg/dresscode-rules-{nette, symfony, laravel}` (two or three rules plus an `Extension` each) and the data-only
`-deegee`.

- A rule is `final class XRule extends NodeRule`: a multi-paragraph class docblock (what it rewrites, then
  "Reported and left: …"), then `#[RuleInfo('laravel/casts-method-for-casts-property', Stage::Structure,
  description: '…', group: RuleGroup::Modernization, requires: ['laravel/framework' => '>=11.0'])]`
  (`dresscode-rules-laravel/src/CastsMethodForCastsPropertyRule.php`); `getVisitedTypes(): array`; `enter(Node|Token
  $node, RuleContext $context): void` opening with a guard (`if (!$node instanceof ClassNode || …) { return; }`),
  refusals as `match (true)` arms, `$context->report($node, $message, fixable: false)`.
- Grouped imports (`use PhpSyntax\{Node, Parser, Printer, Token};`), a root import for foreign classes (`use
  Illuminate;`, `private const Model = Illuminate\Database\Eloquent\Model::class;`), PHP 8.4 functions unimported
  (`array_any`), `(new Parser)->parseFragment(…)`. `dresscode.neon` adds `groups: [modernization, deprecations]`,
  `groupImport: {minImports: 2}` and `overrideAttributeRequired: keep`.
- Diagnostics have identifiers in backticks, a capital start and no period. Upgrade data are NEON
  (`upgrading/<library>.neon`, `since 5.0.2:` sections newest first, `replaced-members`, `replaced-calls`,
  `forbidden-*`); a `forbidden-*` sentence "is English, completes `… is forbidden:` and says what to write instead:
  lower case unless it begins with a name, its code in backticks as in the rest of the message, no period or double
  quotes, at most 160 characters" (`dresscode-rules-nette/AGENTS.md:49-57`).
- Tests are data: `tests/fixtures/<rule>/<case>.{code,expected,violations}` run by `tests/rules.phpt` through
  `DressCode\Testing\RuleTester`; library samples in `tests/samples/` run by `tests/upgrading.phpt`.

### 3.19 Ported and legacy code

Ported code keeps its upstream style. `nette/latte-tools` `src/Twiggy` (143 of 154 files) is Twig 3.2.1 under
`LatteTools\Twiggy\`: Twig's `/* This file is part of Twig. … */` header, `\count()` calls (156 in 28 files),
`*Interface`/`Abstract*` names, untyped properties, one `*Error` class per file, Yoda and `==`, `sprintf('… "%s" …')`
messages, bracketed `namespace X { }` blocks (`Extension/CoreExtension.php:13`); the Nette standard normalises only
`declare` and braces there. Do not reformat a ported tree and do not copy its habits into the dg-authored files
beside it. Those files have their own inherited shape: `LattePrinter.php` derives from nikic/php-parser's printer and
keeps its untyped `pXxx()` signatures and capitalised section comments; the converters expose one `convert(string
$code): string` built from private `void` passes, each opened by a `// before => after` comment, and are tested by
fixture pairs (`tests/fixtures-twig/**/<case>.twig` + `.latte`, `Assert::match()` in `tests/TwigTest.php`).

Legacy eras are not models. `f3l1x/forge` holds 172 PHP files from six eras: PHP 5 plugins with 4-space indent,
`@author` and `NULL` (76), early Contributte on `ninjify/qa` (10), copies of the 2019–20 `nette/sandbox` with the
three-line header (36), third-party blobs; only 37 files (`php/*`, `nette/Http`) are dialect A, and those fail the
current qa ruleset (173 errors in 19 files). In dg's repositories the same holds for latte-tools' tooling (`phpstan
^0.12` level 5, `actions/checkout@v2`), MySQL-dump (UPPER constants, `@author` header) and dibi's `Event` (11 UPPER
constants without a PascalCase twin): when you touch such a constant add the twin and the `#[\Deprecated]` alias
together, and bring repository files to 3.14 only when the repository is otherwise being reworked.

### 3.20 CLI tools

- The executable is thin. ftp-deployment's `deployment` is three lines (`#!/usr/bin/env php`, `<?php`, `require
  __DIR__ . '/src/deployment.php';`); `src/deployment.php` declares `strict_types`, probes `../vendor/autoload.php`
  then `../../../autoload.php` and ends `$runner = new CliRunner; die($runner->run());`. `dresscode/bin/dresscode`
  ends `exit((new DressCode\Console\Application)->run($argv));` and fails on STDERR with exit code 2 ("… is not
  installed; …"); `phpsyntax/bin/phpsyntax` is one namespaced script of functions with the license docblock.
- `CliRunner::run(): ?int` returns the exit code (`return 1;` when `loadConfig()` yields `null`); the 2026 tools
  document 0 clean, 1 findings, 2 failure.
- Arguments go through `Nette\CommandLine\Parser` with the help as an indented nowdoc `<<<'XX'` that opens with a
  blank line, a title underlined with dashes and `Usage:`/`Options:` blocks; positional arguments as `['config' =>
  [Parser::RealPath => true]]`; `$cmd->isEmpty()` prints `$cmd->help()`; options read as `$options['--test']`
  (`ftp-deployment/src/Deployment/CliRunner.php`).
- `setupPhp()`: `set_time_limit(0)`, an error handler turning warnings into `\ErrorException`,
  `set_exception_handler(function (\Throwable $e): void { …; exit(1); })`, SIGINT through `pcntl_signal()` and
  `pcntl_async_signals(true)`; a second run is refused by `flock($lock, LOCK_EX | LOCK_NB)`. Error-prone natives go
  through a `Safe` class (`@method static` list plus `__callStatic()` turning warnings and `false` into
  `ServerException`).
- Root-level converter scripts (`latte-tools/php-to-latte.php input.php [output.latte]`) are plain scripts with one
  `require` and a `<<<'XX'` usage text; the shebang and STDERR form of 3.12.5 is for `bin/` tools in packages.

### 3.21 What dg tells agents

dg's prose for models lives in `nette/agent-plugins` (skills under `plugins/nette-dev/skills/` and
`plugins/nette/skills/`; hooks that run `php -l`, `latte-lint`, `neon-lint`, jsonlint, eslint and `ecs fix` after every
edit) and in the `AGENTS.md` of his repositories. Its rules are folded into 3.1–3.15; the key lines verbatim:

- Every personal `AGENTS.md` (11 of 12 2025–26 libraries, dibi, texy, ftp-deployment, …): "# To My Agents!" / "It
  is my fervent wish that this file guide every AI coding agent working with code in this repository."
- `plugins/nette-dev/docs/contributing/coding-standard.md`: "The easiest way to do this is to imitate the existing
  code. The goal is to make all the code look as if it were written by one person."
- `plugins/nette-dev/skills/php-coding-standards/SKILL.md`: "Write all code, comments, and variables in English only
  (even if communicating with the user in Czech)"; "Never let a method name be a bare noun - a method is an action:
  `getProvider()`, not `provider()`."; "Leave existing methods where they are - reordering them buries the real change
  in the diff"; "Don't add comments referencing specific bug fixes, issues, or tickets".
- `plugins/nette-dev/skills/php-doc/SKILL.md`: "**Never duplicate signature information without adding value.**";
  "Always American English (color, not colour; behavior, not behaviour)".
- `plugins/nette-dev/skills/phpstan-analysis/SKILL.md`: "**Never use `@phpstan-ignore` annotations** - keep
  checker-specific directives out of source code; ignore in `phpstan.neon` instead."; "**Take the verdict from the
  exit code, never from grepping the output.**"
- `plugins/nette-dev/skills/commit-messages/SKILL.md`: "Use past tense for verbs ("added", "fixed", not "add",
  "fix") - the commit describes what happened, so the git log reads as a chronological history".
- `plugins/php-fixer/skills/php-auto-fixer/SKILL.md`: "Always add `use` statements in the same Edit as the code that
  references them, or add the code first and the `use` second." (the hook's `ecs fix` deletes unused imports).
- `plugins/nette/skills/nette-tester/SKILL.md`: "**A test that executes no assertion is an error**"; "Do not add
  comments before `test()` calls - the description parameter serves this purpose".
- `dg/dresscode/AGENTS.md` and `phpsyntax/AGENTS.md`: "Comments only where the code itself is not enough; never
  restate what the code shows; density follows the surrounding file."; "One commit per unit, message lowercase, past
  tense, `subject: description` when it clarifies the area. Linear history."

The fixer hook runs the released `ecs` with the plugin's own `ncs.php`, never the repository's `dresscode.neon`: in a
DressCode repository run `dresscode check` yourself before committing.

---

## 4. Checklists

### 4.1 Before committing in dialect A (Contributte)

1. `make csf && make qa && make tests` are green (phpcs on `src tests`, phpstan level 9, Nette Tester).
2. First line `<?php declare(strict_types = 1);`; tabs; blank line after class `{` and before `}`; one blank line
   between members; magic methods last; imports alphabetical and complete (global classes imported).
3. Native types everywhere; docblocks only for generics/shapes; `?T`; `: void`; `: self` for fluent methods.
4. `sprintf('… "%s" …', $x)` messages; guard clauses; blank line before `return`; strict comparisons; `??`.
5. Exceptions follow the repository's layout (`Exception/Logical|Logic|Runtime` or flat); roots
   `LogicalException`/`RuntimeException`; empty bodies unless a static factory carries data.
6. DI: `@property-read stdClass $config`, hook order, `$builder`/`$config` locals, `prefix()` ids, `*_TAG`
   constants, `setAutowired(false)` on internals, `assert($def instanceof ServiceDefinition)`.
7. Tests: `Toolkit::test(function (): void { … })` with a `// comment`, `ContainerBuilder::of()` + `Neonkit::load`,
   `Assert::exception(…, X::class, 'exact message')`.
8. Repo files from 2.15; commit `Area: imperative phrase`.

### 4.2 Before committing in dialect B (Nette)

1. `composer phpstan` and `composer tester` are green; code-checker `--strict-types` passes; `php
   temp/coding-standard/ecs check` (or `dresscode check` where `dresscode.neon` exists, as in dg's newest
   repositories) passes; PHPStan judged by its exit code, no `@phpstan-ignore`.
2. First line `<?php declare(strict_types=1);`; license docblock if the repository has one; two blank lines before
   the class and between methods; no blank line inside class braces; `use Nette;` or per-class imports (grouped where
   `dresscode.neon` sets `groupImport`) + one `use function …` line for the calls PHP compiles specially.
3. Class docblock sentence with a period; `@param  T  $x` two-space form; no docblock that repeats types or only
   names a setter; English, American spelling; no comment citing an issue.
4. `final` for new internal classes (every concrete class in a new tool; follow the package elsewhere); PascalCase
   constants with deprecated UPPER aliases; no kind in names; two-letter abbreviations uppercase; methods are verbs,
   booleans `is*`/`has*`/`can*`; no `public` on interface methods; enums for closed sets where the repository has
   `enums.php`.
5. Promoted `private readonly` ctor with trailing comma and `) {`; other multi-line signatures `): T` + `{`.
6. `"Message '$x'."` interpolation, period at the end (backticks for identifiers in DressCode-style code);
   `Nette\InvalidStateException` family in nette/*, SPL or the package's own root in dg's personal packages; `??
   throw`.
7. Leading operators on wrapped lines; trailing commas everywhere; `new Foo;`, `(new Foo)->bar()`, `new
   Foo($x)->bar()` on PHP 8.4; `fn($x)` for every single-expression closure, `static fn` only where the file already
   uses it; named arguments for flags and skipped optional parameters; `match`; `catch (\Throwable)` without `$e` when
   unused; `@` only with `// @ reason`; branch blank lines as the repository's DressCode asks (in nette/* a blank line
   before every `}` of a paragraphed `if`/`else` chain).
8. Tests `Subject.aspect.phpt`, `test('lowercase title', function () {…});` with no comment above it, two blank lines
   between tests, `Assert::same($expected, $actual)`; `Test:` (not `TEST:`) only where the suite has the docblock.
9. Commit `added X` / `Class: sentence`, `(BC break)`, `[Closes #N]`; past tense is the form dg's skill teaches.
10. API clients, MCP servers, rule packages and CLI tools follow 3.16–3.20; ported trees keep their own style (3.19).

### 4.3 Converting between dialects

| Change | A → B | B → A |
|---|---|---|
| declare | remove spaces | add spaces |
| class body | drop the blank lines inside braces; two blank lines between methods | add blank lines inside braces; one blank line between methods |
| imports | replace `use stdClass;` with `\stdClass`; add `use function` for the calls PHP compiles specially; consider `use Nette;` | import global classes; drop `use function`; expand `Nette\X` to imports |
| constants | `FOO_BAR` → `FooBar` (keep deprecated alias) | `FooBar` → `FOO_BAR` |
| `new Foo()` | `new Foo` | `new Foo()` |
| `fn ($x)` | `fn($x)` | `fn ($x)` |
| ctor `)` newline `{` | `) {` | `)` newline `{` |
| messages | `sprintf('… "%s"', $x)` → `"… '$x'."` for plain variables; keep `sprintf("… '%s'.", expr)` for expressions | `"… '$x'."` → `sprintf('… "%s"', $x)` |
| exception roots | `LogicalException` → `\LogicException` / `Nette\InvalidArgumentException` / `Nette\NotSupportedException`; `RuntimeException` → `Nette\InvalidStateException` / `Nette\IOException` | reverse (keep logic vs runtime) |
| fluent return | `: self` → `: static` | `: static` → `: self` |
| closures | one-expression closure → `fn()`; drop unused `$e` in catch; drop `static` in nette/* (keep it where the repository writes it) | keep `fn ()` with a space; add `static` where `$this` is unused (2024+ code) |
| interfaces | drop `public` from interface methods | follow the repository |
| `final` | add to new concrete classes in a new tool; follow the package in nette/* | remove where 2.4 leaves classes open |
| named arguments | keep for flags, skipped optional parameters and long constructors | keep only for flags |
| functions | add `use function a, b;` for optimisable calls | drop `use function` |
| docblocks | add class sentence; `@param  T  $x`; remove the blank line before method tags (keep it before `@property`/`@method`) | drop prose; one space; blank line before tags |
| tests | `Toolkit::test` → `test('title', …)`; rename to `Class.aspect.phpt` | `test()` → `Toolkit::test` with `// comment`; move under `tests/Cases` |
| trailing commas | add to calls/params | keep (accepted) or drop in older files |

## 5. Reference files

Dialect A: `contributte/doctrine-orm/src/DI/OrmExtension.php` (+ `DI/Pass/ManagerPass.php`, `DI/Helpers/BuilderMan.php`),
`contributte/messenger/src/DI/MessengerExtension.php` (+ `DI/Pass/BusPass.php`, `Exception/Logical/ContainerException.php`,
`AGENTS.md`), `contributte/doctrine-dbal/src/DI/DbalExtension.php` (+ `DI/Pass/ConnectionPass.php`,
`ConnectionProvider.php`), `contributte/console-extra/src/DI/CacheConsoleExtension.php`,
`contributte/apitte/src/Core/Annotation/Controller/Path.php`, `contributte/middlewares/src/Utils/ChainBuilder.php`,
`contributte/bus/tests/Cases/CommandBusTest.phpt`, `contributte/doctrine-dbal/tests/Cases/DI/DbalExtension.phpt`,
`contributte/webapp-skeleton/app/UI/Modules/Base/BasePresenter.php`, `contributte/apitte-skeleton/app/Domain/User/User.php`,
`contributte/messenger-skeleton/{app/Bootstrap.php,config/config.neon,Makefile}`, `contributte/qa/ruleset.xml`.

Dialect B: `nette/utils/src/Utils/{Json,Callback,Arrays,Strings}.php`, `nette/utils/src/exceptions.php`,
`nette/di/src/DI/{Container.php,Extensions/InjectExtension.php,exceptions.php}`,
`nette/application/src/Bridges/ApplicationDI/ApplicationExtension.php`, `nette/application/src/Application/UI/AccessPolicy.php`,
`nette/caching/src/Caching/Cache.php`, `nette/http/src/Http/{Request,IRequest,enums,IPAddress}.php`,
`nette/mail/src/Mail/{Message,Interceptor,exceptions}.php`, `nette/security/src/Security/*` + `compatibility-intf.php`,
`nette/latte/src/Latte/Essential/Nodes/IfNode.php`, `nette/latte/src/Latte/Compiler/{Token,TokenStream,NodeTraverser}.php`,
`nette/tracy/src/Tracy/Debugger/Debugger.php`, `nette/tester/src/Framework/{Assert,functions}.php`,
`nette/utils/tests/Utils/Arrays.get().phpt`, `nette/utils/tests/bootstrap.php`, `nette/di/tests/Compiler/extension.schema.phpt`,
`nette/web-project/app/**`, `nette/utils/{composer.json,readme.md,AGENTS.md}`.

dg's newer code: `dg/dresscode/src/{Runner,enums,exceptions}.php`,
`dg/dresscode/src/Rules/Namespaces/NameFallbackRule.php`, `dg/dresscode/src/Presets/Nette.php`,
`phpsyntax/phpsyntax/src/{Token,Node}.php`, `dg/ai-access/src/Http/Client.php`,
`dg/ai-access/src/Provider/Claude/{Client,Chat,ChatResponse}.php`, `dg/fio-mcp/{server.php,src/McpToolCallGuard.php}`,
`dg/dresscode-rules-laravel/src/CastsMethodForCastsPropertyRule.php`, `dg/ftp-deployment/src/Deployment/CliRunner.php`,
`nette/agent-plugins/plugins/nette-dev/skills/{php-coding-standards,php-doc,commit-messages,phpstan-analysis}/SKILL.md`.
