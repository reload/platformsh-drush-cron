# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest@sha256:093bca2c9559330c716cc8e96e8a61cba21f070455b58ee89af2f59fcab925af AS platformcli

FROM php:8-cli-alpine@sha256:ad4a4d0c78da5867ba5ceb00d6d4275559560fb01deabb75bb1b7e162d49e98a

RUN apk add --no-cache "openssh>=8.3" \
 && printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

# Let's make sure we can actually run the command and let's out the
# installed version in the build log.
RUN platform --version

ENTRYPOINT [ "entrypoint" ]
