#!/bin/bash

#
# Provisioning for deployment of ftp server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0


#
# FTP
#
yum -y install vsftpd

chkconfig vsftpd on
service vsftpd start
