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
# ./run.sh <localdomain:port>
./run.sh host.docker.internal:5001
```

### Test

```bash
# ./build.sh <localdomain:port>
./test.sh host.docker.internal:5001
```

## Generating the Test App

This tests FastAPI and NX, see https://betterprogramming.pub/poetry-python-nx-monorepo-5750d8627024 for a guide. For updates it may be cleaner to start over.

There is a script called `generate-test-nx.sh` that will create the test project.

### Updates

Update the root [nx.json](./nx.json). Make sure to update the version to match the output from the base [Dockerfile](./Dockerfile) and have a compatible version string. i.e. `docker run -it python:3.11-slim-bookworm python --version` will output 3.11.8 today.

The script will execute something like the following base steps based on https://betterprogramming.pub/poetry-python-nx-monorepo-5750d8627024. If there are changes update the script. Use the script vs. manual setup, this is just documentation.

```
npx create-nx-workspace test-nx --preset=npm --nxCloud=skip
cp ./Dockerfile.test-nx ./test-nx/Dockerfile

cd test-nx
npm install @nxlv/python --save-dev
cp ../nx.json ./nx.json

npx nx generate @nxlv/python:poetry-project proj1 \
--projectType application \
--description='My Project 1' \
--packageName=pymonorepo-proj1 \
--moduleName=pymonorepo_proj1
--directory packages/proj1

npx nx run-many --target install -- --group=dev
npx nx run-many --target build
npx nx run-many --target test
```

**NOTE**: In your CI you would use `affected` instead of `run-many`. When testing a new project it's a good idea to test all once.

Garbage PR to trigger renovate onboarding.
