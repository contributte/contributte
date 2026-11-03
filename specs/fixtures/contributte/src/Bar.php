<?php declare(strict_types = 1);

namespace Contributte\Foo;

class Bar
{

	/**
	 * @param mixed[] $options
	 */
	public function __construct(public array $options, public ?int $timeout)
	{
	}

}
