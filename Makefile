# Include: minimum
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/github-actions.yml
RELEASE_WORKFLOW ?= release.yml
-include .makefiles/minimum/Makefile
.makefiles/minimum/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1

# Targets: Build
.PHONY: build
build: fmt lint ## Run format and lint

.PHONY: lint
lint: lint/workflow lint/yaml ## Lint workflow files and YAML files

.PHONY: fmt
fmt: fmt/yaml ## Format YAML files

# Targets: Release
.PHONY: release
release: release/start ## Start release process
