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
