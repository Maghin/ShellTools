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

#
# Common functions
#
source ./color.sh
source ./common.sh

#
# Is root check
#
if [[ -z $(id -u) ]];
then
	echo -e "${ALERT}This script must be run with root access${NC}"
	exit 1
fi


echo "--------------------------------------"
echo "Configuration du réseau"
echo "--------------------------------------"
echo "1. Configuration Ethernet"
echo "0. Quitter"
echo
read -n 1 -p "Choix: " choix
echo
## choix n°1 : configuration du réseau Ethernet en statique
## si choix = 1 alors passer au menu Ethernet
choix_ethernet()
{
	echo "-------------------------------------"
	echo "Configuration Ethernet"
	echo "-------------------------------------"
	echo "1. Statique"
	echo "2. DHCP"
	echo "0. Retour au menu principal"
	echo
	read -n 1 -p "Choix: " choix_eth 
	echo
	choix_static()
	{	
		echo "-------------------------------------"
		echo "Configuration Ethernet Statique"
		echo "-------------------------------------"
		echo
		echo "Avaiable interfaces:"
		ip -o -4 a |grep -ve ' lo ' |awk '{printf $2;};'
		echo
		read -p "Interface name: " interface
		read -p "IP Addr: " ipaddr
		read -p "Mask: " netmask
		read -p "Gateway: " gateway
		read -p "DNS: " nameserver

		if [[ $(ConfirmYes "Are you sure you want to erase parameters for $interface") ]];
		then
			## Affichage des paramètres dans le fichier de configuration
			echo " 
			TYPE="Ethernet"
			BOOTPROTO=none
			NAME=\"$interface\"
			IPADDR=$ipaddr
			MASK=$netmask
			GATEWAY=$gateway
			DNS1=$nameserver
		       	DEVICE=\"$inteface\"
			ONBOOT=\"yes\""		>> /etc/sysconfig/network-scripts/ifcfg-${interface}
			## Si la dernière commande est correctement exécutée, on affiche

			if [ $? = "0" ]; then
				echo "Les données de configuration ont été écrites avec succès"
				echo "Redémarrage du service..."
				systemctl restart network
			## On affiche le fichier créé (ou modifié)
			cat /etc/sysconfig/network-scripts/ifcfg-${interface}
			fi
		fi
		$0
	}
	choix_dhcp()
	{	
		echo "-----------------------------------"
		echo "Configuration Ethernet DHCP"
		echo "-----------------------------------"
		echo
		echo "Avaiable interfaces:"
		ip -o -4 a |grep -ve ' lo ' |awk '{printf $2;};'
		echo
		read -p "Interface name: " interface

		if [[ $(ConfirmYes "Are you sure you want to erase parameters for $interface") ]];
		then
			echo " 
			TYPE="Ethernet"
			BOOTPROTO=dhcp
			NAME=\"$interface\"
	       		DEVICE=\"$inteface\"
			ONBOOT=\"yes\""		>> /etc/sysconfig/network-scripts/ifcfg-${interface}
		
			## Si la dernière commande est correctement exécutée, on affiche
			if [ $? = "0" ]; then
				echo "Les données de configuration ont été écrites avec succès"
				echo "Redémarrage du service..."
				cat /etc/network/interfaces
			fi
		fi
		$0
	}

	case $choix_eth in
		1) choix_static
			;;
		2) choix_dhcp
			;;
		3) $0
			;;
	esac
}

case $choix in
	1) choix_ethernet
		;;
esac

