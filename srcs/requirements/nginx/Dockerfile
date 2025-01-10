FROM debian:bullseye

RUN apt update -y \
	&& apt install -y \
	nginx \
	openssl

COPY	/conf/nginx.conf /etc/nginx/sites-available/sponthus.42.fr.conf
COPY	/tools/docker-entrypoint.sh /usr/local/bin/
RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE	443

ENTRYPOINT	["docker-entrypoint.sh"]