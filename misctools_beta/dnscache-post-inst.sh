#!/bin/sh

## clean-room post-inst for svscan

SVCNAME=dnscache
SERVICEDIR=/var/service
LOGDIR=/var/log/svscan

LOCALBIN=/usr/local/bin 

IP_LISTEN=${1:-127.0.0.1}

mkdir -p ${LOGDIR}
mkdir -p ${SERVICEDIR}

sysrc svscan_enable=YES
sysrc svscan_logdir=${LOGDIR}
sysrc svscan_servicedir=${SERVICEDIR}

## clean-room post-inst for dnscache 

pw showgroup $SVCNAME > /dev/null ||
	pw groupadd -i 100 ${SVCNAME}

pw showuser $SVCNAME > /dev/null ||
	pw useradd -u 100 -d /nonexistent -w none \
		-s /usr/sbin/nologin \
		-c "${SVCNAME} service" -n ${SVCNAME}

if ! [ -d ${SERVICEDIR}/${SVCNAME} ]; then
	dnscache-conf ${SVCNAME} ${SVCNAME} ${SERVICEDIR}/${SVCNAME} ${IP_LISTEN}
fi

touch ${SERVICEDIR}/${SVCNAME}/root/ip/127
touch ${SERVICEDIR}/${SVCNAME}/root/ip/192.168

service svscan start

