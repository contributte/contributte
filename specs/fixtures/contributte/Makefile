.PHONY: install
install:
	composer update

.PHONY: qa
qa: phpstan cs

.PHONY: cs
cs:
	vendor/bin/phpcs --standard=ruleset.xml --encoding=utf-8 --extensions="php,phpt" --colors -nsp src tests

.PHONY: phpstan
phpstan:
	vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: tests
tests:
	vendor/bin/tester -s -p php --colors 1 -C tests/Cases
