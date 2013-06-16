#!/bin/bash

#
# Provisioning for deployment of server
#
# Security settings
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

#
# FIREWALL
#
    iptables -F

    case $box in
        "app" | "db")
            # iptables-restore < /vagrant/provisioning/vendor/vemt/templates/firewall/iptables.$box.conf
            ;;

        "reports" | "mailings")
            # for tomcat application servers we redirect ports 80 and 443 (http and https)
            # to 8080 and 8181 so by default we go to tomcat
            iptables -A INPUT -i eth1 -p tcp --dport 80 -j ACCEPT
            iptables -A INPUT -i eth1 -p tcp --dport 8080 -j ACCEPT
            iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 8080
            iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 443 -j REDIRECT --to-port 8181
            ;;

    esac

    service iptables save
    # service iptables restart