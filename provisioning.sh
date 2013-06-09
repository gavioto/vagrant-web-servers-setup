#!/bin/bash

#
# Provisioning for deployment of VEMT servers
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

    action=''
    environment='dev'
    box='app'
    vendor='default'
    gituser=''
    vagrant_provisioning_lock="/home/vagrant/.vagrant_provisioning.lock"

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

    fc_setVars(){

        # CMD options
        while getopts "hb:e:v:g:" opt; do
            case $opt in
                b)
                    box=$OPTARG
                    ;;

                e)
                    environment=$OPTARG
                    ;;

                v)
                    vendor=$OPTARG
                    ;;

                g)
                    gituser=$OPTARG
                    ;;

                h)
                    action='help'
                    ;;

                \?)
                    echo "Invalid option: -$OPTARG" >&2
                    exit 1
                    ;;

            esac
        done

        shift $(($OPTIND - 1))

    }

    # ------------------------------------------------------------------

    fc_help(){
            echo -e "\033[33m Usage:  \033[0m"
            echo -e "\033[33m " $0 " [-h] -b <boxName> -e <environment> -v <vendor> \033[0m"
            echo -e "\033[33m Boxes possible: app, db, reports, mailings \033[0m"
            echo -e "\033[33m Environments possible: dev, tst, stg, prd \033[0m"
            echo -e "\033[33m Options: \033[0m"
            echo -e "\033[33m          -h   Show this help information. \033[0m"
            echo -e "\033[33m          -b   The box name. \033[0m"
            echo -e "\033[33m          -e   The environment. \033[0m"
            echo -e "\033[33m          -v   The vendor (for vendor specific configs, where a vendor might be a company or project you work for). \033[0m"
            exit 0
    }

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

    echo
    echo "========== STARTED PROVISIONING.SH =========="
    echo

    fc_setVars "${@}"

    case  $action  in

        "help")
            fc_help
            ;;

        *)
            if [ -f "$vagrant_provisioning_lock" ]; then
                echo "Provisioning of this VM has already been made."
                echo "If you want to run the provisioning script again, login to the VM and delete the file '$vagrant_provisioning_lock'"
            else
                cd /vagrant
                /vagrant/provisioning/$box.sh $environment
                if [ "$vendor" != "default" ]; then
                    /vagrant/provisioning/vendor/$vendor/$box.vendor.sh $gituser $environment
                else
                    echo "Vagrantfile specific to the vendor is set to default, so it will not be run."
                fi
                touch $vagrant_provisioning_lock
            fi
            ;;

    esac

    echo
    echo "========== FINISHED PROVISIONING.SH =========="
    echo
    echo "NOTE: sometimes this locks here, but you can safely terminate execution with ctrl+c twice"
