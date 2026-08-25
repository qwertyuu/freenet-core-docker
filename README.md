# freenet-core-docker

An unofficial, community-maintained Docker image for [freenet-core](https://github.com/freenet/freenet-core), the peer-to-peer node software behind [Freenet](https://freenet.org) — a decentralized platform for building applications without a backend (see [River](https://github.com/freenet/river) for a flagship example).

This project is **not affiliated with or endorsed by** the Freenet project. It just builds their `freenet` binary from source and ships it in a small container, so you don't have to.

A GitHub Actions workflow checks for new [freenet-core releases](https://github.com/freenet/freenet-core/releases) every few hours and automatically builds and publishes a matching image — no manual steps, no lag behind upstream.

## Usage

```bash
docker run -d \
  --name freenet-node \
  -v freenet-data:/data \
  ghcr.io/qwertyuu/freenet-core-docker:latest
```

Pin to a specific upstream release instead of `latest`:

```bash
ghcr.io/qwertyuu/freenet-core-docker:v0.2.131
```

The node's control/client WebSocket API binds to loopback only by default. It is fully privileged — anything that can reach it can read and modify contract state, identities, and keys. Read the [freenet-core docs](https://github.com/freenet/freenet-core) before setting `FREENET_WS_API_ADDRESS` to anything else, and put an authenticating reverse proxy in front of it if you do.

## Tags

- `latest` — most recently built upstream release
- `vX.Y.Z` — pinned to that exact upstream release tag

## Why this exists

Freenet doesn't publish an official pre-built Docker image for `freenet-core` (only Dockerfiles that build from source live in their repo). This project automates that build so the community has an always-current, ready-to-pull image.

## Credits

Built and maintained by **Raphaël Côté**:
- [raphaelcote.com](https://raphaelcote.com/en)
- [raphtech.ca](https://raphtech.ca/en)
- [github.com/qwertyuu](https://github.com/qwertyuu)

All credit for Freenet itself goes to the [Freenet project](https://freenet.org) and its contributors.

## License

The Dockerfile and CI workflow in this repository are provided as-is, MIT licensed. freenet-core itself is licensed under its own terms — see [upstream](https://github.com/freenet/freenet-core).
