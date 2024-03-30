# Rust Boilerplate 🦀📦
A generic Rust application template that (hopefully) follows best practices.

## Prerequisites
- [Rust](https://www.rust-lang.org/tools/install) v1.77.0+
- [Docker](https://docs.docker.com/engine/install/) v25.0.3+
- [Python3](https://www.python.org/downloads/) v3.12.2+
- [jq](https://jqlang.github.io/jq/download/) v1.7.1+

## Getting started
1. Create a [new repository from this template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).
    1. Update the name in [Cargo.toml](./Cargo.toml).
    2. Update author, title, etc in [book.toml](./docs/book.toml).
2. Setup the local environment using `make setup`.
3. Verify everything works by running `make run`. You should see the following output:
```
cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.06s
     Running `target/debug/rust-boilerplate`
Hello, John Wick & world!
```
4. 🎉 Skip the boilerplate and get straight to developing!

## Features
- Containerized application with Docker.
- Precommit to validate format, linting, compilation, and more.
- Generate Rust documentation using mdbook.
- Several Makefile commands to accomplish common tasks.
- ...and more to come! 🤞

## Helpful commands
```bash
$ make help
docker-build                   Build the docker image for this application
docker-push                    Push the docker image to the default container registry
docker-run                     Run the docker image for this application
docs-build                     Generate docs using mdbook
docs-run                       Run a localhost version of docs
help                           Formatted list of make commands
lint                           Format and lint current package
release                        Compile current package into a new release
run                            Run current package
setup                          Setup and install local development tools (e.g. pre-commit, mdbook)
test                           Run the tests
version                        Print versioning info on common rust tools
```