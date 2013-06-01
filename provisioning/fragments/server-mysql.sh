#!/bin/bash

#
# Provisioning for deployment of db server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0


#
# MYSQL
#
    yum -y install mysql mysql-server
    chkconfig --levels 235 mysqld on # start at boot
    /etc/init.d/mysqld start         # start mysql
    /vagrant/provisioning/fragments/mysql_secure.sh '' 'xpto' # (oldrootpass newrootpass) make it secure, answer yes to everything

#
# phpMyAdmin
#
    phpmyadminVer=4.0.2

    /vagrant/provisioning/fragments/server-php.sh

    rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
    yum -y install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
    yum -y install phpmyadmin

    mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
    cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@<Directory "/usr/share/phpmyadmin">@#<Directory "/usr/share/phpmyadmin">@' > /etc/httpd/conf.d/phpmyadmin.conf
    rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

    mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
    cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Order Deny,Allow@#  Order Deny,Allow@' > /etc/httpd/conf.d/phpmyadmin.conf
    rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

    mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
    cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Deny from all@#  Deny from all@' > /etc/httpd/conf.d/phpmyadmin.conf
    rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

    mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
    cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Allow from 127.0.0.1@#  Allow from 127.0.0.1@' > /etc/httpd/conf.d/phpmyadmin.conf
    rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

    mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
    cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@</Directory>@#</Directory>@' > /etc/httpd/conf.d/phpmyadmin.conf
    rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

    mv /usr/share/phpmyadmin/config.inc.php /usr/share/phpmyadmin/config.inc.php.bkp
    cat /usr/share/phpmyadmin/config.inc.php.bkp | sed -e 's@cookie@http@' > /usr/share/phpmyadmin/config.inc.php
    rm /usr/share/phpmyadmin/config.inc.php.bkp

    # Get the latest version of phpMyAdmin
    mv -f /usr/share/phpmyadmin/config.inc.php /vagrant
    rm -rf /usr/share/phpmyadmin
    wget "http://kent.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/$phpmyadminVer/phpMyAdmin-$phpmyadminVer-all-languages.tar.gz"
    tar xfz ./phpMyAdmin-$phpmyadminVer-all-languages.tar.gz -C /usr/share/
    mv /usr/share/phpMyAdmin-$phpmyadminVer-all-languages /usr/share/phpmyadmin
    mv -f /vagrant/config.inc.php /usr/share/phpmyadmin
    rm -f ./phpMyAdmin-$phpmyadminVer-all-languages.zip
    rm -f /vagrant/config.inc.php


    /etc/init.d/httpd restart
