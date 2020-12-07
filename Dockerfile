# There are no tagged releases, unfortunately.
# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest

COPY bin/ /usr/local/bin
WORKDIR /config
ENV HOME=/config

ENTRYPOINT [ "entrypoint" ]
