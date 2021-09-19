#!/bin/sh

# Подключение к базе данных
wp core download    --allow-root --path="/var/www/html"

wp core config	--allow-root \
				--skip-check \
				--dbname=$DB_NAME \
				--dbuser=$DB_USER \
				--dbpass=$DB_PASSWORD \
				--dbhost=$DB_HOST \
				--dbprefix=$DB_PREFIX \
				--path="/var/www/html"

wp core install	--allow-root \
				--url=$DOMAIN_NAME \
				--title="ecole 21" \
				--admin_user="mlikt" \
				--admin_password="mlikt" \
				--admin_email="mlikt@student.21-school.ru" \
				--path="/var/www/html"

[ "root" !=  $NEWUSER ] && chown -R $NEWUSER:$NEWUSER /var/www/html

# Запускаем сервис чтобы создался сокет-файл, отлчючаем и запускаем на переднем плане
service php7.3-fpm start ; service php7.3-fpm stop ; php-fpm7.3 --nodaemonize