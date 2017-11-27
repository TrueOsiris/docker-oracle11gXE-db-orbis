#!/bin/bash

set -e
initfile="oracleinstall.step"
debbase="oracle-xe_11.2.0-1.0_amd64.deb"
url="https://github.com/TrueOsiris/docker-oracle11gXE-db-orbis"

debPull () {
        debPackage=${debbase}$1
        echo "Downloading '$url/raw/master/$debPackage' ..."
        curl --retry 5 -m 60 -o $2/$debPackage -L $url/blob/master/$debPackage?raw=true
        echo "Downloaded '$url/blob/master/$debPackage' to $2"
}
if [ ! -d /config ]; then
  echo "Error! There is no /config volume!"
fi

if [ -f /config/$(echo $initfile) ]; then
  echo "Initfile exists. Continuing installsteps if needed."
else
  echo "Creating initfile $initfile ..."
  echo -e "Do not remove this file.\nIf you do, container will be fully reset on next start." > /config/$(echo $initfile)
  echo -e "Installstep 0: initfile created" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 0 ]; then
  if [ ! -d /config/debpackages ]; then
    echo "Creating folder /config/debpackages ..."
    mkdir -p  /config/debpackages
  fi
  echo -e "Installstep 1: /config/debpackages created" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 1 ]; then
  debPull "aa" "/config/debpackages/"
  echo -e "Installstep 2: Downloaded debian package part aa" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 2 ]; then
  debPull "ab" "/config/debpackages/"
  echo -e "Installstep 3: Downloaded debian package part ab" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 3 ]; then
  debPull "ac" "/config/debpackages/"
  echo -e "Installstep 4: Downloaded debian package part ac" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 4 ]; then
  echo "Reassembling the debian base-install package file ..."
  cat /config/debpackages/${debPackage}a* > /config/debpackages/${debPackage}
  echo -e "Installstep 5: Reassembled the debian base-install package" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 5 ]; then
  echo "Removing downloaded parts ..."
  rm -f /config/debpackages/${debPackage}a*
  echo -e "Installstep 6: Removed downloaded parts" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 6 ]; then
  echo "Installing the package ..."
  dpkg --install /config/debpackages/${debPackage}
  echo -e "Installstep 7: Debian package installed" >> /config/$(echo $initfile)
fi
if [ `cat /config/$(echo $initfile) | grep Installstep | tail -n1 | awk -v FS="(Installstep |:)" '{print $2}'` = 7 ]; then
  echo "Removing the base-install package file ..."
  rm -f /config/debpackages/${debPackage}
  echo -e "Installstep 8: Removing package install file" >> /config/$(echo $initfile)
fi

#mv /init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
#mv /u01/app/oracle/product /u01/app/oracle-product

