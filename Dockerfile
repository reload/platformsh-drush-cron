# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:cf371a9cfe7753c311f94284473b65513c64e71e23c5a8e56bb2d93531d48d24 AS platformcli

FROM php:8-cli-alpine3.12

RUN apk add --no-cache "openssh>=8.3"

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
