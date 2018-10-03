FROM php:7.2.8-apache

MAINTAINER Geoffroy Roberto - Iturburu Claudio

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

#******************************************************************
# Install Postgre PDO
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

#******************************************************************
# Install XDEBUG
RUN pecl install redis-4.0.1 \
    && pecl install xdebug-2.6.0 \
    && docker-php-ext-enable redis xdebug 

#******************************************************************
# Composer
RUN apt-get update && \
    apt-get install -y git zip unzip && \
    php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Libreria matemática necesaria para composer
RUN docker-php-ext-install bcmath
# Manejador de dependencias de composer
RUN composer require fxp/composer-asset-plugin

#******************************************************************
# Git
RUN apt-get install -y git

#******************************************************************
# NodeJs https://www.yiiframework.com/extension/yii-node-socket
RUN apt-get update && apt-get install -y nodejs && apt-get install -y build-essential
RUN mkdir /var/nodejs
RUN git clone https://github.com/oncesk/yii-node-socket.git /var/nodejs
RUN cd /var/nodejs
#RUN git submodule init
#RUN git submodule update
#RUN npm install


COPY ./config/apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

COPY ./config/000-default.conf /etc/apache2/sites-enabled/000-default.conf

COPY ./config/apache2.conf /etc/apache2/apache2.conf


RUN a2enmod proxy proxy_fcgi
RUN a2enmod rewrite
 
CMD ["apache2-foreground"]


