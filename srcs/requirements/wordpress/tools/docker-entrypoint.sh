#!/bin/bash

cd /var/www/wordpress

if [ ! -f wp-includes/version.php ]; then
    echo "Downloading WordPress core files..."
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    cat > wp-config.php <<EOF
<?php
define( 'DB_NAME', '$DB_NAME' );
define( 'DB_USER', '$DB_USER' );
define( 'DB_PASSWORD', '$DB_PW' );
define( 'DB_HOST', 'mariadb:3306' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );

\$table_prefix = 'wp_';

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
EOF
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_name="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PW" \
        --admin_email="$WORDPRESS_ADMIN_MAIL"

    echo "Creating additional user..."
    wp user create --allow-root "$WORDPRESS_USER" "$WORDPRESS_USER_MAIL" --user_pass="$WORDPRESS_USER_PW"

    echo "Installing and activating 2024 theme..."
	rm -rf /var/www/wordpress/wp-content/themes/twentytwentyfour
    wp theme install twentytwentyfour.1.3.zip --allow-root --activate
fi

echo "Setting proper permissions..."
chown www-data:www-data /var/www/wordpress/wp-content -R

echo "Starting PHP-FPM..."
php-fpm7.4 -F