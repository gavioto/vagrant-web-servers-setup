#!/bin/bash

#
# Provisioning for deployment of VEMT  server
#
# Security settings
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

#
# FIREWALL
#
    # iptables-restore < /vagrant/provisioning/vendor/vemt/templates/firewall/iptables.conf

    # service iptables save
    # service iptables restart