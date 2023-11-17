<?php declare(strict_types = 1);

$sources = [
	'https://packagist.org/packages/list.json?vendor=contributte&fields[]=abandoned',
	'https://packagist.org/packages/list.json?vendor=nettrine&fields[]=abandoned',
];

$skipped = [
	// Skeletons are on edge
	'contributte/api-router-skeleton',
	'contributte/apitte-skeleton',
	'contributte/console-skeleton',
	'contributte/datagrid-skeleton',
	'contributte/doctrine-skeleton',
	'contributte/ddd-skeleton',
	'contributte/embedded-skeleton',
	'contributte/framex-skeleton',
	'contributte/gui-skeleton',
	'contributte/micro-skeleton',
	'contributte/nella-skeleton',
	'contributte/starter-skeleton',
	'contributte/tester-skeleton',
	'contributte/ui-skeleton',
	'contributte/webapp-skeleton',
	'contributte/webpack-skeleton',
	// Facebook needs https://github.com/holyfork/facebook-graph-sdk
	'contributte/apitte',
	'contributte/code-checker',
	'contributte/code-rules',
	'contributte/czech-post',
	'contributte/eet',
	'contributte/elastica',
	'contributte/forms-bootstrap',
	'contributte/image-storage',
	'contributte/imagist',
	'contributte/jsonrpc',
	'contributte/latte-parsedown-extra',
	'contributte/nella',
	'contributte/nextras-orm-generator',
	'contributte/psr7-http-message',
	'contributte/rabbitmq',
	'contributte/ui',
	'nettrine/extensions-knplabs',
	'nettrine/extensions-oroinc'
];

$dependencies = ['php' => '>=8.2'];

foreach ($sources as $source) {
	$data = (array) json_decode(file_get_contents($source), true);

	foreach ($data['packages'] as $package => $meta) {
		// Skip abandoned
		if ($meta['abandoned'] !== false) continue;

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

