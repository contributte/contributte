<?php declare(strict_types = 1);

$sources = [
	'https://packagist.org/packages/list.json?vendor=contributte&fields[]=abandoned&fields[]=type',
	'https://packagist.org/packages/list.json?vendor=nettrine&fields[]=abandoned&fields[]=type',
];

$skipped = [
	// TODO
	'nettrine/extensions-knplabs',
];

$dependencies = ['php' => '>=8.2'];

foreach ($sources as $source) {
	$data = (array) json_decode(file_get_contents($source), true);

	foreach ($data['packages'] as $package => $meta) {
		// Skip abandoned
		if ($meta['abandoned'] !== false) continue;
		// Skip other than library
		if ($meta['type'] !== 'library') continue;

		// Skip skipped
		if (in_array($package, $skipped)) continue;

		$dependencies[$package] = '*';
	}
}

$composer = [
	"repositories" => [
		["type" => "git", "url" => "https://github.com/holyfork/facebook-graph-sdk"],
	],
	'require' => $dependencies,
	'conflict' => [
		'mpdf/psr-http-message-shim' => '^2.0',
	],
	'minimum-stability' => 'dev',
	'prefer-stable' => true,
	'config' => [
		'sort-packages' => true,
		'allow-plugins' => [
			'php-http/discovery' => true,
			'dealerdirect/phpcodesniffer-composer-installer' => false,
		],
	],
];

file_put_contents('composer.json', json_encode($composer, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n");

