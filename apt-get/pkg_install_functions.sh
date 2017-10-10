######################################################################################
#
# shell functions that install individual packages
# done as separate functions to that pre-requisite repos and
# other stuff can be done on a per package basis
#
# At the top of the file are a few utility functions
#
######################################################################################

trace=0

######################################################################################
##
## lists the package database and greps the output
## using the first parameter as the grep search string
## returns 0 if exists !=0 if not
##
######################################################################################
pkg_test_exists(){

     grep_string=$1
#     echo " pkg_test_exists ${grep_string}"
#     return 0
#     dpkg-query -l | grep "${grep_string}" 
    
   dpkg-query -l | grep "${grep_string}" &> /dev/null
    return $?
}


######################################################################################
#
# plain apt-get install
#
######################################################################################
apt_get_install(){

    pkg=$1
#     echo "##################################################"
#     echo "#                    ${pkg}                       "
#     echo "##################################################"
#     return;
#     dpkg-query -l  "$pkg" &> /dev/null
#     
#     if [ "$?" -eq "0" ]; then
#         echo "$pkg already installed"
#     else
        apt-get install $pkg -y 
#         echo "$pkg was installed"
#     fi


}
######################################################################################
#
# banner
#
######################################################################################
install_banner(){
    echo "*******************************************************************************"
    echo "**                               $1 - INSTALLING"
    echo "*******************************************************************************"
    return
}

allready_installed_banner(){

    echo "*******************************************************************************"
    echo "**                               $1 - IS ALLREADY INSTALLED "
    echo "*******************************************************************************"
    return

}

######################################################################################
#
# install git
#
######################################################################################
install_git(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  git "
    if [ "$?" -eq "0" ]; then
        
        allready_installed_banner "git"

    else
        install_banner git
        add-apt-repository ppa:git-core/ppa -y
        apt-get update 
        apt-get upgrade 
        apt-get install git
    fi
}

######################################################################################
#
# install nginx
#
######################################################################################
install_nginx(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  nginx" 
    if [ "$?" -eq "0" ]; then
    
        allready_installed_banner "nginx"
    
    else
        install_banner nginx
        add-apt-repository ppa:nginx/stable -y 
        apt-get update 
        apt-get upgrade 
        apt-get install nginx
    fi
}

######################################################################################
#
# install realpath
#
######################################################################################
install_realpath(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  realpath" 
    if [ "$?" -eq "0" ]; then
    
        allready_installed_banner "realpath"
    
    else
        install_banner realpath
        apt-get install realpath
    fi
}


######################################################################################
#
# install redis-server
#
######################################################################################
install_redis_server(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  redis-server " 
    if [ "$?" -eq "0" ]; then
    
        allready_installed_banner "redis-server"
    
    else
        install_banner redis-server
        add-apt-repository ppa:rwky/redis -y 
        apt-get update 
        apt-get upgrade 
        apt-get install redis-server
        return
    fi
}
######################################################################################
#
# install supervisor
#
######################################################################################
install_supervisor(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  supervisor" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner "supervisor"
    else
        install_banner supervisor
        apt-get install supervisor
    fi
}

######################################################################################
#
# install ruby2.2
#
######################################################################################
install_ruby(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
      
    pkg_test_exists "^ii  ruby" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner "ruby2.2"
    else
        install_banner ruby2.2
        apt-add-repository ppa:brightbox/ruby-ng
        apt-get update 
        apt-get upgrade 
        apt-get install ruby2.2
        return
    fi
}
######################################################################################
#
# install nodejs
#
######################################################################################
install_nodejs(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  nodejs" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner "nodejs"
    else
        install_banner nodejs
        curl -sL https://deb.nodesource.com/setup_${node_version} | sudo bash -
        apt-get update 
        apt-get upgrade 
        apt-get install nodejs
		npm -g install bower
		npm -g install webpack 
        return
    fi
}

######################################################################################
#
# install php 5.6
#
######################################################################################
install_php(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  php5 .*5\.6" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner "php5.6"
    else
        install_banner php5.6
        add-apt-repository ppa:ondrej/php5-5.6 -y     
        apt-get update 
        apt-get upgrade 
        apt-get install php5
        return
    fi
}
######################################################################################
#
# install php 7.0
#
######################################################################################
install_php7.0(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  php5 .*5\.6" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner "php5.6"
    else
        install_banner php5.6
        add-apt-repository ppa:ondrej/php5-5.6 -y     
        apt-get update 
        apt-get upgrade 
        apt-get install php5
        return
    fi
}

######################################################################################
#
# install php-extensions
#
######################################################################################
install_php_extensions(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  php5-xdebug" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner php5-extensions  
    else 
        install_banner php5-extensions  
        apt-get install \
            php5-curl \
            php5-gd \
            php5-mcrypt \
            php5-mysql \
            php5-redis \
            php5-xdebug -y 

        cat << EOF | tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
    fi
}

######################################################################################
#
# install proctitle
#
######################################################################################
install_proctitle(){
    php -i | grep "proctitle.*enabled" &> /dev/null
    if [[ $? -eq 0 ]]; then
        allready_installed_banner proctitle
    else
        install_banner proctitle
        apt-get install php-pear php-dev
        pecl install proctitle
        
        ##
        ## now add proctitle.so to the php5 config files
        ##    
        
        return ## not ready yet to try following commands yet
        
            
        cd /etc/php5/mods-available
        sudo touch proctitle.ini
        sudo chmod ugo=rwx proctitle.ini
        sudo echo 'extension=prcotitle.so' > proctitle.ini
        sudo chmod go-wx proctitle.ini
        sudo chmod u-x proctitle.ini
        cd /etc/php5/cli/conf.d
        sudo ln -s /etc/php5/mods-available/proctitle.ini 30-proctitle.ini
        cd /etc/php5/fpm/conf.d
        sudo ln -s /etc/php5/mods-available/proctitle.ini 30-proctitle.ini
        
    fi
}
######################################################################################
#
# install Composer, as a phar
#
######################################################################################
install_composer(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    which composer &> /dev/null
    if [[ "$?" -eq "0" ]]; then 
        allready_installed_banner composer
    else
        install_banner composer
        curl -sS https://getcomposer.org/installer | php 
        mv composer.phar /usr/local/bin/composer 
    fi
}

######################################################################################
#
# install resque_cmd, as a phar
#
######################################################################################
install_resque_cmd(){
    
    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    which resque_cmd.phar &> /dev/null
    if [[ "$?" -eq "0" ]]; then 
        allready_installed_banner resque_cmd
    else
        install_banner resque_cmd
		cd /home/robert		
		git clone https://github.com/robertblackwell/php-resque-command.git 
		chown -R robert php-resque-command
		cd php-resque-command/build
		cp -v resque_cmd.phar /usr/local/bin/
    fi
}


######################################################################################
#
# install MYSQL
#
######################################################################################
install_mysql()
{

    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
    pkg_test_exists "^ii  mysql-server-5.5" 
    if [ "$?" -eq "0" ]; then
        allready_installed_banner mysql
    else
        install_banner mysql-server-5.5
        apt-get install debconf-utils -y 
        debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password rootuser"
        debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password rootuser"

        echo "Installing Mysql"
        export DEBIAN_FRONTEND=noninteractive
        apt-get install mysql-server-5.5 -y 
        mysql -u root --password=rootuser < make_root_user.sql
        ##
        ## need to add a new user called root user
        ##
        echo "Mysql was installed"

    fi
}

######################################################################################
#
# install gulp
#
######################################################################################
install_gulp()
{

    if [[ ${trace} -eq 1 ]] 
    then 
        install_banner "$FUNCNAME[0]" 
        return
    fi
    
	which gulp
    if [ "$?" -eq "0" ]; then
        allready_installed_banner gulp
    else
        install_banner gulp
		npm install --global gulp

    fi
}

