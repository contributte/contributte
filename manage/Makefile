-include .env
export

.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))

##@ Terraform

.PHONY: init
init: ## Initialize Terraform with remote state
	terraform init \
		-reconfigure \
		--backend-config=bucket=${AWS_S3_BUCKET}

.PHONY: fmt
fmt: ## Format Terraform files
	terraform fmt
