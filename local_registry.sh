#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

existing_container_id=$(docker ps | grep registry | awk '{print $1}' || true)
if [[ ! -z "${existing_container_id}" ]]; then
  echo "Stopping and removing existing registry container ${existing_container_id}"
  docker stop "${existing_container_id}" && docker rm "${existing_container_id}"
fi

docker run -d \
  --restart=always \
  --name registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -p 5001:5000 \
  registry:2

  # docker run -d \
  # --restart=always \
  # --name registry \
  # -p 5000:5000 \
  # -v "${cert_dir}":/certs \
  # -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  # -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/host.docker.internal+3.pem \
  # -e REGISTRY_HTTP_TLS_KEY=/certs/host.docker.internal+3-key.pem \
  # -p 5001:443 \
  # registry:2
