#!/bin/sh

service php7.3-fpm start

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

sed "2idefine('WP_HOME','$DOMIAN_NAME');" /var/www/html/wp-config.php >> /var/www/html/wp-config.php.new
mv /var/www/html/wp-config.php.new /var/www/html/wp-config.php
sed "2idefine('WP_SITEURL','$DOMIAN_NAME');" /var/www/html/wp-config.php >> /var/www/html/wp-config.php.new
mv /var/www/html/wp-config.php.new /var/www/html/wp-config.php

if [ "root" -ne $NEWUSER ] ;
	then
	chown -R $NEWUSER:$NEWUSER /var/www/html ;
fi

# Запускаем сервис чтобы создался сокет-файл, отлчючаем и запускаем на переднем плане
service php7.3-fpm stop ; php-fpm7.3 --nodaemonize