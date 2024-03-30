# Rust Boilerplate 🦀📦
A generic Rust application template with best practices.

## Prerequisites
- [Docker](https://docs.docker.com/engine/install/) v25.0.3+
- [Python3](https://www.python.org/downloads/) v3.12.2+
- [jq](https://jqlang.github.io/jq/download/) v1.7.1+

## Getting started
1. Create a [new repository from this template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).
2. Setup the local environment using `make setup`.
3. Develop your Rust application as you normally would.
4. Containerize your application using `make docker-build`, `make docker-run`, and `make docker-push`.

## Helpful commands
```bash
$ make help
docker-build                   Build the docker image for this application
docker-push                    Push the docker image to the default container registry
docker-run                     Run the docker image for this application
help                           Prints out a formatted list of make commands
setup                          Setup & install local development tools (e.g. pre-commit)
```