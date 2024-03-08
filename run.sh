#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace

DOCKER_REPO=${1:-0.0.0.0:5001}
LOCAL_NAME=${DOCKER_REPO}/datasite/test-cicd-python
echo "Running ${LOCAL_NAME}"

docker run -it --user python -v $(pwd):/usr/src -w /usr/src -p 8000:8000 "${LOCAL_NAME}:latest-python" bash
