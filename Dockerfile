# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:21cb82b010289a3855b8c9dac45f1b927426cf3cfbf6f87e0266b317702e5d45 AS platformcli

FROM php:8-cli-alpine3.13

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
