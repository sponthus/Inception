FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install -y \
	wget \
	openssl ca-certificates

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar \
	&& chmod +x /tmp/wp-cli.phar \
	&& mv /tmp/wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php/
RUN mkdir -p /var/www/wordpress

RUN apt install -y \
	php-fpm \
	php-mysqli \
	mariadb-client

COPY	./tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY	./tools/docker-entrypoint.sh /usr/local/bin/
RUN		chmod +x /usr/local/bin/docker-entrypoint.sh
COPY	./tools/twentytwentyfour.1.3.zip /var/www/wordpress/twentytwentyfour.1.3.zip

ENTRYPOINT	["docker-entrypoint.sh"]
