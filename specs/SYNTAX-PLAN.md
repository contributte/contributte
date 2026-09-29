# SYNTAX.md Analysis Plan

> Plan for extracting the Contributte (f3l1x) and Nette (dg) coding style from every repository and every PHP file, and for producing and validating [SYNTAX.md](SYNTAX.md).

## Goal

Produce a single document, `specs/SYNTAX.md`, that contains everything needed to write PHP code indistinguishable from code written by Milan Šulc (f3l1x, Contributte) and David Grudl (dg, Nette): syntax, formatting, naming, typing, docblocks, class layout, abstraction, error handling, tests and repository conventions.

## Method

1. **Inventory.** Clone every non-archived repository of `github.com/contributte` and every package repository of `github.com/nette` (shallow, `--depth 1`). Count PHP files (`*.php`, `*.phpt`, excluding `vendor/`).
2. **Classify.** Each repository is placed in one bucket. The bucket decides how much weight its code carries in SYNTAX.md.
   - `current` — Contributte library using `contributte/qa` ruleset 8.x, PHP >= 8.2. Primary source of the f3l1x style.
   - `skeleton` — Contributte project skeletons and demos. Source of application-level conventions (Bootstrap, presenters, config).
   - `legacy` — Contributte libraries on `ninjify/coding-standard` or PHP 7.x. Used only to document how the style evolved; never overrides `current`.
   - `nette` — Nette Framework packages by dg. Primary source of the dg style.
   - `no-php` — no PHP code, ignored.
3. **Formal rules.** Read the machine-enforced rules first: `contributte/qa` (`ruleset.xml`, `ruleset-8.x.xml`, `ruleset-next.xml`, `SNIFFS.md`), `nette/coding-standard`, `nette/phpstan-rules`, `contributte/phpstan`. Everything a sniff enforces is a hard rule in SYNTAX.md.
4. **Fan-out analysis.** Orchestrator (Claude Fable 5.1) dispatches analyst subagents (Claude Sonnet 5.5). Each analyst owns a slice, reads real files, and must cite `org/repo/path:line` and paste verbatim snippets for every claim, with frequency (majority vs exception). One analyst computes cross-repo statistics with scripts so that every "always/usually" in SYNTAX.md has a number behind it.
5. **Synthesis.** The orchestrator merges the findings into SYNTAX.md, resolving contradictions by (a) enforced ruleset, (b) reference repositories, (c) frequency.
6. **Evaluation.** SYNTAX.md is evaluated in a real Contributte repository: code is written strictly from SYNTAX.md, run through the repository's own `make qa` (phpcs + phpstan) and `make tests`, and then reviewed by adversarial "grilling" reviewers (Claude Opus 5.5) who compare it and SYNTAX.md itself against the real code base and report every deviation. Findings are folded back into SYNTAX.md.

## Analyst slices

| Analyst | Model | Scope | Output |
|---------|-------|-------|--------|
| qa-rulesets | Sonnet 5.5 | `contributte/qa`, `nette/coding-standard`, `nette/phpstan-rules`, `contributte/phpstan`, all `phpstan.neon` | Enforced rules in plain English |
| contributte-core-a | Sonnet 5.5 | Tier-1 libraries: messenger, doctrine-dbal, doctrine-orm, nella, bus, console, console-extra, event-dispatcher(-extra), di, bootstrap, application, cache, database, http, mail, latte, tracy, security, utils, tester, monolog, logging | DI extensions, exceptions, namespace layout |
| contributte-core-b | Sonnet 5.5 | apitte, api, api-router, middlewares, psr7-http-message, psr6-caching, psr11-container-interface, openapi, jsonrpc, sentry, newrelic, redis, rabbitmq, scheduler, firewall, oauth2-client/server, kernel, framex, crafter, dag, aop, nusoap | Large-library architecture, PSR interop, attributes |
| contributte-core-c | Sonnet 5.5 | UI/forms/components, API clients, Doctrine/Nextras bridges, community-maintained libraries | Components, forms, clients, divergences |
| contributte-tests | Sonnet 5.5 | `tests/` of all Contributte repos | Nette Tester conventions (Toolkit, Cases, Fixtures) |
| contributte-skeletons | Sonnet 5.5 | all `*-skeleton`, `demo-*`, doctrine-project | Application layout, Bootstrap, presenters, config |
| nette-core-a | Sonnet 5.5 | nette/utils, di, schema, neon, php-generator, robot-loader, safe-stream, command-line, tokenizer, safe | dg core style |
| nette-core-b | Sonnet 5.5 | nette/application, forms, http, routing, security, component-model, bootstrap, caching, mail, database, assets | dg framework style, Bridges |
| nette-core-c | Sonnet 5.5 | nette/latte, tracy, tester, code-checker, type-fixer, mcp-inspector, xray, web-project | dg compilers/tools, app skeleton |
| nette-tests | Sonnet 5.5 | `tests/` of all Nette repos (~2,300 `.phpt`) | dg test conventions |
| meta-and-commits | Sonnet 5.5 | commit history samples, composer.json, README/.docs, workflows, Makefiles | Repository conventions |
| stats | Sonnet 5.5 | all `src/**/*.php` and tests, scripted | Quantitative tables |
| grill-* | Opus 5.5 | SYNTAX.md vs real code; generated evaluation code | Adversarial review |

## Conflict resolution

1. A rule enforced by `contributte/qa` (f3l1x) or `nette/coding-standard` (dg) always wins for that author.
2. Where f3l1x and dg differ, SYNTAX.md documents both, marked **f3l1x** / **dg**, and states the default (f3l1x for Contributte repositories, dg for Nette repositories).
3. Within one author, the reference repositories win (`contributte/doctrine-dbal`, `doctrine-orm`, `messenger`, `nella`; `nette/utils`, `di`, `schema`, `latte`).
4. Otherwise the majority pattern wins; exceptions are listed as such.
5. Legacy repositories never override current ones.

## Inventory

### Contributte — current libraries (102 repositories, 4086 PHP files)

| Repository | PHP files | src | tests | .phpt | PHP |
|------------|----------:|----:|------:|------:|-----|
| [contributte/anabelle](https://github.com/contributte/anabelle) | 39 | 29 | 1 | 8 | `>=8.1` |
| [contributte/aop](https://github.com/contributte/aop) | 96 | 51 | 45 | 0 | `>=8.2` |
| [contributte/api-docu](https://github.com/contributte/api-docu) | 6 | 4 | 1 | 1 | `>=8.2` |
| [contributte/api-router](https://github.com/contributte/api-router) | 15 | 6 | 9 | 0 | `>=8.2` |
| [contributte/api](https://github.com/contributte/api) | 55 | 44 | 11 | 0 | `>=8.2` |
| [contributte/apitte](https://github.com/contributte/apitte) | 267 | 166 | 46 | 55 | `>=8.2` |
| [contributte/application](https://github.com/contributte/application) | 35 | 19 | 1 | 15 | `>=8.2` |
| [contributte/bootstrap](https://github.com/contributte/bootstrap) | 19 | 8 | 5 | 6 | `>=8.2` |
| [contributte/bus](https://github.com/contributte/bus) | 34 | 19 | 5 | 10 | `>=8.2` |
| [contributte/cache](https://github.com/contributte/cache) | 12 | 7 | 3 | 2 | `>=8.2` |
| [contributte/code-checker](https://github.com/contributte/code-checker) | 3 | 1 | 1 | 1 | `>=8.2` |
| [contributte/codeception](https://github.com/contributte/codeception) | 16 | 9 | 7 | 0 | `>=8.2` |
| [contributte/comgate](https://github.com/contributte/comgate) | 32 | 26 | 2 | 4 | `>=8.2` |
| [contributte/console-extra](https://github.com/contributte/console-extra) | 43 | 38 | 1 | 4 | `>=8.2` |
| [contributte/console](https://github.com/contributte/console) | 27 | 7 | 12 | 8 | `>=8.2` |
| [contributte/crafter](https://github.com/contributte/crafter) | 48 | 44 | 1 | 2 | `>=8.2` |
| [contributte/czech-post](https://github.com/contributte/czech-post) | 33 | 29 | 1 | 3 | `>=8.2` |
| [contributte/dag](https://github.com/contributte/dag) | 15 | 13 | 1 | 1 | `>=8.2` |
| [contributte/database](https://github.com/contributte/database) | 12 | 6 | 3 | 3 | `>=8.2` |
| [contributte/datagrid](https://github.com/contributte/datagrid) | 144 | 99 | 11 | 34 | `>=8.2` |
| [contributte/di](https://github.com/contributte/di) | 39 | 15 | 20 | 4 | `>=8.2` |
| [contributte/doctrine-annotations](https://github.com/contributte/doctrine-annotations) | 6 | 1 | 5 | 0 | `>=8.2` |
| [contributte/doctrine-cache](https://github.com/contributte/doctrine-cache) | 7 | 1 | 1 | 5 | `>=8.2` |
| [contributte/doctrine-dbal](https://github.com/contributte/doctrine-dbal) | 65 | 27 | 7 | 31 | `>=8.2` |
| [contributte/doctrine-extensions-atlantic18](https://github.com/contributte/doctrine-extensions-atlantic18) | 7 | 1 | 3 | 3 | `>=8.2` |
| [contributte/doctrine-extensions-beberlei](https://github.com/contributte/doctrine-extensions-beberlei) | 4 | 1 | 1 | 2 | `>=8.2` |
| [contributte/doctrine-extensions-knplabs](https://github.com/contributte/doctrine-extensions-knplabs) | 12 | 6 | 4 | 2 | `>=8.2` |
| [contributte/doctrine-extensions-oroinc](https://github.com/contributte/doctrine-extensions-oroinc) | 4 | 1 | 1 | 2 | `>=8.2` |
| [contributte/doctrine-extra](https://github.com/contributte/doctrine-extra) | 25 | 19 | 5 | 1 | `>=8.2` |
| [contributte/doctrine-fixtures](https://github.com/contributte/doctrine-fixtures) | 12 | 8 | 3 | 1 | `>=8.2` |
| [contributte/doctrine-migrations](https://github.com/contributte/doctrine-migrations) | 18 | 7 | 6 | 5 | `>=8.2` |
| [contributte/doctrine-mongodb](https://github.com/contributte/doctrine-mongodb) | 3 | 1 | 1 | 1 | `>=8.2` |
| [contributte/doctrine-odm](https://github.com/contributte/doctrine-odm) | 17 | 10 | 2 | 4 | `>=8.2` |
| [contributte/doctrine-orm](https://github.com/contributte/doctrine-orm) | 56 | 16 | 16 | 23 | `>=8.2` |
| [contributte/elastica](https://github.com/contributte/elastica) | 5 | 3 | 2 | 0 | `>=8.1` |
| [contributte/elasticsearch](https://github.com/contributte/elasticsearch) | 3 | 1 | 1 | 1 | `>=8.2` |
| [contributte/event-dispatcher-extra](https://github.com/contributte/event-dispatcher-extra) | 36 | 22 | 10 | 4 | `>=8.2` |
| [contributte/event-dispatcher](https://github.com/contributte/event-dispatcher) | 17 | 7 | 6 | 4 | `>=8.2` |
| [contributte/fileupload](https://github.com/contributte/fileupload) | 33 | 22 | 9 | 2 | `>=8.2` |
| [contributte/fio](https://github.com/contributte/fio) | 40 | 29 | 2 | 9 | `>=8.2` |
| [contributte/firewall](https://github.com/contributte/firewall) | 15 | 11 | 3 | 1 | `>=8.2` |
| [contributte/flysystem](https://github.com/contributte/flysystem) | 6 | 4 | 1 | 1 | `>=8.2` |
| [contributte/forms-bootstrap](https://github.com/contributte/forms-bootstrap) | 64 | 34 | 30 | 0 | `>=8.3` |
| [contributte/forms-multiplier](https://github.com/contributte/forms-multiplier) | 21 | 11 | 4 | 6 | `>=8.2` |
| [contributte/forms-wizard](https://github.com/contributte/forms-wizard) | 24 | 10 | 5 | 9 | `>=8.2` |
| [contributte/forms](https://github.com/contributte/forms) | 78 | 52 | 2 | 24 | `>=8.2` |
| [contributte/framex](https://github.com/contributte/framex) | 27 | 19 | 4 | 4 | `>=8.2` |
| [contributte/gettext](https://github.com/contributte/gettext) | 9 | 2 | 1 | 2 | `>=8.2` |
| [contributte/gosms](https://github.com/contributte/gosms) | 20 | 13 | 2 | 5 | `>=8.2` |
| [contributte/guzzlette](https://github.com/contributte/guzzlette) | 12 | 7 | 1 | 4 | `>=8.2` |
| [contributte/http](https://github.com/contributte/http) | 21 | 12 | 1 | 8 | `>=8.2` |
| [contributte/image-storage](https://github.com/contributte/image-storage) | 15 | 10 | 1 | 4 | `>=8.2` |
| [contributte/imagist](https://github.com/contributte/imagist) | 208 | 167 | 4 | 37 | `>=8.2` |
| [contributte/imap](https://github.com/contributte/imap) | 5 | 2 | 1 | 2 | `>=8.2` |
| [contributte/invoice](https://github.com/contributte/invoice) | 45 | 39 | 1 | 3 | `>=8.2` |
| [contributte/jsonrpc](https://github.com/contributte/jsonrpc) | 51 | 41 | 3 | 7 | `>=8.2` |
| [contributte/kernel](https://github.com/contributte/kernel) | 24 | 22 | 1 | 1 | `>=8.2` |
| [contributte/latte-parsedown-extra](https://github.com/contributte/latte-parsedown-extra) | 9 | 4 | 1 | 4 | `>=8.2` |
| [contributte/latte](https://github.com/contributte/latte) | 40 | 21 | 3 | 16 | `>=8.2` |
| [contributte/logging](https://github.com/contributte/logging) | 38 | 29 | 4 | 5 | `>=8.2` |
| [contributte/mail](https://github.com/contributte/mail) | 28 | 14 | 4 | 10 | `>=8.2` |
| [contributte/mailing](https://github.com/contributte/mailing) | 17 | 14 | 1 | 2 | `>=8.2` |
| [contributte/menu-control](https://github.com/contributte/menu-control) | 39 | 24 | 15 | 0 | `>=8.1` |
| [contributte/messenger](https://github.com/contributte/messenger) | 99 | 28 | 50 | 21 | `>=8.2` |
| [contributte/middlewares](https://github.com/contributte/middlewares) | 53 | 31 | 6 | 16 | `>=8.2` |
| [contributte/monolog](https://github.com/contributte/monolog) | 11 | 8 | 2 | 1 | `>=8.2` |
| [contributte/nella](https://github.com/contributte/nella) | 22 | 20 | 1 | 1 | `>=8.2` |
| [contributte/neonizer](https://github.com/contributte/neonizer) | 29 | 24 | 2 | 3 | `>=8.1` |
| [contributte/newrelic](https://github.com/contributte/newrelic) | 28 | 21 | 3 | 4 | `>=8.2` |
| [contributte/nextras-criteria](https://github.com/contributte/nextras-criteria) | 13 | 7 | 1 | 5 | `>=8.2` |
| [contributte/nextras-orm-events](https://github.com/contributte/nextras-orm-events) | 30 | 13 | 16 | 1 | `>=8.2` |
| [contributte/nextras-orm-generator](https://github.com/contributte/nextras-orm-generator) | 45 | 40 | 1 | 2 | `>=8.2` |
| [contributte/nextras-orm-query-object](https://github.com/contributte/nextras-orm-query-object) | 32 | 9 | 15 | 8 | `>=8.2` |
| [contributte/nusoap](https://github.com/contributte/nusoap) | 49 | 2 | 4 | 15 | `>=8.2` |
| [contributte/oauth2-client](https://github.com/contributte/oauth2-client) | 27 | 17 | 5 | 5 | `>=8.2` |
| [contributte/oauth2-server](https://github.com/contributte/oauth2-server) | 17 | 7 | 7 | 3 | `>=8.2` |
| [contributte/openapi](https://github.com/contributte/openapi) | 59 | 34 | 25 | 0 | `>=8.2` |
| [contributte/pdf](https://github.com/contributte/pdf) | 13 | 6 | 1 | 6 | `>=8.2` |
| [contributte/phpstan](https://github.com/contributte/phpstan) | 3 | 0 | 2 | 1 | `>=8.2` |
| [contributte/phpunit](https://github.com/contributte/phpunit) | 7 | 3 | 3 | 1 | `>=8.2` |
| [contributte/psr11-container-interface](https://github.com/contributte/psr11-container-interface) | 8 | 6 | 1 | 1 | `>=8.2` |
| [contributte/psr6-caching](https://github.com/contributte/psr6-caching) | 10 | 8 | 1 | 1 | `>=8.2` |
| [contributte/psr7-http-message](https://github.com/contributte/psr7-http-message) | 40 | 27 | 13 | 0 | `>=8.2` |
| [contributte/qa](https://github.com/contributte/qa) | 945 | 0 | 944 | 0 | `>=8.2` |
| [contributte/rabbitmq](https://github.com/contributte/rabbitmq) | 55 | 47 | 3 | 5 | `>=8.2` |
| [contributte/reCAPTCHA](https://github.com/contributte/reCAPTCHA) | 22 | 9 | 4 | 9 | `>=8.2` |
| [contributte/redis](https://github.com/contributte/redis) | 19 | 11 | 2 | 6 | `>=8.2` |
| [contributte/replacus](https://github.com/contributte/replacus) | 9 | 7 | 2 | 0 | `>=8.1` |
| [contributte/scheduler](https://github.com/contributte/scheduler) | 20 | 14 | 5 | 1 | `>=8.2` |
| [contributte/security](https://github.com/contributte/security) | 5 | 2 | 1 | 2 | `>=8.2` |
| [contributte/sentry](https://github.com/contributte/sentry) | 33 | 22 | 3 | 8 | `>=8.2` |
| [contributte/social](https://github.com/contributte/social) | 23 | 16 | 1 | 6 | `>=8.1` |
| [contributte/tester](https://github.com/contributte/tester) | 13 | 10 | 1 | 2 | `>=8.2` |
| [contributte/thepay](https://github.com/contributte/thepay) | 6 | 2 | 2 | 2 | `^8.2` |
| [contributte/tracy](https://github.com/contributte/tracy) | 11 | 5 | 3 | 3 | `>=8.2` |
| [contributte/turnstile](https://github.com/contributte/turnstile) | 6 | 4 | 1 | 1 | `>=8.3` |
| [contributte/ui](https://github.com/contributte/ui) | 12 | 9 | 1 | 2 | `>=8.2` |
| [contributte/utils](https://github.com/contributte/utils) | 61 | 31 | 5 | 25 | `>=8.2` |
| [contributte/validator](https://github.com/contributte/validator) | 7 | 2 | 3 | 2 | `>=8.2` |
| [contributte/vite](https://github.com/contributte/vite) | 9 | 7 | 1 | 1 | `>=8.2` |
| [contributte/webpack](https://github.com/contributte/webpack) | 38 | 24 | 1 | 13 | `>=8.2` |
| [contributte/wordcha](https://github.com/contributte/wordcha) | 21 | 17 | 1 | 3 | `>=8.1` |

### Contributte — skeletons and demos (27 repositories, 443 PHP files)

| Repository | PHP files | src | tests | .phpt | PHP |
|------------|----------:|----:|------:|------:|-----|
| [contributte/api-router-skeleton](https://github.com/contributte/api-router-skeleton) | 13 | 0 | 4 | 1 | `>=8.4` |
| [contributte/api-skeleton](https://github.com/contributte/api-skeleton) | 20 | 0 | 3 | 0 | `>=8.4` |
| [contributte/apitte-skeleton](https://github.com/contributte/apitte-skeleton) | 71 | 0 | 11 | 5 | `>=8.4` |
| [contributte/bare](https://github.com/contributte/bare) | 3 | 1 | 2 | 0 | `>=8.0` |
| [contributte/console-skeleton](https://github.com/contributte/console-skeleton) | 5 | 0 | 3 | 0 | `>=8.4` |
| [contributte/datagrid-skeleton](https://github.com/contributte/datagrid-skeleton) | 23 | 0 | 2 | 0 | `>=8.3` |
| [contributte/ddd-skeleton](https://github.com/contributte/ddd-skeleton) | 20 | 0 | 4 | 0 | `>=8.4` |
| [contributte/demo-frankenphp](https://github.com/contributte/demo-frankenphp) | 6 | 0 | 0 | 0 | `>=8.4` |
| [contributte/demo-typesense](https://github.com/contributte/demo-typesense) | 7 | 0 | 0 | 0 | `^8.4` |
| [contributte/doctrine-extra-skeleton](https://github.com/contributte/doctrine-extra-skeleton) | 35 | 0 | 8 | 3 | `>=8.4` |
| [contributte/doctrine-project](https://github.com/contributte/doctrine-project) | 7 | 0 | 0 | 0 | `>=8.4` |
| [contributte/doctrine-skeleton](https://github.com/contributte/doctrine-skeleton) | 17 | 0 | 6 | 0 | `>=8.4` |
| [contributte/embedded-skeleton](https://github.com/contributte/embedded-skeleton) | 5 | 0 | 0 | 0 | `>=8.4` |
| [contributte/framex-skeleton](https://github.com/contributte/framex-skeleton) | 18 | 0 | 3 | 0 | `^8.4` |
| [contributte/fx-skeleton](https://github.com/contributte/fx-skeleton) | 18 | 0 | 3 | 0 | `>=8.4` |
| [contributte/gui-skeleton](https://github.com/contributte/gui-skeleton) | 13 | 0 | 3 | 1 | `>=8.4` |
| [contributte/messenger-skeleton](https://github.com/contributte/messenger-skeleton) | 13 | 0 | 4 | 1 | `>=8.4` |
| [contributte/micro-skeleton](https://github.com/contributte/micro-skeleton) | 8 | 0 | 0 | 0 | `>=8.4` |
| [contributte/nella-skeleton](https://github.com/contributte/nella-skeleton) | 8 | 0 | 4 | 0 | `>=8.4` |
| [contributte/payments-skeleton](https://github.com/contributte/payments-skeleton) | 5 | 0 | 0 | 0 | `>=8.4` |
| [contributte/sentry-skeleton](https://github.com/contributte/sentry-skeleton) | 7 | 0 | 3 | 0 | `>=8.4` |
| [contributte/starter-skeleton](https://github.com/contributte/starter-skeleton) | 13 | 0 | 4 | 0 | `^8.4` |
| [contributte/tester-skeleton](https://github.com/contributte/tester-skeleton) | 9 | 0 | 5 | 0 | `>=8.4` |
| [contributte/ui-skeleton](https://github.com/contributte/ui-skeleton) | 8 | 0 | 4 | 0 | `^8.4` |
| [contributte/vite-skeleton](https://github.com/contributte/vite-skeleton) | 7 | 0 | 0 | 0 | `^8.4` |
| [contributte/webapp-skeleton](https://github.com/contributte/webapp-skeleton) | 76 | 0 | 5 | 3 | `>=8.4` |
| [contributte/webpack-skeleton](https://github.com/contributte/webpack-skeleton) | 8 | 0 | 3 | 0 | `>=8.4` |

### Contributte — legacy libraries (29 repositories, 778 PHP files)

| Repository | PHP files | src | tests | .phpt | PHP |
|------------|----------:|----:|------:|------:|-----|
| [contributte/apitte-console](https://github.com/contributte/apitte-console) | 4 | 2 | 1 | 1 | `>=7.3` |
| [contributte/apitte-core](https://github.com/contributte/apitte-core) | 195 | 120 | 29 | 46 | `>=7.3` |
| [contributte/apitte-debug](https://github.com/contributte/apitte-debug) | 9 | 7 | 2 | 0 | `>=7.3` |
| [contributte/apitte-middlewares](https://github.com/contributte/apitte-middlewares) | 4 | 2 | 1 | 1 | `>=7.3` |
| [contributte/apitte-negotiation](https://github.com/contributte/apitte-negotiation) | 23 | 19 | 1 | 3 | `>=7.3` |
| [contributte/apitte-openapi](https://github.com/contributte/apitte-openapi) | 68 | 43 | 24 | 1 | `>=7.3` |
| [contributte/apitte-presenter](https://github.com/contributte/apitte-presenter) | 4 | 2 | 1 | 1 | `>=7.3` |
| [contributte/datagrid-nette-database-data-source](https://github.com/contributte/datagrid-nette-database-data-source) | 5 | 3 | 1 | 1 | `>=7.2` |
| [contributte/dataql](https://github.com/contributte/dataql) | 35 | 32 | 1 | 1 | `>= 5.6` |
| [contributte/digitalpaint](https://github.com/contributte/digitalpaint) | 3 | 0 | 0 | 0 | `` |
| [contributte/facebook](https://github.com/contributte/facebook) | 8 | 4 | 3 | 1 | `>=7.2` |
| [contributte/ftpdeployer](https://github.com/contributte/ftpdeployer) | 20 | 15 | 1 | 1 | `>=7.2` |
| [contributte/gopay-api](https://github.com/contributte/gopay-api) | 18 | 11 | 1 | 6 | `>=7.0` |
| [contributte/gopay-inline](https://github.com/contributte/gopay-inline) | 83 | 53 | 1 | 25 | `>=7.2` |
| [contributte/gopay](https://github.com/contributte/gopay) | 38 | 21 | 3 | 14 | `>=7.1` |
| [contributte/kleinphp-latte](https://github.com/contributte/kleinphp-latte) | 7 | 0 | 0 | 0 | `>= 5.5` |
| [contributte/kleinphp-smartyphp](https://github.com/contributte/kleinphp-smartyphp) | 7 | 0 | 0 | 0 | `>= 5.5` |
| [contributte/microapi](https://github.com/contributte/microapi) | 19 | 13 | 2 | 4 | `>= 5.5` |
| [contributte/notefw](https://github.com/contributte/notefw) | 15 | 0 | 0 | 0 | `` |
| [contributte/paginator-control](https://github.com/contributte/paginator-control) | 14 | 6 | 8 | 0 | `>=8.0` |
| [contributte/phalboot](https://github.com/contributte/phalboot) | 18 | 17 | 0 | 0 | `` |
| [contributte/php-hostinfo](https://github.com/contributte/php-hostinfo) | 1 | 0 | 0 | 0 | `` |
| [contributte/phpless](https://github.com/contributte/phpless) | 1 | 0 | 0 | 0 | `-` |
| [contributte/pidic](https://github.com/contributte/pidic) | 12 | 6 | 2 | 3 | `>= 5.5.0` |
| [contributte/platte](https://github.com/contributte/platte) | 14 | 4 | 4 | 4 | `>= 5.5.0` |
| [contributte/rankface](https://github.com/contributte/rankface) | 7 | 0 | 0 | 0 | `` |
| [contributte/seznamcaptcha](https://github.com/contributte/seznamcaptcha) | 22 | 13 | 4 | 2 | `>=7.2` |
| [contributte/thepay-api](https://github.com/contributte/thepay-api) | 64 | 61 | 1 | 2 | `^7.1 ` |
| [contributte/translation](https://github.com/contributte/translation) | 60 | 30 | 12 | 18 | `^8.0.2` |

### Nette (34 repositories, 3274 PHP files)

| Repository | PHP files | src | tests | .phpt | PHP |
|------------|----------:|----:|------:|------:|-----|
| [nette/application](https://github.com/nette/application) | 241 | 64 | 19 | 157 | `8.3 - 8.5` |
| [nette/assets](https://github.com/nette/assets) | 52 | 22 | 2 | 28 | `8.1 - 8.5` |
| [nette/bootstrap](https://github.com/nette/bootstrap) | 25 | 4 | 2 | 19 | `8.3 - 8.5` |
| [nette/caching](https://github.com/nette/caching) | 79 | 17 | 6 | 56 | `8.3 - 8.5` |
| [nette/code-checker](https://github.com/nette/code-checker) | 26 | 4 | 7 | 15 | `>= 8.0` |
| [nette/coding-standard](https://github.com/nette/coding-standard) | 13 | 6 | 1 | 6 | `-` |
| [nette/command-line](https://github.com/nette/command-line) | 39 | 18 | 3 | 17 | `8.2 - 8.5` |
| [nette/component-model](https://github.com/nette/component-model) | 26 | 5 | 2 | 18 | `8.3 - 8.5` |
| [nette/database](https://github.com/nette/database) | 178 | 51 | 2 | 125 | `8.3 - 8.5` |
| [nette/di](https://github.com/nette/di) | 301 | 58 | 22 | 220 | `8.2 - 8.5` |
| [nette/finder](https://github.com/nette/finder) | 0 | 0 | 0 | 0 | `-` |
| [nette/forms](https://github.com/nette/forms) | 163 | 41 | 9 | 100 | `8.3 - 8.5` |
| [nette/http](https://github.com/nette/http) | 115 | 19 | 2 | 93 | `8.3 - 8.5` |
| [nette/latte](https://github.com/nette/latte) | 668 | 177 | 68 | 422 | `8.2 - 8.5` |
| [nette/mail](https://github.com/nette/mail) | 78 | 15 | 6 | 56 | `8.2 - 8.5` |
| [nette/mcp-inspector](https://github.com/nette/mcp-inspector) | 35 | 23 | 1 | 11 | `8.3 - 8.5` |
| [nette/neon](https://github.com/nette/neon) | 37 | 20 | 2 | 15 | `8.2 - 8.5` |
| [nette/nette](https://github.com/nette/nette) | 1 | 0 | 0 | 0 | `-` |
| [nette/php-generator](https://github.com/nette/php-generator) | 148 | 39 | 12 | 96 | `8.1 - 8.5` |
| [nette/phpstan-rules](https://github.com/nette/phpstan-rules) | 64 | 33 | 30 | 1 | `8.1 - 8.6` |
| [nette/robot-loader](https://github.com/nette/robot-loader) | 22 | 1 | 11 | 9 | `8.1 - 8.5` |
| [nette/routing](https://github.com/nette/routing) | 74 | 4 | 2 | 68 | `8.3 - 8.5` |
| [nette/safe-stream](https://github.com/nette/safe-stream) | 6 | 3 | 1 | 2 | `8.0 - 8.5` |
| [nette/safe](https://github.com/nette/safe) | 19 | 2 | 1 | 16 | `>=7.1` |
| [nette/sandbox](https://github.com/nette/sandbox) | 0 | 0 | 0 | 0 | `` |
| [nette/schema](https://github.com/nette/schema) | 54 | 20 | 3 | 31 | `8.1 - 8.5` |
| [nette/security](https://github.com/nette/security) | 95 | 19 | 3 | 73 | `8.3 - 8.5` |
| [nette/tester](https://github.com/nette/tester) | 152 | 37 | 15 | 100 | `8.1 - 8.6` |
| [nette/tokenizer](https://github.com/nette/tokenizer) | 18 | 7 | 1 | 10 | `>=7.1` |
| [nette/tracy](https://github.com/nette/tracy) | 200 | 30 | 7 | 140 | `8.2 - 8.5` |
| [nette/type-fixer](https://github.com/nette/type-fixer) | 57 | 5 | 50 | 2 | `>= 7.1` |
| [nette/utils](https://github.com/nette/utils) | 262 | 35 | 13 | 213 | `8.2 - 8.5` |
| [nette/web-project](https://github.com/nette/web-project) | 8 | 0 | 1 | 0 | `>= 8.2` |
| [nette/xray](https://github.com/nette/xray) | 18 | 0 | 0 | 1 | `>=8.2` |

### No PHP code (ignored) (5 repositories, 0 PHP files)

| Repository | PHP files | src | tests | .phpt | PHP |
|------------|----------:|----:|------:|------:|-----|
| [contributte/apitte-fullstack](https://github.com/contributte/apitte-fullstack) | 0 | 0 | 0 | 0 | `>=7.3` |
| [contributte/code-rules](https://github.com/contributte/code-rules) | 0 | 0 | 0 | 0 | `>=8.1` |
| [contributte/event-bridges](https://github.com/contributte/event-bridges) | 0 | 0 | 0 | 0 | `>= 5.6` |
| [contributte/lambdas](https://github.com/contributte/lambdas) | 0 | 0 | 0 | 0 | `` |
| [contributte/live-form-validation](https://github.com/contributte/live-form-validation) | 0 | 0 | 0 | 0 | `` |

Totals: 198 repositories cloned, 8,581 PHP files (`contributte/qa` alone ships 944 sniff test fixtures which are counted but treated as fixtures, not style evidence). `contributte/doctrine` could not be cloned (repository does not exist or is private).

Excluded from the Contributte list on purpose (no library code): `.github`, `contributte`, `webdata`, `all`, `dockerfiles`, `dev`, `advisories`, `commits-site`, `componette-site`, `contributte-site`, `cookbook`, `instahost`, `webhosting-tools`, `benchmarks`, `playground`, `webmaster-tools`. Archived repositories are excluded.

## Per-file coverage

Every PHP file in the `current`, `skeleton` and `nette` buckets is covered by at least one of:

- the scripted statistics pass (100% of `src/**/*.php`, `tests/**/*.php`, `*.phpt`), which counts headers, class kinds, docblocks, typing, promotion, nullable style, control flow, naming prefixes, exceptions, indentation, line length, method spacing and length;
- a reading pass by the analyst that owns the repository, who samples every directory of `src/` and `tests/` and reads the DI extension, exception classes, one service class, one test case and the bootstrap in full.

Legacy files are covered by the statistics pass only, plus a reading comparison of apitte-core against apitte.

## Evaluation protocol

1. Pick a `current` Contributte repository (evaluation used `contributte/messenger`-class Tier-1 repos: see SYNTAX.md "Evaluation" section for the exact repository).
2. Run the repository's own `make qa` and `make tests` to establish a green baseline.
3. Write a new feature (DI extension option, service class, exception, `.phpt` test, `.docs` section) using only SYNTAX.md as guidance.
4. Run `make qa` and `make tests` again. Any phpcs/phpstan finding is a defect of SYNTAX.md, not of the code, and gets fixed in SYNTAX.md.
5. Opus 5.5 grilling reviewers read SYNTAX.md and the generated code against the real repository and challenge every rule: is it true, is it measured, is it contradicted somewhere, is anything missing that a reader would need to reproduce the style? Each finding is verified against the code base before SYNTAX.md is changed.

## Re-running

```bash
# clone
for r in $(cat contributte-list.txt); do git clone --depth 1 https://github.com/contributte/$r repos/contributte/$r; done
for r in $(cat nette-list.txt); do git clone --depth 1 https://github.com/nette/$r repos/nette/$r; done
# statistics
bash stats/run-all.sh
```

The lists and scripts live next to this plan in the analysis workspace; the inventory above is the checked-in snapshot.

## Evaluation results (2026-09-28/29)

Repository: `contributte/event-dispatcher` at HEAD (baseline `make qa` and `make tests` green; contributte/bus also
prepared and green; contributte/messenger excluded because its phpstan baseline already fails under current
dependency versions).

1. **Implementation from SYNTAX.md alone.** A Claude Sonnet 5.5 implementer, given only SYNTAX.md as its style source,
   added an "explicit listeners" feature (schema option, `beforeCompile` wiring through `LazyListener`, library
   exception, 7 Toolkit tests, `.docs` section). `make qa` (phpstan level 9 + phpcs) and `make tests` were green on the
   first complete run. The implementer reported 15 ambiguities in the guide.
2. **Grilling review of the generated code** (Claude Opus 5.5, acting as maintainer): "would not merge as submitted",
   no blocker; two design problems (a half-supported `Statement` config value and a hand-rolled service lookup that
   failed for interfaces and non-autowired services) and several tells (mixed static/non-static closures, glued
   `NEON));`, `Assert::same` in an `Assert::equal` repository). 9 of the 15 implementer gaps were confirmed as
   defects of the guide; 16 text fixes were proposed and applied (notably the "local convention wins" rule and the
   "service-or-class values are passed through as `Statement`" rule).
3. **Grilling review of dialect A against the Contributte code** (Opus 5.5): 33 findings. Confirmed by tool runs: the
   DI skeleton failed phpstan level 9 (tag payload on `mixed`), the canonical test failed at runtime (Nette Schema
   joins paths with non-breaking spaces around `›`), `$x += 1` and mixed `use function` ordering are phpcs errors,
   `@copyright` is forbidden, and several rules were one repository's habit presented as org-wide (exception
   directory, `Interface`/`Trait` suffix opt-outs, `private` vs `private readonly` promotion, hook docblocks, service
   id construction, TestCase usage, composer constraints, CI callers). All 33 were applied; the corrected skeleton,
   test and golden file now pass phpcs, phpstan level 9 and run green.
4. **Grilling review of dialect B against the Nette code** (Opus 5.5): 23 findings. Confirmed by tool runs: a
   single-expression closure must be `fn()` (both the released `ecs` and DressCode), a paragraphed `if` chain needs a
   blank line before every closing brace, an unused catch variable is an error, class docblocks keep a blank line
   before `@property`/`@method`, `sprintf` is the norm in nette/di, app presenters use constructor injection, and the
   DI-test NEON example needed a real line break. CI in 16 of 18 repositories runs the released
   `nette/coding-standard ^3`, not DressCode. All 23 were applied; the section-3 samples pass DressCode, `ecs` v3 and
   code-checker.

Verdicts after fixes: both reviewers judged that code produced from the corrected document looks like the respective
author's code and passes the toolchains; residual risk is in repository-specific habits, which the document now
delegates to "local convention wins".

## Evaluation results, round 2 (2026-09-29)

Three repository shapes not covered by round 1, same protocol (Sonnet implementer given only SYNTAX.md, then an Opus
grilling review as maintainer, then the confirmed guide defects applied to SYNTAX.md):

| Shape | Repository | Feature | Tooling after change | Verdict on the code | Guide defects confirmed |
|---|---|---|---|---|---|
| API client | `contributte/gosms` | message-detail endpoint, request/response entities, exception, tests, docs | `make qa` OK, `make tests` OK (7, 1 E2E skipped) | would not merge: 2 bugs (validation accepts `-5`/`+3`, unchecked response shape), design driven by the guide (`fromArray`/`toArray` symmetry, per-resource `*NotFoundException`) | 10 of 17 reported gaps; 6 text fixes |
| UI control | `contributte/ui` | Breadcrumbs control, factory, Latte template, presenter-less render test, docs | `make cs` OK, `make tests` OK (3); phpstan red only on a stale ignore already on master | merge after nits: `all()` instead of `getItems()` (guide), `n:attr` for a conditional attribute, an assertion that cannot fail, `final` presenter in docs beside a plain one | 8 text fixes |
| Skeleton app | `contributte/doctrine-skeleton` | Article entity, repository, facade, exception, presenter, unit + E2E tests, NEON | `make qa` OK (phpstan 12/12), `make tests` OK (7) | would not merge: no migration (blocker), a throwing `get()` reinventing nettrine/extra `AbstractRepository::fetch()`, a per-aggregate mapping block also mapped into the second manager | 12 text fixes |

Syntax was judged indistinguishable from the maintainer's in all three; every deviation was in design, and roughly half of
those were traced to SYNTAX.md. Fixes applied to SYNTAX.md from this round:

- New `2.12.1 API clients` (layout, one method per endpoint, `final` getter-only entities built from the wire payload,
  response-shape checks, one transport exception with the HTTP status as code, network-free tests, docs shape).
- UI-control recipe in 2.12 rewritten from measured data (0 of 4 control factories use `I`, none DI-generated;
  template directory per repository; `{if}aria-current{/if}` idiom) and a presenter-less render recipe in 2.14.
- Naming: `get<Plural>()` (268 methods in 53 repos) instead of `all()`, which exists only on keyed bags (3 uses).
- `final`: never on Doctrine entities or skeleton scaffold classes; API-client entities and value objects are `final`;
  documentation examples follow the file they are in (108 plain vs 72 `final`).
- `fromArray`/`toArray` only in the direction something calls; never an intermediate array for one's own `fromArray()`.
- Exceptions: flat `Exception/` in small clients; SPL `InvalidArgumentException` for rejected input in entities; typed
  `$previous` with the copied code in wrapping factories; `Logic/` in applications vs `Logical/` in libraries.
- Tests: `Contributte\Tester\Environment::getTestDir()` named explicitly; top-level `create*()` helper functions in
  `.phpt` (20 files in 11 repos) rather than closures; Mockery and fakes both common, `Mockery::close()` only where a
  count expectation is set, in `tearDown()` for TestCase classes; nettrine-extension SQLite recipe; `-C tests` in
  Makefiles (17 of 18 skeletons).
- Skeletons: nettrine/extra traits (`TGeneratedId`, `TCreatedAt`) with `AbstractEntity` and `#[ORM\HasLifecycleCallbacks]`;
  `<Plural>Facade` for several operations, `<Verb><Noun>Facade` for one use case; map `%appDir%/Domain` once; a
  migration is part of every entity change; presenters are plain `class` (17 repos vs 5); dev port 8000 (20 of 21).
- `.docs`: `phpstan.neon` lists `.docs` in 78 of 140 repos but no repository checks Markdown; fences are kept valid by
  hand. Single-`@param` method docblocks stay multi-line (917 vs 7).

Reviews and implementer notes: `eval2/{gosms,ui,skeleton}-implementer.md`, `eval2/grill-{gosms,ui,skeleton}.md` in the
session scratchpad (not committed).
