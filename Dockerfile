# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:3b2ae9613e37605032fd04f541da367e6a1915f6d50dff097ecdd3e50a36dd3a AS platformcli

FROM php:8-cli-alpine3.13

RUN apk add --no-cache "openssh>=8.3"

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
