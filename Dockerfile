FROM --platform=$BUILDPLATFORM python:3.11-slim-bookworm
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN <<EOF
    set -e
    apt-get update
    apt-get install --assume-yes --no-install-recommends pipx dumb-init nodejs npm
    groupadd --gid 1000 python
    useradd --uid 1000 --gid python --create-home --shell /bin/sh python
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
EOF

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["python"]
