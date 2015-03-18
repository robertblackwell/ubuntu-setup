##
## This makefile assists configure supervisor to manager background processes for
## the stringy.io app.
##
## To configure supervisor run
##
## 		make deploy
##
include ../make_inc

deploy:
	rsync -artvp $(PWD)/supervisor.conf $(ROOT)@$(DOMAIN):/etc/supervisor/
	rsync -artvp $(PWD)/conf.d/* $(ROOT)@$(DOMAIN):/etc/supervisor/conf.d/
	@echo ""
	@echo "###########################################################"	
	@echo ""
	@echo "Now signin to the server using" 
	@echo	ssh $(USER)@$(DOMAIN)
	@echo then execute the following commands:
	@echo ""
	@echo sudo supervisorctl reread
	@echo sudo supervisorctl restart
	@echo ""
	@echo "When all is done your Ubuntu server should have supervisor "
	@echo "ready to run the stringy.io background processes"
	@echo ""
	@echo " PREREQUISITE: must have installed all packages and stringy app code "	
	@echo "               before confuring supervisor"
	@echo "###########################################################"	
	@echo ""
	
