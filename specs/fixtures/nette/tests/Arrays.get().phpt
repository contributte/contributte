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
