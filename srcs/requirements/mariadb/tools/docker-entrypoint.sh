#!/bin/sh

echo "Creation of $DB_NAME begins"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

until mysqladmin ping 2>/dev/null; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

timeout=30
SECONDS=0

until mysqladmin ping 2>/dev/null || [ "$SECONDS" -ge "$timeout" ]; do
	echo "Waiting for mariadb ..."
	sleep 1
done

if [ "$SECONDS" -ge "$timeout" ]; then
	echo "Timeout reached."
else
	echo "Ping mariadb success."
fi

echo "Configurating mariadb"
mysql --user=root --password= <<-EOF
		CREATE DATABASE IF NOT EXISTS $DB_NAME;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PW';
		CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PW';
		GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
		FLUSH PRIVILEGES;
	EOF
mysqladmin -u root -p$DB_ROOT_PW shutdown

echo "Launching mariadb"
exec mariadbd --bind_address=0.0.0.0