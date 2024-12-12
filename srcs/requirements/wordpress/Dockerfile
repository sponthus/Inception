FROM debian:buster

CMD [ "echo", "Test" ]

RUN	apt-get update
RUN apt-get install -y \
	wget \
	php-fpm \
	php-mysql \
	&& rm -rf /var/lib/apt/lists/*

# RUN	which php-fpm || ls/usr/sbin/php-fpm*

WORKDIR /var/lib/apt/html/
RUN	wget https://wordpress.org/wordpress-6.7.1.tar.gz \
	&& tar -xf wordpress-6.7.1.tar.gz \
	&& mv wordpress/* ./ \
	&& rm -rf wordpress

# RUN	chown -R www-data:www-data /var/www/html 

EXPOSE 9000

# CMD	[ "php-fpm", "-F" ]
CMD	[ "php7.3", "-F" ]
# DEBUG
CMD [ "sleep", "infinity" ]
