#!/bin/bash
#
# TODO:
#   This is quite simple, made very quick.
#   Would refine later.
#
export CATALINA_BASE="/usr/share/tomcat"

/usr/sbin/tomcat start

trap '/usr/sbin/tomcat stop; sleep 2; exit 0' TERM

while :
do
    sleep 1
done
