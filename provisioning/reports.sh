#!/bin/bash

#
# Provisioning for deployment of VEMT reports server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

    SCRIPT="REPORTS.SH"
    environment='dev'

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

    fc_setVars(){

        SCRIPT="REPORTS.SH"

        # parameters
        environment=$1
    }

    # ------------------------------------------------------------------

    fc_base(){

        echo "[$SCRIPT] ---------- Installing base functionality ----------"

        /vagrant/provisioning/fragments/nano.sh
        /vagrant/provisioning/fragments/yum.sh
        /vagrant/provisioning/fragments/ssh.sh
        /vagrant/provisioning/fragments/telnet.sh

        /vagrant/provisioning/fragments/server-jsp.sh
        /vagrant/provisioning/fragments/solr.sh
        # /vagrant/provisioning/fragments/jasperserver.sh

        /vagrant/provisioning/fragments/firewall.sh

        echo "[$SCRIPT] ---------- Finished installing base functionality ----------"
    }

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

    echo
    echo "========== STARTED $SCRIPT =========="
    echo

    fc_setVars "${@}"

    case $environment in

        'dev' | 'tst' | 'stg' | 'prd')
            fc_base
            ;;

        \?)
            echo "Invalid environment: $environment.  Valid environments: dev, tst, stg, prd"
            exit 2
            ;;

    esac

    echo
    echo "========== FINISHED $SCRIPT =========="
    echo


