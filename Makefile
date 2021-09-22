
CONTAINERS = $(shell docker ps -a -q)
VOLUMES = $(shell docker volume ls -q)
COMPOSE_FILE = ./src/docker-compose.yml

ENV = ./src/.env

PATH_DIR = ./data ./data/db ./data/www

all: generation_envfile dns-host-add build run

rm-container:
	@docker stop $(CONTAINERS) 2>/dev/null || true
	@docker rm $(CONTAINERS) 2>/dev/null || true
	@docker volume rm $(VOLUMES) 2>/dev/null || true
	@docker network rm dockernet 2>/dev/null || true
	@echo "Удаленны все контейнеры и все тома"


build:
	@docker-compose -f ${COMPOSE_FILE} build
	@mkdir ${PATH_DIR} 2>/dev/null || true

# Историчесокое правило
# build-env: generation_envfile
# 	env `cat .env` bash -c "docker-compose -f ./src/docker-compose.yml build"

recreatedir:
	@sudo rm -rf ${PATH_DIR} 2>/dev/null
	@mkdir ${PATH_DIR} 2>/dev/null


rm-all: rm-container
	@docker rmi $(shell docker images -q) 2>/dev/null || true
	@cat /etc/hosts | grep -v "127.0.0.1 mlikt.42.fr" > hosts
	@sudo mv hosts /etc/hosts
	@sudo rm -rf ${PATH_DIR} 2>/dev/null

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

run:
	docker-compose -f ${COMPOSE_FILE} up -d

stop:
	docker-compose -f ${COMPOSE_FILE}stop

dns-host-add:
	@echo "Задать доменное имя локальному сайту: $$USER.42.fr"
	@echo "127.0.0.1 $$USER.42.fr" | sudo tee -a /etc/hosts

# .env по умолчанию
generation_envfile:
	@echo "Generation .env"
	@>  ${ENV}
	@echo "DOMIAN_NAME=$$USER.42.fr" >> ${ENV}
	@echo "NEWUSER=$$USER" >> ${ENV}
	@echo "DB_NAME=wordpress" >> ${ENV}
	@echo "DB_USER=$$USER" >> ${ENV}
	@echo "DB_PASSWORD=$$USER" >> ${ENV}
	@echo "DB_HOST=mariadb" >> ${ENV}
	@echo "DB_PREFIX=wp_" >> ${ENV}
	
