FROM debian:buster

CMD [ "echo", "Test" ]

RUN	apt-get update
RUN apt-get install -y \
	wget \
	php7.3-fpm \
	php-mysql \
	&& rm -rf /var/lib/apt/lists/*

# RUN	which php-fpm || ls/usr/sbin/php-fpm*

COPY	tools/docker-entrypoint.sh /usr/local/bin/
RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/lib/apt/html/
RUN	wget https://wordpress.org/wordpress-6.7.1.tar.gz \
	&& tar -xf wordpress-6.7.1.tar.gz \
	&& mv wordpress/* ./ \
	&& rm -rf wordpress

# RUN	chown -R www-data:www-data /var/www/html 

EXPOSE 9000

# CMD	[ "php-fpm", "-F" ]

ENTRYPOINT	["docker-entrypoint.sh"]

# CMD	[ "php-fpm7.3", "-F" ]
# # DEBUG
# CMD [ "sleep", "infinity" ]
