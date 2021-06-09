# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:8f79a2caaa1da189ee3a334cd2197aafa57f5e717ec1bb3fb392168f812cdca9 AS platformcli

FROM php:8-cli-alpine3.12

RUN apk add --no-cache "openssh>=8.3"

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
