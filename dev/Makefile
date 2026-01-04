.PHONY: install update build

install:
	composer install --ignore-platform-reqs

update:
	composer update -W --ignore-platform-reqs

build:
	php build.php

outdated-direct:
	composer show -o --direct

outdated:
	composer show -o
