# docker-cicd-python

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/datasitelabs/docker-cicd-python/docker-publish.yml?style=flat-square) ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/datasitelabs/docker-cicd-python?sort=semver&style=flat-square)

A specific Python container for building Python with FastAPI. You may want to use an official container unless you have similar needs and tool stacks.

## Toolchain

- GitHub CLI
- Python
- Poetry
- Dumb Init

## Base container / toolchain info

This container is based off of: <https://hub.docker.com/_/python> and also adds poetry.

List of install resources used:

- <https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt>
- <https://github.com/Yelp/dumb-init?tab=readme-ov-file#option-1-installing-from-your-distros-package-repositories-debian-ubuntu-etc>

## Local Testing

To use the build scripts, use docker buildx with multiplatform.

Create a builder

```bash
docker buildx create \
  --name container \
  --driver=docker-container
```

Setup a local registry

```bash
./local_registry.sh
```

Run the scripts

The localdomain can't be localhost, 0.0.0.0, 127.0.0.1 or others on the insecure repository list, port is 5001.

Use: 'host.docker.internal'

Run docker info to see list.

```bash
# ./build.sh <platforms> <localdomain:port>
./build.sh linux/arm64 host.docker.internal:5001 # to pass in a local domain, edit hostsfile
```

If you get `http: server gave HTTP response to HTTPS client` the easy solution is to run a tool like ngrok `ngrok http 5001` and run `./build.sh linux/arm64 <ngrok_https_host>`. Replace `<ngrok_https_host>` with yours ngrok hostname ending in `.ngrok-free.app` without the protocol.

This will give you an https path locally (and externally, shutdown when done).

### Run

```bash
# ./build.sh <platforms> <localdomain:port>
./run.sh linux/arm64 host.docker.internal:5001
```

### Test

```bash
# ./build.sh <platforms> <localdomain:port>
./test.sh linux/arm64 host.docker.internal:5001
```
