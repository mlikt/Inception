#!/bin/sh

check_nginx=`ls /var/run/nginx.pid | grep nginx | wc -l`

if [ $check_nginx -eq "0"];
	then
		nginx;
fi	


check=`ls /etc/nginx/ssl | grep nginx | wc -l`

if [ $check -eq "0" ];
then
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 \
                -x509 \
                -sha256 \
                -days 365 \
                -nodes \
                -out /etc/nginx/ssl/nginx-key.crt \
                -keyout /etc/nginx/ssl/nginx.key \
                -subj "/C=RU/ST=Tatarstan/L=Kazan/O=21School/OU=IT Departament/CN=localhost";

 chown -R www-data:www-data /etc/nginx/;
 chown -R www-data:www-data /etc/nginx;
 chown -R www-data:www-data /var/lib/nginx;

 chown www-data:www-data /run/nginx.pid;
 chown www-data:www-data /var/run/nginx.pid;
fi
nginx -c /etc/nginx/nginx.conf -g "daemon off;"
