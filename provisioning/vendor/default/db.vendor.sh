#!/bin/bash

#
# This script installs all DBs in the mysql server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== DB.VENDOR.SH =========="
echo

gituser=$1
environment=$2

/vagrant/provisioning/vendor/default/fragments/users.sh

# yum update -y # Full system update

case  $environment  in

    "dev")
        ;;

    "tst" | "stg" | "prd")
        /vagrant/provisioning/vendor/default/fragments/firewall.sh
        ;;

    *)
        echo "The environment '$environment' is unknown. Valid environments: dev, tst, stg, prd"
        ;;

esac

echo
echo "========== FINISHED DB.VENDOR.SH =========="
echo
