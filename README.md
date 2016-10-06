# docker-glpi

Para crear la imagen con Dockerfile

		docker build -t nombrerepositorio/imagen . 

Para crear el contenedor

		docker run -d -p --name nombre_contenedor --link contenedor_mysql -m 2GB --restart=always nombrerepositorio/imagen