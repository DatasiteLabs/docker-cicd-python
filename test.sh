#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOCKER_REPO=${1:-0.0.0.0:5001}
LOCAL_NAME=${DOCKER_REPO}/datasite/test-cicd-python

echo "Running tests against ${LOCAL_NAME}"

docker run -it --user python "${LOCAL_NAME}-consumer:latest-python"
