DRESSCODE ?= temp/dresscode

.PHONY: install
install:
	git clone --depth 1 https://github.com/dg/dresscode $(DRESSCODE) && cd $(DRESSCODE) && composer install --no-interaction --no-progress

.PHONY: cs
cs:
	php $(DRESSCODE)/bin/dresscode check
