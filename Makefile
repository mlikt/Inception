
CONTAINERS = $(shell docker ps -a -q)
VOLUMES = $(shell docker volume ls -q)

ENV = ./.env

PATH_DIR = ./debian_mariadb/lib ./debian_nginx/www

rm-container:
	@docker stop $(CONTAINERS)
	@docker rm $(CONTAINERS) 
	@docker volume rm $(VOLUMES)
	@echo "Удаленны все контейнеры и все тома"

build:
	@docker-compose build
	@mkdir ${PATH_DIR} 2>/dev/null

# Историчесокое правило
# build-env: generation_envfile
# 	env `cat .env` bash -c "docker-compose build"

rm-all:rm-container
	docker rmi $(shell docker images -q)

rm-images:
	@docker rmi deb/nginx:v2 2>/dev/null \
	|| docker rmi deb/mariadb:v2 2>/dev/null \
	|| docker rmi deb/wordpress:v2 2>/dev/null \
	|| touch . 
	@docker rmi deb/nginx:v2 2>/dev/null \
	|| docker rmi deb/mariadb:v2 2>/dev/null \
	|| docker rmi deb/wordpress:v2 2>/dev/null \
	|| touch . 2>/dev/null
	@docker rmi deb/nginx:v2 2>/dev/null \
	|| docker rmi deb/mariadb:v2 2>/dev/null \
	|| docker rmi deb/wordpress:v2 2>/dev/null \
	|| echo "Удалить директории"
	@sudo rm -rf ${PATH_DIR} 2>/dev/null

prune:
	docker system prune
	docker network prune
	docker volume prune

run:  generation_envfile
	docker-compose up -d

stop:
	docker-compose stop

# .env по умолчанию
generation_envfile:
	echo "Generation .env"
	@>  ${ENV}
	@echo "DOMIAN_NAME=$$USER.42.fr" >> ${ENV}
	@echo "DB_NAME=wordpress" >> ${ENV}
	@echo "DB_USER=$$USER" >> ${ENV}
	@echo "DB_PASSWORD=$$USER" >> ${ENV}
	@echo "DB_HOST=dockernet" >> ${ENV}
	@echo "DB_PREFIX=wp_" >> ${ENV}
	