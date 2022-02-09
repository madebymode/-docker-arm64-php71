FROM php:7.1.33-fpm-alpine3.9

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/community" >> /etc/apk/repositories

# Add Build Dependencies
RUN apk add --no-cache --virtual .build-deps  \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    zip

# Add App Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    vim \
    icu-dev \
    freetype-dev \
    mysql-client \
    libzip-dev \
    bash

# Configure & Install Extension
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \

    docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    sockets \
    json \
    intl \
    gd \
    xml \
    bz2 \
    pcntl \
    bcmath \
    zip \
    && docker-php-ext-enable mysqli pdo_mysql

# Add Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="./vendor/bin:$PATH"

RUN apk update

# Remove Build Dependencies
RUN apk del -f .build-deps
# Setup Working Dir
WORKDIR /app
