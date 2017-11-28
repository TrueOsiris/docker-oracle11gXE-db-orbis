#!/bin/bash

set -e
initfile="oracleinstall.step"
debbase="oracle-xe_11.2.0-1.0_amd64.deb"
url="https://github.com/TrueOsiris/docker-oracle11gXE-db-orbis"
#>>file1 2>>file2

debPull () {
        debPackage=${debbase}$1
        echo "Downloading '$url/blob/master/$debPackage' ..."
        curl --retry 5 -m 60 -o $2/$debPackage -L $url/blob/master/$debPackage?raw=true
        echo "Downloaded '$url/blob/master/$debPackage' to $2 ..."
        echo "Filesize is "`du -h $2/$debPackage | awk '{print $1}' `
}
if [ ! -d /config ]; then
  echo "Error! There is no /config volume!"
fi

if [ -f /config/$(echo $initfile) ]; then
  echo date
  echo "Initfile exists. Continuing installsteps if needed."
else
  echo "Creating initfile $initfile ..." 
  echo -e "Do not remove this file.\nIf you do, container will be fully reset on next start." > /config/$(echo $initfile)
  echo -e "Installstep 0: initfile created" >> /config/$(echo $initfile)
fi
F=/config/$(echo $initfile)
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 0 ]; then
  if [ ! -d /config/debpackages ]; then
    echo "Creating folder /config/debpackages ..."
    mkdir -p  /config/debpackages
  fi
  echo -e "Installstep 1: /config/debpackages created" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 1 ]; then
  debPull "aa" "/config/debpackages/"
  echo -e "Installstep 2: Downloaded debian package part aa" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 2 ]; then
  debPull "ab" "/config/debpackages/"
  echo -e "Installstep 3: Downloaded debian package part ab" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 3 ]; then
  debPull "ac" "/config/debpackages/"
  echo -e "Installstep 4: Downloaded debian package part ac" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 4 ]; then
  echo "Reassembling the debian base-install package file ..."
  ls -hl /config/debpackages 2>&1
  cat /config/debpackages/${debbase}a* > /config/debpackages/${debbase}
  echo -e "Installstep 5: Reassembled the debian base-install package" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 5 ]; then
  echo "Removing downloaded parts ..."
  rm -f /config/debpackages/${debbase}a*
  echo -e "Installstep 6: Removed downloaded parts" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 6 ]; then
  echo "Installing the package ..."
  dpkg --force-confdef --install /config/debpackages/${debbase}
  echo -e "Installstep 7: Debian package installed" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 7 ]; then
  echo "Removing the base-install package file ..."
  rm -f /config/debpackages/${debbase}
  echo -e "Installstep 8: Removing package install file" >> $F
fi
if [ `cat $F | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 8 ]; then
  echo "Moving /init.ora to /u01/app/oracle/product/11.2.0/xe/config/scripts ..."
  mv /init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
  echo "Moving /initXETemp.ora to /u01/app/oracle/product/11.2.0/xe/config/scripts ..."
  mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
  echo "Moving /u01/app/oracle/product to /u01/app/oracle-product ..."
  mv /u01/app/oracle/product /u01/app/oracle-product
  echo -e "Installstep 9: Moved .ora files & product folder" >> $F
fi

# Prevent owner issues on mounted folders
#chown -R oracle:dba /u01/app/oracle
#rm -f /u01/app/oracle/product
#ln -s /u01/app/oracle-product /u01/app/oracle/product
#if [ "$PORT" = "" ]; then
#PORT=1521
#fi
# Update hostname
#sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
#sed -i -E "s/PORT = [^)]+/PORT = $PORT/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
#echo "export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe" > /etc/profile.d/oracle-xe.sh
#echo "export PATH=\$ORACLE_HOME/bin:\$PATH" >> /etc/profile.d/oracle-xe.sh
#echo "export ORACLE_SID=XE" >> /etc/profile.d/oracle-xe.sh
#. /etc/profile

