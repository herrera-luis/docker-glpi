FROM ubuntu:14.04

MAINTAINER Luis Herrera <luis.herrera.ec@gmail.com>

RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y \
  tar \
  wget \
  php5 \
  php5-mysql \
  php5-ldap \
  php5-xmlrpc \
  curl \
  php5-curl \
  php5-gd \
  nano \
  php5-imap 
RUN php5enmod imap  
RUN a2enmod rewrite && service apache2 stop
WORKDIR /var/www/html
COPY start.sh /opt/
COPY composer.phar /opt/
COPY glpi-9.1.2.tar.gz /opt/
COPY glpi-ocsinventoryng-1.3.3.tar.gz /opt/
RUN usermod -u 1000 www-data
RUN chmod +x /opt/start.sh
CMD ["/opt/start.sh"]
EXPOSE 80
