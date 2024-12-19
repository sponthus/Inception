#!/bin/sh

if [ ! -d "/var/www/html" ]; then
    echo "Creating /var/www/html :"
    mkdir -p /var/www/
    mkdir -p /var/www/html
    echo "/var/www/html directory created."
fi

cd /var/www/html

if [ ! -d "wp-config.php" ]; then
    echo "Downloading wordpress :"
    wget https://wordpress.org/latest.tar.gz
    chown -R www-data:www-data latest.tar.gz
    tar -xzf latest.tar.gz -C wp --strip-components=1
    echo "Wordpress extracted, configurating"
    wp --path='/wp' config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --dbprefix='wp_'
    wp --path='/wp' core install \
        --url="$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --skip-email
    wp -path='/wp' user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --role='author' \
        --user_pass="$WORDPRESS_USER_PASSWORD"
    echo "Wordpress configured"
else
    echo "Wordpress already installed"
fi

echo "Configurating php to listen on 9001 : "
sed -i 's|^listen = .*|listen = 9001|' "/etc/php/7.3/fpm/pool.d/www.conf"
service php7.3-fpm restart

if [ ! -d "/run/php" ]; then
    echo "Creating /run/php directory : "
    mkdir -p /run/php
    chown -R www-data:www-data /run/php
    echo "/run/php directory created."
fi

# kill le protocole TCP si listen 9000

php-fpm7.3 -F

sleep infinity