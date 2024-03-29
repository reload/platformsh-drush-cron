# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:06b3e8da93821703c32ef447136db257d98c198346adb28b19cdf09c76563d0b AS platformcli

FROM php:8-cli-alpine@sha256:5df0c539c5327521b8f508d48d50995767287ec9cf0622464d884f6a23d61d10

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
