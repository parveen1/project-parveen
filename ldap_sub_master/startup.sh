#!/bin/bash
# parveen hisx2
# Crear i engegar slapd amb edt.org
# -------------------------------------
/opt/docker/install.sh && echo "Install Ok"

#kill

/usr/sbin/slapd -d0 -u ldap -h "ldap:/// ldaps:/// ldapi:///" && echo "Ok"

#/usr/sbin/slapd -d0 -u ldap 
