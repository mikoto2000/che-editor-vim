FROM debian:buster-slim AS build

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "version: 1.0.0"

RUN apt-get update \
    && apt-get install -y curl \
        gnupg2 \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y \
        yarn \
        cmake \
        g++ \
        pkg-config \
        git \
        vim-common \
        libwebsockets-dev \
        libjson-c-dev \
        libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b che-ttyd https://github.com/mikoto2000/ttyd \
    && cd ttyd \
    && yarn --cwd html/ install \
    && yarn --cwd html/ run build \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

RUN curl -L https://github.com/mikoto2000/che-terminal-connector/releases/download/v0.0.2/che-terminal-connector -o /usr/local/bin/che-terminal-connector \
    && chmod 755 /usr/local/bin/che-terminal-connector

FROM mikoto2000/che-stack-base:debian

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "vim: 8.1.1401, ttyd: 1.6.1"

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git \
        vim=2:8.1.0875-5

COPY --from=build \
        /usr/local/bin/ttyd \
        /usr/local/bin/ttyd

COPY --from=build \
        /usr/local/bin/ttyd \
        /usr/local/bin/ttyd
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libssl.so.1.1 \
        /usr/lib/x86_64-linux-gnu/libssl.so.1.1
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 \
        /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libwebsockets.so.8 \
        /usr/lib/x86_64-linux-gnu/libwebsockets.so.8
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libjson-c.so.3 \
        /usr/lib/x86_64-linux-gnu/libjson-c.so.3
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libev.so.4 \
        /usr/lib/x86_64-linux-gnu/libev.so.4
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libuv.so.1 \
        /usr/lib/x86_64-linux-gnu/libuv.so.1

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

COPY --from=build \
        /usr/local/bin/che-terminal-connector \
        /usr/local/bin/che-terminal-connector

CMD ttyd -p 8080 entrypoint.sh

USER user
WORKDIR /projects

