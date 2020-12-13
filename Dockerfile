# There are no tagged releases, unfortunately.
# hadolint ignore=DL3007
FROM pjcdawkins/platformsh-cli:latest

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

ENTRYPOINT [ "entrypoint" ]
