#! /bin/bash
# @edt ASIX M06 2018-2019
# instal.lacio slapd edt.org
# -------------------------------------
rm -rf /etc/httpd/conf.d/ldap_httpd.conf
rm -rf /var/www/ldap
rm -rf /etc/httpd/conf/httpd.conf
mkdir /var/www/ldap
cp /opt/docker/httpd.conf /etc/httpd/conf/httpd.conf
cp /opt/docker/ldap_httpd.conf /etc/httpd/conf.d/ldap_httpd.conf
cp /opt/docker/index.html /var/www/ldap/
chown -R apache.apache /var/www/ldap

