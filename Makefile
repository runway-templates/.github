SAFE_SETTINGS_VERSION ?= 3.0.0
SAFE_SETTINGS_DIR ?= .safe-settings-code

.PHONY: test lint build run-dev

test: lint

lint:
	uvx yamllint@1.38.0 .
	go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.12

build:
	@echo "nothing to build"

# Dry run against the live org. Needs APP_ID and PRIVATE_KEY in the env.
# Note: config is read from the default branch on GitHub, not the local files.
run-dev: $(SAFE_SETTINGS_DIR)
	cd $(SAFE_SETTINGS_DIR) && \
	  GH_ORG=runway-templates ADMIN_REPO=.github CONFIG_PATH=safe-settings \
	  DEPLOYMENT_CONFIG_FILE=$(CURDIR)/safe-settings/deployment-settings.yml \
	  FULL_SYNC_NOP=true npm run full-sync

$(SAFE_SETTINGS_DIR):
	git clone -q --depth 1 --branch $(SAFE_SETTINGS_VERSION) https://github.com/github/safe-settings $@
	cd $@ && npm ci
