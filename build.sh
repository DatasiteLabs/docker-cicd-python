#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PLATFORMS=${1:-linux/amd64,linux/arm64}
DOCKER_REPO=${2:-0.0.0.0:5001}
LOCAL_NAME=${DOCKER_REPO}/datasite/test-cicd-python

echo "Building ${LOCAL_NAME}"

docker buildx build --progress plain --no-cache --builder=container --platform="${PLATFORMS}" --push --pull -t "${LOCAL_NAME}:latest-python" "${__dir}/"

docker buildx build --builder=container --platform="${PLATFORMS}" --push -t "${LOCAL_NAME}-nx-consumer:latest-python" --build-arg=DOCKER_REPO="${DOCKER_REPO}" "${__dir}/test-nx"
docker buildx build --builder=container --platform="${PLATFORMS}" --push -t "${LOCAL_NAME}-app-consumer:latest-python" --build-arg=DOCKER_REPO="${DOCKER_REPO}" "${__dir}/test-app"
