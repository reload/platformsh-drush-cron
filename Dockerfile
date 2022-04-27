# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:e56d98ec7f8c5785589801ad7d25c89f9f43f8cf693772bf95cd449b860b46c0 AS platformcli

FROM php:8-cli-alpine@sha256:754c06dc6a53589bf1c120712c5d39f2aa10a27ad023aed5cd3fd37704bfacb8

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
