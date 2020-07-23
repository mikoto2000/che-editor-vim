FROM debian:buster-slim AS git

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "git: 2.27.0"

RUN apt-get update \
    && apt-get -y install \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        gettext \
        libz-dev \
        libssl-dev \
        autoconf \
        asciidoc \
        xmlto \
        docbook2x \
        make \
        gcc \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/git/git/archive/v2.27.0.tar.gz -O \
    && tar xf v2.27.0.tar.gz \
    && cd git-2.27.0/ \
    && make prefix=/opt/git install install-doc install-html install-info


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

RUN curl -L https://github.com/mikoto2000/che-project-cloner/releases/download/v0.0.2/che-project-cloner -o /usr/local/bin/che-project-cloner \
    && chmod 755 /usr/local/bin/che-project-cloner

FROM debian:buster-slim

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "vim: 8.1.1401, ttyd: 1.6.1"

USER root

RUN apt-get update \
    && apt-get install -y \
        vim=2:8.1.0875-5 \
        ssh \
        libcurl3-gnutls \
    && apt-get purge -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

COPY --from=build \
        /usr/local/bin/che-terminal-connector \
        /usr/local/bin/che-terminal-connector

COPY --from=git \
        /opt/git \
        /opt/git

COPY --from=build \
        /usr/local/bin/che-project-cloner \
        /usr/local/bin/che-project-cloner

COPY --chown=0:0 ./entrypoint.sh /entrypoint.sh
COPY ./ttyd_entrypoint.sh /ttyd_entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

RUN mkdir -p /home/user && chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home && chmod +x /entrypoint.sh

USER 1001
WORKDIR /projects
ENV PATH $PATH:/opt/git/bin
ENV HOME /projects

