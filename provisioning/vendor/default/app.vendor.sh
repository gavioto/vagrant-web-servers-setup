#!/bin/bash

#
# This script installs all apps and optionally moves them to /vagrant
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== APP.VENDOR.SH =========="
echo

gituser=$1
environment=$2

/vagrant/provisioning/vendor/default/fragments/users.sh
/vagrant/provisioning/vendor/default/fragments/web-apps-deploy.sh $gituser

# yum update -y # Full system update

case  $environment  in

    "dev")
        /vagrant/provisioning/vendor/default/fragments/web-apps-move-to-vagrant.sh
        ;;

    "tst" | "stg" | "prd")
        /vagrant/provisioning/vendor/default/fragments/firewall.sh
        ;;

    *)
        echo "The environment '$environment' is unknown. Valid environments: dev, tst, stg, prd"
        ;;

esac

echo
echo "========== FINISHED APP.VENDOR.SH =========="
echo
