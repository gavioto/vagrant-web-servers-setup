#!/bin/bash

#
# Provisioning for deployment of VEMT db server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

    SCRIPT="DB.SH"
    environment='dev'

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

    fc_setVars(){
        # parameters
        environment=$1
    }

    # ------------------------------------------------------------------

    fc_base(){

        echo "[$SCRIPT] ---------- Installing base functionality ----------"

        /vagrant/provisioning/fragments/editors.sh
        /vagrant/provisioning/fragments/yum.sh
        /vagrant/provisioning/fragments/ssh.sh
        /vagrant/provisioning/fragments/telnet.sh
        /vagrant/provisioning/fragments/ftp.sh

        /vagrant/provisioning/fragments/server-mysql.sh

        /vagrant/provisioning/fragments/firewall.sh


        # DB_Deploy: Database Change Management tool
        # pear install DB_Deploy-0.9.2.tgz

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

    /etc/init.d/httpd restart

    echo
    echo "========== FINISHED $SCRIPT =========="
    echo


