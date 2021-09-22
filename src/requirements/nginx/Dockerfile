# Какой образ берем за исходный
FROM debian:10

# Для создания нового пользователя с таким же именем как и у пользователя
# хоста который вызвал файл сборки, отличного от root
RUN apt-get -y update \
	&& apt-get -y install nginx\
	&& apt-get -y install openssl
# Проверяем, если запустил root то пользователя создавать не нужно иначе создаем
# Устанавливаем nginx и openssl

# Закинуть конфигурационные файлы с host-машины

COPY ./conf/default /etc/nginx/sites-enabled
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Создать дерикторию где будут хранится сгенерированные ключи
# RUN mkdir /etc/nginx/ssl
# Настройка cервера для пользователя www-data
# Пользователь www-data нужен для безопасности, из-под root работать не круто
# www-data отвечает за свои обезательства и не может просматривать и изменять файлы других пользователей
# RUN chown -R www-data:www-data /etc/nginx
# RUN chown -R www-data:www-data /var/lib/nginx

# Генерация ключей немного о команде
# req — утилита для создания запросов на подпись сертификата и для создания самоподписанных сертификатов
# x509 — утилита для подписи сертификатов
# rsa — утилита для работы с ключами RSA, в данном случае генерируем ключи длинной в 4096 байт (бит?)
# -subj - заполняем инфо об органицазии и бла бла бла
# -nodes подавляет диалог запроса парольной фразы.
# -days устанавливает срок действия сертификата
# Просто полезная ссылка https://www.opennet.ru/docs/RUS/ldap_apacheds/tech/ssl.html
# После настройки можете попробовать подключится с помощью openssl s_client -connect localhost:443, чтобы проверить удалось ли

# RUN openssl req -newkey rsa:4096 \
#                 -x509 \
#                 -sha256 \
#                 -days 365 \
#                 -nodes \
#                 -out /etc/nginx/ssl/nginx-key.crt \
#                 -keyout /etc/nginx/ssl/nginx.key \
#                 -subj "/C=RU/ST=Tatarstan/L=Kazan/O=21School/OU=IT Departament/CN=localhost"

# Дать права к сгенерированным ключам
# RUN chown -R www-data:www-data /etc/nginx/

# Запускаем чтобы создались файлы nginx.pid 
# и затем мы смогли предать права пользователю www-data
# nginx.pid нужен чтобы мы могла подавать сигналы серверу

# RUN service nginx start
# RUN chown www-data:www-data /run/nginx.pid
# RUN chown www-data:www-data /var/run/nginx.pid

# Изменяем права чтобы можно было модифицировать файл из хоста не перключаясь
# в режим суперпользователя

# Записываем строку в глобальную директиву 
# CMD ["nginx", "-g", "daemon off;"]
# CMD /bin/sh nginx -g "deamon off;"  # кто объяснит почему не отрабатывает?

COPY ./tools/start_nginx.sh /
CMD ["sh", "start_nginx.sh"]
# deamon off - нужен чтобы nginx не отправлять в фоновый режим
