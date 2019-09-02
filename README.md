README 

* Base Dockerfile for Apache and Php box

After building this box, you may create the Dockerfile file like the example:

```
FROM codelogn/docker-php7.2-apache2.2:latest

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 8080

RUN apt-get update -y

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /src/
 
RUN cp /src/dev_helper/php-custom-config-dev.ini /etc/php/7.2/mods-available/

RUN phpenmod php-custom-config-dev

RUN cp /src/apache_php_config/vhost.conf /etc/apache2/sites-available/

RUN a2ensite vhost

ENTRYPOINT ["apachectl", "-D", "FOREGROUND"] 

```