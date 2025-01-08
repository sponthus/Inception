#!/bin/sh

echo "Creation of $MYSQL_DATABASE begins"

mkdir -p /var/run/mysql
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/run/mysql
chgrp -R mysql /var/lib/mysql
# grp du localhost ACHECKER ++
chmod -R g+rwx /var/lib/mysql

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Initializing MariaDB data directory"
	if [ -d !"/var/lib/mysql/mysql" ]; then 
		echo "Install_db"
		mysql_install_db
	fi

	/etc/init.d/mysql start

	# echo "Waiting for MariaDB : "
	# until mysqladmin ping --silent; do
	# 	 sleep 2
	# done

	echo "Root PW"
	echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

	echo "Configurating mariadb"
	mysql -u root <<-done
		CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
		CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
		GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
		FLUSH PRIVILEGES;
	done

	# kill $(cat /var/run/mysqld/mysqld.pid)
	# rm -f /var/run/mysqld/mysqld.pid

	/etc/init.d/mysql stop

else
	echo "$MYSQL_DATABASE already exists"
fi

# Execs next dockerfile command
exec "$@"