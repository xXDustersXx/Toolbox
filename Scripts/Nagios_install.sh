#!/bin/bash

#color
GREEN="\e[32m"
RED="\e[31m"
DEFAULT="\e[39m"

#Variables
NAGIOS_VERSION=4.4.5
NAGIOS_TAR=0
NAGIOS_FOLD=0
NAGIOS_LINK=0
CURRENT_SERVER_IP="$(ip a | grep inet | grep /24 | awk '{print $2}' | cut -d '/' -f 1)"
NAGIOS_LOG="/usr/local/nagios/var/nagios.log"

#function
Display_info()
{
	clear
	echo "#################################"
	echo "##     NAGIOS INSTALLATION     ##"
	echo "##        VERSION: $NAGIOS_VERSION       ##"
    echo "#################################"
    echo
}
NagiosVersionSelector_info()
{
	Display_info
	echo "Seclect Nagions Version [ Default = 4.4.5 ]"
	echo "Nagios Version [ 4.4.3 | 4.4.4 | 4.4.5 | 4.4.6 ]: \c"
	read NAGIOS_VERSION
	export NAGIOS_VERSION
	if [ "$NAGIOS_VERSION" = "" ]; then
		export NAGIOS_VERSION=4.4.5
	fi
	if [ "$NAGIOS_VERSION" = "4.4.3" ]; then
		Display_info
		echo "Nagios Selected Version is: ${GREEN}4.4.3${DEFAULT}"
		export NAGIOS_LINK="https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz"
		sleep 3
		Createuser_info
	elif [ "$NAGIOS_VERSION" = "4.4.4" ]; then
		Display_info
		echo "Nagios Selected Version is: ${GREEN}4.4.4${DEFAULT}"
		export NAGIOS_LINK="https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.4.tar.gz"
		sleep 3
		Createuser_info
	elif [ "$NAGIOS_VERSION" = "4.4.5" ]; then
		Display_info
		echo "Nagios Selected Version is: ${GREEN}4.4.5${DEFAULT}"
		export NAGIOS_LINK="https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz"
		sleep 3
		Createuser_info
	elif [ "$NAGIOS_VERSION" = "4.4.6" ]; then
		Display_info
		echo "Nagios selected version is: ${GREEN}4.4.6${DEFAULT}"
		echo "${RED}Beware 4.4.6 version is really recent releases, some bugs could appear !!!${DEFAULT}"
		echo "Are you sure wante continue ? [y/n]: \c"
		read NAG_VER_VALIDATE
		if [ "$NAG_VER_VALIDATE" = "" ]; then
			export NAGIOS_LINK="http://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.4.6/nagios-4.4.6.tar.gz"
			Createuser_info
		elif [ "$NAG_VER_VALIDATE" = "y" ]; then
			export NAGIOS_LINK="http://sourceforge.net/projects/nagios/files/nagios-4.x/nagios-4.4.6/nagios-4.4.6.tar.gz"
			Createuser_info
		elif [ "$NAG_VER_VALIDATE" = "n" ]; then
			NagiosVersionSelector_info
		else
			echo "Incorrect choice"
			echo "[Enter] to continue \c"
			read PAUSE
			NagiosVersionSelector_info
		fi
	else
		echo "Enter right Nagios version please !"
		NagiosVersionSelector_info
	fi
}

Cleanfiles_info()
{
	Display_info
	NAGIOS_TAR=/tmp/nagios-$NAGIOS_VERSION.tar.gz
	NAGIOS_FOLD=/tmp/nagios-$NAGIOS_VERSION
	echo "${GREEN}Cleaning files ...${DEFAULT}"
	if [ -f "$NAGIOS_TAR" ]; then
		rm -rf $NAGIOS_TAR
	fi
	if [ -d "$NAGIOS_FOLD" ]; then
		rm -rf $NAGIOS_FOLD
	fi
	sleep 3
}

Createuser_info()
{
	Display_info
	echo "${GREEN}Creating & setup user ...${DEFAULT}"
	sleep 3
	groupadd -g 9000 nagios
	groupadd -g 9001 nagcmd 
	useradd -u 9000 -g nagios -G nagcmd -d /usr/local/nagios -c 'Nagios Admin' nagios
	adduser www-data nagcmd
	usermod -aG nagios www-data
	Install_info
}

Install_info()
{
	Display_info
	echo "Install Package and dependancies:\n - Build-essential\n - Unzip\n - OpenSSL\n - Libssl-dev\n - libgd-dev\n - Apache2\n - Libapache2-mod-php\n - PHP\n - libapache2-mod-php"
	sleep 3
	apt -y install build-essential unzip openssl libssl-dev libgd-dev apache2 php libapache2-mod-php php-gd
	Cleanfiles_info
	echo "${GREEN}Starting nagios download ...${DEFAULT}"
	sleep 3
	wget $NAGIOS_LINK -P /tmp/
	tar xf /tmp/nagios-$NAGIOS_VERSION.tar.gz -C /tmp/
	cd /tmp/nagios-$NAGIOS_VERSION/
	echo "${GREEN}Starting nagios install ...${DEFAULT}"
	sleep 3
	./configure --with-httpd-conf=/etc/apache2/sites-enabled
	make all
	make install
	make install-init
	make install-commandmode
	make install-config
	make install-webconf
	echo "${GREEN}Nagios is installed${DEFAULT}"
	sleep 3
	Apacheconfig_info
}

Apacheconfig_info()
{
	Display_info
	echo "${GREEN}start apache2 setup ...${DEFAULT}"
	sleep 3
	a2enmod rewrite cgi
	echo "${RED}Enter password for web interface !${DEFAULT}"
	htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
	sed -i 's/nagiosadmin/admin/g' /usr/local/nagios/etc/cgi.cfg
	chown www-data.www-data /usr/local/nagios/etc/htpasswd.users
	chmod 640 /usr/local/nagios/etc/htpasswd.users
	echo "${GREEN}Open HTTP port ...${DEFAULT}"
	sleep 3
	ufw allow 80
	systemctl restart apache2
	Nagiosstart_info
}

Nagiosstart_info()
{
	Display_info
	echo "${GREEN}Download nagios plugins ...${DEFAULT}"
	sleep 3
	wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz -P /tmp/
	tar xf /tmp/nagios-plugins-2.2.1.tar.gz -C /tmp/
	cd /tmp/nagios-plugins-2.2.1/
	echo "${GREEN}Install nagios plugins ...${DEFAULT}"
	sleep 3
	./configure --with-nagios-user=nagios --with-nagios-group=nagios
	make
	make install
	systemctl restart nagios
	echo "${GREEN}Nagios is installed${DEFAULT}"
	sleep 3
	Print_info
}

Print_info()
{
	Display_info
	echo "Nagios Install is Now ${GREEN}FINISHED${DEFAULT}"
	echo "You can acces nagios web interface here:${GREEN} http://$CURRENT_SERVER_IP/nagios${DEFAULT}"
	echo "Logs are available here:${GREEN} $NAGIOS_LOG${DEFAULT}"
	echo
}
#exec
NagiosVersionSelector_info
