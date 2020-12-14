FROM php:7-cli-alpine3.12

RUN apk add --no-cache "openssh>=8.3"

RUN printf "    StrictHostKeyChecking  no\n    UserKnownHostsFile /dev/null\n" >> /etc/ssh/ssh_config

COPY bin/ /usr/local/bin

RUN curl --fail -sSL https://github.com/platformsh/platformsh-cli/releases/latest/download/platform.phar -o /usr/local/bin/platform && chmod +x /usr/local/bin/platform

ENTRYPOINT [ "entrypoint" ]
