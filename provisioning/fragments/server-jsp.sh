#!/bin/bash

#
# Provisioning for deployment of web server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== SERVER-JSP.SH =========="
echo

ver_java="1.6.0"
ver_tomcat="6"

yum install -y java-$ver_java-openjdk tomcat$ver_tomcat
# installs to folder /usr/share/tomcat6

echo
echo "========== FINISHED SERVER-JSP.SH =========="
echo
