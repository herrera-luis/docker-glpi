# docker-glpi

Para crear la imagen con Dockerfile

		docker build -t nombrerepositorio/imagen . 

Para crear el contenedor

		docker run -d -p 268:80 --name nombre_contenedor --link contenedor_mysql --restart=always nombrerepositorio/imagen