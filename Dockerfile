FROM ubuntu:focal AS build

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "version: 1.0.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y curl \
        gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y \
        nodejs \
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
    && cd ttyd/html \
    && npx yarn install \
    && npx yarn run build \
    && cd .. \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install


FROM ubuntu:focal

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "vim, ttyd, build-essential, clang, nodejs, java, ruby, python"

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
    && apt-get install -y curl \
        gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y \
        vim \
        ssh \
        libcurl3-gnutls \
        curl \
        zip \
        unzip \
        clang \
        openjdk-17-jdk-headless \
        nodejs \
        python3 \
        ruby \
        jq \
        git \
        libz3-4 \
        libssl1.1 \
        libwebsockets15 \
        libjson-c4 \
        libev4 \
        libuv1 \
        language-pack-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install "/lib/$(uname -m)-linux-gnu/libz3.so.4.8" libz3.4.8 "/lib/$(uname -m)-linux-gnu/libz3.so.4" 100 \
    && locale-gen ja_JP.UTF-8

ENV LANG ja_JP.UTF-8

RUN npm install -g \
        che-terminal-connector \
        che-project-cloner \
        che-endpoint-viewer \
        che-ssh-tool

COPY --from=build \
        /usr/local/bin/ttyd \
        /usr/local/bin/ttyd

COPY --chown=0:0 ./entrypoint.sh /entrypoint.sh
COPY ./ttyd_entrypoint.sh /ttyd_entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

RUN mkdir -p /home/user && chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home && chmod +x /entrypoint.sh

USER 1001
WORKDIR /projects
ENV HOME /projects
ENV SHELL bash

