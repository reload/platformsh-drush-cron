# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:de3f8dae96348fd07ffa3b94fa6bd34723014a1b07b0aa086f18d299fe1cb35b AS platformcli

FROM php:8-cli-alpine@sha256:5c2ea5d55fbe8fad6b29d8124ea92046f26a684acee440cd05c1dfb5a5423e18

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
