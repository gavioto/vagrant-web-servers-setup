#!/bin/bash

#
# SCRIPT TO UPDATE JASPERSERVER TO ANOTHER VERSION
#
# It installs another version of jasperserver side by side with the old version
#
# Just edit the version of jasperserver, below, and run the script.
# It will:
#       export the current server data (reports, datasources, etc)
#       install the new version
#       update the links to the new version
#       import the data from the old version
#
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

ver_jasper="5.1.0"

echo
echo "========== UPDATING JASPERSERVER =========="
echo

ts=`date +%Y%m%d.%H%M`

echo "exporting jasperserver data..."
/opt/jasperserver/buildomatic/js-export.sh \
    --output-zip /opt/jasperserver-export-$ts.zip \
    --everything

echo "stoping tomcat and jasperserver..."
service tomcat6 stop
service jasperserver stop

echo "downloading jasperserver..."
wget --quiet "http://community.jaspersoft.com/sites/default/files/releases/jasperreports-server-cp-$ver_jasper-linux-x86-installer.run"
chmod -R +x jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

echo "removing legacy links before installing..."
rm -f /opt/jasperserver
rm -f /etc/tomcat6/Catalina/localhost/jasperserver.xml
rm -f /usr/share/tomcat6/webapps/jasperserver

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

echo "
# addition for xpath2 queries
net.sf.jasperreports.query.executer.factory.xpath2=com.jaspersoft.jrx.query.JRXPathQueryExecuterFactory
" >> /opt/jasperserver/apache-tomcat/webapps/jasperserver/WEB-INF/classes/jasperreports.properties

echo "starting jasperserver and tomcat..."
service jasperserver start
service tomcat6 start

echo "waiting 2min for jasperserver to start completely..."
sleep 60

echo "importing jasperserver data..."
/opt/jasperserver/buildomatic/js-import.sh --input-zip /home/herberto/jasperserver-export-$ts.zip


echo
echo "========== FINISHED UPDATING JASPERSERVER =========="
echo '
You might also want to:

    Make sure USER_ROLE only has execute permissions

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
