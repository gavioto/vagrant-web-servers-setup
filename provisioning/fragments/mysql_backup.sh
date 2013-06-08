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
ts=`date +%Y%m%d.%H%M`


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
        echo -e "\033[33m If in import no DBname is given, all files in folder will be imported. \033[0m"
        echo -e "\033[33m If in export no DBname is given, all dbs in server will be exported, except system DBs. \033[0m"
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

    fc_export_data(){

        # Get the databases
        DBs=`mysql -u root -p$pass --skip-column-names -e 'SHOW DATABASES'`

        for db_name in $DBs; do
            if [ "$db_name" != "information_schema" ] && \
                [ "$db_name" != "mysql" ] && \
                [ "$db_name" != "performance_schema" ] && \
                [ "$db_name" != "phpmyadmin" ] && \
                [ "$db_name" != "test" ]; then
                echo
                echo "Starting to export DB: $db_name"
                echo "Exporting DB to $dbs_folder/$ts/$db_name.sql ..."
                mysqldump -h localhost -u root -p$pass $db_name > $dbs_folder/$ts/$db_name.sql
                echo "Finished DB $db_name"
                echo
            fi
        done
    }

    # ------------------------------------------------------------------

    fc_export_users(){
        # Build mysql query to grab all privs and user@host combo for given db_username
        mysql  -u root -p$pass -h localhost -B -N \
            -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') AS query FROM user" mysql \
            | mysql  -u root -p$pass -h localhost \
            |  sed 's/Grants for .*/\n\n#### &\n/' > "$dbs_folder/$ts/mysql_users.sql"
    }

    # ------------------------------------------------------------------

    fc_import_data(){

        echo "ls $dbs_folder/*.sql"
        dbs_list=`ls $dbs_folder/*.sql`
        for file in $dbs_list; do

            # Get the DB name
            filename=$(basename "$file")
            db_name="${filename%.*}"

            echo
            echo "Starting to import DB: $dbs_folder/$db_name"
            # The next 2 lines can be removed after we import into the new production server
            echo "Replacing migration\`@\`82-168-162-214.ip.telfort.nl for CURRENT_USER ..."
            mv $dbs_folder/$db_name.sql $dbs_folder/$db_name.sql.bkp
            cat $dbs_folder/$db_name.sql.bkp | sed -e "s/DEFINER=\`migration\`@\`82-168-162-214.ip.telfort.nl\`/DEFINER=CURRENT_USER/" > $dbs_folder/$db_name.sql
            echo "Done"
            echo "Importing DB ..."
            mysql -u root -p$pass -e "CREATE DATABASE IF NOT EXISTS $db_name"
            mysql -u root -p$pass $db_name < $dbs_folder/$db_name.sql
            rm -f $dbs_folder/$db_name.sql
            mv $dbs_folder/$db_name.sql.bkp $dbs_folder/$db_name.sql
            echo "Finished DB $db_name"
            echo
        done
    }

    # ------------------------------------------------------------------

    fc_import_users(){
        if [ -f $dbs_folder/mysql_users.sql ]; then
            mysql -u  -u root -p$pass -h localhost < $dbs_folder/mysql_users.sql
        fi
    }

    # ------------------------------------------------------------------

    fc_main(){
        case $action in

            'export')
                fc_export_data
                fc_export_users
                ;;

            'import')
                fc_import_data
                fc_import_users
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




