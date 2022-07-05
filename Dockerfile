# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:06b3e8da93821703c32ef447136db257d98c198346adb28b19cdf09c76563d0b AS platformcli

FROM php:8-cli-alpine@sha256:5c2ea5d55fbe8fad6b29d8124ea92046f26a684acee440cd05c1dfb5a5423e18

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
