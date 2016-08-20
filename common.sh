#!/bin/bash

# OS VERSION: CentOS 7 + Minimal
# ARCH: 64bit

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

# ***************************************
# * Common installer functions *
# ***************************************

# Generates random passwords for services as Postfix and MySQL root account
function PasswordGenerator()
{
        l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9 < /dev/urandom | head -c ${l} | xargs
}

# Generate a string with date and hour without spaces
function DateString()
{
	date +%F-%H:%M:%S
}

# Install a package with a nice output
function InstallYum()
{
	if [[ -n "$1" ]];
	then
		echo -ne "${Yellow}Installing $1...$NC"
		yum -qy install $1 > /dev/null
		if [[ $? -eq 0 ]];
			then echo -e "${Green} Ok!$NC"
			else echo -e "$ALERT Error!$NC"
		fi
	fi
}

# Confirm an action, return 0 if yes
function ConfirmNo()
{
	# Call with a prompt string or use a default
	read -r -p "${1:-Are you sure?} [y/N] " response trash
	case $response in
		[yY][eE][sS]|[yY])
			true
			;;
		*)
			false
			;;
	esac
}

# Confirm an action, return 0 if yes
function ConfirmYes()
{
	# Call with a prompt string or use a default
	read -r -p "${1:-Are you sure?} [Y/n] " response trash
	case $response in
		[nN][oO]|[nN])
			false
			;;
		*)
			true
			;;
	esac
}
