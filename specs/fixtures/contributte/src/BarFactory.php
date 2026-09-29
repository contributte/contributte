<?php declare(strict_types = 1);

namespace Contributte\Foo;

class BarFactory
{

	/**
	 * @param array<string, string> $map
	 */
	public function __construct(public array $map)
	{
	}

}
