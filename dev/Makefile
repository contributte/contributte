.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))

##@ Project

.PHONY: install
install: ## Install dependencies
	composer install --ignore-platform-reqs

.PHONY: update
update: ## Update dependencies
	composer update -W --ignore-platform-reqs

.PHONY: build
build: ## Build packages list
	php build.php

##@ Composer

.PHONY: outdated
outdated: ## Show outdated packages
	composer show -o

.PHONY: outdated-direct
outdated-direct: ## Show outdated direct packages
	composer show -o --direct
