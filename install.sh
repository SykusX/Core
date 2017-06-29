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

pacman -S git python python-pip archiso

mkdir -p /tmp/sykusx/repo

git clone git@github.com:SykusX/Core /tmp/sykusx/repo
