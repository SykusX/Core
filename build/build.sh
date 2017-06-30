#!/bin/bash

timestamp() {
	date +"%F %T"
}

if [ ! $(pwd) = "/opt/sykusx/build" ]; then
	cd /opt/sykusx/build
fi

echo "Starting to build system!" | xargs -L1  echo "$(timestamp)" | tee -a /var/log/sykusx/sykusx-build/isobuild.log

echo "Cleaning buildpath." | xargs -L1 echo "$(timestamp)" | tee -a /var/log/sykusx/sykusx-build/isobuild.log
make clean | while read line ; do echo "$line " | xargs -L1 echo "$(timestamp)" ; done | tee -a /var/log/sykusx/sykusx-build/isobuild.log

echo "Copy buildfiles." | xargs -L1 echo "$(timestamp)" | tee -a /var/log/sykusx/sykusx-build/isobuild.log
make install | while read line ; do echo "$line " | xargs -L1 echo "$(timestamp)" ; done | tee -a /var/log/sykusx/sykusx-build/isobuild.log
echo "Finished copying." | xargs -L1 echo "$(timestamp)"  | tee -a /var/log/sykusx/sykusx-build/isobuild.log

echo "Create output directory." | xargs -L1 echo "$(timestamp)"  | tee -a /var/log/sykusx/sykusx-build/isobuild.log
mkdir archimg/out

echo "Start building iso: " | xargs -L1 echo "$(timestamp)"  | tee -a /var/log/sykusx/sykusx-build/isobuild.log
sudo archimg/build.sh -v | while read line ; do echo "$line " | xargs -L1 echo "$(timestamp)" ; done | tee -a /var/log/sykusx/sykusx-build/isobuild.log
echo "Finished building iso." | xargs -L1 echo "$(timestamp)"  | tee -a /var/log/sykusx/sykusx-build/isobuild.log
