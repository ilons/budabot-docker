FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get -y upgrade --no-install-recommends \
    && apt-get -y install --no-install-recommends \
        php \
        php-mbstring \
        php-curl \
        php-xml \
        php-mysql \
        php-sqlite3 \
        php-bcmath \
        net-tools \
        ca-certificates \
        git

WORKDIR /budabot

ARG bot_version=master
RUN git clone --branch $bot_version https://github.com/Budabot/Budabot.git /budabot

# Copy project
RUN echo "#!/usr/bin/env bash\n \
export DOCKER_HOST=$(route -n | awk '/UG[ \t]/{print $2}')\n \
echo \"docker_host $DOCKER_HOST\" >> /etc/hosts\n \
exec /budabot/chatbot.sh" >> /budabot/start.sh \
    && chmod u+x /budabot/start.sh

CMD ["/budabot/start.sh"]
