#!/bin/bash

set -e
initfile="oracleinstall.step"
debfile="oracle-xe_11.2.0-1.0_amd64.deb"

debPrep () {
	local url="https://github.com/TrueOsiris/docker-oracle11gXE-db-orbis"
	local debPackage_part=( 
		${debPackage}aa 
		${debPackage}ab 
		${debPackage}ac
	)
	local i=1
	for j in "${debPackage_part[@]}"; do     
		echo "[Downloading '$j' (part $i/3)]"
		curl -s --retry 5 -m 30 -o /$j -L $url/blob/master/$j?raw=true
		i=$((i + 1))
	done
	cat /${debPackage}a* > /${debPackage}
	rm -f /${debPackage}a*
}

GetInstallstep () {
	installstep=`cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'`
}

if [ -f /config/$(echo $initfile) ]; then
        echo 'initfile already exists.'
else
	echo 'creating initfile $initfile.'
	echo -e "Do not remove this file.\nIf you do, container will be fully reset on next start." > /config/$(echo $initfile)
	echo -e "Installstep: 0. initfile created" >> /config/$(echo $initfile)
fi
GetInstallstep
echo $installstep




#debPrep 
#dpkg --install /${debPackage} && rm -f /${debPackage}
#mv /init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /u01/app/oracle/product /u01/app/oracle-product
#apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
