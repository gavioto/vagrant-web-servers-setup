#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

ver_jasper="5.1.0"

echo
echo "========== JASPERSERVER.SH =========="
echo

echo "downloading jasperserver..."
wget --quiet "http://community.jaspersoft.com/sites/default/files/releases/jasperreports-server-cp-$ver_jasper-linux-x86-installer.run"
chmod -R +x jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

echo "installing jasperserver..."
./jasperreports-server-cp-$ver_jasper-linux-x86-installer.run --optionfile /vagrant/provisioning/fragments/jasperserver.opts
rm jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

echo "creating generic link to jasperserver..."
chmod -R o+w /usr/share/tomcat6/webapps/jasperserver/
ln -s -f /opt/jasperserver-$ver_jasper /opt/jasperserver

echo "moving all jasperserver assets to one location..."
cp -f /vagrant/provisioning/templates/jasperserver/jasperserver.xml /opt/jasperserver/jasperserver.xml
ln -s -f /opt/jasperserver/jasperserver.xml /etc/tomcat6/Catalina/localhost/jasperserver.xml

mkdir -p /opt/jasperserver/apache-tomcat/webapps
mv /usr/share/tomcat6/webapps/jasperserver /opt/jasperserver/apache-tomcat/webapps/jasperserver
ln -s -f /opt/jasperserver/apache-tomcat/webapps/jasperserver /usr/share/tomcat6/webapps/jasperserver

echo "fetching and installing driver for xml datasources, to use xpath2 and solr..."
wget --quiet "http://netcologne.dl.sourceforge.net/project/ireport/iReport/iReport-$ver_jasper/iReport-$ver_jasper.tar.gz"
tar xfz ./iReport-$ver_jasper.tar.gz
cp ./iReport-$ver_jasper/ireport/modules/ext/jasperreports-extensions-*.jar \
    /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/lib/
rm -Rf ./iReport-$ver_jasper
rm -f ./iReport-$ver_jasper.tar.gz

echo "Downloading mysql JDBC driver ..."
wget --quiet "http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.25.tar.gz"
echo "Installing mysql JDBC driver in jasperserver..."
tar xfz ./mysql-connector-java-5.1.25.tar.gz
mv ./mysql-connector-java-5.1.25/mysql-connector-java-5.1.25-bin.jar /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/lib/
rm -Rf ./mysql-connector-java-5.1.25
rm -f ./mysql-connector-java-5.1.25.tar.gz
echo "Done"

echo "
# addition for xpath2 queries
net.sf.jasperreports.query.executer.factory.xpath2=com.jaspersoft.jrx.query.JRXPathQueryExecuterFactory
" >> /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/classes/jasperreports.properties

echo "adding jasperserver autostart script..."
cp /vagrant/provisioning/templates/jasperserver/jasperserver_init_script.sh /etc/init.d/jasperserver
chmod u+x /etc/init.d/jasperserver

echo "adding jasperserver update script..."
cp /vagrant/provisioning/templates/jasperserver/jasperserver_update.sh /opt/jasperserver_update.sh

chkconfig --add jasperserver
service jasperserver start

echo
echo "========== FINISHED JASPERSERVER.SH =========="
echo '

ATTENTION: If you suspend this VM, you will have to restart tomcat fot jasperserver to work again (sudo service tomcat6 restart)

You might also want to:

    -------------------------------
    Add the nl_NL locale
    -------------------------------
    Edit /opt/jasperserver/apache-tomcat/webapps/reporting/WEB-INF/applicationContext-security.xml

    and locate the bean named userLocalesList. For example:
    <bean id="userLocalesList" class="com.jaspersoft.jasperserver.war.common.-LocalesListImpl">

    Add the locale you want, for example:
    <value type="java.util.Locale">nl_NL</value>

    Add the translated file(s) to the folder:
    /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/bundles/

    -------------------------------
    Edit the available export formats
    -------------------------------
    Open the file: /opt/jasperserver/apache-tomcat/webapps/reporting/WEB-INF/flows/viewReportBeans.xml
    Edit the following block, in the end of the file:
    <util:map id="exporterConfigMap">

    -------------------------------
    Change session timeout
    -------------------------------
    In file /opt/jasperserver/apache-tomcat/webapps/reporting/WEB-INF/web.xml
    we must change <session-timeout>20</session-timeout> to 720(12h), 0 or -1.

    -------------------------------
    Activate query log
    -------------------------------
    Edit the following file /opt/jasperserver/apache-tomcat/webapps/reporting/WEB-INF/log4j.properties
    and uncomment the line log4j.logger.net.sf.jasperreports.engine.query.JRJdbcQueryExecuter=debug

    The querys will be logged in /opt/jasperserver/apache-tomcat/webapps/reporting/WEB-INF/logs/jasperserver.log'
