#!/bin/bash

#
# Provisioning for deployment of VEMT web server
# This script deploys the latest version (DEV) of all apps, from the provided git user
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== WEB.APPS.DEPLOY.SH =========="
echo

gituser=$1
tag='dev'

#
# APP
#
git clone git@github.com:$gituser/APP.git /var/www/apps/APP/$tag/
cd /var/www/apps/APP/$tag/
git checkout $tag
cd /vagrant