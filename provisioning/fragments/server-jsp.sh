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

yum install -y java-$ver_java-openjdk tomcat$ver_tomcat
# installs to folder /usr/share/tomcat6

# increase memory available so that solr and maily jasper don't have any memory problems
cp /vagrant/provisioning/templates/tomcat/tomcat6.conf /etc/tomcat6/tomcat6.conf
chmod o+r /etc/tomcat6/tomcat6.conf

echo
echo "========== FINISHED SERVER-JSP.SH =========="
echo
