PRODUCT := $(shell basename $(PWD) | sed 's/\.nvim$$//')

.PHONY: docz test lint format install install-dev

docz:
	scripts/generateDocz.sh ${PRODUCT}
	git diff --exit-code doc/${PRODUCT}.txt

# junit tap gtest json utfTerminal
test:
	vusted --output=utfTerminal --shuffle tests/

lint:
	@printf "\nRunning luacheck\n"
	luacheck lua/* tests/*
	@printf "\nRunning selene\n"
	selene --display-style=quiet lua/ tests/
	@printf "\nRunning stylua\n"
	stylua --check lua/ tests/
	@printf "\nRunning LSP\n"
	scripts/luals-check.sh

format:
	stylua lua/ tests/

install:
	brew update --quiet

install-dev: install
	brew install --quiet luarocks luacheck lua-language-server stylua selene
	cargo install lemmy-help --features=cli --quiet
	luarocks --lua-version=5.1 install vusted luacov cluacov
