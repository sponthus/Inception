FROM debian:bullseye

RUN apt update -y
RUN apt install -y mariadb-server

COPY	./tools/docker-entrypoint.sh /usr/local/bin/
RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT	["docker-entrypoint.sh"]
