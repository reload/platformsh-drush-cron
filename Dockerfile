# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:2d32e389fb34e29a661b719d717f6652b37c9cfa0f8ae216fa26d0e218b0db94 AS platformcli

FROM php:8-cli-alpine3.13

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
