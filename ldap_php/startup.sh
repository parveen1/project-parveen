#!/bin/bash
#/usr/sbin/httpd $OPTIONS -DFOREGROUND && echo "ok"
/usr/sbin/httpd $OPTIONS
httpd -S
echo $(pgrep httpd)

