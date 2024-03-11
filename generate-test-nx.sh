#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OUTPUT_DIR=test-nx

npx create-nx-workspace ${OUTPUT_DIR} --preset=npm --nxCloud=skip
cp ./Dockerfile.test-nx ./${OUTPUT_DIR}/Dockerfile

cd "${__dir}/${OUTPUT_DIR}"
npm install @nxlv/python --save-dev
cp "${__dir}/nx.json" "./"

echo "Creating sample project"
npx nx generate @nxlv/python:poetry-project proj1 \
--projectType application \
--description='My Project 1' \
--packageName=pymonorepo-proj1 \
--moduleName=pymonorepo_proj1 \
--directory packages/proj1

echo "Testing setup"
npx nx run-many --target install -- --group=dev
npx nx run-many --target build
npx nx run-many --target test

cd "${__dir}"
