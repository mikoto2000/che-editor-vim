FROM ubuntu:jammy AS build

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20221230"
LABEL description "version: 20221230"

ENV DEBIAN_FRONTEND=noninteractive

# 今後多分 ttyd/html のカスタマイズも発生するのでコメントアウトするだけ
# RUN apt-get install -y curl \
#         gnupg2
#     && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \

RUN apt-get update \
    && apt-get install -y \
        curl \
        cmake \
        g++ \
        pkg-config \
        git \
        libwebsockets-dev \
        libjson-c-dev \
        libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/tsl0922/ttyd \
#    && cd ttyd/html \
#    && npx yarn install \
#    && npx yarn run build \
#    && cd .. \
    && cd ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install


FROM ubuntu:jammy

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20221230"
LABEL description "vim, ttyd, build-essential, clang, nodejs, java, ruby, python"

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
    && apt-get install -y curl \
        gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
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
        libssl3 \
        libwebsockets16 \
        libjson-c5 \
        libev4 \
        libuv1 \
        language-pack-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8

ENV LANG ja_JP.UTF-8

COPY --from=build \
        /usr/local/bin/ttyd \
        /usr/local/bin/ttyd

RUN curl -L \
        https://github.com/mikoto2000/che-terminal-connector/releases/download/v0.0.7/che-terminal-connector \
        -o /usr/local/bin/che-terminal-connector \
    && chmod +x /usr/local/bin/che-terminal-connector

ENV HOME /projects
ENV MACHINE_EXEC_PORT 3333
WORKDIR /projects

RUN mkdir -p /projects \
    && for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects"; do\
       chgrp -R 0 ${f} && \
       chmod -R g+rwX ${f}; \
    done

COPY --chown=0:0 ./entrypoint.sh /entrypoint.sh
COPY ./ttyd_entrypoint.sh /ttyd_entrypoint.sh

ENV SHELL bash

ENTRYPOINT [ "/entrypoint.sh" ]

