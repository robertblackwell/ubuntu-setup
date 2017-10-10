##
## This makefile adds a single new user (robert) to the target server
## and makes it a sudoer
##
include ../make_inc

default:
	make add_sudo_user PW=$(USERPW) NAME=$(USER)
	
add_sudo_user:
	sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) "useradd  $(NAME) -m -b /home -g sudo"
	echo "$(NAME):$(PW)" | sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) "chpasswd"	
	