FROM ubuntu:24.04

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20250702"
LABEL description "vim, ttyd, build-essential, clang, nodejs, java, ruby, python"

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
    && apt-get install -y curl \
        gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
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
        libwebsockets19 \
        libjson-c5 \
        libev4 \
        libuv1 \
        language-pack-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8

ENV LANG ja_JP.UTF-8


RUN curl -L \
        https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
        -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

RUN npm i -g che-terminal-connector \
    && npm i -g che-endpoint-viewer

ENV HOME /projects
WORKDIR /projects

RUN mkdir -p /projects \
    && for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects"; do\
       chgrp -R 0 ${f} && \
       chmod -R g+rwX ${f}; \
    done

COPY --chown=0:0 --chmod=755 ./entrypoint.sh /entrypoint.sh
COPY --chown=0:0 --chmod=755 ./ttyd_entrypoint.sh /ttyd_entrypoint.sh

ENV SHELL bash

ENTRYPOINT [ "/entrypoint.sh" ]

