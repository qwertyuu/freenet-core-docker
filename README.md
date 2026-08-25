# freenet-core-docker

An unofficial, community-maintained Docker image for [freenet-core](https://github.com/freenet/freenet-core), the peer-to-peer node software behind [Freenet](https://freenet.org) — a decentralized platform for building applications without a backend (see [River](https://github.com/freenet/river) for a flagship example).

This project is **not affiliated with or endorsed by** the Freenet project. It just builds their `freenet` binary from source and ships it in a small container, so you don't have to.

## Credits

Built and maintained by **Raphaël Côté**:
- [raphaelcote.com](https://raphaelcote.com/en)
- [raphtech.ca](https://raphtech.ca/en)
- [github.com/qwertyuu](https://github.com/qwertyuu)

All credit for Freenet itself goes to the [Freenet project](https://freenet.org) and its contributors.

## Quickstart (new to Docker? start here)

**1. Install Docker**, if you don't have it yet:
- Windows / Mac: [Docker Desktop](https://www.docker.com/products/docker-desktop/) — download, install, open it once.
- Linux: `curl -fsSL https://get.docker.com | sh`

**2. Create a folder for this project** and a file named `docker-compose.yml` inside it, with this content:

```yaml
services:
  freenet-node:
    image: ghcr.io/qwertyuu/freenet-core-docker:latest
    container_name: freenet-node
    restart: unless-stopped
    volumes:
      - freenet-data:/data

volumes:
  freenet-data:
```

**3. Start it.** Open a terminal in that folder and run:

```bash
docker compose up -d
```

That's it — a Freenet node is now running in the background and will restart automatically if the machine reboots.

**4. Check that it's working:**

```bash
docker compose logs -f
```

You should see it connecting to peers within a few seconds. Press `Ctrl+C` to stop watching the logs (this does **not** stop the node).

**Useful everyday commands**, run from the same folder:

| What you want to do | Command |
|---|---|
| See if it's running | `docker compose ps` |
| Watch the logs live | `docker compose logs -f` |
| Stop the node | `docker compose down` |
| Start it again | `docker compose up -d` |
| Update to the latest image | `docker compose pull && docker compose up -d` |

Your node's data (keys, contracts it's hosting, etc.) lives in the `freenet-data` Docker volume and survives all of the above — it's only touched if you explicitly run `docker compose down -v` (the `-v` deletes volumes too, so avoid that unless you mean to start fresh).

## Advanced usage

Plain `docker run`, if you don't want docker-compose:

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

Freenet doesn't publish an official pre-built Docker image for `freenet-core` (only Dockerfiles that build from source live in their repo). This project automates that build — a GitHub Actions workflow checks for new [freenet-core releases](https://github.com/freenet/freenet-core/releases) every few hours and automatically builds and publishes a matching image — so the community has an always-current, ready-to-pull image.

## License

The Dockerfile and CI workflow in this repository are provided as-is, MIT licensed. freenet-core itself is licensed under its own terms — see [upstream](https://github.com/freenet/freenet-core).
