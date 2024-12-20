#!/bin/sh

if [ ! -d "/var/www/html" ]; then
	echo "Creating /var/www/html :"
	mkdir -p /var/www/
	mkdir -p /var/www/html
	echo "/var/www/html directory created."
fi

cd /var/www/html

if [ ! -d "wp-config.php" ]; then
	echo "Download of wordpress :"
	wp core download --allow-root
	# wget https://wordpress.org/latest.tar.gz
	# chown -R www-data:www-data latest.tar.gz
	# tar -xzf latest.tar.gz -C wp --strip-components=1
	# echo "Wordpress extracted, configurating"

	# mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

	# sed -i -r "s/database_name_here/$MYSQL_DATABASE/1" wp-config.php
	# sed -i -r "s/username_here/$MYSQL_USER/1" wp-config.php
	# sed -i -r "s/password_here/$MYSQL_PASSWORD/1" wp-config.php
	# sed -i -r "s/localhost/mariadb/1" wp-config.php

	wp config create \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbpass="$WORDPRESS_DB_PASSWORD" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--dbprefix='wp_' \
		--allow-root

	echo "Config create done"

	wp core install \
		--url="$DOMAIN_NAME" \
		--title="$WORDPRESS_TITLE" \
		--admin_user="$WORDPRESS_ADMIN_USER" \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL" \
		--allow-root
	
	echo "Core install"

	wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
		--role='author' \
		--user_pass="$WORDPRESS_USER_PASSWORD" \
		--allow-root
	
	echo "User create ok"
	echo "Wordpress configured"
else
	echo "Wordpress already installed"
fi

if [ ! -d "/run/php" ]; then
	echo "Creating /run/php directory : "
	mkdir -p /run/php
	chown -R www-data:www-data /run/php
	echo "/run/php directory created."
fi
echo "Configurating php to listen on 9000 : "
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' "/etc/php/7.3/fpm/pool.d/www.conf"
service php7.3-fpm restart

# kill le protocole TCP si il listen 9000

php-fpm7.3 -F

sleep infinity