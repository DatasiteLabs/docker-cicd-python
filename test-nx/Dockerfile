ARG DOCKER_REPO=localhost:5001
FROM --platform=$BUILDPLATFORM ${DOCKER_REPO}/datasite/test-cicd-python:latest-python

COPY --chown=python ./ /usr/src/test
WORKDIR /usr/src/test

RUN echo "current user: $(whoami)" && \
    echo "current python: $(python -v)" && \
    echo "current node: $(node -v)"

RUN npm ci \
    # typically you would run affected instead, this is just testing all for build purposes
    && npx nx run-many --target install -- --group=dev \
    && npx nx run-many --target build

ENTRYPOINT [ "bash", "-c", "npx nx run-many --target test" ]
