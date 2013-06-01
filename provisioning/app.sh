#!/bin/bash

#
# Provisioning for deployment of VEMT app server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

    SCRIPT="APP.SH"
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
        /vagrant/provisioning/fragments/git.sh
        /vagrant/provisioning/fragments/pear_packages.sh

        /vagrant/provisioning/fragments/server-php.sh

        /vagrant/provisioning/fragments/firewall.sh

        echo "[$SCRIPT] ---------- Finished installing base functionality ----------"
    }

    # ------------------------------------------------------------------

    fc_dev_utilities(){

        echo "[$SCRIPT] ---------- Installing development utilities ----------"

        #
        # PEAR packages
        #
        pear install --alldeps phpunit/PHPUnit
        pear install --alldeps PHP_CodeSniffer
        pear install --alldeps phpmd/PHP_PMD
        pear install --alldeps pear.phpunit.de/phpcpd

        # PHP code standards fixer
        wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/bin/php-cs-fixer
        chmod a+x /usr/bin/php-cs-fixer

        # wget and unzip the analizer project with all dependencies to /opt
        wget https://dl.dropboxusercontent.com/u/17350177/software/php-analyzer.tar.gz
        tar xfz ./php-analyzer.tar.gz -C /opt
        rm ./php-analyzer.tar.gz
        ln -s /opt/php-analyzer/bin/phpalizer /usr/bin/phpalizer


        #
        # PHPUnit extra packages
        #
        yum -y install php-phpunit-DbUnit php-phpunit-PHPUnit-MockObject php-phpunit-PHPUnit-Selenium php-phpunit-File-Iterator php-phpunit-FinderFacade php-phpunit-PHP-CodeBrowser php-phpunit-PHP-CodeCoverage php-phpunit-PHP-Invoker php-phpunit-PHP-Timer php-phpunit-PHP-TokenStream php-phpunit-PHPUnit php-phpunit-PHPUnit-SkeletonGenerator php-phpunit-Text-Template php-phpunit-phpcpd php-phpunit-phpdcd php-phpunit-phploc


        #
        # Show errors
        #
        mv /etc/php.ini /etc/php.ini.bkp
        cat /etc/php.ini.bkp | sed -e "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" > /etc/php.ini
        rm /etc/php.ini.bkp
        mv /etc/php.ini /etc/php.ini.bkp
        cat /etc/php.ini.bkp | sed -e "s/display_errors = Off/display_errors = On/" > /etc/php.ini
        rm /etc/php.ini.bkp

        echo "[$SCRIPT] ---------- Finished installing development utilities ----------"
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

        'dev')
            fc_base
            fc_dev_utilities
            ;;

        'tst' | 'stg' | 'prd')
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
