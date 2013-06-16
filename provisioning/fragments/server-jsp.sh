#!/bin/bash

#
# Provisioning for deployment of web server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== STARTED SERVER-JSP.SH =========="
echo

ver_java="1.6.0"
ver_tomcat="6"

yum install -y liberation-sans-fonts java-$ver_java-openjdk tomcat$ver_tomcat
# installs to folder /usr/share/tomcat6

echo "Increase memory available so that solr and maily jasper don't have any memory problems ..."
cp /vagrant/provisioning/templates/tomcat/tomcat6.conf /etc/tomcat6/tomcat6.conf
chmod o+r /etc/tomcat6/tomcat6.conf

echo "Downloading mysql JDBC driver ..."
wget --quiet "http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.25.tar.gz"
echo "Installing mysql JDBC driver ..."
tar xfz ./mysql-connector-java-5.1.25.tar.gz
mv ./mysql-connector-java-5.1.25/mysql-connector-java-5.1.25-bin.jar /usr/share/tomcat6/lib/mysql-connector-java-5.1.25-bin.jar
rm -Rf ./mysql-connector-java-5.1.25
rm -f ./mysql-connector-java-5.1.25.tar.gz
echo "Done"

chkconfig tomcat6 on
service tomcat6 restart

echo
echo "========== FINISHED SERVER-JSP.SH =========="
echo
