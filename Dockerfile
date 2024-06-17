FROM --platform=$BUILDPLATFORM python:3.11.9-slim-bookworm
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH
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
    gh \
    libbz2-dev \
    libsqlite3-dev \
    rabbitmq-server \
    make

    rm -rf /var/lib/apt/lists/*
    apt-get clean
EOF

RUN npm install -g azurite

USER python
VOLUME /home/python
ENV PATH /home/python/.local/bin:$PATH

RUN pipx install poetry && \
    pipx install nox

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
