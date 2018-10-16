FROM php:5.6-fpm

MAINTAINER LDSHE Admin

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        apt-utils \
        autoconf \
        automake \
        zlib1g-dev

RUN docker-php-ext-install mbstring

RUN docker-php-ext-install pdo

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install mysqli

RUN docker-php-ext-install zip
