# ubuntu
Tools for configuring a Ubuntu 14.04.2 (VPS) server #


This note is intended to assist in setting up a Unbuntu Virtual Private Server.

The details are derived from my efforts to set up a personal __mediatemple__ server intended for the exclusive use of two installations of the stringy.io software.

However since the domain __stringy.io__ is already in use I must use a different
domain for this server and for accessing the __stringy.io__ applications.

I have chosen __iracoon.com__ as the domain for both th server and the implementation of the stringy.io app.   

The __starting point__ for this effort is a server running `Ubuntu 14.04.2 LTS (Trusty Tahr)` for which you have ssh access as root.

The notes below we made during the process in the hope of reminding me what I did.

In each of the steps below I give some explanation of what is going on plus a list of commands to be issued (either on your development machine or the server).

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

## Clone this repository ##

Much of the setup can be accomplished by executing makefiles and shell scripts on your development machine. So
before going any further clone this repo. And CD to the root of the local copy of the repo.

A file named `make_inc` is required by the various makefiles and scripts as it provides parameters, 
including user names and password, that customize the installation process. This file should be created
by you from `make_inc_template` 
BEFORE moving on to the rest of the READFME. 

## Users  ##
Add a user that will be the home of the stringy.io installation. The user needs `sudo` capability, so don't forget to add them to the `/etc/sudoer` file or include them in the `sudo` group. It will help latter if they are also in the `data-www` group.

Do this by issuing the following command on your development machine

|__Commands__|
|-----------------------------|
| ./users/makefile|

## 2. SSH Without passwords  ##

It is convenient to have ssh access without passwords for both `root` and the user you added above.

In the folder `~/.ssh` on your local machine find the file that holds your public key, it may be called something like `id_dsa_pub` or `id_rsa_pub`/ Make sure that this is named correctly in 

	make_inc

Copy the key contained in this file to the files

	/home/robert/.ssh/authorized_keys` 
	/root/.ssh/authorized_keys` 
	
on the server with a command like

	cat ~/.ssh/id_dsa.pub | ssh user@remotehost 'cat >> ~/.ssh/authorized_keys'
	
This can be done with the command 

|Commands|
|------------------------|
| cd ssh; make; cd .. |


## 3. Installing packages ##

Install the `ubuntu/apt-get` folder as `/home/robert/apt-get` on the server. 

The following command (on your work station, from the repo root) should do it 

	rsync -pva apt-get robert@iracoon.com:/home/robert
	
|Commands|
|---------------|
|cd apt-get; make; cd .. |

will also achieve the same transfer but will use the values specified in `make_inc`.
	
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

## php version ##

Currently php5.6 is installed. Have not had a need or time to update for php 7.0.

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

__NOTE__ : THIS IS ACTUALLY DONE BY THE pxg_install.sh script

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

It is a good idea if this is NOT TCP port 9000 as that is the port XDEBUG uses for interactive debugging.

IN this sample I am using a unix port `/var/run/php5-fpm.sock`.

Test this initially in the default nginx configuration. By creating a `phpinfo.php`
file in the directory

	/usr/share/nginx/html	

## 3. nginx configuration ###

### note 1 - todo

Use an include file for the socket/port that connects php-fpm and nginx so that it is not repeated in each config file.
	
### note 2

Note on ubuntu `nginx` and `php5.6-fpm` are started, stopped and restarted with the following commands

	sudo /etc/init.d/nginx start|stop|restarted
	sudo /etc/init.d/php5.6-fpm start|stop|restart

### back to config

Configuration of nginx for the stringy app is best done with the help of scripts and files inside the folder

	ubuntu-setup/nginx-config
	
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

### Generate nginx config files from templates

These conf files can be generated (on your development machine) by the following commands

	cd nginx-config
	make confs_all
	
which deposits the conf files in the sub-folder

	nginx-config/sites/iracoon.com
	
### Deploy the generated config files to server's 'sites-available' folder

To transfer the config files to the iracoon.com server with the command

	cd nginx-setup/nginx-conf
	make deploy

The configuration files are activated or enabled by creating a link into the 
	
	/etc/nginx/sites-enabled

folder on the server. These links are most easily created using remote commands such as :

	ssh root@iracoon.com ln -s /etc/nginx/sites-available/com.iracoon.docs.stg.conf  /etc/sites-enabled/com.iracoon.api.stg.link



## 4. Stringy API setup ###

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

	
## 5. Hooking up Php-Resque for background processing ##

The Stingy Api requires a background processing capability which is provided by a fork of `chrisboulton/php-resque`.

Background processing is performed by `php-resque` worker processes. These processes are started/controlled by `supervisord`.

A set of workers are provided for each of the `live`and `stg` implementations of the api. These workers are configured in 

	/etc/supervisor/conf.d/resque-iracoon.conf

Templates for this file can be found in `Stringy/supervisor/iracoon`
	
Resque worker processes are invoked via shell scripts

	/home/robert/www/stg.iracoon.com/api/bin/start_worker_stg.sh 
	/home/robert/www/stg.iracoon.com/live/bin/start_worker_live.sh 

## 6. Front end

To run the frontend of this app some more stuff has to be done and I have not packaged that. This is the quick and dirty way of doing it.

### Frontend code to server (this is really crude, sorry)

On your development machine 

	cd ~/StringyProject/Stringy
	rsync -rav www robert@iracoon.com:www/stg.iracoon.com

### Nginx passthru fo frontend requests to dev server

Next start setup nginx to pass frontend requests to the frontend dev server on port 3330

On your development machine

	cd ~/unbuntu-setup/nginx-config
	make DOMAIN=iracoon.com MODE=stg SUBDOMAIN=frontend
	
On the server
	
	sudo /etc/init.d/nginx restart
		
On the server we need to start the dev server on port 3330 

	cd ~/www/stg.iracoon.com/www
	npm start

### Run the frontend

Go to a browser and enter the URL

	http://stg.iracoon.com
