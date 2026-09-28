# SYNTAX.md — How to write PHP like f3l1x (Contributte) and dg (Nette)

> Extracted from every PHP file in 164 Contributte repositories and 34 Nette repositories (8,581 files) on 2026-09-28.
> Every rule below was measured, not guessed. Percentages are over `src/` of current-era repositories unless stated.
> Companion plan with the full inventory and method: [SYNTAX-PLAN.md](SYNTAX-PLAN.md).

## 0. How to use this document

There are two authors and two dialects. They share a philosophy (tabs, strict types, native types everywhere, small
classes, Nette Tester) but disagree on nearly every layout detail. **Pick one dialect per repository and never mix.**

| You are writing in… | Dialect | Enforced by |
|---|---|---|
| any `contributte/*`, `nettrine/*`, `apitte/*` repository, or a project built on Contributte skeletons | **A — f3l1x** | `contributte/qa` (phpcs + Slevomat), `contributte/phpstan` (level 9 + strict rules) |
| any `nette/*`, `latte/*`, `tracy/*` repository, or a project built on `nette/web-project` | **B — dg** | Nette Coding Standard (`nette/coding-standard`, DressCode), `nette/code-checker`, PHPStan level 8 |

If nothing tells you which, default to **A** for Contributte work and **B** for Nette work. Section 1 is the cheat
sheet of the differences; sections 2 and 3 are the complete dialect descriptions; section 4 is the checklist.

## 1. The two dialects side by side

| Topic | A — f3l1x (Contributte) | B — dg (Nette) |
|---|---|---|
| First line | `<?php declare(strict_types = 1);` (spaces around `=`), 99.8% | `<?php declare(strict_types=1);` (no spaces), 100% |
| File docblock | none | `/** This file is part of the X (url) / Copyright (c) YEAR David Grudl (https://davidgrudl.com) */` in framework packages; none in apps and new tools |
| Blank lines: `use` block → class | 1 | 2 |
| Blank line after class `{` and before class `}` | yes, always (99.4%) | never |
| Blank lines between methods | exactly 1 (99.7%) | exactly 2 (97.7%) |
| Blank lines between properties | exactly 1 | 0 or 1 (1 before a documented member) |
| Class docblock | rare (17%), tags only (`@property-read stdClass $config`, `@template`) | on every class, one-sentence description ending with a period (84%) |
| Global classes | imported: `use stdClass;`, `use Throwable;`, `use LogicException;` | fully qualified: `\stdClass`, `\Throwable`, `\LogicException` |
| Global functions | bare (`count($a)`), no `use function` | imported once per file: `use function count, is_array, sprintf;` |
| Sibling namespace | full import per class | `use Nette;` then `Nette\Utils\Strings::...` in older code; per-class import in 2026 code |
| Constants | `UPPER_SNAKE` (enforced) | `PascalCase` (`Strings::TrimCharacters`); `UPPER` only as deprecated aliases |
| `new Foo` without args | `new Foo()` (enforced) | `new Foo` (enforced, no parentheses) |
| Arrow function | `fn ($x) => …` (space, enforced) | `fn($x) => …` (no space, enforced) |
| Trailing comma, multi-line array | required | required |
| Trailing comma, multi-line call / parameter list | optional, mostly absent in old code, present in 2025+ code | required |
| Multi-line ctor with promoted params | `)` newline `{` | `) {` on the same line |
| Multi-line method signature | `)` newline `{` | `): type` newline `{` |
| Nullable | `?T` (93%) | `?T` for one type, `A\|B\|null` for unions, null last |
| Exception messages | `sprintf('Service "%s" not found', $name)`; no interpolation (enforced) | `"Service '$name' not found."` interpolation; sprintf only for number formats |
| Exception base classes | own `LogicalException` / `RuntimeException` per library in `Exception/` | `Nette\InvalidStateException`, `Nette\InvalidArgumentException`, … from `exceptions.php` |
| `match` | practically unused (43 in 1,935 files); `switch`/`if` | used freely (205 in 779 files), `match (true)` for dispatch |
| Enums | none in libraries (0) | rare (15); constants in a `final class` preferred |
| `readonly class` | none | `final readonly class` for value objects |
| Numeric separators | forbidden (`1000000`) | used from 7 digits (`1_000_000`) |
| Method docblock layout | description, blank ` *` line, tags | description, no blank line, `@param  type  $x` with two spaces |
| PHPStan | level 9 + strict rules; `// @phpstan-ignore-line` inline | level 8; `ignoreErrors` in `phpstan.neon` with a reason comment; no inline ignores |
| Member order | consts → props → ctor → public → protected → private → magic (enforced) | traits → consts → props → ctor → methods in any order (helpers next to their caller) |
| Tests | `Toolkit::test(function (): void { … });` in `tests/Cases/*.phpt` | `test('title', function () { … });` in `tests/<Dir>/Class.aspect.phpt` |
| Commit subject | `Area: imperative lowercase phrase` (`Composer: require PHP 8.2`) | `added X` / `Class::method() past-tense phrase` (`requires PHP 8.2`) |
| Dev entry point | `Makefile` (`make qa cs csf phpstan tests`) | `composer phpstan`, `composer tester` |

---

## 2. Dialect A — f3l1x / Contributte

### 2.1 Toolchain (what enforces the style)

- `ruleset.xml` in the repository root extends `./vendor/contributte/qa/ruleset-8.2.xml` (or `-8.4.xml` for skeletons)
  and adds `SlevomatCodingStandard.Files.TypeNameMatchesFileName` with `src => Vendor\Package`, `tests => Tests`.
  `ruleset-8.x.xml` files differ only in `php_version`; all 185 sniffs live in `ruleset.xml`.
- `phpstan.neon` includes `vendor/contributte/phpstan/phpstan.neon` (phpstan-strict-rules, phpstan-nette,
  deprecation rules), `level: 9`, `phpVersion: 80200`, paths `src` and `.docs`.
- `make qa` = `make phpstan` + `make cs`; `make csf` auto-fixes; `make tests` runs Nette Tester over `tests/Cases`.
  phpcs runs over `src tests` with `--extensions="php,phpt"`: **test files obey every rule below too.**
- Consequences of strict rules at level 9 that shape the code: only real booleans in conditions (`if ($x !== null)`,
  never `if ($x)` on a nullable object, never `if (count($a))`), no `empty()`, no `==`, no short ternary `?:`,
  `in_array(..., true)`, no implicit array creation, no dynamic property or method names.

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
3. `use` block: one import per line, **alphabetical by full name, case-insensitive**, classes and `use function`
   sorted together, no blank lines inside, no grouping by vendor, no `use A\{B, C}`, no leading backslash, no
   unused imports (annotations count as usage). Global classes are **imported** (`use stdClass;`, `use Throwable;`,
   `use ReflectionClass;`, `use LogicException;`), never written `\stdClass` in code. Only when a class collides with
   its own name is the parent fully qualified: `class RuntimeException extends \RuntimeException`.
4. Aliases only to disambiguate, named vendor-prefix + name or role suffix: `use Nette\Http\IRequest as HttpRequest;`,
   `use Tracy\ILogger as TracyLogger;`, `use Nette\Utils\Arrays as NetteArrays;`,
   `use Doctrine\DBAL\Driver as DriverInterface;`.
5. Global functions are called bare (`sprintf(...)`, `count(...)`); `use function` appears in 57 of 1,935 files and is
   not the style. Never `\count(`.
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
	}

	protected function prepare(): void
	{
	}

	private function finish(): void
	{
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

- **`final` is not the default.** 25% of classes are `final`. Use `final` for: leaf exceptions, static utility
  classes (`Helpers`, `Regex`, `Caster`, `Uuid`, `BuilderMan`), DI helpers, decorators/value leaves, and code in the
  newest repositories (console-extra, logging, crafter, jsonrpc). Leave services, DI extensions, passes, presenters,
  mailers, panels and anything users may extend as plain `class`. Never `final` on Doctrine entities, DTOs or
  scaffold classes in skeletons. In documentation examples, user-land classes are shown `final`.
- Abstract classes: `Abstract*` (34%: `AbstractPass`, `AbstractEntity`, `AbstractHandler`, `AbstractRepository`) or
  `Base*` (13%: `BasePresenter`, `BaseModule`, `BaseResponse`, `BaseControl`); the rest carry a plain role name
  (`Command`, `Event`, `Plugin`, `JsonController`). Rule of thumb from the code: presenters, controllers, controls,
  modules → `Base*`; entities, repositories, passes, handlers, transformers → `Abstract*`. Never a trailing
  `Abstract`.
- Interfaces: **`I` prefix is the majority in libraries** (56%: `IHandler`, `IMiddleware`, `IRouter`, `IDispatcher`,
  `ILogger`, `IMailer`, `ICacheFactory`, `IController`). No prefix/suffix in the newest Nette-adjacent code
  (`ConnectionAccessor`, `FiltersProvider`, `Firewall`, `Serializer`) and in application code (`Queryable`). The
  `Interface` suffix is **forbidden** by the ruleset (`SuperfluousInterfaceNaming`); it appears only in
  `contributte/api` and `imagist`, which opt out. Constant-bag interfaces have no prefix (`RequestAttributes`).
  Interfaces are small, often a single method (`IRouter::match`, `IHandler::handle`, `ISerializer::serialize`).
- Traits: `T` prefix in application code and DI (`TId`, `TCreatedAt`, `TContainerAware`, `TReflectionProperties`) or a
  descriptive name (`ExtraRequestTrait`, `StructuredTemplates`). `Trait` suffix is tolerated only in the PSR-7
  package; do not add it to new code.
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
  `configure`. Booleans are `isX()` / `hasX()`, never `getIsX()`. A class with one natural value exposes `get()`;
  a collection exposes `all()`. DI hook names are fixed (see 2.11). Nette-side hooks: `createComponent*`, `action*`,
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
  (with `DI/Pass`, `DI/Helpers` or `DI/Utils`), `Exception` (singular; `Exceptions` only in 4 older repos) with
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
	public function __construct(
		private readonly Container $container,
		private readonly array $commandMap,
	)
	{
	}
```

1. Properties are always natively typed; `@var` docblocks only add generics (`/** @var AbstractPass[] */`,
   `/** @var array<string, string> */`) and are **one line** (enforced).
2. Visibility: `private` for state (60–72%), `protected` only in classes designed for subclassing (`CoreDispatcher`,
   `ServiceHandler`, `BasePresenter`), `public` only for Nette Schema config DTOs, request/response entities and
   mapping entities the library reflects (`public int $userId;`).
3. Promoted parameters are `private readonly` in leaf/value classes, `protected` (no `readonly`) in classes meant
   to be extended, `public` in DTO/command objects. Never `protected readonly`.
4. Multi-line parameter lists: one parameter per line, one tab deeper, `)` alone on its line at method indent, `{`
   on the next line. Promoted lists in 2025+ code end with a trailing comma; classic lists usually do not. A single
   promoted parameter stays on one line: `public function __construct(private readonly Mailer $mailer)`.
5. An empty constructor body is `{` newline `}`; a private constructor with no work carries `// Use self::create()`;
   other intentionally empty methods carry `// Nothing to register`, `// No-op`, `// Override in child`,
   `// Nothing` (an empty body without a comment is a phpcs error).
6. Nullable optional dependencies come last with `= null` and are resolved with `??`:
   `$this->serializer = $serializer ?? new DefaultSerializer();`.
7. `readonly class` is never used; `readonly` is per property, on promoted params only, never on classic
   declarations.
8. `new static()` is used together with a class docblock `@phpstan-consistent-constructor`;
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
  constants, `final const`, intersection types, named arguments in calls (1 use), first-class callable syntax (2
  uses). Use constants for fixed sets and `switch`/`if` for dispatch. (Skeleton apps contain one enum; treat enums
  as allowed but exceptional.)
- Attributes used: `#[AsCommand(name: 'nette:cache:purge', description: 'Clear temp folders')]` (multi-line with
  named args and trailing comma when 2+ args), `#[Inject]` on public presenter properties, `#[Attribute(...)]`
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
   `@see`, `@template`, `@param`…, `@return`, `@throws`. A docblock with a single tag is written on one line
   (`/** @var Foo[] */`, `/** @internal */`, `/** @phpstan-consistent-constructor */`) — required for properties.
4. Class docblocks (17%): tags only — `@property-read stdClass $config` or `@method stdClass getConfig()` on DI
   extensions, `@template`/`@implements`/`@extends`, `@phpstan-type`/`@phpstan-import-type`,
   `@phpstan-consistent-constructor`, `@internal`, `@see <upstream url>`, `@method` (Doctrine repositories),
   `@mixin BasePresenter` on presenter traits, `@copyright` only when crediting ported code. One-line prose
   summaries are rare (`File download response from PSR7 stream.`). Never `@author`, `@package`, `@since`,
   `@version`, `@todo`, `@license` (forbidden by the ruleset).
5. `@inheritDoc` (this spelling in current code; `{@inheritdoc}` is older) as the whole docblock when an override
   narrows a return type or implements a framework interface with generics.
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
2. **Blank line before `return`, `throw`, `continue`, `break`** (enforced `JumpStatementsSpacing`) unless it is the
   first statement in the block or directly follows a `//` comment. Blank line after every block (`if`, `foreach`,
   `try`) before the next statement (enforced). No blank line as the first or last line of a method body.
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

6. `match` is essentially unused; `switch` (37 uses) has a blank line before every `break;` in current code.
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
11. Increment `++$i`/`$i++` both fine; `$x += 1` not `$x = $x + 1` (enforced).
12. Destructuring `[$a, $b] = …` (never `list()`); by-reference parameters and `use (&$x)` are forbidden by the
    ruleset (repositories that need them exclude `DisallowReference`).

### 2.9 Strings, arrays, formatting

1. Single quotes (97%). Double quotes only for escape sequences (`"\n"`) or to contain an apostrophe
   (`"Bus '%s' not found"`, `"I'm info command"`). **Never interpolation** (`"Hello $x"` is a phpcs error: use
   `sprintf`). Values in messages go through `sprintf` with `"%s"` (double quotes inside the single-quoted PHP
   string) — see 2.10. Concatenation ` . ` with one space each side; string literals are never concatenated to each
   other on one line (enforced). Heredoc is forbidden; nowdoc `<<<'NEON'` is used in tests and `Expect` helpers.
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

1. Every library has its own roots `LogicalException` (extends SPL `LogicException`, imported with
   `use LogicException;`) and `RuntimeException` (extends `\RuntimeException`, fully qualified because the short
   names collide). The directory is `Exception/` (12 repos; `Exceptions/` in doctrine-dbal, event-dispatcher,
   event-dispatcher-extra, logging, scheduler — keep whatever the repository already uses). Small libraries throw
   the two roots directly and may make them `final` (doctrine-dbal, doctrine-orm, event-dispatcher have no leaves);
   libraries with leaves keep the roots plain (messenger, console, di, nella) or `abstract` (apitte, logging).
   Leaves live in `Exception/Logical/` and `Exception/Runtime/` (or `Exception/Logic/`), are `final` when
   library-internal, and have **empty bodies** (86%). Never add a leaf under a `final` root; reuse the root.
2. Programmer/config errors → `LogicalException` (or `InvalidStateException`, `InvalidArgumentException` leaves);
   environment/IO/runtime failures → `RuntimeException` leaves. Inside DI extensions, invalid configuration and
   wiring problems throw the library `LogicalException` by default (messenger, doctrine-orm, latte); Nette's
   `ServiceCreationException` / `MissingServiceException` are used when the extension already throws them
   (event-dispatcher, console) or when the problem is a missing/invalid service definition. Match the file you are
   editing. Attribute classes throw the SPL `InvalidArgumentException` imported with `use InvalidArgumentException;`.
3. Messages: capitalised complete phrase, values quoted with double quotes via `sprintf`, class names via `::class`,
   trailing period optional (40% have one; be consistent inside a file):

   ```php
   throw new LogicalException(sprintf('Connection "%s" not found', $connectionName));
   throw new InvalidStateException(sprintf('Cannot get undefined logger "%s".', $name));
   throw new LogicalException(sprintf('Service of type "%s" is needed. Please register it.', Foo::class));
   throw new LogicalException('Second level cache is enabled but no cache is set.');
   throw new InvalidArgumentException('Empty #[Path] given');
   ```

   AGENTS.md rule: "Exception messages must be explicit — tests assert on them."
4. Static factories (messenger, bus, api) when an exception carries data: named after the situation, `sprintf` the
   message, set public typed properties, `return $exception;` after a blank line. Call site: `throw
   BusException::busNotFound($name);`.

   ```php
   final class ContainerException extends LogicalException
   {

   	public string $service;

   	public static function serviceNotFound(string $id): self
   	{
   		$exception = new self(sprintf("Service '%s' not found", $id));
   		$exception->service = $id;

   		return $exception;
   	}

   }
   ```

5. Alternatively the message is built in a constructor that takes the offending value:
   `public function __construct(string $type) { parent::__construct(sprintf('Class "%s" does not exist', $type)); }`.
6. API exceptions (apitte/api) use a fluent trait: `ClientErrorException::create()->withMessage('User not
   found')->withCode(404)`; constructor order `(string $message = '', int $code = 400, ?Throwable $previous = null,
   mixed $context = null)`; HTTP status constants from Nette (`IResponse::S404_NotFound`).
7. Wrapping: `throw new CacheException($e->getMessage(), $e->getCode(), $e);`. PSR adapter exceptions take only
   `Throwable $previous` and copy message and code from it.
8. No `@throws` on ordinary methods.

### 2.11 DI extension (the core Contributte artefact)

Canonical skeleton, valid under `contributte/qa`:

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
			Expect::string()->required()->assert(static fn (mixed $input): bool => is_string($input) && (str_starts_with($input, '@') || class_exists($input))),
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
				->addTag(self::BAR_TAG, ['name' => $name]);
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

		foreach ($builder->findByTag(self::BAR_TAG) as $serviceName => $tag) {
			$map[$tag['name']] = $serviceName;
		}

		return $map;
	}

}
```

Rules and idioms:

1. Name `<Concern>Extension`, in namespace `<Root>\DI`, extending `Nette\DI\CompilerExtension`. Not `final` by default
   (14 of 45 are; newest ones are). Config is typed through the class docblock: `@property-read stdClass $config`
   and read as `$this->config` (majority, doctrine-dbal/orm/mail/http/latte/cache) or `@method stdClass getConfig()`
   with `$this->getConfig()` (console, event-dispatcher). `stdClass` is imported.
2. Hook order in the file is fixed: `getConfigSchema()`, `loadConfiguration()`, `beforeCompile()`,
   `afterCompile(ClassType $class)`, then private helpers. Hook docblocks are the fixed one-liners `Register
   services` and `Decorate services`; `afterCompile` usually has none. Extensions without options omit
   `getConfigSchema()`.
3. First two lines of every hook body: `$builder = $this->getContainerBuilder();` and `$config = $this->config;`
   (builder first).
4. Schema is `Expect::structure([...])` returned inline; defaults as the scalar argument (`Expect::bool(false)`,
   `Expect::int(20)`), `->required()`, `->nullable()`, `->dynamic()` for values that may be `%parameters%`,
   `->castTo('array')` on nested structures consumed as arrays, `->assert(fn, 'message')` for inline validation.
   Keys are camelCase (`failureTransport`, `defaultMiddlewares`) unless mirroring an upstream option name.
   Reusable fragments live in local variables and are reused with `(clone $expectService)`; the recurring
   "service or class" type is `string|Statement`. Environment-dependent defaults come from a constructor argument
   (`bool $debugMode`, `bool $cliMode`) passed from NEON as `%debugMode%` / `%consoleMode%`.
5. Service definitions: `$builder->addDefinition($this->prefix('name'))` followed by chained calls one per line.
   Prefer `setFactory(X::class, [args])` over `setType()`; `setType()` only when there is no factory. Internal
   services get `->setAutowired(false)` (61 of 70 `setAutowired` calls); only the `default` instance of a
   multi-instance service is autowired (`->setAutowired($name === 'default')`). Ids are literal dotted camelCase
   (`'bus.container'`, `'transportFactory.inMemory'`) or `sprintf('managers.%s.entityManager', $name)`; never
   concatenation. References to other services are `$this->prefix('@bus.container')` (the `@` inside `prefix`),
   or `'@container'`, `'@self'`; `Reference` objects are not used. Setup calls with placeholders:
   `->addSetup('?->addEventListener(?, ?)', ['@self', $event, $listener])`.
6. Tags are `*_TAG` constants; payload is an array (`['name' => $name]`) or a bare string; consumers use
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
8. **"Service or class" config values are never resolved by hand.** The schema validates the shape
   (`Expect::string()->assert(static fn (mixed $input): bool => is_string($input) && (str_starts_with($input, '@')
   || class_exists($input) || interface_exists($input)))` or `Expect::anyOf(Expect::string(), Expect::type(Statement::class))`)
   and the value is passed straight to Nette DI as `new Statement($value)` — the doctrine/messenger helper
   `SmartStatement::from(mixed $service): Statement` (string → `new Statement($string)`, `Statement` → itself, else
   `throw new LogicalException('Unsupported type of service')`) — or as a factory/setup argument; Nette DI resolves
   `@name` references and autowires class names itself. No `str_starts_with($x, '@')` + `substr()` +
   `hasDefinition()` + `getByType()` ladders in extensions (the only `str_starts_with(..., '@')` in the reference
   repos is inside schema assertions and one serializer-name normaliser). PHPStan level 9 note:
   `$builder->getByType()` / `getDefinitionByType()` take `class-string`, so pass `Foo::class` literals; dynamic
   strings go through `Statement`.
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

### 2.12 Library architecture and design habits

- **Composition over inheritance**: decorators wrap an interface and delegate (`TraceableMailer`, `DebugDispatcher`,
  `LoggableStorage`, `DebugMiddleware`); inheritance is used to extend framework bases (`extends Command`,
  `extends CompilerExtension`, `extends AbstractManagerRegistry`, `extends NetteDateTime`).
- **"Collect + run" managers**: a class holds `/** @var IValidation[] */ private array $validators = [];`, exposes
  `add(IValidation $validator): void` and iterates in `validate()`; DI wires it with `->addSetup('add', [$def])` in
  a loop. Pipelines reduce with `foreach ($this->decorators as $decorator) { $request = $decorator->decorate($request); }`.
- **Static utility classes**: `final class Helpers` / `Regex` / `Caster` / `Uuid`, all `public static`, stateless, no
  private constructor, in namespace `Utils`. `Regex::match()` wraps `preg_match` and returns `null` instead of
  `false`. Name triples in `Caster`: `xOrNull()`, `ensureX()`, `forceX()`. Getter naming: `get()` for the single
  value, `all()` for the array.
- **Value objects**: getter-only classes with promoted private props, `fromArray(array $data): self` +
  `toArray(): array` symmetry with null-skipping serialization; `__toString()` via `sprintf`. Setters on DTO/entity/
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
- **Nette UI components** (`Control` subclasses): `createComponent*()` methods (protected), `render()` sets
  `$this->template->setFile()` and `->render()`, `handle*()` signals, templates in `templates/` next to the class,
  `I*Factory` interfaces with `create()` generated by DI (`addFactoryDefinition()->setImplement(...)`).
- **Whimsy and terseness**: short class names (`Nella`, `Expecto`, `BuilderMan`), short variable names, methods of
  4–10 lines (median 6), files of 30–60 lines (median 35).

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
   `SecuredPresenter` / `UnsecuredPresenter` → `final class HomePresenter`. Dependencies via `#[Inject] public
   Foo $foo;` (one blank line between injected props) or constructor injection; never `@inject` in new code.
   Methods `action*`, `render*`, `handle*` (signals), `protected function createComponent*()`, `process*Form`
   callbacks; flash + redirect idiom `$this->flashMessage('Saved'); $this->redirect('this');`; template variables
   assigned dynamically (`$this->template->users = $users;`). No typed `*Template` classes, no `I*Factory`
   component factories in skeletons.
3. Doctrine entities: plain `class` (never final), `#[ORM\Entity(repositoryClass: UserRepository::class)]`,
   `#[ORM\Table(name: '`user`')]`, one attribute per line, `#[ORM\Column(type: 'string', length: 255, nullable:
   false)]` with string type names, `private` typed properties with `?T = null`, traits `TId`, `TCreatedAt`,
   `TUpdatedAt`, constructor takes required fields and sets defaults, domain mutators named by intent
   (`activate()`, `block()`, `changeUsername()`, `rename()`), simple `getX()`/`setX(): void`, `isActivated(): bool`.
   Repositories `final class UserRepository extends AbstractRepository` with `/** @extends AbstractRepository<User> */`,
   custom finders `findOneByEmail()`; `EntityManagerDecorator` extends Doctrine's decorator.
4. Facades `<Plural>Facade` / `<Verb><Noun>Facade` hold `$em` and return DTOs (`UserResDto::from($entity)`); commands
   and handlers under `App\Domain\<Aggregate>` (`#[AsMessageHandler] final class CreateUserHandler`, `__invoke`).
5. Console commands: `#[AsCommand(name: self::NAME)] final class InfoCommand extends Command` with `public const NAME
   = 'app:info';`, `configure()` (`setName`, `setDescription`), `execute(InputInterface $input, OutputInterface
   $output): int` returning `0`.
6. Security: `UserAuthenticator implements Authenticator` with an `if/elseif` throw ladder and Nette 3.2
   PascalCase constants (`self::IdentityNotFound`); `SecurityUser extends Nette\Security\User` registered as
   `security.user`; `Identity extends SimpleIdentity`.
7. Exceptions in apps mirror libraries: `App\Model\Exception\{LogicException,RuntimeException}` roots →
   `Logic\*`, `Runtime\*` final leaves.
8. NEON (tabs; `# ====` banner comments in Nella-era configs; section order `php` → `parameters` → `extensions` →
   extension blocks → `services`): services as anonymous list entries `- App\Domain\User\CreateUserFacade`, named only
   when overriding framework services (`security.user: App\Model\Security\SecurityUser`, `router: … factory:
   @App\Model\Router\RouterFactory::create`); extension keys dotted with vendor (`nettrine.dbal`, `contributte.console`)
   in new skeletons, short (`console`, `monolog`) in older ones; parameters `%appDir%`, `%tempDir%`, `%debugMode%`,
   `%consoleMode%`; constants via `::constant(Foo::BAR)`.
9. Latte: `@layout.latte`, `{block #content}` in f3l1x scaffolds (`{block content}` in community demos),
   `{include #content}`, `{block #title|striptags}…{/}`, n:attributes over tag pairs (`n:if`, `n:href`, `n:class`,
   `n:inner-foreach`, `n:name`), `{=date(Y)}`, `{$basePath}`, loop variable `$_user`; tabs.
10. Root files: `Makefile` with `#####` banner sections (`PROJECT`, `DEVELOPMENT`, `DOCKER`, `DEPLOYMENT`) and
    targets `project init install setup clean qa cs csf phpstan tests coverage dev build docker-up deploy`
    (`qa: cs phpstan`, `dev: NETTE_DEBUG=1 NETTE_ENV=dev php -S 0.0.0.0:8000 -t www`); `ruleset.xml` extending
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
		->withCompiler(static function (Compiler $compiler): void {
			$compiler->addExtension('foo', new FooExtension());
			$compiler->addConfig(Neonkit::load(<<<'NEON'
				foo:
					bars:
						default:
							factory: Contributte\Foo\Bar
			NEON));
		})->build();

	Assert::type(Bar::class, $container->getByType(Bar::class));
	Assert::count(1, $container->findByTag(FooExtension::BAR_TAG));
});

// Invalid config
Toolkit::test(function (): void {
	Assert::exception(static function (): void {
		ContainerBuilder::of()
			->withCompiler(static function (Compiler $compiler): void {
				$compiler->addExtension('foo', new FooExtension());
				$compiler->addConfig(Neonkit::load(<<<'NEON'
					foo:
						unknown: 1
				NEON));
			})->build();
	}, InvalidConfigurationException::class, "Unexpected item 'foo › unknown'.");
});
```

1. Header identical to `src` files; `namespace Tests\Cases\<Dir>;` mirrors the path (present in ~52% of files; the
   rest are global; be consistent inside a repository). `use` block alphabetical, then
   `require_once __DIR__ . '/../../bootstrap.php';` **after** the imports, then tests. Test files are phpcs-checked.
2. Each test is `Toolkit::test(function (): void { … });` preceded by a one-line `// Description` comment (74% of
   calls) and separated by a blank line. `static function` is chosen per repository (bus, di, monolog, nella); inner
   callbacks are commonly `static function (Compiler $compiler): void`. No test names, no docblocks, no `@testCase`.
3. Assertions: expected first. `Assert::same` / `Assert::equal` split by repository (`equal` for arrays and objects
   in doctrine/bus/middlewares, `same` in messenger/apitte/mail); `Assert::type(Foo::class, $x)` for services;
   `Assert::count`, `Assert::true`/`false`, `Assert::null`, `Assert::contains`;
   `Assert::exception(callable, Class::class, 'exact message')` (messages asserted verbatim, Nette Schema
   messages including the `›` glyph; `sprintf` or `~regex~` when parts vary); `Assert::true(true)` as "did not
   throw". Comments between asserts explain intent.
4. Containers are built with `ContainerBuilder::of()->withCompiler(fn)->build()` from `contributte/tester` and
   inline nowdoc NEON via `Neonkit::load(<<<'NEON' … NEON)`; messenger uses a per-repo `Tests\Toolkit\Container::of()
   ->withDefaults()->withCompiler(…)->build()` with `Helpers::neon()`. Legacy raw `ContainerLoader` + `FileMock`
   with numeric keys is not written anymore. Typical DI assertions: service type, laziness (`isCreated`), counts of
   `findByType`, tags, parameters, exact `InvalidConfigurationException` message.
5. Narrowing in tests uses `/** @var Foo $x */` above `$container->getByType()` (438 uses) rather than `assert()`.
6. Fixtures: `final class Dummy*` / `Fake*` / `Foo*` / `Simple*` / `Invalid*` with public properties, `// Nothing`
   or `// For tests` bodies, attributes as in real code; autoloaded via `autoload-dev` `"Tests\\": "tests"`.
   Hand-written fakes are preferred over Mockery; when Mockery is used: `use Mockery;`, `Mockery::mock(Foo::class)`
   chained one expectation per line (`->once()->with(...)->andReturn(...)`), variables named after the role
   (`$dispatcher`, not `$mock`), `Toolkit::tearDown(static fn () => Mockery::close());` once per file.
7. `Tester\TestCase` classes only for data-provider scenarios and multi-step E2E flows: `final class XTest extends
   TestCase`, `public function testX(): void`, `public function setUp(): void { parent::setUp(); }`,
   `/** @dataProvider provideCases */` + `public function provideCases(): iterable`, file ends with
   `(new XTest())->run();`; scenario data in `__files__/*.neon`. Files may be `.php` (`*Test.php`) or `.phpt`.
8. Temp files go to `Environment::getTestDir()`; `Environment::skip('MySQL is not running')` for optional
   infrastructure; SQLite `:memory:` for DBAL/ORM E2E tests.
9. `make tests` = `vendor/bin/tester -s -p php --colors 1 -C tests/Cases`; coverage with `--coverage coverage.xml
   --coverage-src src`. `tests/.gitignore` ignores `*.expected`, `*.actual`, `/tmp`, `/*.log`, `/*.html`. No
   `tests/php.ini`.
10. PHPUnit appears only in `qa`, `aop`, `forms-bootstrap`, `codeception`: `class XTest extends TestCase`,
    `testX(): void`, static `self::assertSame()`, `#[DataProvider('provideX')]` + `public static function
    provideX(): Generator`.

### 2.15 Repository conventions

- **composer.json** (2-space JSON): key order `name, description, keywords, type, license, homepage, authors,
  require, require-dev, [conflict], [suggest], autoload, autoload-dev, minimum-stability, prefer-stable, config,
  extra`. `"license": "MIT"`, `"homepage": "https://github.com/contributte/<repo>"`, one author
  `{"name": "Milan Felix Šulc", "homepage": "https://f3l1x.io"}` (no email), `"php": ">=8.2"` (never a range),
  full three-part caret versions (`"nette/di": "^3.1.8"`), `~0.x.y` for 0.x Contributte tooling
  (`"contributte/qa": "~0.4.0"`, `"contributte/tester": "~0.4.0"`, `"contributte/phpstan": "~0.3.0"`),
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
- **LICENSE** file (no extension), MIT, `Copyright (c) <year> Contributte`.
- **README.md** is a fixed template: heatbadger banner, two `<p align=center>` rows of badgen badges (GitHub checks,
  codecov, packagist dm/v; php, license, gitter, forum, sponsor), the `Website 🚀 … | Contact 👨🏻‍💻 … | Twitter 🐦 …`
  line, `## Usage` (`composer require contributte/foo`), `## Documentation` ("For details on how to use this
  package, check out our [documentation](.docs)."), `## Versions` table `| State | Version | Branch | Nette | PHP |`
  with `dev` / `stable` rows (`` `^0.7` `` / `` `master` `` / `3.2+` / `` `>=8.2` ``), `## Development` ("See [how
  to contribute](https://contributte.org/contributing.html) to this package." + maintainer avatar), `-----`, and the
  support footer.
- **.docs/README.md**: `# Contributte <Name>`, one-sentence intro, `## Content` bullet TOC, `## Setup`
  (`composer require` in ```` ```bash ```` + `extensions:` registration in ```` ```neon ````), `## Configuration`
  (`### Minimal configuration`, `### Advanced configuration` = annotated NEON tree with `<type>` placeholders and
  `# optional` comments), `## Usage`, `## Examples`; GitHub alerts `> [!NOTE]` / `> [!TIP]`; user-land PHP examples
  shown as `final class`. `.docs` is analysed by phpstan, so PHP fences must be valid.
- **CI**: four thin callers in `.github/workflows/{tests,phpstan,codesniffer,coverage}.yml` (2-space YAML,
  double-quoted strings) using `contributte/.github/.github/workflows/<name>.yml@master` with `php: "8.4"`, jobs
  `test85`, `test84`, `test83`, `test82`, `testlower` (`--prefer-lowest`), weekly cron `"0 8 * * 1"`,
  `workflow_dispatch`; every workflow runs `make <target>`.
- **Versioning**: single `master` branch; tags `vMAJOR.MINOR.PATCH`; after a release, commit `Composer: open v0.N.x`
  bumping `branch-alias` and the README `dev`/`stable` rows. 0.x minor = BC break.
- **Commits**: `Area: imperative lowercase phrase`, no period, no body, no emoji, no conventional-commit type.
  Areas: `Composer`, `Tests`, `Readme`, `Docs`, `CI`, `QA`, `Makefile`, `DI`, `Refactor`, `Feature`, `Code`,
  `Extension`, `Phpstan`, `Codesniffer`, `Versions`, `AI`, or the class/feature name (`Bus:`, `Transports:`,
  `ManagerRegistry:`). Examples: `Composer: require PHP 8.2`, `Tests: cover more handlers usecases`, `DI: introduce
  passes (no more multiple extensions)`, `Readme: clarify autoconfiguration [#99]`, `Annotations: unlock
  doctrine/annotations v2 [closes #196]`, `Composer: open v0.3.x`, `AI: init`. Issue refs `[#N]` / `[closes #N]` at
  the end. AI commits are authored as `Contributte AI <ai@f3l1x.io>` and use the same form.
- **AGENTS.md** (messenger, qa; `CLAUDE.md` containing `@AGENTS.md`): sections Stack, Codebase, Architecture, Code
  Style, Testing, Conventions; "Always run `make cs phpstan tests` and fix all errors."

### 2.16 Do not (f3l1x)

- No `declare(strict_types=1)` without spaces; no `declare` on its own line; no closing tag.
- No `match`, enums, `readonly class`, `never`, `#[Override]`, typed constants, named arguments for ordinary data,
  first-class callable syntax as a habit.
- No `\Foo` for global classes in code; no `\count()`; no `use function` as a habit; no `use Nette;` root import.
- No interpolated strings, no `printf`, no positional `%1$s`, no heredoc, no numeric separators, no aligned `=>`.
- No `==`, `!=`, Yoda, `empty()`, `is_null()`, `else if`, `?:`, `list()`, `array()`, brace-less `if`.
- No `//` comment glued above a member; no `#` or `/* */` comments; no `@author`, `@package`, `@since`,
  `@version`, `@todo`; no `@return void`; no docblock repeating native types; no multi-line `@var` on properties;
  no `@throws` on ordinary methods; no baseline files.
- No `final` on entities, DTOs, extensions/passes/services by default; no `Interface`/`Trait` suffix on own types;
  no `protected readonly`; no `readonly` on classic property declarations.
- No `assert()` for input validation; no `else` after `return`/`throw`; no blank line as first/last line of a body;
  no missing blank line before `return`.
- No test names/docblocks on `Toolkit::test`; no `tests/php.ini`; no committed `expected` outputs; no `$mock`
  variable names; no PHPUnit in libraries.
- No `Felixbot`, no trailers, no `Co-Authored-By`, no commit bodies, no `feat:`/`fix:` prefixes.

---

## 3. Dialect B — dg / Nette

### 3.1 Toolchain

- Nette Coding Standard: the rules live in DressCode's `dresscode/nette` preset (`nette/coding-standard` v4 only adds
  optional presets `nette/clean-code`, `nette/optimize-fn`, `nette/types`); older repositories still carry `ncs.xml`
  / `ncs.php` for the v3 `ecs` runner. CI runs `nette/code-checker --strict-types` and `nette/coding-standard`'s
  `ecs check` over `src` and `tests` (both created via `composer create-project` into `temp/`).
- PHPStan level 8 (never 9), no strict-rules package, `nette/phpstan-rules` for Nette-aware precision;
  `phpstan.neon` analyses `src` only, every `ignoreErrors` entry carries a `# reason` comment and an `identifier`.
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
   `… the Nette Tester.`; second line `Copyright (c) YEAR David Grudl (https://davidgrudl.com)`). Applications,
   skeletons and new tools (mcp-inspector, xray, web-project, assets) have none. Copy the header of the repository
   you are in.
3. Blank lines: one between `declare` and the docblock, one before and after `namespace`, none inside the `use`
   block, **two** between the `use` block (or `namespace`) and the class docblock.
4. `use` block, in this order with no blank lines between kinds: class imports alphabetically (case-insensitive,
   `use Nette;` first because shortest), then **one** `use function a, b, c;` line (alphabetical, comma-separated,
   however long; 400-character lines are normal), then one `use const A, B;` line. Import the functions PHP can
   optimise (`count`, `strlen`, `is_*`, `in_array`, `sprintf`, `implode`, `array_*`, `preg_*`, …) — the newest code
   imports every native function it calls. Group use `use Foo\{A, B};` only where a repository already does it.
5. Global classes are **not** imported: write `\stdClass`, `\Closure`, `\Throwable`, `\LogicException`,
   `\ReflectionClass`, `\Generator`, `\DateTimeInterface` in code (582 vs ~5 imports). Sibling packages are reached
   through the root import `use Nette;` and written `Nette\Utils\Strings::…`, `Nette\InvalidStateException` (99 of
   203 core files); partial imports `use Nette\DI;` → `new DI\Compiler` are common. 2026 tools import each class
   individually instead; both are accepted, follow the file. Aliases are rare and only shorten long namespaces
   (`use Nette\PhpGenerator as Php;`, `use Latte\Runtime as LR;`).
6. Global functions are bare (never `\count()`).
7. Several declarations per file are allowed for exception families (`src/<Pkg>/exceptions.php`), enums
   (`enums.php`), compatibility shims (`compatibility.php`, `compatibility-intf.php`) and namespaced functions
   (`functions.php`), each declaration separated by two blank lines; composer autoload is `classmap: ["src/"]` plus
   `psr-4`.
8. Tabs everywhere (PHP, Latte, NEON, PHTML). Markdown code samples use 4 spaces only in docs. Line length: no hard
   limit (DressCode reports at 140); 92% of lines are ≤ 80, long `throw` lines of 130–180 columns are normal;
   wrap chains and ternaries by feel at 100–120.

### 3.3 Class layout

```php
/**
 * Paginating math.
 */
class Paginator
{
	use Nette\SmartObject;

	public const
		Priority = 'priority',
		Expire = 'expire';

	#[\Deprecated('use Cache::Priority')]
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
2. Member order (DressCode `ordered-members`): trait `use` lines (then one blank line) → constants (public,
   protected, private) → properties (public, protected, private) → **two blank lines** → constructor → methods.
   Methods are **not** sorted by visibility: a private helper sits right below the public method that calls it;
   `getIterator()` last in iterable classes.
3. **Exactly two blank lines between methods** (97.7%; one blank line only inside interfaces). Between constants
   or properties of one group: 0 blank lines; one blank line before a member that has a docblock or attribute, and
   between visibility groups.
4. Constants: `public const` once, then one constant per line, comma-separated, `;` after the last
   (`public const\n\tAssocLeft = -1,\n\tAssocNone = 0;`); PascalCase names (`TrimCharacters`, `S404_NotFound`,
   `Token::Latte_TagOpen` with an underscore for category prefixes); UPPER_SNAKE survives only as deprecated aliases
   directly below (`#[\Deprecated('use Cache::Priority')] public const PRIORITY = self::Priority;`). Never typed
   constants, never `final const`.
5. Modifier order `final public function`, `public static function`, `abstract public function`. `final` on
   individual methods freezes invariants in extensible base classes (`final public function getRequest()`).
6. Interface methods carry **no `public`** and one blank line between them (33 of 38 core interfaces); newest
   packages write `public function` — follow the file.
7. Section banners in long classes (≥ 400 lines), lowercase, with dg's signature, two blank lines before and after:

   ```php
	/********************* interface IPresenter ****************d*g**/
   ```

8. Properties are typed, defaults inline, `public` for configuration and DTO/AST data (`public ?string $directory =
   null;`, `Debugger::$maxDepth`, Latte nodes), `private` for state, `protected` only on explicit extension points.
   No `SmartObject` in new classes (11 of 261 files, all old magic-property classes); `use Nette\StaticClass;` as the
   first line of a static utility class.

### 3.4 Declarations and naming

- **`final`**: internals, value objects, responses, attributes, DI extensions, helpers and everything in new
  repositories are `final` (~37% overall; mcp-inspector, xray, assets ≈ 100%). Public building blocks meant to be
  extended stay open: `Presenter`, `Control`, `Component`, `Form`, `Route`, `Engine`, `Logger`, `Debugger`,
  `Assert`, `TestCase`, `Strings`, `Arrays`, `Container`, `Compiler`, every Latte tag/expression node.
- **No kind in the name** (enforced by the standard): no `I` prefix, no `Abstract` prefix, no `Interface`/`Trait`
  suffix. Interfaces are capability nouns/adjectives: `Response`, `Renderable`, `Authenticator`, `Storage`,
  `Mailer`, `Router`, `Loader`, `Policy`, `Schema`, `Adapter`, `HtmlStringable`. Implementations use a concrete
  adjective: `SessionStorage`, `SimpleAuthenticator`, `FileStorage`, `SendmailMailer`. Abstract classes are plain
  nouns (`Definition`, `Node`, `Component`, `CompilerExtension`). Traits: `StaticClass`, `SmartObject`,
  `TagParserData`, `*Aware` (`NameAware`, `CommentAware`). Kept deliberately with `I`: `IPresenter`,
  `IPresenterFactory`, `IRequest`, `IResponse`, `IIdentity`, `IComponent`, `IContainer`, `IBarPanel`, `ILogger`;
  reference them as they are.
- Renames keep BC with `interface_exists(IOld::class);` two blank lines after the new interface and a
  `compatibility-intf.php` block: `if (false) { /** @deprecated use X */ interface IOld extends New {} } elseif
  (!interface_exists(IOld::class)) { class_alias(New::class, IOld::class); }`.
- `@internal` marks "public for technical reasons": `/** @internal */` above `final class Helpers`, or as the last
  tag of a method docblock. Never `#[Internal]`.
- Enums: rare (15 in 779 files), PascalCase cases, string-backed for wire values (`enum SameSite: string`), pure for
  flags, no methods, may live in `enums.php`; a fixed set is otherwise a constant group in a final class
  (`ContentType`, `Token` types). `final readonly class` for immutable value objects (`Type`, `Token`, `Position`,
  `IPAddress`).
- Static utility classes are named plural: `Helpers`, `PhpHelpers`, `NodeHelpers`, `HtmlHelpers`, `Filters`,
  `Passes`, `Tasks`, `Validators`, `Strings`, `Arrays`, `Callback`, `Json` (with `use Nette\StaticClass;` or a
  `final public function __construct() { throw new \LogicException; }` guard).
- Methods camelCase; `get`/`set`/`is`/`has`/`add`/`remove`/`create`/`parse`/`print`/`render`/`format`/`validate`/
  `resolve`/`generate`/`find`/`fetch`/`try*`/`with*`. `try*` returns `null` instead of throwing (`tryPeek`,
  `tryConsume`, `tryGetAsset`). Booleans `isX()`/`hasX()`. Toggles take `bool $state = true`
  (`setVariadic(bool $state = true)`, `required(bool $state = true)`). DSL-style fluent methods without `set`
  prefix in Schema/DI (`->default()`, `->required()`, `->castTo()`, `->tag()`, `->lazy()`). Internal DI hook methods
  prefixed `do` (`doRegisterExcludedClasses`). Static constructors: `from()`, `fromString()`, `fromReflection()`,
  `fromParts()`, `create()`, `parse()`, `el()`; never `of()`.
- Variables short and idiomatic: `$res`, `$tmp`, `$s`, `$m` (regex matches), `$e`, `$rc`/`$rm`/`$rp` (reflection),
  `$dolly` (the clone in `with*()`), `$def`, `$pos`, `$k => $v`, `$i`.
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
2. Every other multi-line signature ends `): Type` on its own line and puts `{` on the next line. Single-line
   signatures (≤ ~117 columns) keep `{` on the next line too. `#[\SensitiveParameter]` on its own line before the
   parameter forces the multi-line form.
3. Classic assignment constructors remain in classes with initialisation logic (`Cache`, `Selection`, `Route`,
   `Bootstrap`, Tracy `Value`).
4. Docblocks on promoted parameters go inline above the parameter (`/** @var list<Message> */` or a one-line
   description), never as `@param` on the constructor.
5. Configuration that callers tweak is a public property with a default, set directly (`$logger->directory = …`),
   not a constructor argument.
6. Presenters have **no constructor**; dependencies arrive through `final public function injectPrimary(...)`.

### 3.6 Types

- Everything is typed; `mixed` is used freely (`mixed $value`, `: mixed`); untyped only where a contract forbids
  (`offsetSet($index, $value)`, `__call`).
- Nullable: `?T` for one type (never `T|null` for a single type: 0 hits); `A|B|null` with `null` **last** for
  unions (`string|Stringable|null $label = null`, `string|int|\DateTimeInterface|null`); `false` also last
  (`static|false`). Defaults `?T $x = null`; implicit nullable never.
- Return types always, including `: void`; **fluent setters and withers return `static`** (`: static` 526 vs
  `: self` 77); `: self` only for named constructors on final/readonly value objects; `: never` for methods that
  always throw or exit (`terminate()`, `redirectUrl()`, `error()`, `throwUnexpectedException()`).
- Immutable objects: `with*(): static` cloning into `$dolly` (`$dolly = clone $this; $dolly->url = $url; return
  $dolly;`); mutable counterparts have setters.
- Named arguments label boolean/flag literals only: `in_array($x, $list, strict: true)`, `getComponent($name,
  throw: false)`, `microtime(as_float: true)`, `class_exists($c, autoload: false)`, `var_export($x, return:
  true)`, `previous: $e`; never for ordinary positional data.
- First-class callables `foo(...)` are preferred over `[$this, 'foo']`: `'n:href' => LinkNode::create(...)`,
  `$this->factory = $factory(...)`, `array_map(strval(...), $x)`.
- Conditional return docs for `bool $throw` parameters: `@return ($throw is true ? T : ?T)`.
- Regex delimiters `#…#` (or `~…~`), `D` modifier when anchoring with `$`, `x` mode with inline `#` comments for
  long patterns; native `preg_*` in libraries (`Nette\Utils\Strings::match` is for user code).
- Attributes: `#[\Deprecated('use X')]` (PHP 8.4, used unguarded), `#[Attribute(Attribute::TARGET_METHOD)]` with
  `use Attribute;` imported in attribute classes, `#[Requires(methods: 'POST')]`, `#[Persistent]`, `#[Language('SQL')]`
  on parameters, `#[\SensitiveParameter]`, `#[\AllowDynamicProperties]`; `#[\Override]` never.

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

1. **Every class has a docblock**: one sentence, third person, present tense, ends with a period
   (`JSON encoder and decoder.`, `Token produced by lexers.`, `Failed to send the email.` for exceptions); for
   Latte tags the docblock shows the tag syntax. Then optional tags in this order: `@property*`, `@method`,
   `@template`, `@extends`/`@implements`, `@internal`/`@deprecated`. Usage examples in `<code>` blocks, never
   fences.
2. ~60% of public methods have a docblock: a one-line summary starting with a verb (`Returns`, `Adds`, `Checks`,
   `Creates`, `Sets`, `Converts`, `Removes`, `Finds`, `Parses`), ending with a period; trivial getters, `print()`,
   `getIterator()`, `__construct` and overrides usually have none. **No blank line between the description and the
   tags.** Tag order: `@template`, `@param`, `@return`, `@throws`, then `@internal`/`@deprecated`.
3. `@param` uses **two spaces** after the tag and two spaces between type and name (`@param  string[]  $options`),
   an optional description after two more spaces; `@return`, `@throws`, `@var` use one space. Only `@param`/`@return`
   that add information (arrays, generics, callables, shapes, conditional types); a docblock repeating the native
   type is never written.
4. Property docblocks are one line: `/** @var array<string, int>  service name => index */` (description after two
   spaces), or a plain description `/** minute in seconds */`. Constants may carry a one-line description docblock.
5. Type notation: `list<T>` for lists, `array<K, V>` for maps, `T[]` in older code (both kept), `array{file:
   string, line: int}` shapes, `callable(Node): bool`, `\Closure(mixed): mixed`, `class-string<T>`, `literal-string`,
   `int<0, max>`, `array-key`; `?T` in docs for single nullable, `X|Y|null` for unions.
6. `@throws Nette\IOException  on error occurred` documents public contracts (interfaces, public API), description
   lowercase after two spaces. `@deprecated use X` (lowercase "use", no period). `@internal` on helpers.
   `@phpstan-*` tags: essentially never (2 `@phpstan-type` in the whole framework); `@inheritDoc`: never;
   `@author`/`@package`/`@since`: never (forbidden).
7. Line comments: `//` only, **lowercase start, no trailing period**, terse, explaining why: `// removes xD800-xDFFF,
   x110000 and higher`, `// back compatibility`, `// intentionally ==`. Trailing comments after code are normal
   (`$name = '0' . $i; // prevents converting to integer in array key`). Every `@` suppression carries a same-line
   reason: `@mkdir($dir); // @ - directory may already exist`, `@fopen(...); // @ is escalated to exception`.
   Phase comments in lifecycle code are UPPERCASE (`// STARTUP`, `// SIGNAL HANDLING`). Fall-through in `switch`
   is marked `// break omitted`. Commented-out code has no space (`//$this->configurator->setDebugMode(...)`).

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
   `useless-else: keep`): validation ladders are `if … throw; elseif … throw;`. Early `return`/`continue` guards
   coexist. A blank line before `} elseif` / `} else` appears when the preceding branch is a multi-statement
   paragraph (~40%), never in new code.
2. Blank lines inside methods: after a closing `}` of a block before the next statement (87%); **no blank line
   before `return` after a plain statement** (`$x = …;` directly followed by `return $x;` in 95%); blank line
   before `return` after a block (85%); none after `{` or before `}`; none between `match`/`switch` arms.
3. Assignment inside conditions is idiomatic: `if ($error = json_last_error())`, `while ($token = $this->next())`,
   `elseif ($prop = …)`.
4. Strict comparisons; `==` only with `// intentionally ==`; `!$x instanceof Y` without parentheses; `isset()` and
   `??` over `array_key_exists()`; `empty()` sparingly; `in_array(..., strict: true)`; never Yoda, never `is_null`.
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

8. Closures: `function (int $x) use ($y): bool {` (space after `function`), **`fn($x) => …` with no space**
   (enforced), never `static fn`/`static function` (3 in the whole framework). Closure parameters are often
   untyped in short callbacks.
9. Casts with a space `(string) $x`, `(int)` not `intval()`; `!$x` without space; `new Foo` **without parentheses**
   when there are no arguments (`new static`, `(new NodeTraverser)->traverse(...)`, `throw new
   Nette\ShouldNotHappenException;`); `new class ($x) extends Foo {` with a space after `class`.
10. Destructuring `[$a, $b] = …`, `foreach ($x as [$k, $v])`; by-reference APIs where PHP needs them
    (`&getIterator()`, `foreach ($items as &$item)`); `static $fn;` function-local statics for lazy state;
    `false && yield;` for an empty generator; `(function (Node ...$args) {})(...$items);` to type-check array items.
11. `try`/`catch (\Throwable $e)` (never `\Exception`), `catch (\ReflectionException)` without variable when
    unused, `try { … } catch (\Throwable $e) { cleanup; throw $e; }`, `try`/`finally` for locks; an intentionally
    empty catch is `catch (\Throwable $e) {` newline `}`.
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
   (`"{$this->getName()}"`). `sprintf` is the exception (number formats, three or more values). Concatenation
   ` . ` with spaces, `.` leading continuation lines.
2. Multi-line text is nowdoc `<<<'XX'` (dg's delimiter), indented, closing marker at code level and immediately
   followed by `,` or `;` when it is an argument.
3. Arrays `[]`; one item per line when the array does not fit in ~130 columns, otherwise inline; **trailing comma in
   every multi-line array, argument list, parameter list and `match`** (~100%); no `=>` alignment (only trailing
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
   `\Exception` fully qualified.
2. Package exceptions are collected in one `exceptions.php`: a marker `interface Exception` (Latte), then classes
   with one-sentence docblocks and empty bodies (`class ServiceCreationException extends
   Nette\InvalidStateException`, `class CompileException extends \Exception implements Exception`), two blank lines
   between them. Never `final`, no `Error` suffix, no static factories (except `SmtpException::fromReply()`,
   `DriverException::from()`), data as promoted `readonly` params (`private readonly ?string $sqlState`,
   `readonly ?Position $position`), HTTP semantics via `protected $code = Http\IResponse::S404_NotFound;`.
3. Messages: English sentence, **ends with a period**, identifiers in single quotes, interpolated:
   `"Service '$name' already exists."`, `"Invalid filter name '$name'."`, `"Cannot add cases '$name', because it
   already exists."`, `'Logging directory is not specified.'`; wrong types report `get_debug_type($x) . ' given'`;
   arity checks use `__METHOD__ . "() expects 2 parameters, $count given."`; config paths use
   `"\u{a0}›\u{a0}"` separators. Multi-value messages use `sprintf(` with one argument per line and a trailing
   comma. Previous exceptions: `, 0, $e)` or `previous: $e`.
4. `throw` as an expression (`?? throw`, `?: throw`, `default => throw`, `fn() => throw`) and `throw new X;` without
   parentheses when there are no arguments.
5. `@throws` on public API and interface methods, with a lowercase description.

### 3.11 Architecture and design habits

- **Static utility classes** (`final class Strings { use Nette\StaticClass; public static function …`) with `self::`
  calls (1005 `self::` vs 15 `static::`); `static::` only where subclass override is intended.
- **Tiny interfaces** (1–5 methods) only where several implementations exist; capability discovery by `instanceof`
  (`BulkReader`, `BulkWriter`).
- **Public typed properties instead of getters** on data holders: Latte nodes, Tracy `Value`, `Logger` config,
  `Printer::$wrapLength`, event arrays `onSuccess`. Getters protect state that must stay consistent.
- **Fluent mutable builders** returning `static` (`Message::setSubject()`, `Selection::where()`, php-generator
  `ClassType::addMethod()->setReturnType()`); immutability through `final readonly class` or `with*()` + `$dolly`.
- **DI extension (Nette style)**: `final class FooExtension extends Nette\DI\CompilerExtension` in
  `Nette\Bridges\<Package>DI`, class docblock `@property object{debugger: ?bool, …} $config`, constructor
  `private readonly bool $debugMode = false` (from `%debugMode%`), `getConfigSchema(): Nette\Schema\Schema`
  returning `Expect::structure([...])` with a trailing `// comment` per key and a tri-state `'debugger' =>
  Expect::bool()`, `loadConfiguration()` (`$config = $this->config; $builder = $this->getContainerBuilder();`),
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
   `app/`), private `setupContainer()`. `www/index.php` is six lines ending in
   `$container->getByType(Nette\Application\Application::class)->run();`.
3. `services.neon`: `services:` list plus `search:` auto-registration by suffix (`*Facade`, `*Factory`,
   `*Repository`, `*Service`), tabs, two blank lines between top-level sections, booleans `yes`/`no`
   (`strictParsing: yes`, `export: parameters: no`).
4. Latte: `{block content}`, `{include content}`, `{include title|stripHtml}`, `n:foreach`, `n:class`,
   `<h1 n:block=title>` (unquoted simple attribute values), `{asset? 'main.js'}`.
5. `composer.json` for apps: `"php": ">= 8.2"` (with a space), `^` constraints, scripts `phpstan` and `tester`;
   `phpstan.neon` level 8 for `app` and `bin`; `bin/` scripts start `#!/usr/bin/env php` + `<?php
   declare(strict_types=1);` and probe both `vendor/autoload.php` locations, failing with `fwrite(STDERR, "Install
   packages using Composer.\n"); exit(1);`.

### 3.13 Tests (Nette Tester, dg style)

`tests/bootstrap.php`:

```php
<?php declare(strict_types=1);

// The Nette Tester command-line runner can be
// invoked through the command: ../vendor/bin/tester .

if (@!include __DIR__ . '/../vendor/autoload.php') {
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
   in test files (96%). Test-local classes (`class Foo`, `interface Iface`, `class TestPresenter`) are declared in
   the file, loosely typed, separated by two blank lines.
2. Header: `<?php declare(strict_types=1);`, blank, optional `/** * Test: Nette\Utils\Strings::match() */` docblock
   (old files; newest repositories omit it), blank, `use` lines (`use Tester\Assert;` sorted among them), one blank
   line (DressCode; older files have two), `require __DIR__ . '/../bootstrap.php';` (plain `require`, never
   `require_once`), **two blank lines**, body. Annotations in the docblock: `@phpExtension mbstring`, `@phpVersion 8.4`, `@dataProvider?
   ../databases.ini`, `@exitCode   255`, `@httpCode   500`, `@outputMatch`, `@outputMatchFile expected/x.expect`.
3. `test()` is provided by Tester (`Environment::setupFunctions()`), never redefined: `test('lowercase description',
   function () use ($x) { … });` — title required, lowercase, no period, may embed `method()` names; **two blank
   lines between `test()` blocks**; companions `testException('title', function () { … }, X::class, 'msg')`,
   `setUp(function () { … })`, `tearDown(...)`. Older files are flat top-level `Assert::` scripts with
   `// section` comments after two blank lines; `Tester\TestCase` classes are practically extinct (run as
   `$test = new XTest; $test->run();`, `new X` without parentheses).
4. Assertions expected-first: `Assert::same`, `Assert::null($x)` (not `same(null, …)`), `Assert::true/false`,
   `Assert::type(Foo::class, $x)`, `Assert::count`, `Assert::equal` for object graphs (`(object) [...]`),
   `Assert::match('%a%:%d% %A%', $s)` with Tester patterns, `Assert::matchFile(__DIR__ . '/expected/x.php', $out)`
   for snapshots, `Assert::error(fn() => …, E_USER_DEPRECATED, 'msg')`, `Assert::noError`, `Assert::with(Class::class,
   function () { … })` for private access. `Assert::exception(fn() => …, Class::class, 'message',)` multi-line with
   trailing comma; closure with statements uses `function () { … }` and puts the remaining arguments on the closing
   line. Expected multi-line text is nowdoc `<<<'XX'`.
5. DI tests: `createContainer($compiler, '\nfoo:\n\tkey: value\n')` helper from `di/tests/bootstrap.php`, NEON as
   an inline single-quoted string starting with a newline and top-level keys at column 0; config files via
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
  `Nette Community` (`https://nette.org/contributors`); `"php": "8.2 - 8.5"` (range with spaces, upper bound bumped
  per PHP release); `^x.y` constraints, `@stable` on phpstan tooling; `"autoload": {"classmap": ["src/"], "psr-4":
  {"Nette\\": "src"}}` (+ `"files"` for `functions.php`); no `autoload-dev`, no `prefer-stable`, no `sort-packages`;
  `"scripts": {"phpstan": "phpstan analyse", "tester": "tester tests -s"}`; `extra.branch-alias.dev-master:
  "4.1-dev"` (no `.x`); `extra.nette.di-extensions` for auto-discovered extensions.
- **readme.md** (lowercase): banner image link, five shields.io/poser badges each on its own line, Setext-underlined
  sections `Introduction`, `Installation` ("The recommended way to install is via Composer:" + compatibility
  sentence "Nette Utils 4.1 is compatible with PHP 8.2 to 8.5."), `Usage`, `[Support Me](https://github.com/sponsors/dg)`
  with the "Buy me a coffee" image; sections separated by ` <!---->`; feature lists as `✅ [Arrays](…)<br>`; docs live
  on doc.nette.org, not in the repo. **license.md** (lowercase) with the BSD/GPL dual text. No Makefile, no
  `.editorconfig`, no CHANGELOG, no `.docs/`.
- **AGENTS.md** in most repos (`# To My Agents!`), stating conventions ("Every file starts with
  `declare(strict_types=1);`; everything typed; `readonly` for immutable properties; tabs; two blank lines between
  methods; Nette Coding Standard; document the shut-up operator"); agent-facing `docs/internals/*.md`.
- **.gitattributes** column-aligned with `export-ignore` for `.github/`, `AGENTS.md`, `docs/`, `tests/`, `ncs.*`,
  `phpstan*.neon`, plus `*.php* diff=php`, `*.sh text eol=lf`. **.gitignore**: `/vendor`, `/composer.lock`,
  `tests/lock`, `/tests/output`, `/tests/tmp`.
- **phpstan.neon** (tabs): `level: 8`, `paths: - src`, `excludePaths` for compatibility files, `bootstrapFiles`,
  `ignoreErrors` entries as `- # reason` + `identifier:` (+ `message:`, `path:`, `count:`).
- **Workflows**: `.github/workflows/{tests,coding-style,static-analysis}.yml`, self-contained, 4-space YAML,
  `on: [push, pull_request]`, snake_case job ids (`nette_cc`, `nette_cs`, `code_coverage`, `lowest_dependencies`),
  `actions/checkout@v6`, `shivammathur/setup-php@v2`.
- **Versioning**: `master` tracks the next version (`4.1-dev`); one long-lived branch per released minor (`v4.0`,
  `v3.2`); tags `vX.Y.Z` (+ `v3.3.0-RC`); release commit `Released version 3.1.6` (only the version constant), then
  `opened 4.1-dev` (composer alias). BC breaks are flagged in the commit subject, not in a changelog.
- **Commits**: lowercase past tense for changes (`added Type::fromValue()`, `removed support for Latte 2`,
  `improved tests`, `used native PHP 8 functions`, `requires PHP 8.2`, `uses PascalCase constants`, `opened
  4.1-dev`) or `Class: behaviour sentence` / `Class::method() sentence` (`Finder: exclude() uses the same mask
  grammar as find()`, `Arrays::renameKey() fixed incorrect replacement for existing new keys [Closes #230]`,
  `Html: added fragment() and add()`); tool prefixes lowercase (`tests:`, `composer:`, `readme:`, `phpstan.neon:`,
  `coding style:`, bare `cs`); markers `(BC break)`, `[Closes #N]` (capital C, one bracket per issue), `[security]`,
  `WIP`; no trailing period, no emoji, no body except long prose bodies in 2026 work.

### 3.15 Do not (dg)

- No spaces in `declare(strict_types = 1)`; no `declare` on its own line; no blank line after class `{`; no single
  blank line between methods; no blank lines between `use` groups.
- No `use stdClass;`/`use Throwable;` (write `\stdClass`); no `\count()`; no per-line `use function`.
- No `I`/`Abstract`/`Interface`/`Trait` in names; no `UPPER_SNAKE` constants in new code; no typed constants;
  no `#[\Override]`; no `static fn`/`static function`; no `new Foo()` with empty parentheses; no `fn ($x)` with a
  space; no `(int)$x` without a space.
- No `sprintf`-only messages; no braced `{$var}` where `$var` suffices; no messages without a period; no
  `Foo::bar():` prefixes in messages; no exception static factories.
- No `@param string $x` restating a native type; no blank line between description and tags; no `@author`,
  `@since`, `@package`, `@inheritDoc`, `@phpstan-*`, `@return $this`/`@return static` docblocks; no "Class that …"
  summaries; no docblocks on trivial getters; no uppercase-starting or period-terminated `//` comments; no `@`
  without a same-line reason.
- No `else` removal for its own sake; no Yoda; no `is_null`; no `else if`; no `switch` where `match` fits; no
  `list()`, `array()`, `goto` (one commented exception); no aligned `=>`/`=`.
- No `SmartObject`/`@property` on new classes; no presenter constructors; no docblock annotations (`@persistent`);
  no `private` on subclass hooks (`protected`); no `final` on the main extension points.
- No PHPStan inline ignores; no strict-rules; no Makefile, `.editorconfig`, `ruleset.xml`, CHANGELOG, `.docs/`.
- No test namespaces; no `require_once` for bootstrap; no test docblocks in new repos; no redefined `test()`;
  no `Test`-suffixed `.phpt` names; no PHPUnit.
- No imperative capitalised commit subjects (`Add feature`); no conventional-commit types; no `Co-Authored-By`.

---

## 4. Checklists

### 4.1 Before committing in dialect A (Contributte)

1. `make csf && make qa && make tests` are green (phpcs on `src tests`, phpstan level 9, Nette Tester).
2. First line `<?php declare(strict_types = 1);`; tabs; blank line after class `{` and before `}`; one blank line
   between members; magic methods last; imports alphabetical and complete (global classes imported).
3. Native types everywhere; docblocks only for generics/shapes; `?T`; `: void`; `: self` for fluent methods.
4. `sprintf('… "%s" …', $x)` messages; guard clauses; blank line before `return`; strict comparisons; `??`.
5. Exceptions in `Exception/Logical|Runtime`, roots `LogicalException`/`RuntimeException`, empty bodies.
6. DI: `@property-read stdClass $config`, hook order, `$builder`/`$config` locals, `prefix()` ids, `*_TAG`
   constants, `setAutowired(false)` on internals, `assert($def instanceof ServiceDefinition)`.
7. Tests: `Toolkit::test(function (): void { … })` with a `// comment`, `ContainerBuilder::of()` + `Neonkit::load`,
   `Assert::exception(…, X::class, 'exact message')`.
8. Repo files from 2.15; commit `Area: imperative phrase`.

### 4.2 Before committing in dialect B (Nette)

1. `composer phpstan` and `composer tester` are green; code-checker `--strict-types` passes; `ecs check` passes.
2. First line `<?php declare(strict_types=1);`; license docblock if the repository has one; two blank lines before
   the class and between methods; no blank line inside class braces; `use Nette;` + `use function …` one line.
3. Class docblock sentence with a period; `@param  T  $x` two-space form; no docblock that repeats types.
4. `final` unless it is an extension point; PascalCase constants with deprecated UPPER aliases; no kind in names.
5. Promoted `private readonly` ctor with trailing comma and `) {`; other multi-line signatures `): T` + `{`.
6. `"Message '$x'."` interpolation, period at the end; `Nette\InvalidStateException` family; `?? throw`.
7. Leading operators on wrapped lines; trailing commas everywhere; `new Foo;`; `fn($x)`; `match`; `catch (\Throwable)`.
8. Tests `Subject.aspect.phpt`, `test('lowercase title', function () {…});`, two blank lines between tests,
   `Assert::same($expected, $actual)`.
9. Commit `added X` / `Class: sentence`, `(BC break)`, `[Closes #N]`.

### 4.3 Converting between dialects

| Change | A → B | B → A |
|---|---|---|
| declare | remove spaces | add spaces |
| class body | drop the blank lines inside braces; two blank lines between methods | add blank lines inside braces; one blank line between methods |
| imports | replace `use stdClass;` with `\stdClass`; add `use function`; consider `use Nette;` | import global classes; drop `use function`; expand `Nette\X` to imports |
| constants | `FOO_BAR` → `FooBar` (keep deprecated alias) | `FooBar` → `FOO_BAR` |
| `new Foo()` | `new Foo` | `new Foo()` |
| `fn ($x)` | `fn($x)` | `fn ($x)` |
| ctor `)` newline `{` | `) {` | `)` newline `{` |
| messages | `sprintf('… "%s"', $x)` → `"… '$x'."` | `"… '$x'."` → `sprintf('… "%s"', $x)` |
| exception roots | `LogicalException` → `Nette\InvalidStateException` etc. | Nette exceptions → package `Exception/` roots |
| docblocks | add class sentence; `@param  T  $x`; remove blank line before tags | drop prose; one space; blank line before tags |
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
