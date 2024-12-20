#!/bin/sh

echo "Creation of $MYSQL_DATABASE begins"

mkdir -p /var/run/mysql
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/run/mysql
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Initializing MariaDB data directory"
	if [ -d !"/var/lib/mysql/mysql" ]; then 
		mysql_install_db
	fi
	/etc/init.d/mysql start

	echo "Waiting for MariaDB : "
	until mysqladmin ping --silent; do
		 sleep 2
	done

	echo "Configurating mariadb"
	mysql -u root <<-EOSQL
		 CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
		 CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
		 GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
		 FLUSH PRIVILEGES;
	EOSQL

	kill $(cat /var/run/mysqld/mysqld.pid)
	rm -f /var/run/mysqld/mysqld.pid

else
	echo "$MYSQL_DATABASE already exists"
fi

# Execs next dockerfile command
exec "$@"