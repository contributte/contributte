<?php declare(strict_types = 1);

require __DIR__ . '/../vendor/autoload.php';

$cb = fn($fn) => $fn;
$repos = json_decode(file_get_contents(__DIR__ . '/../data/repos-v1.json'), true);
$tf1 = [];
$tf2 = [];

foreach ($repos as $repo) {
	$name = str_replace('.', '_', $repo['name']);

	$tf1[] = <<<EOF
	resource "github_repository" "{$name}" {
		name                 = "{$repo['name']}"
		description          = "{$cb(isset($repo['description']) ? addcslashes($repo['description'], '\\') : '')}"
		allow_merge_commit   = false
		has_downloads        = true
		has_issues           = true
		homepage_url         = "{$repo['homepage']}"
		topics               = {$cb(json_encode($repo['topics']))}
		vulnerability_alerts = true
		archived             = {$cb(json_encode($repo['archived']))}
		has_wiki             = {$cb(json_encode($repo['has_wiki']))}
		has_discussions      = {$cb(json_encode($repo['has_discussions']))}
	}
	EOF;

	$tf2[] = "terraform import github_repository.{$name} {$repo['name']} || true";
}

file_put_contents(__DIR__ . '/../data/repos-v1.tf', implode("\n\n", $tf1));
file_put_contents(__DIR__ . '/../data/repos-v1.sh', implode("\n", $tf2));
