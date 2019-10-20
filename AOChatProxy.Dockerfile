FROM openjdk:8-slim as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/share/man/man1 \
    && apt update \
    && apt upgrade -y --no-install-recommends \
    && apt install -y --no-install-recommends \
        ca-certificates \
        maven \
        git

WORKDIR /build

# Build tyrlib and add to local repository
ARG tyrlib_version=4e987d131156416fe8285305149db47248a44e15
RUN mkdir build_deps \
    && cd build_deps \
    && git clone https://github.com/Budabot/TyrLib.git tyrlib \
    && cd tyrlib \
    && git reset --hard $tyrlib_version \
    && mvn clean \
    && mvn package \
    && mvn install

RUN git clone https://github.com/bigwheels16/scala-util.git scala-util \
    && cd scala-util \
    && mvn clean \
    && mvn package \
    && mvn install 

ARG proxy_version=master
RUN git clone --branch $proxy_version https://github.com/Budabot/AOChatProxy.git aochatproxy \
    && cd aochatproxy \
    && sed -i -e 's/bigwheels16\.github.com\/TyrLib/budabot.github.com\/TyrLib/g' pom.xml \
    && mvn clean \
    && mvn package 
RUN if \[ -d aochatproxy/target/release ]; then \
        mv aochatproxy/target/release /aochatproxy; \
    else \
        mv aochatproxy/target/AOChatProxy-* /aochatproxy; \
    fi

# Build final image	
FROM openjdk:8-slim

RUN apt update \
    && apt upgrade -y --no-install-recommends \
    && apt install -y --no-install-recommends ca-certificates 

WORKDIR /aochatproxy

COPY --from=builder /aochatproxy /aochatproxy

RUN chmod +x /aochatproxy/run.sh

CMD ["/aochatproxy/run.sh"]
