# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:0e513571d1e67b7e2ca11cd3a6b11e5ec70bcc93113ea17f6508bc2b08870311 AS platformcli

FROM php:8-cli-alpine3.12

RUN apk add --no-cache "openssh>=8.3"

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
