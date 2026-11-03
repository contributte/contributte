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
