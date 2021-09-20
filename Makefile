
CONTAINERS = $(shell docker ps -a -q)
VOLUMES = $(shell docker volume ls -q)

ENV = ./.env

PATH_DIR = ./debian_mariadb/lib ./debian_nginx/www

rm-container:
	@docker stop $(CONTAINERS) 2>/dev/null || true
	@docker rm $(CONTAINERS) 2>/dev/null || true
	@docker volume rm $(VOLUMES) 2>/dev/null || true
	@echo "Удаленны все контейнеры и все тома"

build:
	@docker-compose build
	@mkdir ${PATH_DIR} 2>/dev/null

# Историчесокое правило
# build-env: generation_envfile
# 	env `cat .env` bash -c "docker-compose build"

recreatedir:
	@sudo rm -rf ${PATH_DIR} 2>/dev/null
	@mkdir ${PATH_DIR} 2>/dev/null


rm-all:rm-container
	docker rmi $(shell docker images -q)

rm-images:
	@docker rmi deb/nginx:${USER} 2>/dev/null \
	|| true
	@docker rmi deb/mariadb:${USER} 2>/dev/null \
	|| true
	@docker rmi deb/wordpress:${USER} 2>/dev/null \
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
	@echo "NEWUSER=$$USER" >> ${ENV}
	@echo "DB_NAME=wordpress" >> ${ENV}
	@echo "DB_USER=$$USER" >> ${ENV}
	@echo "DB_PASSWORD=$$USER" >> ${ENV}
	@echo "DB_HOST=mariadb" >> ${ENV}
	@echo "DB_PREFIX=wp_" >> ${ENV}
	