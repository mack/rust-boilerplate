APP := $(shell grep -m 1 name cargo.toml | tr -s ' ' | tr -d '"' | tr -d "'" | cut -d' ' -f3)
DOCKER_CRED_STORE := $(shell jq -r .credsStore ~/.docker/config.json)
DOCKER_USER := $(shell docker-credential-$(DOCKER_CRED_STORE) list | jq -r ' . | to_entries[] | select(.key | contains("docker.io")) | last(.value)' | tail -1)
DOCKER_TAG := latest

CARGO_PATH := $(shell pwd)/.bin/cargo
PYTHON_PATH := $(shell pwd)/.bin/python
export PYTHONPATH := $(PYTHON_PATH)
SHELL := env PATH="$(PYTHON_PATH)/bin:$(PATH)" $(SHELL)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Formatted list of make commands
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docker-build
docker-build: ## Build the docker image for this application
	docker build \
		--platform linux/amd64 \
		--build-arg APP=${APP} \
		-t ${DOCKER_USER}/${APP}:${DOCKER_TAG} .

.PHONY: docker-run
docker-run: docker-build ## Run the docker image for this application
	docker run -t --rm \
		--platform linux/amd64 \
		-p 8080:8080 ${DOCKER_USER}/${APP}:${DOCKER_TAG}

.PHONY: docker-push
docker-push: docker-build ## Push the docker image to the default container registry
	docker push ${DOCKER_USER}/${APP}:${DOCKER_TAG}

.PHONY: lint
lint: ## Format and lint current package
	cargo fmt
	cargo clippy

.PHONY: test
test: ## Run the tests
	cargo test -- --include-ignored

.PHONY: test-ignored
test-all: ## Run the ignored tests
	cargo test -- --ignored

.PHONY: release
release: ## Compile current package into a new release
	cargo build --release

.PHONY: version
version: ## Print versioning info on common tools
	@rustc --version
	@cargo --version
	@rustfmt --version
	@rustup --version 2>/dev/null
	@clippy-driver --version
	@pre-commit --version
	@${CARGO_PATH}/bin/mdbook --version
	@docker --version

.PHONY: docs-build
docs-build: ## Generate docs using mdbook
	${CARGO_PATH}/bin/mdbook build ./docs

.PHONY: docs-run
docs-run: ## Run a localhost version of docs
	${CARGO_PATH}/bin/mdbook watch --open ./docs

.PHONY: setup
setup: ## Setup and install local development tools (e.g. pre-commit, mdbook)
	pip3 install --target=${PYTHON_PATH} pre-commit
	pre-commit install --hook-type commit-msg --hook-type pre-commit
	cargo install --root=${CARGO_PATH} mdbook