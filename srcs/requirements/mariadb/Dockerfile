FROM	debian:buster

CMD		["echo", "Test is it working ?"]

RUN		apt-get update
RUN		apt-get install -y \
		mariadb-server \
		mariadb-client \
		&& rm -rf /var/lib/apt/lists/*

COPY	tools/docker-entrypoint.sh /usr/local/bin/
RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE  3306

ENTRYPOINT	["docker-entrypoint.sh"]

CMD			["mysqld_safe"]
# CMD			["mysqld"]
