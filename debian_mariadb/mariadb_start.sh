# Запускаем СУБД
service mysql start

# Проверяем существует ли база данных, если нет то создаем
find_my_database=$(echo "SHOW DATABASES;" | mysql --no-defaults -u root | grep "$DB_NAME" | wc -l)

if [ "1" != $find_my_database ] ;
	then echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" | mysql --no-defaults -u root ;
fi

# Проверяем существует ли пользователь, если нет то создаем
# И наделяем правами на базу данных
find_my_user=$(echo "SELECT USER from mysql.user;" | mysql --no-defaults -u root | grep "$DB_USER" | wc -l)

if [ "1" != $find_my_user ];
	then 
		echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql --no-defaults -u root
		echo "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%';" | mysql --no-defaults -u root
		echo "FLUSH PRIVILEGES;" | mysql --no-defaults -u root ;
fi
# Отключаем, чтобы перезапустить вне фонового режима

service mysql stop

mysqld_safe

