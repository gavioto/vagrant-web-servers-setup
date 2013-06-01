#!/bin/bash

#
# Provisioning for deployment of VEMT web server
# This script moves all deployed apps to the vagrant folder, putting a symlink in its place
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== WEB.APPS.MOVE.TO.VAGRANT.SH =========="
echo

mkdir -p /vagrant/workspace

#
# An app
#
mv /var/www/apps/APP/dev /vagrant/workspace/APP
sudo ln -s /vagrant/workspace/APP /var/www/apps/APP/dev
