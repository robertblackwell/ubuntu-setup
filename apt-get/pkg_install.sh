#!/usr/bin/env bash 
#set -x
##########################################################################################
#
# PACKAGE install uninstall
#
# This script installs or uninstalls the apt-get packages required
# by the string.io system
#
# Usage:
#   
#   to install packages just type 
#       sudo bootstrap.sh
#
#   to uninstall type
#       sudo bootstrap.sh uninstall
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
    
    rm -vf /usr/local/bin/composer/composer.phar 
    rm -vf /usr/local/bin/resque_cmd.phar
	rm -Rvf /home/robert/php-resque-cmd
	
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

    hash -r
    apt-get install -f
    . ${MYDIR}/pkg_versions.sh
     
fi 


