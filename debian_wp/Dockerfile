FROM debian

ARG NEWUSER


RUN apt-get update
# Устанавливаем php и php-fpm, а так-же инструмент curl 
# (альтернатива для нашего случая wget)
# Чтобы скачать и установить wp-cli
RUN apt-get install -y php php-fpm
RUN apt-get install -y curl
RUN apt-get install -y sudo

# Создаем пользователя 
# --------------------------------------- #

# RUN [ "root" !=  $NEWUSER ] && \
# 	useradd -d /home/$NEWUSER -m -s /bin/bash $NEWUSER \
# 	&& echo "$NEWUSER:$NEWUSER" | chpasswd && adduser $NEWUSER sudo

# --------------------------------------- #

# Скачиваем wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Даем права на испольнения и переносить в /usr/local/bin/ 
# чтобы можно было исполнить из любой точки
# оболочки
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Подготовим место для wordpress файлов
RUN mkdir /var/www

# Установить wordpress в указанную директорию
RUN wp core download    --allow-root --path="/var/www"

CMD /bin/bash