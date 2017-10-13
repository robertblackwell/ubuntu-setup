#
#  This makefile creates nginx config files for each of the components (sub domains)
#  of the Stringy.io app.
#
#  Stringy can be implemented with a different domain name, such as iracoon.com
#  this make file knows how to do that.
#  
#  In addition to makeing the config files this makefile can send them to the
#  server hosting the target domain (assuming its a Ubuntu 14 server)
#  the default username and password are se in variables.
#
#  Once sent to the server the config files can be activated or deactivated
#  by this makefile 
#
#############
#  NOTE - THIS MAKEFILE DOES ALL ITS TASKS FROM A DEVELOPMENT MACHINE NOT ON THE SERVER
#############

include ../make_inc

AVAILABLE=/etc/nginx/sites-available
ENABLED=/etc/nginx/sites-enabled

##
## deletes nginx config files for a single domain
##
clean:
	test -d ./sites/$(DOMAIN) && rm -R ./sites/$(DOMAIN)

##
## creates all nginx config files for a domain, all subdomains, all modes plus one for supervisord
##
confs_all:
	test -d ./sites/$(DOMAIN) || mkdir -p ./sites/$(DOMAIN)
	cp -R templates/supervisor.conf ./sites/$(DOMAIN)
	make conf DOMAIN=$(DOMAIN) MODE=stg
	make conf DOMAIN=$(DOMAIN) MODE=local
	make conf DOMAIN=$(DOMAIN) MODE=live

##
## creates the nginx config files for a single domain a single mode and all subdomains
##
conf:	
	php ./mkconf.php $(MODE) docs $(DOMAIN) > ./sites/$(DOMAIN)/$(DOMAIN).docs.$(MODE).conf
	php ./mkconf.php $(MODE) api $(DOMAIN) > ./sites/$(DOMAIN)/$(DOMAIN).api.$(MODE).conf
	php ./mkconf.php $(MODE) frontend $(DOMAIN) > ./sites/$(DOMAIN)/$(DOMAIN).frontend.$(MODE).conf

##
## Sends all the config files for a specified domain to a ubuntu server /etc/nginx/sites-available
## locations assume Ubuntu version 14
##
deploy:
	rsync -artvp ./sites/$(DOMAIN)/* root@$(DOMAIN):$(AVAILABLE)

##
## activates one config files by creating a link /etc/nginx/sites-available --> /etc/nginx/sites-enabled
## ln -s /etc/nginx/sites-available/$(FILE).conf /etc/nginx/sites-enabled/$(FILE).link
##
## requires:
##
##	ROOTPW, AVAILABLE, ENABLED - these are probably already set
##
##	DOMAIN SUBDOMAIN MODE - make sure of these
##
##
activate_file:
	sshpass -p $(ROOTPW) ssh root@${DOMAIN} "ln -s $(AVAILABLE)/$(FILE).conf $(ENABLED)/$(FILE).link"

##
## deactivate a conf file by breaking the link
##	
deactivate_file:
	sshpass -p $(ROOTPW) ssh root@${DOMAIN} "rm $(ENABLED)/$(FILE).link"
		
##
## activate the conf file - domain.subdomain.mode.conf
##		
activate: 
	@make activate_file FILE=$(DOMAIN).$(SUBDOMAIN).$(MODE)

##
## deactivate the conf file - domain.subdomain.mode.conf
##		
deactivate:
	@make deactivate_file FILE=$(DOMAIN).$(SUBDOMAIN).$(MODE)

## 
## activate all conf files for a domain
##
activate_all:
	@make activate DOMAIN=iracoon.com SUBDOMAIN=api MODE=stg
	@make activate DOMAIN=iracoon.com SUBDOMAIN=api MODE=live
	@make activate DOMAIN=iracoon.com SUBDOMAIN=docs MODE=stg
	@make activate DOMAIN=iracoon.com SUBDOMAIN=docs MODE=live
	@make activate DOMAIN=iracoon.com SUBDOMAIN=frontend MODE=stg
	@make activate DOMAIN=iracoon.com SUBDOMAIN=frontend MODE=live
	@make activate_file FILE=supervisor
	
## 
## deactivate all conf files for a domain
##
deactivate_all:
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=api MODE=stg
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=api MODE=live
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=docs MODE=stg
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=docs MODE=live
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=frontend MODE=stg
	@make deactivate DOMAIN=iracoon.com SUBDOMAIN=frontend MODE=live
	@make deactivate_file FILE=supervisor
	
