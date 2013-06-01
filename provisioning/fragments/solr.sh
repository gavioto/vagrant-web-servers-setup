#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== SOLR.SH =========="
echo

ver_java="1.6.0"
ver_tomcat="6"
ver_solr="4.3.0"

yum install -y java-$ver_java-openjdk tomcat$ver_tomcat

wget -qO- "ftp://ftp.cs.uu.nl/mirror/apache.org/dist/lucene/solr/$ver_solr/solr-$ver_solr.tgz" | \
tar xzf -

mv solr-$ver_solr /opt/solr
cp -r /vagrant/provisioning/templates/solr/instances /opt/solr/
ln -s /opt/solr/instances/instance1.xml /usr/share/tomcat6/conf/Catalina/localhost/instance1.xml
chown tomcat:tomcat -R /opt/solr

cp /opt/solr/example/lib/ext/* /usr/share/java/tomcat6
cp /vagrant/provisioning/templates/solr/log4j.properties /usr/share/java/tomcat6

chkconfig tomcat6 on && service tomcat6 restart

echo "checking solr installation. This should return 'HTTP/1.1 200 OK'"
curl -sI http://localhost:8080/instance1/ | head -2
# HTTP/1.1 200 OK
# Server: Apache-Coyote/1.1

echo
echo "========== FINISHED SOLR.SH =========="
echo
