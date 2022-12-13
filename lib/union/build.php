<?php declare(strict_types = 1);

$sources = [
	'https://packagist.org/packages/list.json?vendor=contributte&fields[]=abandoned',
	'https://packagist.org/packages/list.json?vendor=nettrine&fields[]=abandoned',
	'https://packagist.org/packages/list.json?vendor=ninjify&fields[]=abandoned',
];

$skipped = [
	// Skeletons are on edge
	"contributte/api-router-skeleton",
	"contributte/apitte-skeleton",
	"contributte/console-skeleton",
	"contributte/datagrid-skeleton",
	"contributte/doctrine-skeleton",
	"contributte/gui-skeleton",
	"contributte/embedded-skeleton",
	"contributte/micro-skeleton",
	"contributte/starter-skeleton",
	"contributte/webapp-skeleton",
	"contributte/webpack-skeleton",
	// Facebook needs https://github.com/holyfork/facebook-graph-sdk
	"contributte/facebook",
	"contributte/apitte",
	"contributte/sentry",
	"contributte/nella",
	"contributte/ui",
];

$dependencies = ['php' => '>=8.0'];

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
	'require' => $dependencies,
	"minimum-stability" => "dev",
	"prefer-stable" => true,
	"config" => [
		"sort-packages" => true,
		"allow-plugins" => [
			"composer/package-versions-deprecated" => true,
			"dealerdirect/phpcodesniffer-composer-installer" => true,
		],
	],
];

file_put_contents('composer.json', json_encode($composer, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n");

