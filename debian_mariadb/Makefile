
build:
	docker build -t "deb/mariadb:v2" .
newcontainer:
	docker run -i -t --name mariadb deb/mariadb:v2 /bin/bash
fon:
	docker run -d -p 3306:3306 --name mariadb deb/mariadb:v2
debian:
	docker run -i -t --name deb debian
remove:
	docker stop mariadb
	docker rm mariadb
remove_debian:
	docker rm deb