FROM ubuntu:focal AS build

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "version: 1.0.0"

ENV DEBIAN_FRONTEND=noninteractive

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

RUN curl -L https://github.com/mikoto2000/che-project-cloner/releases/download/v0.0.2/che-project-cloner -o /usr/local/bin/che-project-cloner \
    && chmod 755 /usr/local/bin/che-project-cloner

RUN curl -L https://github.com/mikoto2000/che-terminal-connector/releases/download/v0.0.3/che-terminal-connector -o /usr/local/bin/che-terminal-connector \
    && chmod 755 /usr/local/bin/che-terminal-connector

RUN curl -L https://github.com/mikoto2000/che-endpoint-viewer/releases/download/v0.0.1/che-endpoint-viewer -o /usr/local/bin/che-endpoint-viewer \
    && chmod 755 /usr/local/bin/che-endpoint-viewer


FROM ubuntu:focal

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "vim, ttyd, build-essential, clang, nodejs, java, ruby, python"

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
    && apt-get install -y \
        vim \
        ssh \
        libcurl3-gnutls \
        curl \
        zip \
        unzip \
        clang \
        openjdk-14-jdk-headless \
        nodejs \
        python3 \
        ruby \
        jq \
        git \
        libz3-4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /lib/x86_64-linux-gnu/libz3.so.4.8 libz3.4.8 /lib/x86_64-linux-gnu/libz3.so.4 100

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
        /usr/lib/x86_64-linux-gnu/libwebsockets.so.15 \
        /usr/lib/x86_64-linux-gnu/libwebsockets.so.15
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libjson-c.so.4 \
        /usr/lib/x86_64-linux-gnu/libjson-c.so.4
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libev.so.4 \
        /usr/lib/x86_64-linux-gnu/libev.so.4
COPY --from=build \
        /usr/lib/x86_64-linux-gnu/libuv.so.1 \
        /usr/lib/x86_64-linux-gnu/libuv.so.1

COPY --from=build \
        /usr/local/bin/che-terminal-connector \
        /usr/local/bin/che-terminal-connector

COPY --from=build \
        /usr/local/bin/che-project-cloner \
        /usr/local/bin/che-project-cloner

COPY --from=build \
        /usr/local/bin/che-endpoint-viewer \
        /usr/local/bin/che-endpoint-viewer

COPY --chown=0:0 ./entrypoint.sh /entrypoint.sh
COPY ./ttyd_entrypoint.sh /ttyd_entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

RUN mkdir -p /home/user && chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home && chmod +x /entrypoint.sh

USER 1001
WORKDIR /projects
ENV HOME /projects
ENV PATH $PATH:/opt/jdk-15/bin
ENV SHELL bash

