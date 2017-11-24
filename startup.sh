#!/bin/bash

set -e
initfile="oracleinstall.step"
debbase="oracle-xe_11.2.0-1.0_amd64.deb"
url="https://github.com/TrueOsiris/docker-oracle11gXE-db-orbis"

debpull {
	debPackage=${debbase}$1
	echo "Downloading '$debPackage' ..."
	curl -s --retry 5 -m 30 -o /$j -L $url/blob/master/$debPackage?raw=true
}

if [ -f /config/$(echo $initfile) ]; then
        echo "Initfile already exists."
else
	echo "Creating initfile $initfile ..."
	echo -e "Do not remove this file.\nIf you do, container will be fully reset on next start." > /config/$(echo $initfile)
	echo -e "Installstep 0: initfile created" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'`=0 ]; then
	if [ ! -d /config/debpackages ]; then
		echo "Creating folder /config/debpackages ..."
		mkdir -p  /config/debpackages
		echo -e "Installstep 0: initfile created" >> /config/$(echo $initfile)
	fi
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'`=1 ]; then
	debpull "aa"
	echo -e "Installstep 2: Downloaded $debbaseaa" >> /config/$(echo $initfile)
fi
	

#cat /${debPackage}a* > /${debPackage}
#rm -f /${debPackage}a*

#debPrep 
#dpkg --install /${debPackage} && rm -f /${debPackage}
#mv /init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /u01/app/oracle/product /u01/app/oracle-product
#apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
