#!/bin/bash

######################################
#                                    #
######################################

#Variable 



#Function
display_func()
{
	clear
	echo "##############################"
	echo "##      Systeme Setup       ##"
	echo "##############################"
}

apt_install(){
	apt-get update
	apt-get -y install locate 
	echo "alias ll='ls -la --color'" >> ~/.bashrc
	echo "alias apt-get='apt-get -y'" >> ~/.bashrc
	echo "alias rekt='rm -rf *~'" >> ~/.bashrc
	echo "alias e='emacs'" >> ~/.bashrc
	echo "alias cc='clear'" >> ~/.bashrc
	echo "alias apti='apt-get -y install'" >> ~/.bashrc
	echo "alias aptr='apt-get -y remove'" >> ~/.bashrc
	echo "alias aptrp='apt-get -y remove --purge'" >> ~/.bashrc
	echo "alias aptu='apt-get -y update'" >> ~/.bashrc
	source ~/.bashrc
}

yum_install(){
	yum update
	yum -y install locate 
	echo "alias ll='ls -la --color'" >> ~/.bashrc
	echo "alias apt-get='apt-get -y'" >> ~/.bashrc
	echo "alias rekt='rm -rf *~'" >> ~/.bashrc
	echo "alias e='emacs'" >> ~/.bashrc
	echo "alias cc='clear'" >> ~/.bashrc
	echo "alias apti='apt-get -y install'" >> ~/.bashrc
	echo "alias aptr='apt-get -y remove'" >> ~/.bashrc
	echo "alias aptrp='apt-get -y remove --purge'" >> ~/.bashrc
	echo "alias aptu='apt-get -y update'" >> ~/.bashrc
	source ~/.bashrc
}

arch_selector()
{
	display_func
	read -p "arch (yum | apt): " ARCH
	if [[ "$ARCH" = "apt" ]]; then
		apt_install
	elif [[ "$ARCH" = "yum" ]]; then
		yum_install
	else
		echo "Select Available arch!"
		arch_selector
	fi
}
#Execution
arch_selector
