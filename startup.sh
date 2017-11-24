#!/bin/bash

set -e
initfile=$(echo $HOST_HOSTNAME)\.initialised



debPackage="oracle-xe_11.2.0-1.0_amd64.deb"
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
debPrep 
dpkg --install /${debPackage} && rm -f /${debPackage}
mv /init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
mv /u01/app/oracle/product /u01/app/oracle-product
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
