docker-oracle11gXE-db-orbis
============================

Oracle Express Edition 11g Release 2 on Ubuntu 17.04.1 LTS
I mixed the idea of sath89/oracle-xe-11g with the baseimage.
Thanks go to https://github.com/MaksymBilenko

### Installation

    docker run -d \
    -p 8080:8080 \
    -p 1521:1521 \
    -v /mnt/docker/oracle/data:/u01/app/oracle \
    -v /mnt/docker/oracle/config:/config \
    trueosiris/docker-oracle11gXE-db-orbis

### Processes, sessions, transactions

    #processes=x
    #sessions=x*1.1+5
    #transactions=sessions*1.1
    
    docker run -d \
    -p 8080:8080 \
    -p 1521:1521 \
    -v /mnt/docker/oracle/data:/u01/app/oracle \
    -v /mnt/docker/oracle/config:/config \
    -e processes=1000 \
    -e sessions=1105 \
    -e transactions=1215 \
    -e DEFAULT_SYS_PASS=mypassword \
    trueosiris/docker-oracle11gXE-db-orbis

### Credentials

Connect database with following setting:

    hostname: localhost
    port: 1521
    sid: xe
    username: system
    password: oracle

Password for SYS & SYSTEM:

    oracle

Connect to Oracle Application Express web management console with following settings:

    http://localhost:8080/apex
    workspace: INTERNAL
    user: ADMIN
    password: oracle

Apex upgrade up to v 5.*

    docker run \
    -it \
    --rm \
    --volumes-from ${DB_CONTAINER_NAME} \
    --link ${DB_CONTAINER_NAME}:oracle-database \
    -e PASS=YourSYSPASS \
    sath89/apex install
    
Details could be found here: https://github.com/MaksymBilenko/docker-oracle-apex

Auto import of sh sql and dmp files

    docker run -d \
    -p 8080:8080 \
    -p 1521:1521 \
    -v /mnt/docker/oracle/data:/u01/app/oracle \
    -v /mnt/docker/oracle/config:/config \ 
    -v /my/oracle/init/sh_sql_dmp_files:/docker-entrypoint-initdb.d \
    trueosiris/docker-oracle11gXE-db-orbis

**In case of using DMP imports dump file should be named like ${IMPORT_SCHEME_NAME}.dmp**
**User credentials for imports are  ${IMPORT_SCHEME_NAME}/${IMPORT_SCHEME_NAME}**
