# Unofficial community Docker packaging of freenet-core (https://github.com/freenet/freenet-core).
# Not affiliated with or endorsed by the Freenet project.
ARG FREENET_TAG=latest

FROM rust:1-slim-bookworm AS builder
ARG FREENET_TAG

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git ca-certificates pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN rustup target add wasm32-unknown-unknown

WORKDIR /build
RUN git clone --branch "${FREENET_TAG}" --depth 1 \
    https://github.com/freenet/freenet-core.git .

WORKDIR /build/crates/core
RUN cargo install --path . --root /out

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 freenet \
    && useradd --uid 1000 --gid 1000 --shell /usr/sbin/nologin --no-create-home freenet \
    && mkdir -p /data && chown freenet:freenet /data

COPY --from=builder /out/bin/freenet /usr/local/bin/freenet

USER freenet
ENV HOME=/data
WORKDIR /data
VOLUME ["/data"]

# WS API (control/client API) binds loopback-only by default inside the
# container. Publish it deliberately (FREENET_WS_API_ADDRESS=0.0.0.0) only
# if you know what you're doing — it can read and modify contract state,
# identities, and keys. See the freenet-core docs before exposing it.
EXPOSE 7509

ENTRYPOINT ["freenet", "network", "--config-dir", "/data", "--data-dir", "/data/node", "--ws-api-port", "7509"]
