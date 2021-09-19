# Запускаем СУБД
service mariadb start

# Проверяем существует ли база данных, если нет то создаем
FIND_MY_DATABASE=$(echo "SHOW DATABASES;" | mysql --no-defaults -u root | grep "$DB_NAME" | wc -l)

	if [ "1" -ne $FIND_MY_DATABASE ]
		then echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" | mysql --no-defaults -u root
	fi

# Проверяем существует ли пользователь, если нет то создаем
# И наделяем правами на базу данных
FIND_MY_USER=$(echo "SELECT USER from mysql.user;" | mysql --no-defaults -u root | grep "$DB_USER" | wc -l)

	if [ "1" -ne  $FIND_MY_USER ]
		then 
			echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql --no-defaults -u root
			echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql --no-defaults -u root
			echo "FLUSH PRIVILEGES;" | mysql --no-defaults -u root
	fi
# Отключаем, чтобы перезапустить вне фонового режима
service mariadb stop

/usr/bin/mysqld_safe