# docker-glpi with tini

Create Docker Image

		docker build -t nombrerepositorio/imagen . 

RUN Container

		docker run -d -p 268:80 --name nombre_contenedor --link contenedor_mysql --restart=always nombrerepositorio/imagen && docker exec -t -u root test_glpi /etc/init.d/apache2 restart
