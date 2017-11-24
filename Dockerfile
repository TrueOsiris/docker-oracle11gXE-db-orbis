FROM trueosiris/docker-baseimage:latest
MAINTAINER Tim Chaubet <tim.chaubet@agfa.com>

ARG DEBIAN_FRONTEND=noninteractive

ADD chkconfig /sbin/chkconfig
ADD oracle-install.sh /oracle-install.sh
ADD init.ora /
ADD initXETemp.ora /

# Prepare to install Oracle
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y -q libaio1 \
                          net-tools \
                          bc \
                          curl \
                          rlwrap \
                          htop \
                          vim \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* \
 && ln -s /usr/bin/awk /bin/awk \
 && mkdir /var/lock/subsys \
 && chmod 755 /sbin/chkconfig 
 

#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh
# && /oracle-install.sh

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV PATH $ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV DEFAULT_SYS_PASS oracle
ENV PORT 1521

EXPOSE 1521
EXPOSE 8080
VOLUME ["/u01/app/oracle","/work"]

ENV processes 500
ENV sessions 555
ENV transactions 610

#ADD entrypoint.sh /
#ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/my_init"]
