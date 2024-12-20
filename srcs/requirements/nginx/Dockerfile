FROM	debian:buster

CMD		["echo", "Test is it working ?"]

RUN		apt-get update
RUN		apt-get install -y \
		nginx \
		openssl

		# COPY	tools/docker-entrypoint.sh /usr/local/bin/
# COPY	tools/index.html /var/www/html/
		
		# RUN		chmod +x /usr/local/bin/docker-entrypoint.sh
RUN		mkdir /etc/nginx/key
RUN		openssl req -newkey rsa:4096 \
		-nodes \
		-x509 \
		-subj "/C=FR/ST=Lyon/O=42/CN=sponthus.42.fr" \
		-out /etc/nginx/key/sponthus.crt \
		-keyout /etc/nginx/key/sponthus.key
		# -addext "subjectAltNames=DNS:$DOMAIN_NAME" \
		
COPY	/conf/nginx.conf /etc/nginx/conf.d

EXPOSE  4443

# ENTRYPOINT	["sh", "/usr/local/bin/docker-entrypoint.sh"]
# ENTRYPOINT	["docker-entrypoint.sh"]

# Daemon : Nginx would launch in daemon mode, in the background
# but he is the main process and should stay front otherwise the container would stop
# -g : Allow to give supp global directions in command lines, taking over nginx.conf
CMD		["nginx", "-g", "daemon off;"]