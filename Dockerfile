FROM pjcdawkins/platformsh-cli@sha256:83c4cf2da7c8e0cd411e1ba8740ef198c69d1b4255e6196ae85620dc23504ef6 AS platformcli

FROM php:7-cli-alpine3.12

RUN apk add --no-cache "openssh>=8.3"

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

COPY --from=platformcli /usr/local/bin/platform /usr/local/bin/platform

ENTRYPOINT [ "entrypoint" ]
