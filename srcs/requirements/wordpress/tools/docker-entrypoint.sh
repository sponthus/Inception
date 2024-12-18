#!/bin/sh

sed -i 's|^listen = .*|listen = 9000|' "/etc/php/7.3/fpm/pool.d/www.conf"
service php7.3-fpm restart

if [ ! -d "/run/php" ]; then
    echo "Creating /run/php directory..."
    mkdir -p /run/php
    chown -R www-data:www-data /run/php
    echo "/run/php directory created."
fi

# kill le protocole TCP

php-fpm7.3 -F

sleep infinity