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

wget "http://community.jaspersoft.com/sites/default/files/releases/jasperreports-server-cp-$ver_jasper-linux-x86-installer.run"
chmod -R +x jasperreports-server-cp-$ver_jasper-linux-x86-installer.run

./jasperreports-server-cp-$ver_jasper-linux-x86-installer.run --optionfile jasperserver.opts

echo
echo "========== FINISHED JASPERSERVER.SH =========="
echo
