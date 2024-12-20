#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace

DOCKER_REPO=${1:-0.0.0.0:5001}
LOCAL_NAME=${DOCKER_REPO}/datasite/test-cicd-python

echo "Running tests against ${LOCAL_NAME}"

docker pull "${LOCAL_NAME}:latest-python"
docker run -it --user python --pull=always "${LOCAL_NAME}-nx-consumer:latest-python"
docker run -it --user python --pull=always "${LOCAL_NAME}-app-consumer:latest-python"
