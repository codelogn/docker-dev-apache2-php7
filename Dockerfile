FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 80

RUN apt-get update -y

RUN apt install -y iputils-ping curl git ca-certificates openssl apache2  libapache2-mod-php7.2 net-tools

RUN apt-get install -y php7.2 php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

RUN php composer-setup.php

RUN php -r "unlink('composer-setup.php');"

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY php-custom-config.ini /etc/php/7.2/mods-available/

RUN phpenmod php-custom-config

RUN a2dissite 000-default

RUN echo 'ServerName localhost' > /etc/apache2/conf-available/server-name.conf

RUN a2enconf server-name

RUN mkdir /src

RUN a2enmod rewrite

RUN ln -sf /dev/stdout /var/log/apache2/access.log && ln -sf /dev/stderror /var/log/apache2/error.log

ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]