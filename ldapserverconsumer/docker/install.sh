#! /bin/bash
# @edt ASIX M06 2018-2019
# instal.lacio slapd edt.org
# -------------------------------------
cp  /opt/docker/ldap.conf /etc/openldap/ldap.conf

rm -rf /etc/openldap/slapd.d/*
rm -rf /var/lib/ldap/*
cp /opt/docker/DB_CONFIG /var/lib/ldap
slaptest -F /etc/openldap/slapd.d -f /opt/docker/slapd.conf
slaptest -F /etc/openldap/slapd.d -f /opt/docker/slapd.conf -u
#slapadd -F /etc/openldap/slapd.d -l /opt/docker/dataDB.ldif
chown -R ldap.ldap /etc/openldap/slapd.d
chown -R ldap.ldap /var/lib/ldap
#ldapmodify -vx -h 172.18.0.3 -D "cn=Manager,dc=edt,dc=org" -w jupiter -f modify.ldif
