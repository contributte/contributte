<?php declare(strict_types = 1);

use Ninjify\Nunjuck\Environment;

if (@!include __DIR__ . '/../vendor/autoload.php') {
	echo 'Install dependencies using `composer install`';
	exit(1);
}

Environment::setup(__DIR__);
