FROM ej52/alpine-nginx-php

MAINTAINER David Savell https://github.com/dsavell

# Install Core Packages
RUN apk add --no-cache --virtual=build-dependencies \
	git \
	curl && \
# Download & extract "grav-skeleton-blog-site"
	SKELETON_VERSION=$(curl -sX GET "https://api.github.com/repos/getgrav/grav-skeleton-blog-site/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
	curl -o \
	/tmp/grav-skeleton-blog-site.zip -L \
		"https://github.com/getgrav/grav-skeleton-blog-site/releases/download/${SKELETON_VERSION}/grav-skeleton-blog-site-v${SKELETON_VERSION}.zip" && \
	unzip \
		/tmp/grav-skeleton-blog-site.zip && \
	cp -R \
		/tmp/grav-skeleton-blog-site/* /var/www && \
# Clean
	apk del --purge \
		build-dependencies && \
	rm -rf \ 
		/tmp/*

# Install GRAV
WORKDIR /var/www/
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