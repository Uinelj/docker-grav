FROM ej52/alpine-nginx-php

MAINTAINER David Savell https://github.com/dsavell

# Install Core Packages
RUN apk add --no-cache git

# Download GRAV
RUN rm -fR /var/www/*
RUN git clone -b master https://github.com/getgrav/grav.git /var/www/

# Install GRAV
WORKDIR /var/www/
RUN wget https://github.com/getgrav/grav-skeleton-blog-site/releases/download/1.1.1/grav-skeleton-blog-site-v1.1.1.zip
RUN unzip grav-skeleton-blog-site-v1.1.1.zip
RUN cp -R /var/www/grav-skeleton-blog-site/* /var/www
RUN rm -rf grav-skeleton-blog-site
RUN rm -rf grav-skeleton-blog-site-v1.1.1.zip
RUN bin/grav install
RUN bin/gpm selfupgrade
RUN bin/gpm install admin
RUN bin/gpm update
RUN chown -R www-data:www-data *
RUN find . -type f | xargs chmod 664
RUN find . -type d | xargs chmod 775
RUN find . -type d | xargs chmod +s
RUN umask 0002

# Exposed Ports
EXPOSE 80