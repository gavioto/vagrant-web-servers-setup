#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== GIT.SH =========="
echo

# CMD options
name="VEMT"
email="dev@vemt.com"
while getopts "ne" opt; do
    case $opt in
        n)
            name="$OPTARG"
            ;;
        e)
            email="$OPTARG"
            ;;

        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;

    esac
done

#
# GIT
#
yum -y install git-core git-cola meld

git config --global user.name $name                          # Sets the default name for git to use when you commit
git config --global user.email $email                        # Sets the default email for git to use when you commit
git config --global core.editor vim                          # Sets the default editor
git config --global merge.tool meld                          # Sets the default merge tool to be used when there are problems
git config --global credential.helper 'cache --timeout=3600' # Set the cache to timeout after 1 hour (setting is in seconds)

echo
echo "========== FINISHED GIT.SH =========="
echo
