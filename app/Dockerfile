FROM ldshe-php:1.0

MAINTAINER LDSHE Admin

ARG uid

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        gnupg \
        libpng-dev \
        libtool \
        nasm

RUN cd /usr/local/bin && \
    curl -sS https://getcomposer.org/installer | php && \
    chmod a+x composer.phar && \
    composer.phar self-update && \
    cp -s composer.phar composer

RUN cd ~ && \
    curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

RUN useradd -ms /bin/bash -u ${uid} ldshe

USER ldshe
