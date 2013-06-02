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
        /vagrant/provisioning/fragments/jasperserver.sh

        /vagrant/provisioning/fragments/firewall.sh

        # redirect ports 80 and 443 ()http and https) to 8080 and 8181 so by default we go to tomcat
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
        iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8181

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


