#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== PEAR_PACKAGES.SH =========="
echo

#
# PEAR packages
#
yum -y install php-pear
pear config-set auto_discover 1
pear upgrade pear
pear channel-discover bartlett.laurent-laville.org
pear channel-discover pear.symfony.com
pear channel-discover pear.symfony-project.com
pear channel-discover pear.phpunit.de
pear channel-discover components.ez.no
pear channel-discover pear.phpdoc.org
pear channel-discover pear.phing.info
pear channel-discover pear.phpmd.org
pear channel-discover pear.pdepend.org
pear channel-update pear.php.net

pear install --alldeps bartlett/PHP_CompatInfo
pear install --alldeps XML_Serializer-0.20.2
pear install --alldeps pear.symfony.com/Yaml
pear install --alldeps pear/PEAR_PackageFileManager2
pear install --alldeps pear.phpdoc.org/phpDocumentor-2.0.0a12
pear install --alldeps SOAP-0.13.0
pear install --alldeps Net_Dime
pear install --alldeps Net_FTP
pear install --alldeps XML_Parser-1.3.4
pear install --alldeps VersionControl_Git-0.4.4
pear install --alldeps phing/phingdocs
pear install --alldeps phing/phing


echo
echo "========== FINISHED PEAR_PACKAGES.SH =========="
echo
