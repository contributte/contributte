<?php declare(strict_types = 1);

namespace Tests\Cases;

use Tester\Assert;
use Tester\TestCase;
use TODO_Vendor\TODO_Package\Example;

require __DIR__ . '/../bootstrap.php';

class ExampleTest extends TestCase
{

	public function testFoo(): void
	{
		$example = new Example();
		Assert::same('foo', $example->getFoo());
	}

}

($test = new ExampleTest())->run();
