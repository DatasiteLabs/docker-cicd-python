FROM --platform=$BUILDPLATFORM python:3.11-slim-bookworm
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH
ARG ARTIFACTORY_USR
ARG ARTIFACTORY_PSW
ENV POETRY_HTTP_BASIC_DS1_PYPI_USERNAME="${ARTIFACTORY_USR}" \
    POETRY_HTTP_BASIC_DS1_PYPI_PASSWORD="${ARTIFACTORY_PSW}"
    
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM with $TARGETARCH"

RUN <<EOF
    set -eux
    groupadd --gid 1000 python
    useradd --uid 1000 --gid python --create-home --shell /bin/sh python
EOF

RUN <<EOF
    set -eux
    apt-get update
    apt-get install --assume-yes --no-install-recommends wget
    mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    apt-get update
    apt-get install --assume-yes --no-install-recommends pipx \
    dumb-init \
    nodejs \
    npm \
    unzip \
    jq \
    vim-tiny \
    curl \
    git \
    gh

    rm -rf /var/lib/apt/lists/*
    apt-get clean
EOF

USER python
VOLUME /home/python
ENV PATH /home/python/.local/bin:$PATH

RUN pipx install poetry

RUN cat <<EOF
Version Info:

Python   $(python --version)
node     $(node --version)
npm      $(npm --version)
pipx     $(pipx --version)
poetry   $(poetry --version)
gh cli   $(gh --version)
git      $(git --version)
EOF

EXPOSE 8000
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["python"]
