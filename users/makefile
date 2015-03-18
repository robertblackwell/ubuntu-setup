##
## This makefile adds a single new user (robert) to the target server
## and makes it a sudoer
##
include ../make_inc

default:
	make add_sudo_user PW='Wara)(12' NAME=robert
	
add_sudo_user:
	sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) "useradd  $(NAME) -g sudo"
	echo "$(NAME):$(PW)" | sshpass -p $(ROOTPW) ssh $(ROOT)@$(DOMAIN) "chpasswd"	
	