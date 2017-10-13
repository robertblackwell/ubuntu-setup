#!/usr/bin/env bash 
#set -x
##########################################################################################
#
# PACKAGE install uninstall
#
# This script allows execution of one of the functions in
# pkg_install_functions.sh
# Usage:
#   
#   to install packages just type 
#       pkg_install_one.sh install <function name>
#
#   to uninstall type
#       pkg_one.sh uninstall <function_name>
#
##########################################################################################
MYDIR=`cd "$(dirname "$0")" && pwd`

. ${MYDIR}/pkg_install_functions.sh ## include specialist functions

######################################################################################
#
# MAINLINE
#
######################################################################################

delta=false
override=false
node_version='0.12'
ruby_version=ruby2.2
php_version=php5-5.6
mysql_version=mysql-server-5.5


if [ "$1" = "uninstall" ] ; then

    ##########################################################################################
    #
    # UNINSTALL packages
    #
    ##########################################################################################
    apt-get autoremove git  
    apt-get autoremove nginx
    apt-get autoremove realpath
    apt-get autoremove redis-server  
    apt-get autoremove supervisor  
    apt-get autoremove rubu2.2 
    apt-get autoremove nodejs  
    
    apt-get autoremove mysql-server-5.5
    apt-get autoremove debconf-utils
    if [ "$2" = "composer"]; then
        rm -vf /usr/local/bin/composer/composer.phar
    elif [ "$2" = "resque"]; then
        rm -vf /usr/local/bin/resque_cmd.phar
        rm -Rvf /home/robert/php-resque-cmd
    elif [ "$2" = "gulp"]; then
        npm uninstall gulp
    else
        apt-get autoremove $2
    fi
else
    ##########################################################################################
    #
    # INSTALL packages
    #
    ##########################################################################################
    install_git
    install_nginx
    install_realpath
    install_redis_server
    install_supervisor
    install_ruby
    install_nodejs    
    install_php
    install_php_extensions
    install_proctitle
    install_mysql
    install_composer
    install_resque_cmd
    install_gulp

    hash -r
    apt-get install -f
    . ${MYDIR}/pkg_versions.sh
     
fi 


