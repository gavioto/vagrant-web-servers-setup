#!/bin/bash

#
# Script to export/import all DBs in the production server (backup)
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

pass=''
action='help'
dbs_folder='.'

# DBs
#     DB_S2000  /  DB_ML  /  DB_MD  /  DB_HF
DBs=("25c18594956a3196ca388d06f8a852c6" "869d272988ac4f4cb46ed81e4c8db33a" "987bcab01b929eb2c07877b224215c92" "a3819c74b8d519da14f2485e50ff1a9a" "b9bd544ae3cb4abc294005898df5ccaa" "d90703d2d2df546b1d129498d565893c" "fe01ce2a7fbac8fafaed7c982a04e229")



# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

    fc_setVars(){

        # CMD options
        while getopts "heip:f:" opt; do
            case $opt in
                e)
                    echo "exporting ..."
                    action='export'
                    ;;
                i)
                    echo "importing ..."
                    action='import'
                    ;;
                p)
                    pass=$OPTARG
                    ;;
                f)
                    dbs_folder=$OPTARG
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

        if [ "$pass" == "" ]; then
            echo "You didn't gave me the root password for the DB server" >&2
            action='help'
        fi

        if [ "$1" != "" ]; then
            DBs=($1)
        fi
    }

    # ------------------------------------------------------------------

    fc_help(){
        echo -e "\033[33m Usage:  \033[0m"
        echo -e "\033[33m " $0 "<options> [DBname] [DBs path] \033[0m"
        echo -e "\033[33m If no DBname is given, all predefined DBs will be imported or exported \033[0m"
        echo -e "\033[33m Example:" $0 " -e \033[0m"
        echo -e "\033[33m Example:" $0 " -e -p xpto -f ./dbs db_name \033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
        echo -e "\033[33m          -e   Export the DBs. \033[0m"
        echo -e "\033[33m          -i   Import the DBs. \033[0m"
        echo -e "\033[33m          -p   The root pass. \033[0m"
        echo -e "\033[33m          -f   The folder where the DBs are or should be exported to. \033[0m"
        exit 0
    }

    # ------------------------------------------------------------------

    fc_export(){
        for db_name in "${DBs[@]}"; do
            ts=date +%Y%m%d.%H%M
            echo "DB: $dbs_folder/$ts/$db_name"
            mysqldump -h localhost -u root -p$pass $db_name > $dbs_folder/$ts/$db_name.sql
        done
    }

    # ------------------------------------------------------------------

    fc_import(){
        for db_name in "${DBs[@]}"; do
            echo "DB: $dbs_folder/$db_name"
            # The next 2 lines can be removed after we import into the new production server
            mv $dbs_folder/$db_name.sql $db_name.sql.bkp
            cat $dbs_folder/$db_name.sql.bkp | sed -e "s/DEFINER=\`migration\`@\`82-168-162-214.ip.telfort.nl\`/DEFINER=CURRENT_USER/" > $dbs_folder/$db_name.sql
            mysql -u root -p$pass -e "CREATE DATABASE $db_name"
            mysql -u root -p$pass $db_name < $dbs_folder/$db_name.sql
        done
    }

    # ------------------------------------------------------------------

    fc_main(){
        case $action in

            'export')
                fc_export
                ;;

            'import')
                fc_import
                ;;

            'help')
                fc_help
                ;;

            \?)
                echo "Invalid action: $action" >&2
                exit 2
                ;;

        esac
    }

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

    fc_setVars "${@}"

    fc_main




