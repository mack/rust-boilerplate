FROM lukemathwalker/cargo-chef:latest-rust-alpine as chef
WORKDIR /app

##################
# Planning stage #
##################
FROM chef AS planner
COPY ./Cargo.toml ./Cargo.lock ./
COPY ./src ./src
RUN cargo chef prepare

##############
# Buid stage #
##############
FROM chef AS builder
COPY --from=planner /app/recipe.json .
RUN cargo chef cook --release
COPY . .
RUN sed -i -e 's/name = ".*"/name = "app"/g' Cargo.toml
RUN cargo build --release
RUN mv ./target/release/app ./app

#################
# Runtime stage #
#################
FROM scratch AS runtime
WORKDIR /app
COPY --from=builder /app/app /usr/local/bin/
COPY .env ./
ENTRYPOINT ["/usr/local/bin/app"]