# ubuntu
Tools for configuring a Ubuntu 14.04.2 (VPS) server #


This note is intended to assist in setting up a Unbuntu Virtual Private Server.

The details are derived from my efforts to set up a personal __mediatemple__ server intended for the exclusive use of two installations of the stringy.io software.

However since the domain __stringy.io__ is already in use I must use a different
domain for this server and for accessing the __stringy.io__ applications.

I have chosen __iracoon.com__ as the domain for both th server and the implementation of the stringy.io app.   

The __starting point__ for this effort is a server running `Ubuntu 14.04.2 LTS (Trusty Tahr)` for which you have ssh access as root.

The notes below we made during the process in the hope of reminding me what I did.

Since writing these I have automated much of the process in a series of makefiles
that can be found in the github repository `robertblackwell/ubuntu14`.

To get started with these makefiles clone the repository to your development machine. 

In each of the steps below I give some explanation of what is going on plus a list of commands to be issued (either on your development machine or the server)
to use the makefiles.

Before getting started here are two topics that need be covered to help you get to the point where a __mediatemple__ server meets our starting point requirements.

### DNS ###

Make sure that the DNS records of your domain (the domain you used for your media temple server) point at the __mediatemple__ name servers. Typically they are:

	ns1.mediatemple.net

	ns2.mediatemple.net

You will know when this is done as a ping of your domain will show the IP address
given in your media temple control panel.

### SSH Part I ###

You might be able to 

	ssh root@yourdomain
	
immediately by giving the root password supplied when setting up your media temple account.

But if you a re-using a previously used domain you might get a response something like this

```

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
a8:1c:db:45:28:b8:5f:33:20:c0:89:45:16:6b:ca:2e.
Please contact your system administrator.
Add correct host key in /Users/rob/.ssh/known_hosts to get rid of this message.
Offending RSA key in /Users/rob/.ssh/known_hosts:12
RSA host key for iracoon.com has changed and you have requested strict checking.
Host key verification failed.

```

This is telling you that __yourdomain__ has previously been used but on a different host. To use __yourdomain__ on the new host you will have to delete that domain from the `know_hosts` file. The message gives the line number. 

##1. Users  ##
Add a user that will be the home of the stringy.io installation. The user needs `sudo` capability, so don't forget to add them to the `/etc/sudoer` file or include them in the `sudo` group. It will help latter if they are also in the `data-www` group.

|__Commands__|
|-----------------------------|
| ubuntu/users/makefile|

## 2.SSH Without passwords  ##

It is convenient to have ssh access without passwords for both `root` and the user you added above.

In the folder `~/.ssh` on your local machine find the file that holds your public key, it may be called something like `id_dsa_pub` or `id_rsa_pub`/ Make sure that this is named correctly in 

	ubuntu/make_inc

Copy the key contained in this file to the files

	/home/robert/.ssh/authorized_keys` 
	/root/.ssh/authorized_keys` 
	
on the server with a command like

	cat ~/.ssh/id_dsa.pub | ssh user@remotehost 'cat >> ~/.ssh/authorized_keys'
	
This can be done with the command 

|Commands|
|------------------------|
| ubuntu/ssh/makefile|


## 3. Installing packages ##

Install the `ubuntu/apt-get` folder as `/home/robert/apt-get` on the server. 

The following command (on your work station) should do it (executed from ubuntu-setup folder)

	rsync -pva apt-get robert@iracoon.com:/home/robert
	
|Commands|
|---------------|
|ubuntu/apt-get/makefile |

will also achieve the transfer.
	
Now run the `pkg_install` script on the server.

After ssh'ing to the server as the appropriate user enter the following commands.

	cd ~/apt-get
	./pkg_install.sh

This should install all required packages.

After this in addition to packages you should have mysql installed with a user `rootuser`, `php5-5.6` with a range of extension and `pecl`.

See the makefiles and associated scripts for details.

Check this by running

	./pkg_versions.sh

This should list all the required packages with version numbers.
	
### MYSQL root password ###

The command

	sudo dpkg-reconfigure mysql-server-5.5
	
will prompt for a new password for the mysql root user.

__Alternative__

The mysql can be stopped using the command

	sudo service mysql stop

Start mysql with `sudo mysql --skip-grant-tables &`
Start mysql command line with `mysql -u root mysql`
Set the password with

	UPDATE user set Password=PASSWORD('the_new_password') where User='root';
	FLUSH PRIVLIGES;
	EXIT;

Then `sudo kill -9` the mysql process you started.

__NOTE__ This is now done by the `pkg_install.sh` script.
	
### Php proctitile extension  ###

NOTE : THIS IS ACTUALLY DONE BY THE pxg_install.sh script

Install 	`php-pear` and `php5-dev`

	sudo apt-get install php-pear
	
	sudo apt-get install php5-dev
	
and then 
	
	sudo pecl install proctitle
	
unfortunately after that there is some manual config to do, so that both the cli and fpm versions of php have access to the `proctitle.so` file.

	cd /etc/php5/mods-available
	sudo touch proctitle.ini
	sudo chmod ugo=rwx proctitle.ini
	sudo echo 'extension=prcotitle.so' > proctitle.ini
	sudo chmod go-wx proctitle.ini
	sudo chmod u-x proctitle.ini
	cd ../cli/conf.d
	sudo ln -s ../../mods-available/proctitle.ini 30-proctitle.ini
	cd /etc/php5/fpm/conf.d
	sudo ln -s ../../mods-available/proctitle.ini 30-proctitle.ini

__NOTE__ : this may not have been necessary as it seems the `cli_set_process_title` works on this implementation of php5

### FastCGI ###

Make sure that the `php-fpm` and `nginx` config files have the same unix/tcp port for connection. This may involve editing either 

	/etc/nginx/sites-available/default
	
and or

	/etc/php5/fpm/pools.d/www.conf

Test this initially in the default nginx configuration. By creating a `phpinfo.php`
file in the directory

	/usr/share/nginx/html	

### nginx configuration ###

Configuration of nginx for the stringy app is best done with the help of scripts and files inside the folder

	Stringy/provisioning/nginx-config
	
To config the Stringy app on a new domain (such as iracoon.com) requires generating nginx config files for the following subdomains.

-	stg.docs.iracoon.com	-	the documentation stage site
-	stg.api.iracoon.com	-	 the backend api stage site
-	stg.iracoon.com	-	the front end stage site

-	live.docs.iracoon.com	-	the documentation live site
-	live.api.iracoon.com	-	the backend api live site
-	iracoon.com	-	the front end live site

These sites will be served from the following document root folders

|Subdomain | Document Root|
|-------------------| -----------------------|
stg.docs.iracoon.com | ~/www/stg.iracoon.com/docs/public
stg.api.iracoon.com | ~/www/stg.iracoon.com/api/public
stg.iracoon.com | ~/www/stg.iracoon.com/www/public
live.docs.iracoon.com | ~/www/stg.iracoon.com/docs/public
live.api.iracoon.com | ~/www/stg.iracoon.com/api/public
iracoon.com | ~/www/stg.iracoon.com/www/public

And each site requires a config file

|Subdomain | Name of config file|
|-------------------| -----------------------|
stg.docs.iracoon.com | com.iracoon.docs.stg.conf
stg.api.iracoon.com | com.iracoon.api.stg.conf
stg.iracoon.com | com.iracoon.stg.conf
live.docs.iracoon.com | com.iracoon.docs.live.conf
live.api.iracoon.com | com.iracoon.api.live.conf
iracoon.com | com.iracoon.live.conf

These con files can be generated by the following commands

	cd Stringy/provisioning/nginx-config
	mkconfs.sh
	
which deposits the con files in the sub-folder

	Stringy/provisioning/nginx-config/iracoon.com
	
transfer the config files to the iracoon.com server with the command

	cd Stringy/provisioning/nginx-conf
	rsync -ravp iracoon.com/* root@iracoon.com:/etc/nginx/sites-available/
	
The configuration files are activated or enabled by creating a link into the 
	
	/etc/nginx/sites-enabled

folder on the server. These links are most easily created using remote commands such as :

	ssh root@iracoon.com ln -s /etc/nginx/sites-available/com.iracoon.docs.stg.conf  /etc/sites-enabled/com.iracoon.api.stg.link



###  Stringy API setup ###

-	The makefile in `Stringy/api` has an option `make deploy_iracoon_stg` which will send all api related files to the correct folder on the `iracoon` server.

-	Once the transfer is complete login to the server 
	
		ssh robert@iracoon.com

	and run 

		cd www/stg.iracoon.com
		composer install`.

-	Create the Log and Temp folder and give it the correct permissions `ugo=rwx`.

		cd www/stg.iracoon.com
		cd api
		mkdir Log
		chmod -r ugo=rwx  Log

	or chown these folders to be owned by the user `www-data` - thats who nginx and php-fpm run as.
	
		sudo chown -R www-data Log
		sudo chown -R www-data Temp
	
-	Seed the database

		make db_all MODE=stg

	
## Hooking up Php-Resque for background processing ##

The Stingy Api requires a background processing capability which is provided by a fork of `chrisboulton/php-resque`.

Background processing is performed by `php-resque` worker processes. These processes are started/controlled by `supervisord`.

A set of workers are provided for each of the `live`and `stg` implementations of the api. These workers are configured in 

	/etc/supervisor/conf.d/resque-iracoon.conf

Templates for this file can be found in `Stringy/supervisor/iracoon`
	
Resque worker processes are invoked via shell scripts

	/home/robert/www/stg.iracoon.com/api/bin/start_worker_stg.sh 
	/home/robert/www/stg.iracoon.com/live/bin/start_worker_live.sh 




