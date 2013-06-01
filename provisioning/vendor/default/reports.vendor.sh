#!/bin/bash

#
# This script installs all solr cores and jasper reports
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== REPORTS.VENDOR.SH =========="
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
echo "========== FINISHED REPORTS.VENDOR.SH =========="
echo
