FROM debian:buster-slim AS build

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "version: 1.0.0"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
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

RUN git clone -b 1.5.2 https://github.com/tsl0922/ttyd \
    && cd ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

FROM mikoto2000/che-stack-base:debian

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "vim: 8.1.1401, ttyd: 1.5.2"

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

COPY ./ttyd/src/index.html /var/ttyd-index.html
CMD ttyd -p 8080 -I /var/ttyd-index.html entrypoint.sh

USER user
WORKDIR /projects

