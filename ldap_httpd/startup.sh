#! /bin/bash
# @edt ASIX M06 2018-2019
# Crear i engegar slapd amb edt.org
# -------------------------------------

/opt/docker/install.sh && echo "Install Ok"
/usr/sbin/httpd $OPTIONS -DFOREGROUND && echo "ok"
#/sbin/httpd   && echo "slapd Ok"

