# docker-glpi

Para crear la imagen con Dockerfile

		docker build -t nombrerepositorio/imagen . 

Para crear el contenedor

		docker run -d -p 268:80 --name nombre_contenedor --link contenedor_mysql -m 2GB --restart=always nombrerepositorio/imagen