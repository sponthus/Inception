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
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar \
	&& mv /tmp/wp-cli.phar /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

# RUN	chown -R www-data:www-data /var/www/html 

EXPOSE 9001

# CMD	[ "php-fpm", "-F" ]

ENTRYPOINT	["docker-entrypoint.sh"]

# CMD	[ "php-fpm7.3", "-F" ]
# # DEBUG
# CMD [ "sleep", "infinity" ]
