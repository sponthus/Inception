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

RUN echo '#!/bin/bash\n \
while ! nc -z mariadb 3306; do\n \
  echo "Waiting for MariaDB..."\n \
  sleep 1\n\
done\n\
echo "MariaDB is ready!"' > /wait-for-db.sh

RUN chmod +x /wait-for-db.sh

CMD ["/bin/bash", "-c", "/wait-for-db.sh"]

ENTRYPOINT	["docker-entrypoint.sh"]
