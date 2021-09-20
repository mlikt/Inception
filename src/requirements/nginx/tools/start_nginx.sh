#!/bin/sh

mkdir /etc/nginx/ssl


openssl req -newkey rsa:4096 \
                -x509 \
                -sha256 \
                -days 365 \
                -nodes \
                -out /etc/nginx/ssl/nginx-key.crt \
                -keyout /etc/nginx/ssl/nginx.key \
                -subj "/C=RU/ST=Tatarstan/L=Kazan/O=21School/OU=IT Departament/CN=localhost"

service nginx start

chown -R www-data:www-data /etc/nginx/
chown -R www-data:www-data /etc/nginx
chown -R www-data:www-data /var/lib/nginx

chown www-data:www-data /run/nginx.pid
chown www-data:www-data /var/run/nginx.pid

service nginx stop

/usr/sbin/nginx -c /etc/nginx/nginx.conf  -g "daemon off;"