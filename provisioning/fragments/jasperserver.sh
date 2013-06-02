#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== JASPERSERVER.SH =========="
echo

ver_jasper="5.1.0"

echo "downloading jasperserver..."
wget --quiet "http://community.jaspersoft.com/sites/default/files/releases/jasperreports-server-cp-$ver_jasper-linux-x86-installer.run"
chmod -R +x jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

echo "installing jasperserver..."
./jasperreports-server-cp-$ver_jasper-linux-x86-installer.run --optionfile /vagrant/provisioning/fragments/jasperserver.opts
rm jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

chmod -R o+w /usr/share/tomcat6/webapps/jasperserver/
ln -s /opt/jasperserver-5.1.0 /opt/jasperserver

cp -f /vagrant/provisioning/templates/jasperserver/jasperserver.xml /opt/jasperserver.xml
ln -s -f /opt/jasperserver.xml /etc/tomcat6/Catalina/localhost/jasperserver.xml

cp /vagrant/provisioning/templates/jasperserver/jasperserver_init_script.sh /etc/init.d/jasperserver
chmod u+x /etc/init.d/jasperserver

echo "adding jasperserver autostart script..."
chkconfig --add jasperserver
service jasperserver start

# /opt/jasperserver/ctlscript.sh start

# service tomcat6 restart

echo
echo "========== FINISHED JASPERSERVER.SH =========="
echo
