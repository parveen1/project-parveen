#! /bin/bash
# description add authomatic all user
rm -rf group.ldif
rm -rf user.ldif

python group_make_ldif.py groupfile.txt group.ldif

python user_make_ldif.py user_file.txt user.ldif

# insisde from network or docker(from out must use ip address)
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f group.ldif
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f user.ldif
