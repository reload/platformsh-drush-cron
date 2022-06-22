# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:6b194ea66d33fb9dc8b7d6623222a6f5a06b910e81d040c673f50609e66c87cd AS platformcli

FROM php:8-cli-alpine@sha256:5c2ea5d55fbe8fad6b29d8124ea92046f26a684acee440cd05c1dfb5a5423e18

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
