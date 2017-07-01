#!/bin/bash

if [ ! $(whoami) = "root" ]; then
	echo "You need root permissions to run this script."
	exit
fi

clear

cat << EOF


---------------------------------------------------------------------------

			    Welcome to
   _____         __                _  __    ______
  / ___/ __  __ / /__ __  __ _____| |/ /   / ____/____   _____ ___
  \\__ \\ / / / // //_// / / // ___/|   /   / /    / __ \\ / ___// _ \\
 ___/ // /_/ // ,<  / /_/ /(__  )/   |   / /___ / /_/ // /   /  __/
/____/ \\__, //_/|_| \\__,_//____//_/|_|   \\____/ \\____//_/    \\___/
      /____/

    - An open networking solution for schools and enterprises -

       Copyright (C) 2017 Moritz F. Kuntze, Adrian Noethlich

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License version 3 as
  published by the Free Software Foundation.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

---------------------------------------------------------------------------


This program will install the SykusX Core Server on this machine.
It is intended for use on a freshly installed Arch Linux Distribution.
Two network adapters are required.

EOF
read -n 1 -r -p "Do you wish to continue? (y/n) [y]: " yn
echo
if [ ! $yn = "y" ]; then
	exit
fi

pacman -Syu

pacman -S git openssh python python-pip archiso dnsmasq syslinux

mkdir -p /tmp/sykusx/repo

git clone git@github.com:SykusX/Core /tmp/sykusx/repo

mkdir -p /opt/sykusx/build
cp  -R /tmp/sykusx/repo/build/* /opt/sykusx/build
echo "Build system installed."

ip addr

read -r -p "Please specify the LAN network interface: " lan
read -r -p "Please specify the WAN network interface: " wan

mkdir -p /opt/sykusx/tftp

cp /lib64/syslinux/bios/lpxelinux.0 /opt/sykusx/tftp

echo "user=root
group=root
port=0
interface=$lan
bind-interfaces
dhcp-rage=10.42.1.2,10.42.255.255,12h
dhcp-boot=lpxelinux.0
enable-tftp
tftp-secure
tftp-root=/opt/sykux/tftp" > /etc/dnsmasq.conf

mkdir -p /opt/sykusx/tftp/pxelinux.cfg
cp /tmp/sykusx/repo/cfg/pxelinux/* /opt/sykusx/tftp/pxelinux.cfg/

echo "PXE installed."

useradd -G wheel -m sykusx

echo "Please enable the wheel group in /etc/sudoers using visudo and add the following line:"
echo "sykusx ALL=NOPASSWD: /opt/sykusx/build/archimg/build.sh"
echo "Install finished. Run /opt/sykusx/build/build.sh to initiate build and deploy images."
