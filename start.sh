#!/bin/bash
# - Install GLPI if not already installed
# - Run apache in foreground

### GENERAL CONF ###############################################################

APACHE_DIR="/var/www/html"
GLPI_DIR="${APACHE_DIR}/glpi"

### INSTALL GLPI IF NOT INSTALLED ALREADY ######################################
if [ "$(ls -A $GLPI_DIR)" ]; then
  echo "GLPI is already installed at ${GLPI_DIR}"
else
  echo '--------> Install GLPI'
  tar -C $APACHE_DIR -xzf /tmp/glpi-9.1.tar.gz
  chown -R www-data $GLPI_DIR
 
  VHOST=/etc/apache2/sites-enabled/000-default.conf

	# Use /var/www/html/glpi as DocumentRoot
	sed -i -- 's/DocumentRoot .*/DocumentRoot \/var\/www\/html\/glpi/g' $VHOST
	# Remove ServerSignature (secutiry)
	sed -i -- '/ServerSignature /d' $VHOST
	awk '/<\/VirtualHost>/{print "ServerSignature Off" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
	# Eenable .htaccess
	sed -i -- '/<Directory /d' $VHOST
	awk '/<\/VirtualHost>/{print "<Directory \"/var/www/html/glpi\">" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
	sed -i -- '/AllowOverride All/d' $VHOST
	awk '/<\/VirtualHost>/{print "AllowOverride All" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
	sed -i -- '/<\/Directory/d' $VHOST
	awk '/<\/VirtualHost>/{print "</Directory>" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
fi

### REMOVE THE DEFAULT INDEX.HTML TO LET HTACCESS REDIRECTION ##################

rm ${APACHE_DIR}/index.html

chown www-data .

### RUN APACHE IN FOREGROUND ###################################################

# stop apache service
#service apache2 stop
service apache2 restart
# start apache in foreground
#source /etc/apache2/envvars
#/usr/sbin/apache2 -D FOREGROUND
tail -f /var/log/apache2/error.log -f /var/log/apache2/access.log
