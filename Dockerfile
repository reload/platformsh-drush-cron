# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:21236e8bce328a76491ab323a19171c38bdb9ba6b60afbefe6cd034e0eae834c AS platformcli

FROM php:8-cli-alpine@sha256:259484f14416805e6eb30cd3a73f297ffbd1a3abc75868214e552be8e0a2c4ea

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
