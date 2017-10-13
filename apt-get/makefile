#
# This makefile assists with the setting up of a Ubuntu 14 server as a host for the Stringy.io
# application.
#
# 
#
include ../make_inc

TARGETDIR=apt-get
PWD=$(shell pwd)

deploy:
	rsync -artvp $(PWD) $(USER)@$(DOMAIN):/home/$(USER) #/$(TARGETDIR)/
	@echo ""
	@echo "###########################################################"	
	@echo ""
	@echo "Now signin to the server using" 
	@echo	ssh $(USER)@$(DOMAIN)
	@echo then execute the following commands:
	@echo ""
	@echo cd /home/$(USER)/package_install
	@echo sudo ./pkg-install.sh
	@echo sudo ./pkg_versions.sh
	@echo ""
	@echo "When all is done your Ubuntu server should have all the "
	@echo "packages required by Stringy.io installed"	
	@echo ""
	@echo "###########################################################"	
	@echo ""
	