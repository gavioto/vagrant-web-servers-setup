#!/bin/bash

#
# Provisioning for deployment of web server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== WEB.SH =========="
echo

#
# APACHE
#
yum -y install httpd
cp /vagrant/provisioning/templates/httpd/vhosts/00-generic.conf /etc/httpd/conf.d/00-generic.conf
cp /vagrant/provisioning/templates/httpd/httpd.conf /etc/httpd/conf/httpd.conf
chkconfig --levels 235 httpd on # start at boot
/etc/init.d/httpd start         # start apache


#
# PHP
#
yum -y install php php-xml php-cli php-pdo php-mbstring php-bcmath php-mysql php-common php-soap php-pecl-apc php-pear php-gd php-imap php-ldap php-odbc php-xmlrpc php-devel
mv /etc/php.ini /etc/php.ini.bkp
cat /etc/php.ini.bkp | sed -e "s@;date.timezone =@date.timezone = Europe/Amsterdam@" > /etc/php.ini
rm /etc/php.ini.bkp
/etc/init.d/httpd restart

#
# Set up the playground
#
rm -rf /var/www/cgi-bin
rm -rf /var/www/error
rm -rf /var/www/icons
rm -rf /var/www/html

mkdir -p /var/www/logs
chown -R apache:apache /var/www/logs
chmod -R 770 /var/www/logs

mkdir -p /var/www/apps
chown -R apache:apache /var/www/apps
chmod -R 770 /var/www/apps

echo "<?php phpinfo(); ?>" > /var/www/index.php
chown -R apache:apache /var/www/index.php
chmod -R 770 /var/www/index.php

#
# QUEUE SERVER
#
yum -y install rabbitmq-server


/etc/init.d/httpd restart

echo
echo "========== FINISHED WEB.SH =========="
echo
