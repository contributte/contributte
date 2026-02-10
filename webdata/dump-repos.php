<?php declare(strict_types = 1);

use Milo\Github\Api;

require __DIR__ . '/../vendor/autoload.php';

$cb = fn($fn) => $fn;
$pages = [1, 2, 3];
$repos = [];

$api = new Api();

foreach ($pages as $page) {
	$response = $api->get('orgs/contributte/repos?per_page=100&page=' . $page);
	$content = json_decode($response->getContent(), true);
	$content = array_map(function ($repo) {
		return [
			'org' => 'contributte',
			'name' => $repo['name'],
			'description' => $repo['description'],
			'homepage' => $repo['homepage'],
			'topics' => $repo['topics'],
			'archived' => $repo['archived'],
			'has_wiki' => $repo['has_wiki'],
			'has_discussions' => $repo['has_discussions'],
			'has_pages' => $repo['has_pages'],
		];
	}, $content);
	$repos = array_merge($repos, $content);
}

file_put_contents(__DIR__ . '/../data/repos-v1.json', json_encode($repos, JSON_PRETTY_PRINT));

echo "Dumped {$cb(count($repos))} repos.";
