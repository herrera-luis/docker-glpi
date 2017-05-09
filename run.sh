#!/bin/bash -e
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
  tar -C $APACHE_DIR -xzf /opt/glpi-9.1.2.tar.gz
  chown -R www-data $GLPI_DIR
  tar -C $GLPI_DIR/plugins -xzf /opt/glpi-ocsinventoryng-1.3.3.tar.gz
  cp /opt/composer.phar $GLPI_DIR
  php $GLPI_DIR/composer.phar install -d $GLPI_DIR --no-dev 
fi

### RUN APACHE IN FOREGROUND ##################################################
tail -f /var/log/apache2/error.log -f /var/log/apache2/access.log
