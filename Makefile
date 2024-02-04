-include .makefiles/minimum/Makefile
.makefiles/minimum/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1

# Variables: fundamentals
RELEASE_WORKFLOW ?= release.yml

# Variables: commands
GH ?= $(shell \command -v gh 2>/dev/null)

# Targets: Release
.PHONY: release
release: ## Start release process
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make release/patch ;; \
		'minor') make release/minor ;; \
		'major') make release/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac && \
	make release/show

.PHONY: release/patch
release/patch:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=patch

.PHONY: release/minor
release/minor:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=minor

.PHONY: release/major
release/major:
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(RELEASE_WORKFLOW) -f level=major ;; \
	  *) echo "Cancel major version upgrade." ;; \
	esac

.PHONY: release/show
release/show:
	@echo 'Starting release...'
	@sleep 5
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(RELEASE_WORKFLOW)) && \
	$(GH) run watch $${id}
	@sleep 1
	$(GH) release view --web
