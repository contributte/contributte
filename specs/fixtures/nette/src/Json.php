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
