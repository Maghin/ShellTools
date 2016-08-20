#!/bin/bash

# OS VERSION: CentOS 7 + Minimal
# ARCH: 64bit

# MerhylStudio Architechture
# Automated Installation Script Common Functions
# ===============================================
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#


###############################################
# Common functions
#
source ./common.sh
source ./color.sh


###############################################
# Set custom logging methods so we create a log file in the current working directory.
#
currentTime=`DateString`
logfile=$0-${currentTime}.log
exec > >(tee $logfile)
exec 2>&1

# Create a task file
todoFile="todoTask-currentTime.txt"

###############################################
# Print a nice banner
#
echo -e "${Blue}------------------------------------------------${NC}"
echo -e "${Blue}--${NC}                                            ${Blue}--${NC}"
echo -e "${Blue}--${NC}  ${Purple}MerhylShark Architechture${NC} (GNU/GPL3)      ${Blue}--${NC}"
echo -e "${Blue}--${NC}                                            ${Blue}--${NC}"
echo -e "${Blue}--${NC}    ${Red}Automated Installation Script${NC}           ${Blue}--${NC}"
echo -e "${Blue}--${NC}                                            ${Blue}--${NC}"
echo -e "${Blue}--${NC}      BY: Maghin                            ${Blue}--${NC}"
echo -e "${Blue}--${NC}    DATE: June 2016                         ${Blue}--${NC}"
echo -e "${Blue}--${NC}      OS: CentOS 7 + Minimal                ${Blue}--${NC}"
echo -e "${Blue}--${NC}    ARCH: 64bits                            ${Blue}--${NC}"
echo -e "${Blue}--${NC}                                            ${Blue}--${NC}"
echo -e "${Blue}------------------------------------------------${NC}"
echo

################################################
# Is root check
#
if [[ -z $(id -u) ]];
then
	echo -e "${ALERT}This script must be run with root access${NC}"
	exit 1
fi


###############################################
# Changing root password ?
#
if [[ $(ConfirmYes "Do you want to change root passord?") ]];
then
	passwd
fi


##############################################
# Changing hostname ?
#
if [[ $(ComfirmYes "Doyou want to change hostname?") ]];
then
	read -p "New hostname? " newhostname trash
	if [[ -n $newhostname ]] echo $newhostname > "/etc/hostname"
	needRestart=1
fi


###############################################
# Set CentOS base repositories, disabling mirrors
#
if [[ $(ConfirmYes "Do you want to enable base repositories, disabling mirrors?") ]];
then
	#to remedy some problems of compatibility use of mirror centos.org to all users
	#CentOS-Base.repo

	#released Base
	sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os|' "/etc/yum.repos.d/CentOS-Base.repo"
	sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/|baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/|' "/etc/yum.repos.d/CentOS-Base.repo"
	#released Updates
	sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates|' "/etc/yum.repos.d/CentOS-Base.repo"
	sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/|baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/|' "/etc/yum.repos.d/CentOS-Base.repo"
	#additional packages that may be useful Centos Extra
	sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras|' "/etc/yum.repos.d/CentOS-Base.repo"
	sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/|baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/|' "/etc/yum.repos.d/CentOS-Base.repo"
	#additional packages that extend functionality of existing packages Centos Plus
	sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus|' "/etc/yum.repos.d/CentOS-Base.repo"
	sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/centosplus/$basearch/|baseurl=http://mirror.centos.org/centos/$releasever/centosplus/$basearch/|' "/etc/yum.repos.d/CentOS-Base.repo"
	#contrib - packages by Centos Users
	sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib|' "/etc/yum.repos.d/CentOS-Base.repo"
	sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/contrib/$basearch/|baseurl=http://mirror.centos.org/centos/$releasever/contrib/$basearch/|' "/etc/yum.repos.d/CentOS-Base.repo"
fi


###############################################
# Setup the network
#
isEnabled_Network=0
if [[ $(ConfirmYes "Do you want to setup the network now?") ]];
then
	/bin/bash ./Centos7-network.sh
fi


echo
###############################################
# Set server roles
#
ConfirmNo "Do you want to disable SELinux? (not recommanded)" || isEnable_SELinux=1
ConfirmYes "Does this server is going to be a SSH server?" && isEnable_SSH=1 \
	&& ConfirmYes "With a nice auto-nenerated banner?" && isEnable_SSHBanner=1 \
	&& ConfirmYes "With another port than 22?" && read -p "Witch one? " sshPort trash
ConfirmYes "Does this server is going to be a DHCP server?" && isEnable_DHCP=1
ConfirmYes "Does this server is going to be a DNS server?" && isEnable_DNS=1
ConfirmYes "Does this server is going to be a NTP server?" && isEnable_NTP=1
ConfirmYes "Does this server is going to be a WEB server?" && isEnable_WEB=1
ConfirmYes "Does this server is going to be a MAIL server?" && isEnable_MAIL=1
ConfirmYes "Does this server is going to be a DB server?" && isEnable_DB=1 \
	&& ConfirmNo "Do you want to enable remote access to you database?" && isEnable_DBremote=1 \
	&& ConfirmYes "With another port than 3306?" && read -p "Witch one? " mysqlPort trash
ConfirmYes "Does this server is going to need VMWare support?" && isEnable_VMWare=1
echo
ConfirmNo "Does this server has aan other disk to store apps and logs?" \
	&& read -r -p "Witch one? (ex: /dev/sdb)" appDisk trash \
	&& ConfirmYes "Are you sure you want to use $appDisk, all data will be lost" || appDisk=""


###############################################
# Create Disk App
#
if [[ -n "$appDisk" ]];
then
	lsblk -r "$appDisk" > /dev/null
	if [[ $? -eq 0 ]];
	then
		# Create LVM volumes
		echo -ne "${Yellow}Configuring LVM disk...$NC"
		pvcreate $appDisk > /dev/null || appDisk=""
		vgcreate data $appDisk > /dev/null || appDisk=""
		lvcreate -L 80%FREE -n app data > /dev/null || appDisk=""
		lvcreate -L 100%FREE -n logs data > /dev/null || appDisk=""
		
		if [[ -n $appDisk ]];
		then echo -e "$BGreen OK!$NC";
		else echo -e "$Alert Error!$NC"; exit 1; fi;
			
		# Formating
		echo -ne "${Yellow}Formating...$NC"
		mkfs.ext4 /dev/data/app > /dev/null || appDisk=""
		mkfs.ext4 /dev/data/app > /dev/null || appDIsk=""
				
		if [[ -n $appDisk ]];
		then echo -e "$BGreen OK!$NC";
		else echo -e "$Alert Error!$NC"; exit 1; fi;

	else
		if [[ $(ComfirmNo "${BRed} Error:${NC} $appDisk does not exist, do you want to continue?") ]];
		then appDisk="";
		else exit 1; fi;
	fi
fi



###############################################
# Test internet connection
#
echo -ne "${Yellow}Testing internet connexion...$NC"

ping -q -w 1 -c 1 google.com > /dev/null

if [[ $? -ne 0 ]];
then
	echo
	echo -e "${BRed}This script needs an internet access to continue$NC"
	exit 1
else
	echo -e "${BGreen} Internet access Ok$NC"
fi


###############################################
# Update the system
#
echo -ne "${Yellow}Updating system...$NC"
yum -qy update > /dev/null && yum -qy upgrade > /dev/null
if [[ $? -eq 0 ]];
	then echo -e "${Green} Ok!$NC"
	else echo -e "$ALERT Error!$NC"
fi


###############################################
# Disabling SELinux ??? :/
#
if [[ -n "$isEnabled_SELinux" ]];
then
	sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' etc/selinux/config
	setenforce 1
	InstallYum "policycoreutils-python"
else
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' etc/selinux/config
	setenforce 0
fi


###############################################
# Install tools
#
InstallYum "make gcc g++ vim git"
InstallYum "wget curl zip unzip bzip2"


###############################################
# Install Kernel headers
#
if [[ -n "$isEnabled_VMWare" ]]; InstallYum "kernel-headers"


##############################################
# Install WMtools if requested
#
if [[ -n "$isEnabled_VMWare" ]]; InstallYum "open-vm-tools"

###############################################
# SSH
#
if [[ -n "$isEnabled_SSH" ]];
then
	InstallYum "openssh-server"

	# basic security
	sed -i 's|^#\?Protocol 2$|Protocol 2|' /etc/ssh/sshd_config
	sed -i 's|^#\?ServerKeyBits.*$|ServerKeyBits 2048|' /etc/ssh/sshd_config

	sed -i 's|^#\?PermitRootLogin.*$|PermitRootLogin no|' /etc/ssh/sshd_config
	sed -i 's|^#\?PermitEmptyPasswords.*$|PermitEmptyPasswords no|' /etc/ssh/sshd_config
	sed -i 's|^#\?PasswordAuthentication.*$|PasswordAuthentication yes|' /etc/ssh/sshd_config
	sed -i 's|^#\?$||' /etc/ssh/sshd_config
	sed -i 's|^#\?UseDNS$|UseDNS no|' /etc/ssh/sshd_config

	if [[ -n "$isEnabled_SSHBanner" ]];
	then
		sed -i 's|^#\?PrintMotd.*$|PrintMotd yes|' /etc/ssh/sshd_config
		[[ -f "/etc/warningbanner.txt" ]] && rm -f "/etc/warningbanner.txt"

		echo -e "${ALERT}!!! WARNING !!!$NC" >> /etc/warningbanner.txt
		echo -e "- You are about to authenticate on a ${BPurple}MerhylShark${NC} network." >> /etc/warningbanner.txt
		echo -e "- This network is only available for authorized people," >> /etc/warningbanner.txt
		echo -e "  if you are not, you will be purshased by using it." >> /etc/warningbanner.txt
		echo -e "- All attempt and use will be monitored" >> /etc/warningbanner.txt
		
		sed -i 's|^#\?Banner.*$|Banner /etc/ssh/warningbanner.txt|' /etc/ssh/sshd_config
	fi

	if [[ -n "$sshPort" -a "$sshPort" -gt 1024 ]];
	then
		echo -e "${Yellow}Changing SSH port to $sshPort...${NC}"
		sed -i 's|^#\?Port.*$|Port $sshPort|' /etc/ssh/sshd_config

		firewall-cmd --permanent --zone=public --add-port=$sshPort/tcp
		[[ -n "$isEnabled_SELinux" ]] && semanage port -a -t ssh_port_t -p tcp $sshPort
	fi

	systemctl restart sshd && systemctl enable sshd
fi


###############################################
# Installing and configuring DHCP
#
if [[ -n "$isEnabled_DHCP" ]];
then
	YumInstall "dhcp"

	confFile="/etc/dhcp/dhcpd.conf"
	tempFile=`mktemp`

	echo "# File generated by a MerhylShark script" >> $tempFile
	echo "default-lease-time 600;" >> $tempFile
	echo "max-lease-time 7200;" >> $tempFile
	echo "option domain-name $domainName;" >> $tempFile
	[[ -n isEnabled_DNS ]] && echo "option domain-name-servers dns.$domainName;" >> $tempFile
	[[ -z isEnabled_DNS ]] && echo "option domain-name-servers `grep nameserver /etc/resolv.conf| cut -d ' ' -f 2`;" >> $tempFile
	echo "subnet $DHCPsubnet netmask $DHCPnetmask {" >> $tempFile
	echo "\toption routers `ip r |grep default |cut -d ' ' -f 3`;" >> $tempFile
	echo "\toption subnet-mask $DHCPnetmask;" >> $tempFile
	echo "\toption time-offset -18000;" >> $tempFile
	echo "\trange `echo $DHCPsubnet |cut -d '.' -f 1,2,3`.100 `echo $DHCPsubnet |cut -d '.' -f 1,2,3`.199;" >> $tempFile
	echo "}" >> $tempFile

	[[ -f "$confFile" ]] && mv $confFile $confFile.$currentTime
	mv $tempFile $confFile
	chmod 660 $confFile

	firewall-cmd --permanent --zone=public --add-service=dhcp

	systemctl restart dhcpd && systemctl enable dhcpd
else
	;
fi


###############################################
# Installing and configuring DNS
#
if [[ -n "$isEnabled_DNS" ]];
then
	YumInstall "bind"

	firewall-cmd --permanent --zone=public --add-service=dns

	systemctl restart named && systemctl enable named
else
	;
fi


###############################################
# Installing and configuring NTP
#
if [[ -n "$isEnabled_NTP" ]];
then
	YumInstall "ntp"

	firewall-cmd --permanent --zone=public --add-service=ntp

	systemctl restart ntpd && systemctl enable ntpd
else
	;
fi


###############################################
# Installing and configuring WEB
#
if [[ -n "$isEnabled_WEB" ]];
then
	YumInstall "httpd"
	YumInstall "php php-mysql php-xml php-mcrypt"
	YumInstall "java"

	confFile="/etc/httpd/conf.d/merhylshark.conf"
	tempFile=`mktemp`

	if [[ -n $appDisk ]];
	then
		echo "<Directory \"/app/httpd/conf.d\">" >> $tempFile
		echo "  AllowOverride None" >> $tempFile
		echo "  Require all granted" >> $tempFile
		echo "</Directory>" >> $tempFile
		echo "Include /app/httpd/conf.d/*.conf" >> $tempFile
	fi

	[[ -f "$confFile" ]] mv $confFile $confFile.$currentTime
	mv $tempFile $confFile
	[[ -n isEnable_SELinux ]] && chcon -t httpd_config_t $confFile
	chown root:root $confFile
	chmod 600 $confFile

	firewall-cmd --permanent --zone=public --add-service=http
	firewall-cmd --permanent --zone=public --add-service=https

	systemctl restart httpd && systemctl enable httpd
else
	;
fi


###############################################
# Installing and configuring MAIL
#
if [[ -n "$isEnabled_MAIL" ]];
then
	YumInstall "postfix"

	firewall-cmd --permanent --zone=public --add-service=smtp

	systemctl restart postfix && systemctl enable postfix
else
	[[ -f /usr/sbin/postfix ]] && yum -qy remove postfix > /dev/null
fi


###############################################
# Installing and configuring DB
#
if [[ -n "$isEnabled_DB" ]];
then
	YumInstall "mariadb"
	systemctl stop mariadb

	confFile="/etc/my.cnf.d/merhylshark.cnf"
	tempFile=`mktemp`

	echo "[mysqld]" >> $tempFile

	if [[ -n "$isEnabled_DBremote" ]];
	then

		if [[ -n "$mysqlPort" ]];
		then
			echo "port = $mysqlPort" >> $tempFile
			firewall-cmd --permanent --zone=public --add-port=$mysqlPort/tcp
		else
			echo "port = 3306" >> $tempFile
			firewall-cmd --permanent --zone=public --add-service=mysql
		fi
	else
		echo "skip-networking" >> $tempFile
	fi

	if [[ -n "$appDisk" ]];
	then
		mv /var/lib/mysql /app/

		echo "datadir= /app/mysql" >> $tempFile
		echo "socket = /app/mysql/mysql.sock" >> $tempFile
		mkdir -p /app/mysql/tmp && echo "tmpdir = /app/mariadb/tmp/" >> $tempFile
		
		[[ -n isEnable_SELinux ]] && chcon -R -t mysqld_db_t /app/mysql
		chown -R mysql:mysql /app/mysql
		chmod -R o-rwx /app/mysql
	else
		echo "socket = /var/lib/mysql/mysql.sock" >> $tempFile
	fi
	echo "skip-external-locking" >> $tempFile
	echo "key_buffer_size = 384M" >> $tempFile
	echo "max_allowed_packet = 1M" >> $tempFile
	echo "table_open_cache = 512" >> $tempFile
	echo "sort_buffer_size = 2M" >> $tempFile
	echo "read_buffer_size = 2M" >> $tempFile
	echo "read_rnd_buffer_size = 8M" >> $tempFile
	echo "myisam_sort_buffer_size = 64M" >> $tempFile
	echo "thread_cache_size = 8" >> $tempFile
	echo "query_cache_size = 32M" >> $tempFile
	echo "thread_concurrency = 2" >> $tempFile
	echo "log-bin=mysql-bin" >> $tempFile
	echo "server-id = 1" >> $tempFile

	[[ -f "$confFile" ]] && mv $confFile $confFile.$currentTime
	mv $tempFile $confFile
	[[ -n isEnable_SELinux ]] && chcon -R -t mysqld_etc_t $confFile
	chown root:root $confFile
	chmod 660 $confFile

	systemctl start mariadb && systemctl enable mariadb
	
	rootName="root"
	rootPassword=`PasswordGenerator`
	userName="merhyl"
	userPassword=`PasswordGenerator`

	mysqladmin -u root password "$rootPassword"
	mysql -u root -p$rootPassword -e "DELETE FROM mysql.user WHERE User='root' AND Host != 'localhost';"
	mysql -u root -p$rootPassword -e "DELETE FROM mysql.user WHERE User='';"
	mysql -u root -p$rootPassword -e "DROP DATABASE test"
	mysql -u root -p$rootPassword -e "FLUSH PRIVILEGES;"

	passFile="/root/dbPassword.txt"
	touch $passFile
	chmod 600 $passFile
	echo "MySQL root password: $rootPassword" >> $passFIle
fi
