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

WORKDIR /var/www/html
COPY run.sh /opt/
COPY composer.phar /opt/
COPY glpi-9.1.2.tar.gz /opt/
COPY glpi-ocsinventoryng-1.3.3.tar.gz /opt/
COPY 000-default.conf /etc/apache2/sites-enabled/
RUN usermod -u 1000 www-data
RUN chmod +x /opt/run.sh
RUN chmod +x /var/www/html
RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /var/log/apache2
RUN chown -R www-data:www-data /etc/apache2/sites-enabled/
RUN a2enmod rewrite

ARG user=user_glpi
ARG group=glpi
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group} \
    && useradd -d /var/www/html -o -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4


ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

EXPOSE 80

USER ${user}

ENTRYPOINT ["/bin/tini", "--","/opt/run.sh"]
