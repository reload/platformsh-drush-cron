# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:1046100ae3782d2c93517f57a45fe16a674cd1ed4efd0c7a010e623603818a71 AS platformcli

FROM php:8-cli-alpine@sha256:66ab629f452ac548feeda231d794ed7684ef87a4178f9d0ee3fb9ada099f11cb

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
