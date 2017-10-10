include ../make_inc

##
## config user to ssh without passwords
##
## run this target from your development machine
##
config_user: user_ssh_dir
	cat /Users/$(LOCALUSER)/.ssh/$(KEYFILE).pub | ssh $(USER)@$(DOMAIN) 'cat >> /home/$(USER)/.ssh/authorized_keys'

##
## make a folder /root/.ssh if it does not exist and add a file authorized_keys
##
root_ssh_dir:
	sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) 'test -d .ssh || mkdir -p .ssh'
	sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) 'test -f .ssh/authorized_keys || touch .ssh/authorized_keys'

user_ssh_dir:
	sshpass -p $(USERPW) ssh $(USER)@$(DOMAIN) 'test -d .ssh || mkdir -p .ssh'
	sshpass -p $(USERPW) ssh $(USER)@$(DOMAIN) 'test -f .ssh/authorized_keys || touch .ssh/authorized_keys'

##
## config root for passwordless ssh
##	
config_root: root_ssh_dir
	make root_ssh_dir
	cat /Users/$(LOCALUSER)/.ssh/$(KEYFILE).pub | sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) 'cat >> /root/.ssh/authorized_keys'
	