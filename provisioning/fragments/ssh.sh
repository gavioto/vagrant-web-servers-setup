#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== SSH.SH =========="
echo

#
# SSH
#
yum -y install openssh openssh-server

cp /vagrant/provisioning/templates/sshd_config /etc/ssh/sshd_config
chown -R root:root /etc/ssh/sshd_config
chmod -R 770 /etc/ssh/sshd_config

echo
echo "========== FINISHED SSH.SH =========="
echo
