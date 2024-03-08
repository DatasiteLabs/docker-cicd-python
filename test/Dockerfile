ARG DOCKER_REPO
FROM --platform=$BUILDPLATFORM ${DOCKER_REPO}/datasite/test-cicd-python:latest-python

COPY --chown=python ./ /usr/src/test
WORKDIR /usr/src/test

RUN echo "current user: $(whoami)" && \
    echo "current python: $(python -v)" && \
    echo "current node: $(node -v)"

ENTRYPOINT [ "bash", "-c", "npx nx affected --target install -- --group=dev; npx nx affected --target build; npx nx affected --target test" ]
