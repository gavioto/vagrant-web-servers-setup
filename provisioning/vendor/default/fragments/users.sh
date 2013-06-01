#!/bin/bash

#
# Provisioning for deployment of server users
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== STARTED USERS.SH =========="
echo

# #
# # auser
# #
# mkdir /home/auser/.ssh
# chown -R auser:auser /home/auser/.ssh
# chmod -R 755 /home/auser/.ssh

# cp /vagrant/provisioning/vendor/default/templates/users/auser/ssh/id_dsa /home/auser/.ssh/id_dsa
# chown -R auser:auser /home/auser/.ssh/id_dsa
# chmod -R 600 /home/auser/.ssh/id_dsa

# cp /vagrant/provisioning/vendor/default/templates/users/auser/ssh/id_dsa.pub /home/auser/.ssh/id_dsa.pub
# chown -R auser:auser /home/auser/.ssh/id_dsa.pub
# chmod -R 644 /home/auser/.ssh/id_dsa.pub

# cp /vagrant/provisioning/vendor/default/templates/users/known_hosts /home/auser/.ssh/known_hosts
# chown -R auser:auser /home/auser/.ssh/known_hosts
# chmod -R 644 /home/auser/.ssh/known_hosts



echo
echo "========== FINISHED USERS.SH =========="
echo
