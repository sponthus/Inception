#!/bin/sh

echo "name is $MYSQL_DATABASE"

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Database already exists"
else
	echo "Creating database"
	if [ -d !"/var/lib/mysql/mysql" ]; then 
		mysql_install_db
	fi
	/etc/init.d/mysql start

sleep 5

mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -e "CREATE USER '$MYSQL_USER' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

fi

# Execute la prochaine cmd du dockerfile
exec "$@"