FROM debian:10

# ARG DB_NAME
# ARG DB_USER
# ARG DB_PASSWORD

# Устанавливаем mariadb
RUN apt-get update
RUN apt-get install -y mariadb-server

# Перекидываем файл конфигурации
COPY ./my.cnf /etc/mysql/my.cnf
RUN chmod 0444 /etc/mysql/my.cnf

# Примичание если мы запускаем сервевис в одной инструкции RUN
# это не означает, что он будет запущен для следующей инструкции RUN
# Поэтому мы запускаем mariadb для следующей инструкции

# Переменные окружения при сборки беруться только из ARG, при сборки не возможно
# использовать переменные окружения из файла .env
# Поэтому создадим sh-скрипт который отработает при запуске контейнера 


# -------------------------------------------------------------- #
# Закоментированный ниже код для исторической справки ошибок #


# RUN echo $DB_NAME > file.txt # Эта строка требовалась 
# чтобы проверить видет ли переменные из .env

## Запускаем сервис и cоздаем базу данных если она отсутсвует

# RUN service mariadb start ; \
# 	 FIND_MY_DATABASE=$(echo "SHOW DATABASES;" | mysql --no-defaults -u root | grep "$DB_NAME" | wc -l) ; \
# 	if [ "1" -ne $FIND_MY_DATABASE ] ; \
# 		then echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" | mysql --no-defaults -u root; \
# 	fi
# 

# # Создаем пользователя СУБД если его нет

# RUN service mariadb start ; \
# 	FIND_MY_USER=$(echo "SELECT USER from mysql.user;" | mysql --no-defaults -u root | grep "$DB_USER" | wc -l); \
# 	if [ "1" -ne  $FIND_MY_USER ] ; \
# 	then echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql --no-defaults -u root \
# 	&& echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql --no-defaults -u root \
# 	&& echo "FLUSH PRIVILEGES;" | mysql --no-defaults -u root ; fi

# -------------------------------------------------------------- #

COPY ./mariadb_start.sh /bin/mariadb_start.sh
# RUN chmod +x /bin/mariadb_start.sh

# CMD ["mysqld_safe"]

# Кто расскажет почему контейнер закрывается?
# CMD mariadb_start.sh

# Причина: Правило Dokerfile
# Одна команда один контекст! 
# Поэтому следует задать права исполняемому файлу (скрипту) перед его запуском в поле CMD

CMD chmod +x /bin/mariadb_start.sh ; mariadb_start.sh