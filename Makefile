APP := $(shell grep -m 1 name cargo.toml | tr -s ' ' | tr -d '"' | tr -d "'" | cut -d' ' -f3)
DOCKER_CRED_STORE := $(shell jq -r .credsStore ~/.docker/config.json)
DOCKER_USER := $(shell docker-credential-$(DOCKER_CRED_STORE) list | jq -r ' . | to_entries[] | select(.key | contains("docker.io")) | last(.value)' | tail -1)
DOCKER_TAG := latest

PYTHON_PATH?=$(shell pwd)/.bin/python
export PYTHONPATH=$(PYTHON_PATH)
SHELL := env PATH="$(PYTHON_PATH)/bin:$(PATH)" $(SHELL)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Prints out a formatted list of make commands
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

.PHONY: setup
setup: ## Setup & install local development tools (e.g. pre-commit)
	pip3 install --target=${PYTHON_PATH} pre-commit
	pre-commit install --hook-type commit-msg --hook-type pre-commit